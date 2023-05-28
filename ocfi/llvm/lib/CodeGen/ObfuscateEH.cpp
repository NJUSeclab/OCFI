//===- ObfuscateEH.cpp - Compute safe point for EH insertion ----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineBlockFrequencyInfo.h"
#include "llvm/CodeGen/MachineDominators.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineOptimizationRemarkEmitter.h"
#include "llvm/CodeGen/MachinePostDominators.h"
#include "llvm/CodeGen/RegisterClassInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Function.h"
#include "llvm/InitializePasses.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"

using namespace llvm;

#define DEBUG_TYPE "obfuscate-eh"

STATISTIC(NumObfuscatedFuncs, "The # of functions that successfully obfuscated");

namespace {
class ObfuscateEH : public MachineFunctionPass {
    MachineDominatorTree *MDT;
    // MachinePostDominatorTree* MPDT;

public:
  static char ID;

  ObfuscateEH() : MachineFunctionPass(ID) {

  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesAll();
    AU.addRequired<MachineDominatorTree>();
    AU.addRequired<MachinePostDominatorTree>();
    MachineFunctionPass::getAnalysisUsage(AU);
  }

  MachineFunctionProperties getRequiredProperties() const override {
    return MachineFunctionProperties().set(
        MachineFunctionProperties::Property::NoVRegs);
  }
  bool inline isNoUnwindFn(Function& F) {
    bool result = F.hasFnAttribute(Attribute::NoUnwind);
    return result;
  }

  bool inline forceEmitPersonality(Function& F) {
      Function* Per = nullptr;
      if (F.hasPersonalityFn())
        Per = dyn_cast<Function>(F.getPersonalityFn()->stripPointerCasts());
      return F.hasPersonalityFn() &&
      !isNoOpWithoutInvoke(classifyEHPersonality(Per)) &&
      F.needsUnwindTableEntry();
  }

  bool inline containsLandingPad(MachineFunction& MF) {
    for (auto& MBB: MF) {
        if (MBB.isEHPad())
            return true;
    }
    return false;
  }

  StringRef getPassName() const override { return "Obfuscate EH analysis";}

  bool callToNoUnwindFunction(MachineInstr* MI) {
    assert((MI->isCall() || MI->isBranch()) && "This should be a call instruction!");

    bool MarkedNoUnwind = false;
    bool SawFunc = false;

    for (unsigned I = 0, E = MI->getNumOperands(); I != E; ++I) {
        const MachineOperand &MO = MI->getOperand(I);

        if (!MO.isGlobal()) continue;

        const Function *F = dyn_cast<Function>(MO.getGlobal());
        if (!F) continue;

        if (SawFunc) {
        // Be conservative. If we have more than one function operand for this
        // call, then we can't make the assumption that it's the callee and
        // not a parameter to the call.
        //
        // FIXME: Determine if there's a way to say that `F' is the callee or
        // parameter.
        MarkedNoUnwind = false;
        break;
        }

        MarkedNoUnwind = F->doesNotThrow();
        // F->arg_size
        SawFunc = true;
    }

  return MarkedNoUnwind;

  }

  bool runOnMachineFunction(MachineFunction &MF) override;
};
}

char ObfuscateEH::ID = 0;
char &llvm::ObfuscateEHID = ObfuscateEH::ID;

INITIALIZE_PASS_BEGIN(ObfuscateEH, DEBUG_TYPE, "Obfuscate EH Pass", false, false)
INITIALIZE_PASS_DEPENDENCY(MachineDominatorTree)
// INITIALIZE_PASS_DEPENDENCY(MachinePostDominatorTree)
INITIALIZE_PASS_END(ObfuscateEH, DEBUG_TYPE, "Obfuscate EH Pass", false, false)

FunctionPass *llvm::createObfuscateEH() { return new ObfuscateEH(); }

void handleNoUnwindFn(MachineFunction& MF) {
    unsigned entrySecID = MF.front().getSectionIDNum();
    // mark last basic block as the begin of obfuscation
    MachineBasicBlock* target_bb = nullptr;
    for (auto rbegin = MF.rbegin(), rend = MF.rend(); rbegin != rend; rbegin++) {
        if (rbegin->getSectionIDNum() == entrySecID) {
            target_bb = &*rbegin;
            break;
        }
    }
    assert(target_bb != nullptr && "can't find the target bb!");
    if(target_bb == &MF.front())
    {
        bool find_call = false;
        MachineInstr * preInst = nullptr;
        int cnt = 0;
	    // MachineInstr * lastInst = nullptr;
        for(MachineInstr& MI: *target_bb) {
            preInst = &MI;
            cnt++;
            if (MI.isCall())
            {
                find_call = true;
                break;
            }
        }
        if(find_call && preInst)
        {
            target_bb = (*target_bb).splitAt(*preInst);
            // outs() << "[ztt]: try spilt func nounwind bb of " << MF.getFunction().getName() << " by call inst \n";
            bool check_newBB = false;
            for(auto rbegin = MF.rbegin(), rend = MF.rend(); rbegin != rend; rbegin++) {
                if (&*rbegin == target_bb) {
                    check_newBB = true;
                    break;
                }
                assert(check_newBB && "cannot find new bb!");
            }
        }
        else
        {
            int now_id = 0;
            cnt /= 2;
            preInst = nullptr;
            for(MachineInstr& MI: *target_bb) {
                now_id++;
                preInst = &MI;
                if(cnt == now_id)
                    break;
            }
            if(preInst)
            {
                target_bb = (*target_bb).splitAt(*preInst);
                // outs() << "[ztt]: try spilt func nounwind bb of " << MF.getFunction().getName() << " by mid inst \n";
                bool check_newBB = false;
                for(auto rbegin = MF.rbegin(), rend = MF.rend(); rbegin != rend; rbegin++) {
                    if (&*rbegin == target_bb) {
                        check_newBB = true;
                        break;
                    }
                    assert(check_newBB && "cannot find new bb!");
                }
            }
        }
    }
    target_bb->setIsObfuscatedBegin();
    MF.InitializeObfuscateEHRange(target_bb);
    target_bb->setObfuscateInitialize();
}

bool ObfuscateEH::runOnMachineFunction(MachineFunction &MF) {

    unsigned entrySecID = MF.front().getSectionIDNum();
    bool potentialCallSite = false;

    if (isNoUnwindFn(MF.getFunction()) && !forceEmitPersonality(MF.getFunction()) && \
            !containsLandingPad(MF)) {
        // outs() << "nounwind function is " << MF.getFunction().getName() << "\n";
        handleNoUnwindFn(MF);
        return false;
    }

    // if (forceEmitPersonality(MF.getFunction())) {
    //     MF.front().setIsObfuscatedBegin();
    //     MF.front().setObfuscateInitialize();
    //     MF.InitializeObfuscateEHRange(&MF.front());
    //     return false;
    // }
    // outs() << "unwind Function is " << MF.getFunction().getName() << "\n";

    MDT = &getAnalysis<MachineDominatorTree>();

    std::map<MachineBasicBlock*, int> bb_nums;

    int cur_idx = 0;
    for (MachineBasicBlock &MBB: MF) {
        bb_nums[&MBB] = cur_idx;
        cur_idx++;
    }

    SmallVector<MachineBasicBlock*, 4> potential_unwind_mbb;


    for (MachineBasicBlock &MBB : MF) {
        if (MBB.isEHPad()) {
            potential_unwind_mbb.push_back(&MBB);
            continue;
        }
        /*

        const BasicBlock* BB = MBB.getBasicBlock();
        if (!BB)
            continue;
        bool isUnwind = false;

        for (const Instruction &instr: *BB) {
            if (instr.mayThrow()) {
		// printf("maythorw!\n");
                isUnwind = true;
                break;
            }

            if (const CallInst* CI = dyn_cast<CallInst>(&instr)) {
                Function* calleeFn = CI->getCalledFunction();
                if (!calleeFn) {
                    isUnwind = true;
                    break;
                } else if (!isNoUnwindFn(*calleeFn)) {
                    isUnwind = true;
                    break;
                }
            }
        }
        if (isUnwind) {
            potential_unwind_mbb.push_back(&MBB);
        }
        */
       bool SawPotentiallyThrowing = false;
       for(MachineInstr& MI: MBB) {
        if (!MI.isEHLabel()) {
            if (MI.isCall())
                SawPotentiallyThrowing |= !callToNoUnwindFunction(&MI);
            continue;
        }
        else {
            potentialCallSite = true;
            SawPotentiallyThrowing = true;
        }
      }
      if (SawPotentiallyThrowing) {
        potential_unwind_mbb.push_back(&MBB);
      }
    }

    // if (potentialCallSite) {
    //     MF.front().setIsObfuscatedBegin();
    //     MF.InitializeObfuscateEHRange(&MF.front());
    //     MF.front().setObfuscateInitialize();
    //     return false;
    // }

    if (potential_unwind_mbb.size() == 0) {
        handleNoUnwindFn(MF);
        // outs() << "[binpang]: can't find unwind bb of " << MF.getFunction().getName() << "\n";
        return false;
    }

    // auto dominateAll = [potential_unwind_mbb, bb_nums, this](MachineBasicBlock* mbb) -> bool
    // {
    //     for (MachineBasicBlock* p_mbb : potential_unwind_mbb) {
    //         if (!MDT->dominates(mbb, p_mbb) || \
    //             bb_nums.find(mbb)->second > bb_nums.find(p_mbb)->second)
    //             return false;
    //     }
    //     return true;
    // };

    MachineBasicBlock* last_dominate_bb = nullptr;

    // for (MachineBasicBlock &MBB : MF) {
    //     if (MBB.getSectionIDNum() == entrySecID && dominateAll(&MBB)) {
    //         last_dominate_bb = &MBB;
    //     }
    // }

    last_dominate_bb = potential_unwind_mbb[0];
    bool found = false;
    for(auto rbegin = MF.rbegin(), rend = MF.rend(); rbegin != rend; rbegin++) {
        if (&*rbegin == last_dominate_bb) {
            found = true;
        }
        if (found && rbegin->getSectionIDNum() == entrySecID) {
            last_dominate_bb = &*rbegin;
            break;
        }
    }


    assert(last_dominate_bb && "can't find dominate node!");
    bool findPrevBB = false;

    if (last_dominate_bb != &MF.front()) {
        NumObfuscatedFuncs++;
    }

    if (last_dominate_bb == &MF.front() && !(*last_dominate_bb).isEHPad()) {
        bool find_call = false;
        MachineInstr * preInst = nullptr;
        int cnt = 0;
	    // MachineInstr * lastInst = nullptr;
        for(MachineInstr& MI: *last_dominate_bb) {
            // if (MI.isEHLabel())
            // {

            //     break;
            // }
            if ((MI.isCall() && !callToNoUnwindFunction(&MI)) || MI.isEHLabel())
            {
                find_call = true;
                break;
            }
            preInst = &MI;

        }
        if(find_call && preInst)
        {
            last_dominate_bb = (*last_dominate_bb).splitAt(*preInst);
            // outs() << "[ztt]: try spilt func unwind bb of " << MF.getFunction().getName() << "\n";
            bool check_newBB = false;
            for(auto rbegin = MF.rbegin(), rend = MF.rend(); rbegin != rend; rbegin++) {
                if (&*rbegin == last_dominate_bb) {
                    check_newBB = true;
                    break;
                }
                assert(check_newBB && "cannot find new bb!");
            }
            NumObfuscatedFuncs++;
        }
    }


    MF.InitializeObfuscateEHRange(last_dominate_bb);

    int bb_num = bb_nums.find(last_dominate_bb)->second;
    for (MachineBasicBlock& MBB : MF) {
        if (&MBB == last_dominate_bb) {
            findPrevBB = true;
            MBB.setObfuscateInitialize();
            continue;
        }
        if (findPrevBB) {
            // its dependency is not in the range.
            for (auto pit = MBB.pred_begin(), pet = MBB.pred_end(); pit != pet; ++pit) {
                if (bb_nums.find(*pit)->second < bb_num) {
                    MBB.setObfuscateInitialize();
                    break;
                }
            }
        }
    }
    last_dominate_bb->setIsObfuscatedBegin();
    // outs() << "unwind function is " << MF.getFunction().getName() << "\n";
    return false;
}


//===------ RemoveObfuscatedCFI.cpp - Insert additional CFI instructions -----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//===--------------------------------------------------------------------------
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/InitializePasses.h"

using namespace llvm;

namespace {
class RemoveObfuscatedCFI : public MachineFunctionPass {
  public:
    static char ID;

    RemoveObfuscatedCFI() : MachineFunctionPass(ID) {
        initializeRemoveObfuscatedCFIPass(*PassRegistry::getPassRegistry());
    }

    void getAnalysisUsage(AnalysisUsage &AU) const override {
        AU.setPreservesAll();
        MachineFunctionPass::getAnalysisUsage(AU);
    }

    bool removeCFIs(MachineBasicBlock& MBB) {
        bool removed = false;
        SmallVector<MachineInstr *, 4> vec;
        for (MachineInstr &MI : MBB) {
            if (MI.isCFIInstruction()) {
                vec.push_back(&MI);
            }
        }

        for (auto MI : vec) {
            // outs() << "Remove mi " << *MI << "\n";
            MBB.erase_instr(MI);
        }
        // outs() << "After deletion " << MBB << "\n";
        if (vec.size() > 0)
            removed = true;
        return removed;
    }

    bool runOnMachineFunction(MachineFunction &MF) override {
        // outs() << "HELLO, remove obfuscated cfi\n";
        if (!MF.needsFrameMoves())
            return false;
        // outs() << "HELLOsssss\n";
        bool removed = false;

        for (MachineBasicBlock &MBB: MF) {
            if (MBB.isOutObfuscateRange()) {
                removed |= removeCFIs(MBB);
            }
        }
        return removed;
    }


};
} // namespace

char RemoveObfuscatedCFI::ID = 0;
INITIALIZE_PASS(RemoveObfuscatedCFI, "remove-obfuscated-cfi",
                        "Remove obfuscated cfi instruction", false, false)
FunctionPass *llvm::createRemoveObfuscatedCFI() {return new RemoveObfuscatedCFI();}
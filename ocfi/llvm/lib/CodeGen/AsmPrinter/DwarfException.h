//===-- DwarfException.h - Dwarf Exception Framework -----------*- C++ -*--===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains support for writing dwarf exception info into asm files.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_CODEGEN_ASMPRINTER_DWARFEXCEPTION_H
#define LLVM_LIB_CODEGEN_ASMPRINTER_DWARFEXCEPTION_H

#include "EHStreamer.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/MC/MCDwarf.h"

namespace llvm {
class MachineFunction;
class ARMTargetStreamer;

class LLVM_LIBRARY_VISIBILITY DwarfCFIExceptionBase : public EHStreamer {
protected:
  DwarfCFIExceptionBase(AsmPrinter *A);

  /// Per-function flag to indicate if frame CFI info should be emitted.
  bool shouldEmitCFI;
  /// Per-module flag to indicate if .cfi_section has beeen emitted.
  bool hasEmittedCFISections;

  void markFunctionEnd() override;
  void endFragment() override;
};

class LLVM_LIBRARY_VISIBILITY DwarfCFIException : public DwarfCFIExceptionBase {
  /// Per-function flag to indicate if .cfi_personality should be emitted.
  bool shouldEmitPersonality;

  /// Per-function flag to indicate if .cfi_personality must be emitted.
  bool forceEmitPersonality;

  /// Per-function flag to indicate if .cfi_lsda should be emitted.
  bool shouldEmitLSDA;

  /// Per-function flag to indicate if frame moves info should be emitted.
  bool shouldEmitMoves;

public:
  //===--------------------------------------------------------------------===//
  // Main entry points.
  //
  DwarfCFIException(AsmPrinter *A);
  ~DwarfCFIException() override;

  /// Emit all exception information that should come after the content.
  void endModule() override;

  /// Gather pre-function exception information.  Assumes being emitted
  /// immediately after the function entry point.
  void beginFunction(const MachineFunction *MF) override;

  /// binpang. Special handling of Obfuscating EH frame data.
  // void beginObsBasicBlock(const MachineBasicBlock *MBB) override;

  /// Gather and emit post-function exception information.
  void endFunction(const MachineFunction *) override;

  void beginFragment(const MachineBasicBlock *MBB,
                     ExceptionSymbolProvider ESP) override;

  void beginBasicBlock(const MachineBasicBlock &MBB) override;
  void endBasicBlock(const MachineBasicBlock &MBB) override;
};

class LLVM_LIBRARY_VISIBILITY ARMException : public DwarfCFIExceptionBase {
  void emitTypeInfos(unsigned TTypeEncoding, MCSymbol *TTBaseLabel) override;
  ARMTargetStreamer &getTargetStreamer();

public:
  //===--------------------------------------------------------------------===//
  // Main entry points.
  //
  ARMException(AsmPrinter *A);
  ~ARMException() override;

  /// Emit all exception information that should come after the content.
  void endModule() override {}

  /// Gather pre-function exception information.  Assumes being emitted
  /// immediately after the function entry point.
  void beginFunction(const MachineFunction *MF) override;

  /// Gather and emit post-function exception information.
  void endFunction(const MachineFunction *) override;
};

class LLVM_LIBRARY_VISIBILITY AIXException : public DwarfCFIExceptionBase {
  /// This is AIX's compat unwind section, which unwinder would use
  /// to find the location of LSDA area and personality rountine.
  void emitExceptionInfoTable(const MCSymbol *LSDA, const MCSymbol *PerSym);

public:
  AIXException(AsmPrinter *A);

  void endModule() override {}
  void beginFunction(const MachineFunction *MF) override {}

  void endFunction(const MachineFunction *MF) override;
};
} // End of namespace llvm

#endif

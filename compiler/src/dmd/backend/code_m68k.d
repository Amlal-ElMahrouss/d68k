module dmd.backend.code_m68k;

import dmd.backend.cdef;
import dmd.backend.cc : config, FL;
import dmd.backend.code;
import dmd.backend.codebuilder : CodeBuilder;
import dmd.backend.el : elem;
import dmd.backend.ty : I64;
import dmd.backend.barray;

///Authors: Amlal El Mahrouss
///Bugs: None

///Brief: Motorola 68k support for dmd.

nothrow:
@safe:

alias opcode_t = uint;           // CPU opcode
alias register_t = uint;

enum opcode_t NoOpcode = 0x0000; // not a valid opcode_t

// registers
enum
{
    D0 = 0,
    D1,
    D2,
    D3,
    D4,
    D5,
    D6,
    D7,
    A0,
    A1,
    A2,
    A3,
    A4,
    A5,
    A6,
    SP,
    PC,
    CCR,
    NUM_REGS,
}

public struct CodeRegister
{
    private register_t mReg = D0;

    this(register_t reg)
    {
        this.mReg = reg;
    }

    public bool matches(codeRegister32 reg)
    {
        return mReg ==  reg.mReg;
    }

    public bool matches(register_t reg)
    {
        return mReg ==  reg;
    }

}

// instruction set.

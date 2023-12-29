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
// It is quite barebones right now (no paging or segmentation right now)
// and can only address 32-bit operands, but I plan to improve that.

nothrow:
@safe:

alias opcode_t = char;           // CPU opcode
alias register_t = char;

enum opcode_t nop_value = 0x0000; // not a valid opcode_t

// registers
enum M68KRegisterList
{
    D0 = 0b0,
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

public struct M68KRegisterType
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

    public M68KRegisterList leak()
    {
        return mReg;
    }

}

alias addr_t = ushort;

/// Write a m68k opcode.
/// Params:
///   opcode_type = the opcode id
///   register_info = register id
///   to_mem = to memory -> yes otherwise no.
///   effective_address = the effective address. (PC + ADDR)
/// Returns:

public uint16_t writeOpcode68k(opcode_t opcode_type,
                                M68KRegisterType register_info,
                                bool to_mem,
                                addr_t effective_address)
{
    uint16_t opcode = (opcode_type) | 0b00_00_00_00_00_00_00_00;
    opcode = (register_index << 6) | opcode;

    if (to_mem)
        opcode = (0b1 << 11) | opcode;

    opcode = (0b11 << 13) | opcode;
    opcode = (-((opcode & -opcode) & opcode) << effective_address) | opcode;

    return opcode;
}

// so that we can give warnings about it.

const uint m68k_max_addressable = 0xFFFFFFFF;
const uint m68k_min_addressable = 0x00000000;

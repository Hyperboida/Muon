const std = @import("std");
const Header = struct {
    version: u16,
    s_count: u32,
    endian: u1,
    obj_type: u2,
    class: u1

};

const SectionFlags = packed struct {
    executable: bool,
    writable: bool,
    readable: bool,
    exclude: bool,
};

const SectionData = union(enum) {
    Data: []const u8,
    Text: []Instr,
    //Bss,
    //SymTab,
    //Reloc,
    //Debug
};

const SectionTableEntry = struct {
    offset: u64,
    size: u64,
    flags: SectionFlags,
    s_data: SectionData
};

const SectionTable = struct {
    sections: std.ArrayList(SectionTableEntry)   
};

pub const MuonObject = struct {
    header: Header,
    s_table: SectionTable,

};

const Instr = struct {
    opcode: Opcode,
    mode: u8,
};

const Immediate = union(enum) {
    b1: u8,
    b2: u16,
    b4: u32,
    b8: u64,
    b16: u128
};

const Register = union(enum) {
    r: u8,
    a: u8,
    f: u8,
    mm: u8
};

const Dest = union(enum) {
    Register: Register,
    DirectMemory: u64,
    IndirectMemory: Register,
    BaseAddressing: struct {
        base_reg: Register, 
        disp: i64
    },
    IndexedAddressing: struct {
        base_reg: Register,
        index_reg: Register,
        scale: u8,
        displ: i64
    },
    PCRelative: i64,
    StackAddressing: i64
};

const Src = union(enum) {
    Register: Register,
    DirectMemory: u64,
    IndirectMemory: Register,
    BaseAddressing: struct {
        base_reg: Register, 
        disp: i64
    },
    IndexedAddressing: struct {
        base_reg: Register,
        index_reg: Register,
        scale: u8,
        displ: i64
    },
    PCRelative: i64,
    StackAddressing: i64,
    Immediate: Immediate

};

const DestSrc = .{Dest, Src};

const Opcode = union(enum) {
    Add: DestSrc,
    AddI: DestSrc,
    AddF: DestSrc,
    Sub:  DestSrc,
    SubI: DestSrc,
    SubF: DestSrc,
    Mul:  DestSrc,
    MulI: DestSrc,
    MulF: DestSrc,
    Div:  DestSrc,
    DivI: DestSrc,
    DivF: DestSrc,
    Inc:  Dest,
    Dec: Dest,
    Cmp: DestSrc,
    Jmp: Src,
    Jeq: Src,
    Jnq: Src,
    Jg: Src,
    Jl: Src,
    Jge: Src,
    Jle: Src,
    And: DestSrc,
    Or: DestSrc,
    Xor: DestSrc,
    Not: DestSrc,
    Lsh: DestSrc,
    Rsh: DestSrc,
    Mov: DestSrc,
    Call: Src,
    Push: Src,
    Pop: Dest,
    Lea: DestSrc,
};

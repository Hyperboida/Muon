const std = @import("std");

pub const uclass = u64;
pub const iclass = i64;

pub const Header = struct {
    version: u32,
    s_count: u32,
    endian: std.builtin.Endian,
    obj_type: enum{Obj, Exe, Reloc, Shared},
    class: enum {x32, x64},
    s_table_offset: uclass

};

pub const SectionFlags = packed struct {
    executable: bool,
    writable: bool,
    readable: bool,
    exclude: bool,
};

pub const SectionData = union(enum) {
    Data: []u8,
    Text: []Instr,
    //Bss,
    //SymTab,
    //Reloc,
    //Debug
};

pub const SectionTableEntry = struct {
    flags: SectionFlags,
    s_data: SectionData
};

pub const SectionTable = struct {
    sections: std.ArrayList(SectionTableEntry)   
};

pub const MuonObject = struct {
    header: Header,
    s_table: SectionTable,

};


pub const Immediate = union(enum) {
    b8: u8,
    b16: u16,
    b32: u32,
    b64: u64,
};

pub const Register = union(enum) {
    r: u32,
    a: u32,
    f: u32,
    mm: u32 //unsupported
};

pub const Dest = union(enum) {
    RegisterDirect: Register,
    RegisterIndirect: Register,
    RegisterIndirectOffset: struct {
        base_reg: Register,
        offset: iclass
    },
    MemoryDirect: uclass,
    PCRelative: iclass,
    StackRelative: iclass,
};

pub const Src = union(enum) {
    Immediate: Immediate,
    RegisterDirect: Register,
    RegisterIndirect: Register,
    RegisterIndirectOffset: struct {
        base_reg: Register,
        offset: iclass
    },
    MemoryDirect: uclass,
    PCRelative: iclass,
    StackRelative: iclass,
};

pub const DestSrc = struct{Dest, Src};

pub const Instr = union(enum) {
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

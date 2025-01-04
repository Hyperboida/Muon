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
    b1: u8,
    b2: u16,
    b4: u32,
    b8: u64,
};

pub const Register = union(enum) {
    r: u8,
    a: u8,
    f: u8,
    mm: u8 //unsupported
};

pub const Dest = union(enum) {
    Register: Register,
    DirectMemory: uclass,
    IndirectMemory: Register,
    BaseAddressing: struct {
        base_reg: Register, 
        disp: iclass
    },
    IndexedAddressing: struct {
        base_reg: Register,
        index_reg: Register,
        scale: u8,
        displ: iclass
    },
    PCRelative: iclass,
    StackAddressing: iclass
};

pub const Src = union(enum) {
    Register: Register,
    DirectMemory: uclass,
    IndirectMemory: Register,
    BaseAddressing: struct {
        base_reg: Register, 
        disp: iclass
    },
    IndexedAddressing: struct {
        base_reg: Register,
        index_reg: Register,
        scale: u8,
        displ: iclass
    },
    PCRelative: iclass,
    StackAddressing: iclass,
    Immediate: Immediate

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

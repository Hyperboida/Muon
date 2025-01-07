const std = @import("std");

pub const SPEC_VERSION = 1;
pub const uclass = u64;
pub const iclass = i64;

pub const Header = struct {
    version: u32,
    s_count: u32,
    endian: std.builtin.Endian,
    obj_type: enum{Obj, Exe, Reloc, Shared},
    class: enum {x32, x64},
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
    allocator: std.mem.Allocator

};


pub const Immediate = union(enum) {
    b8: u8,
    b16: u16,
    b32: u32,
    b64: u64,
};

pub const Register = union(enum) {
    r: u32, //0 < x <= max/4
    a: u32, //max/4 < x <= max/2
    f: u32, //max/2 < x <= (max * 3)/4
    mm: u32 //unsupported, (max * 3)/4 < x <= max
};

pub const Dest = union(enum) {
    RegisterDirect: Register,
    RegisterIndirect: Register,
    RegisterIndirectOffset: struct {
        base_reg: Register,
        offset: iclass
    },
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

pub const Opcode = enum(u8){
    Nop = 0,
    Add = 1,
    AddI = 2,
    AddF = 3,
    Sub = 4,
    SubI = 5,
    SubF = 6,
    Mul = 7,
    MulI = 8,
    MulF = 9,
    Div = 10,
    DivI = 11,
    DivF = 12,
    Inc = 13,
    Dec = 14,
    Cmp = 15,
    Jmp = 16,
    Jeq = 17,
    Jnq = 18,
    Jg = 19,
    Jl = 20,
    Jge = 21,
    Jle = 22,
    And = 23,
    Or = 24,
    Xor = 25,
    Not = 26,
    Lsh = 27,
    Rsh = 28,
    Mov = 29,
    Call = 30,
    Push = 31,
    Pop = 32,
    Lea = 33,

};

pub const Instr = union(enum) {
    Nop,
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

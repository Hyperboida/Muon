const std = @import("std");
const types = @import("../types.zig");

fn MObjectDefault (allocator: std.mem.Allocator) types.MuonObject {
    return .{ 
        .header = .{
            .version = types.SPEC_VERSION,
            .s_count = 0,
            .endian = .Little,
            .obj_type = .Obj,
            .class = .x32,
        },
        .s_table = .{
            .sections = std.ArrayList(types.SectionTableEntry).init(allocator)
        }
    };
}

pub const MuonBuilder = struct {
    object: *types.MuonObject,
    allocator: std.mem.Allocator,

    fn init(allocator: std.Allocator) !MuonBuilder {
        const obj = try allocator.alloc(types.MuonObject, 1);
        obj.* = MObjectDefault;
        return .{
            .object = obj,
            .allocator = allocator
        };
    }

    fn build(self: *@This()) *types.MuonObject {
        return self.object;
    }
    
    //builder methods

    fn set_endian(self: *@This(), endian: std.builtin.Endian) *@This() {
        self.object.header.endian = endian;
        return self;
    }

    fn set_class(self: *@This(), class: enum{x32, x64}) *@This() {
        self.object.header.class = if(class == .x32) .x32 else .x64;
        return self;
    }
    
    fn add_section(self: *@This(), section: *types.SectionTableEntry) *@This() {
        self.object.s_table.sections.push(section);
        return self;
    }

};


const TextBuilder = struct {
    text: std.ArrayList(Instr),
    flags: SectionFlags,
    fn init(allocator: Allocator) TextBuilder {
        return .{
            .text = std.ArrayList(Instr).init(allocator)
        };
    }

    fn build(self: *@This()) !

    fn add_instr(self: *@This(), instr: Instr) *@This() {
        self.text.push(instr);
        return self;
    }

    fn set_flags(self: *@This(), flags: SectionFlags) *@This {
        self.flags = flags;
        return self;
    }
}

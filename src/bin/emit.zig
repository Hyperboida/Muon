const std = @import("std");
const types = @import("types");

pub fn emit(self: *types.MuonObject, out: *std.ArrayList(u8)) !void {
    try emit_writer(self, &out.writer()); 
}

pub fn emit_writer(self: *types.MuonObject, writer: anytype) !void {
    try emit_header(self, writer);
}

fn emit_header(obj: *types.MuonObject, writer: anytype) !void {
    const header = obj.header;
    try writer.writeAll("MUON");
    try writer.writeInt(u32, header.version);
    const endian = if (header.endian == .Little) 0 else 1;
    const obj_type = switch(header.obj_type) {
        .Obj => 0,
        .Exe => 1,
        .Reloc => 2,
        .Shared => 3
    };
    const class = if(header.class == .x32) 0 else 1;
    const mode = endian | (obj_type >> 1) | (class >> 3);
    std.debug.print("mode: {}", mode);

}

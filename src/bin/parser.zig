const std = @import("std");
const types = @import("../types.zig");
const uclass = types.uclass;

///Converts an array of bytes into a MuonObject. The bytes must be a valid muon object.
pub fn parse(bin: []const u8) !types.MuonObject {
    var fbs = std.io.fixedBufferStream(bin);
    const reader = fbs.reader();
    return parse_reader(reader);
}

///Create a MuonObject from a Reader.
pub fn parse_reader(in_reader: anytype) !types.MuonObject {
    var reader = std.io.countingReader(in_reader);
    const m_object = undefined;
    const header = try parse_header(@TypeOf(in_reader), &reader);
    _ = header;
    return m_object;
}

//creates a SectionTable from a reader
fn parse_s_table(comptime R: type, creader: *std.io.CountingReader(R), header: types.Header) !types.SectionTable {
    var reader = creader.reader();
    if (header.s_count == 0) return error.NoSections;
    const STableType = struct { //intermediate type to store section data
        s_type: u8,
        offset: uclass,
        size: uclass,
        flags: u8
    };
    var entries = std.ArrayList(STableType).init();
    defer entries.deinit();
    for(0..header.s_count) |_|{
        const s_type = try reader.readByte(); //<type: 1b>
        const offset = try reader.readVarInt(uclass, header.endian, header.class); //<offset: ?b>
        const size = try reader.readVarInt(uclass, header.endian, header.class); //<size: ?b>
        const flags = try reader.readByte(); //<flags: 1b>
        entries.push(STableType {
            .s_type = s_type,
            .offset = offset,
            .size = size,
            .flags = flags
        });
    }
    var s_table_entries = std.ArrayList(types.SectionTableEntry).init();
    for(entries) |entry| { //construct and move the reader to each section in the object
        try reader.skipBytes(entry.offset - creader.bytes_read);
        const buffer: []u8 = [entry.size]u8{}; //TODO: change to heap allocated
        _ = try reader.read(buffer);
        const flags = types.SectionFlags {
            .executable = entry.flags & 0b0001 != 0,
            .writable = entry.flags & 0b0010 != 0,
            .readable = entry.flags & 0b0100 != 0,
            .exclude = entry.flags & 0b1000 != 0
        };
        const s_data = switch(entry.s_type) {
            0 => .Data{buffer},
            1 => .Text{{}},
            else => return error.UnsupportedSectionType
        };
        s_table_entries.push(.{
            .flags = flags,
            .s_data = s_data
        });


    }

}

//parses the header from a reader
fn parse_header(comptime R: type, creader: *std.io.CountingReader(R)) !types.Header {
    var reader = creader.reader();
    if (!try reader.isBytes("MUON")) return error.InvalidMagic;
    const version = try reader.readInt(u32, std.builtin.Endian.little); //<version: 4b>
    const mode = try reader.readByte(); //<mode: 1b>
    const endian = if (mode & 0x01 == 1) std.builtin.Endian.big else std.builtin.Endian.little;
    const class: u8 = if ((mode & 0x8) == 8) 8 else 4;
    std.debug.print("class: {}\n", .{mode & 0x8});
    const s_count = try reader.readInt(u32, endian); //<section_count: 4b>
    _ = try reader.skipBytes(5, .{}); //skip reserved bytes (also aligns it to a four byte boundry)
    const s_table_offset = try reader.readVarInt(uclass, endian, class); //The offset of the section_table
    const header = types.Header {
        .version = version,
        .s_count = s_count,
        .endian = endian,
        .obj_type = switch (mode & 0b0110) {
            0 => .Obj,
            1 => .Exe,
            2 => .Reloc,
            3 => .Shared,
            else => return error.InvalidObjectType
        },
        .class = if (class == 4) .x32 else .x64,
        .s_table_offset = s_table_offset
    };
    return header;

}

fn parse_text(reader: anytype, header: types.Header) ![]types.Instr {
     
}

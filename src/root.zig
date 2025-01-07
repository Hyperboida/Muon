const types = @import("types");
const bin = @import("bin/parser.zig");
const emit = @import("bin/emit.zig");
const builder = @import("bin/builder.zig");
comptime {
    const std = @import("std");
    std.testing.refAllDecls(@This());
}

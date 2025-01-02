const std = @import("std");
const types = @import("types.zig");
const builder = @import("bin/parser.zig");
pub fn main() void {
    std.debug.print("Hello, World\n", .{});
    const ref = types;
    _ = ref;
    const ref1 = builder;
    _ = ref1;
}

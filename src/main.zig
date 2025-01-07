const std = @import("std");
const types = @import("types.zig");
const parser = @import("bin/parser.zig");
const iter = @import("utils/iterator.zig");
const builder = @import("bin/builder.zig");
pub fn main() !void {
    std.debug.print("Hello, World\n", .{});
   var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    var args = try std.process.argsWithAllocator(alloc.allocator());
    _ = args.skip();
    const path =  args.next() orelse return error.TooFewArgs;
    defer args.deinit();
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const val = try parser.parse_reader(file.reader());
    _ = val;
}
comptime {
    std.testing.refAllDecls(@This());
}


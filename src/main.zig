const std = @import("std");
const types = @import("types.zig");
const builder = @import("bin/parser.zig");
const iter = @import("utils/iterator.zig");
pub fn main() !void {
    std.debug.print("Hello, World\n", .{});
    const ref = types;
    _ = ref;
    const ref1 = builder;
    _ = ref1;
    const ref2 = iter;
    _ = ref2;
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    var args = try std.process.argsWithAllocator(alloc.allocator());
    _ = args.skip();
    const path =  args.next() orelse return error.TooFewArgs;
    defer args.deinit();
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    const val = try builder.parse_reader(file.reader());
    _ = val;
}

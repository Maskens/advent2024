const std = @import("std");
pub fn main() !void {
    const apa = [_]u8{ 0, 1, 2, 3, 4, 5, 6 };

    const apa2 = apa[3..5];

    std.debug.print("Apa", .{});

    for (apa2) |n| {
        std.debug.print("{d}", .{n});
    }
}

const std = @import("std");
const map = @import("map.zig");

const WIDTH: u32 = 10;
const HEIGHT: u32 = 10;
const word = "XMAS";

pub fn main() !void {
    var buf = [_]u8{0} ** ((WIDTH + 1) * HEIGHT);

    _ = try std.fs.cwd().readFile("input_test.txt", &buf);

    const array: [WIDTH * HEIGHT]u8 = .{0} ** (WIDTH * HEIGHT);

    var m = map.Map{
        .width = 10,
        .height = 10,
        .map = array,
    };

    m.loadData(&buf);

    for (0..HEIGHT) |y| {
        for (0..WIDTH) |x| {
            // const c = try map.getChar(@intCast(x), @intCast(y));
            // std.debug.print("{c}", .{c});
            // Test for word
            const found = m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = 1, .y = 0 },
            );

            if (found) {
                std.debug.print("Found!", .{});
            }
        }
    }
}

// test "simple test" {
//     var list = std.ArrayList(i32).init(std.testing.allocator);
//     defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
//     try list.append(42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }

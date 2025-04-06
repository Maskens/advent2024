const std = @import("std");
const map = @import("map.zig");

//const WIDTH: u32 = 10;
//const HEIGHT: u32 = 10;
const WIDTH: u32 = 140;
const HEIGHT: u32 = 140;
const word = "MAS";

pub fn main() !void {
    var buf = [_]u8{0} ** ((WIDTH + 1) * HEIGHT);

    _ = try std.fs.cwd().readFile("real_input.txt", &buf);

    const array: [WIDTH * HEIGHT]u8 = .{0} ** (WIDTH * HEIGHT);

    var m = map.Map{
        .width = WIDTH,
        .height = HEIGHT,
        .map = array,
    };

    m.loadData(&buf);

    var found_counter: u32 = 0;

    for (0..HEIGHT) |y| {
        for (0..WIDTH) |x| {
            const _x: i32 = @intCast(x);
            const _y: i32 = @intCast(y);

            const found_upper_left = m.findWord(
                "MAS",
                _x - 1,
                _y - 1,
                map.Dir{ .x = 1, .y = 1 },
            ) or m.findWord(
                "SAM",
                _x - 1,
                _y - 1,
                map.Dir{ .x = 1, .y = 1 },
            );

            const found_upper_right = m.findWord(
                "MAS",
                _x + 1,
                _y - 1,
                map.Dir{ .x = -1, .y = 1 },
            ) or m.findWord(
                "SAM",
                _x + 1,
                _y - 1,
                map.Dir{ .x = -1, .y = 1 },
            );

            if (found_upper_left and found_upper_right) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }
        }
    }

    std.debug.print("Found {d} number of words!", .{found_counter});
}

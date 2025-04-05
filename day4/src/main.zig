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

    var found_counter: u32 = 0;

    for (0..HEIGHT) |y| {
        for (0..WIDTH) |x| {

            // RIGHT
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = 1, .y = 0 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }

            // LEFT
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = -1, .y = 0 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }

            // DOWN
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = 0, .y = 1 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }

            // UP
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = 0, .y = -1 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }

            // UP RIGHT
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = 1, .y = -1 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }

            // UP LEFT
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = -1, .y = -1 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }

            // DOWN LEFT
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = -1, .y = 1 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }

            // DOWN RIGHT
            if (m.findWord(
                word,
                @intCast(x),
                @intCast(y),
                map.Dir{ .x = 1, .y = 1 },
            )) {
                std.debug.print("Found word at {d}, {d}!\n", .{ x, y });
                found_counter += 1;
            }
        }
    }

    // std.debug.print("{c}", .{try m.getChar(4, 1)});
    // std.debug.print("{c}", .{try m.getChar(3, 1)});
    // std.debug.print("{c}", .{try m.getChar(2, 1)});
    // std.debug.print("{c}", .{try m.getChar(1, 1)});

    std.debug.print("Found {d} number of words!", .{found_counter});
}

// test "simple test" {
//     var list = std.ArrayList(i32).init(std.testing.allocator);
//     defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
//     try list.append(42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }

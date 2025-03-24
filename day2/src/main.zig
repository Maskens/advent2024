const std = @import("std");

const Direction = enum { noop, same, increasing, decreasing };

pub fn main() !void {
    const content = try readFile("real_input.txt", std.heap.page_allocator);

    var lines = std.mem.splitSequence(u8, content, "\n");

    var noOfSafe: u32 = 0;

    while (lines.next()) |line| {
        var numberList = std.ArrayList(u32).init(std.heap.page_allocator);
        defer numberList.deinit();

        try getNumberSeries(line, &numberList);

        if (numberList.items.len == 0) break;

        std.debug.print("Testing numbers: ", .{});
        for (numberList.items) |item| {
            std.debug.print("{d} ", .{item});
        }

        if (isSafe(numberList.items)) {
            std.debug.print(" Safe!", .{});
            noOfSafe += 1;
        } else {
            std.debug.print(" Not safe!", .{});
        }

        std.debug.print("\n", .{});
    }

    std.debug.print("{d}", .{noOfSafe});
}

fn getNumberSeries(string_numbers: []const u8, numbers: *std.ArrayList(u32)) !void {
    var number_iterator = std.mem.splitScalar(u8, string_numbers, ' ');

    while (number_iterator.next()) |number| {
        const n = std.fmt.parseInt(u32, number, 10) catch {
            break;
        };

        try numbers.*.append(n);
    }
}

fn getDirection(n1: u32, n2: u32) Direction {
    if (n1 == n2) {
        return Direction.same;
    }

    if (n1 < n2) {
        return Direction.increasing;
    }

    return Direction.decreasing;
}

fn getDistance(n1: i32, n2: i32) u32 {
    return @abs(n1 - n2);
}

fn isSafe(numbers: []u32) bool {
    var cur_distance: i32 = 0;
    for (numbers, 0..) |number, i| {
        if (i + 1 == numbers.len) {
            break;
        }

        const num1: i32 = @intCast(numbers[i]);
        const num2: i32 = @intCast(numbers[i + 1]);
        std.debug.print("{d},{d}", .{ num1, num2 });

        const distance: i32 = num1 - num2;

        if (distance == 0 or @abs(distance) > 3) return false;

        if (i == 0) {
            cur_distance = distance;
            continue;
        }

        if (distance > 0 and cur_distance < 0) {
            return false;
        }

        if (distance < 0 and cur_distance > 0) {
            return false;
        }

        std.debug.print("{d} ", .{number});
    }

    return true;
}

fn readFile(name: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const content = std.fs.cwd().readFileAlloc(allocator, name, 99999);

    return content;
}

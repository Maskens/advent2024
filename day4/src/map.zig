pub const MapError = error{NotFound};

const std = @import("std");

const WIDTH: u32 = 10;
const HEIGHT: u32 = 10;

pub const Dir = struct {
    x: i32,
    y: i32,
};

pub const Map = struct {
    width: u32,
    height: u32,
    map: [WIDTH * HEIGHT]u8,

    pub fn getChar(self: *Map, x: i32, y: i32) MapError!u8 {
        if (x < 0 or y < 0 or x >= self.width or y >= self.height) {
            return MapError.NotFound;
        }

        // Calculate x and y pos in map
        const _x: u32 = @intCast(x);
        const _y: u32 = @intCast(y);

        return self.map[_x + _y * self.width];
    }

    pub fn loadData(self: *Map, file_str: []u8) void {
        var i: u32 = 0;
        for (file_str) |c| {
            if (c == '\n') {
                continue;
            }

            self.map[i] = c;
            i += 1;
        }
    }

    pub fn print(self: *Map) void {
        for (self.map, 0..self.map.len) |c, i| {
            std.debug.print("{c}", .{c});
            if ((i + 1) % WIDTH == 0) {
                std.debug.print("\n", .{});
            }
        }
    }

    pub fn findWord(
        _: *Map,
        word: []const u8,
        x: u32,
        y: u32,
        _: Dir,
    ) bool {
        std.debug.print("{s}, {d}, {d}", .{ word, x, y });
        return true;
    }
};

const std = @import("std");

pub fn main() !void {
    var buf: [32]u8 = undefined;
    const file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();
    var file_reader = file.reader();

    var output_fbs = std.io.fixedBufferStream(&buf);
    const writer = output_fbs.writer();

    var list1 = std.ArrayList(i32).init(std.heap.page_allocator);
    var list2 = std.ArrayList(i32).init(std.heap.page_allocator);

    defer list1.deinit();
    defer list2.deinit();

    while (true) {
        file_reader.streamUntilDelimiter(writer, '\n', null) catch |err| {
            switch (err) {
                error.EndOfStream => {
                    output_fbs.reset();
                    break;
                },
                else => {
                    std.debug.print("Error while reading file: {any}\n", .{err});
                    return err;
                }
            }
        };

        const line = output_fbs.getWritten();
        const index = std.mem.indexOf(u8, line, " ").?;

        const first_number = line[0..index];
        const second_number = line[(index+3)..line.len];

        const first_int = try std.fmt.parseInt(i32, first_number, 10);
        const second_int = try std.fmt.parseInt(i32, second_number, 10);

        try list1.append(first_int);
        try list2.append(second_int);

        std.debug.print("{d} ", .{first_int});
        std.debug.print("{d}\n", .{second_int});

        output_fbs.reset();
    }

    std.mem.sort(i32, list1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, list2.items, {}, std.sort.asc(i32));

    var total_distance: u32 = 0;
    for (list1.items, 0..) |item, index| {
        const number1 = item;
        const number2 = list2.items[index];

        const distance = @abs(number1 - number2);
        total_distance += distance;
    }

    std.debug.print("{d}", .{total_distance});
}

pub fn main() !void {
    var stdout_buffer: [1000]u8 = undefined;
    var stdout_writer: File15.Writer = .init(stdoutFile(), &stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("Hello {s}\n", .{"iobackport"});
    try stdout.flush();

    {
        const tmp_file = try std.fs.cwd().createFile("test.txt", .{ .read = true });
        defer tmp_file.close();
        defer std.fs.cwd().deleteFile("test.txt") catch {};

        var write_buffer: [1024]u8 = undefined;
        var file_writer: File15.Writer = .init(tmp_file, &write_buffer);
        const writer = &file_writer.interface;

        try writer.writeAll("Hello from file writer!\n");
        try writer.writeAll("This is a test.\n");

        try tmp_file.seekTo(0);

        var read_buffer: [1024]u8 = undefined;
        var file_reader: File15.Reader = .init(tmp_file, &read_buffer);
        const reader = &file_reader.interface;

        var content_buffer: [256]u8 = undefined;
        const bytes_read = try reader.readSliceShort(&content_buffer);

        try stdout.print("Read {} bytes from file: {s}\n", .{
            bytes_read,
            content_buffer[0..bytes_read],
        });
        try stdout.flush();
    }
}

pub const zig_atleast_15 = @import("builtin").zig_version.order(.{ .major = 0, .minor = 15, .patch = 0 }) != .lt;

const builtin = @import("builtin");
const std = @import("std");
const std15 = if (zig_atleast_15) std else @import("std15");

const Writer = std15.Io.Writer;
const Reader = std15.Io.Reader;

const Stream15 = if (zig_atleast_15) std.net.Stream else std15.net.Stream15;
const File15 = if (zig_atleast_15) std.fs.File else std15.fs.File15;

pub fn stdoutFile() std.fs.File {
    return if (zig_atleast_15) std.fs.File.stdout() else std.io.getStdOut();
}

pub fn socketWriter(stream: std.net.Stream, buffer: []u8) Stream15.Writer {
    if (zig_atleast_15) return stream.writer(buffer);
    return .init(stream, buffer);
}
pub fn socketReader(stream: std.net.Stream, buffer: []u8) Stream15.Reader {
    if (zig_atleast_15) return stream.reader(buffer);
    return .init(stream, buffer);
}

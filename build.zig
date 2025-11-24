const std = @import("std");

const zig_atleast_15 = @import("builtin").zig_version.order(.{ .major = 0, .minor = 15, .patch = 0 }) != .lt;

pub fn build(b: *std.Build) void {
    const std15_mod = b.addModule("std15", .{
        .root_source_file = b.path("src/std.zig"),
    });

    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{
        .name = "iobackport-example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("example/example.zig"),
            .target = target,
            .optimize = .Debug,
        }),
    });
    if (!zig_atleast_15) {
        exe.root_module.addImport("std15", std15_mod);
    }
    const install = b.addInstallArtifact(exe, .{});
    b.step("install-example", "").dependOn(&install.step);
    const run = b.addRunArtifact(exe);
    run.step.dependOn(&install.step);
    if (b.args) |args| run.addArgs(args);
    b.step("example", "").dependOn(&run.step);
}

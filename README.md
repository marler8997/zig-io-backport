# zio-io-backport

Zig's 0.15 IO backported to 0.14. This project allows you to write zig code that works on both 0.14 and 0.15 while also utilizing the new Reader/Writer interfaces on both versions.

# How to use

Example `build.zig.zon`:
```zig
    // ...
    .dependencies = .{
        .iobackport = .{
            .url = "git+https://github.com/marler8997/zig-io-backport#INSERT_SHA_HERE",
            .hash = "INSERT_HASH_HERE",
            .lazy = true,
        },
    },
```

Example `build.zig`:
```zig
pub const zig_atleast_15 = @import("builtin").zig_version.order(.{ .major = 0, .minor = 15, .patch = 0 }) != .lt;

// ...

    if (!zig_atleast_15) {
        if (b.lazyDependency("iobackport", .{})) |iobackport| {
            x_mod.addImport("std15", iobackport_dep.module("std15"));
        }
    }
```

See [example/example.zig](example/example.zig) for example usage.

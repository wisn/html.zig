const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const internal_module = b.createModule(.{
        .root_source_file = b.path("src/html/internal/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{},
    });

    const transformer_module = b.createModule(.{
        .root_source_file = b.path("src/html/transformer/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "internal", .module = internal_module },
        },
    });

    const validation_module = b.createModule(.{
        .root_source_file = b.path("src/html/validation/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "internal", .module = internal_module },
        },
    });

    const base_module = b.createModule(.{
        .root_source_file = b.path("src/html/base/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "internal", .module = internal_module },
            .{ .name = "transformer", .module = transformer_module },
            .{ .name = "validation", .module = validation_module },
        },
    });

    const element_module = b.createModule(.{
        .root_source_file = b.path("src/html/element/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "base", .module = base_module },
            .{ .name = "internal", .module = internal_module },
            .{ .name = "transformer", .module = transformer_module },
            .{ .name = "validation", .module = validation_module },
        },
    });

    // This creates a "module", which represents a collection of source files alongside
    // some compilation options, such as optimization mode and linked system libraries.
    // Every executable or library we compile will be based on one or more modules.
    const html_module = b.addModule("html", .{
        // `root_source_file` is the Zig "entry point" of the module. If a module
        // only contains e.g. external object files, you can make this `null`.
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/html/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "base", .module = base_module },
            .{ .name = "element", .module = element_module },
            .{ .name = "transformer", .module = transformer_module },
        },
    });

    // Now, we will create a static library based on the module we created above.
    // This creates a `std.Build.Step.Compile`, which is the build step responsible
    // for actually invoking the compiler.
    const html = b.addLibrary(.{
        .linkage = .static,
        .name = "html",
        .root_module = html_module,
    });

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(html);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    // const html_tests = b.addTest(.{
    //     .root_source_file = b.path("tests/html.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });
    const html_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/html/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "html", .module = html_module },
            },
        }),
    });
    const run_html_tests = b.addRunArtifact(html_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_html_tests.step);
}

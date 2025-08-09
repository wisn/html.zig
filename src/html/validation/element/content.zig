const std = @import("std");
const internal = @import("internal");
const constant = internal.constant;
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_listing(children: *const []const Entity) void {
    const supported_child = std.StaticStringMap(void).initComptime(.{
        .{"li"},
        .{"script"},
        .{"template"},
    });

    for (children.*) |child| {
        if (child.definition == .comment) {
            continue;
        }

        const child_name = child.definition.element.name;
        if (!supported_child.has(child_name)) {
            @compileError(InvalidContentModel("The \"" ++ child_name ++ "\" element is not supported in the ol element."));
        }
    }
}

const std = @import("std");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_html(children: *const []const Entity) void {
    const error_message = InvalidContentModel("The html element must have two children, a head element followed by a body element.");

    if (children.len != 2) {
        @compileError(error_message);
    }

    const first_element = children.*[0].definition.element;
    const second_element = children.*[1].definition.element;

    if (!eql(u8, first_element.name, "head") or !eql(u8, second_element.name, "body")) {
        @compileError(error_message);
    }
}

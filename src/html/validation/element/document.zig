const std = @import("std");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentAttribute = internal.constant.errors.InvalidContentAttribute;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_html(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;
    const error_message = InvalidContentModel("The html element must have two children, a head element followed by a body element.");

    if (children.len != 2) {
        @compileError(error_message);
    }

    const first_element = children[0].definition.element;
    const second_element = children[1].definition.element;

    if (!eql(u8, first_element.name, "head") or !eql(u8, second_element.name, "body")) {
        @compileError(error_message);
    }

    if (internal.util.has_undefined_attribute(&element.attributes)) {
        @compileError(InvalidContentAttribute("Only global attributes and event handler attributes are supported in the html element."));
    }
}

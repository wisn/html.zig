const std = @import("std");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const eql = std.mem.eql;

pub fn validate_head(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;
    comptime var title_element_count = 0;
    comptime var base_element_count = 0;

    for (children) |child| {
        if (eql(u8, child.definition.element.name, "title")) {
            title_element_count += 1;
        }

        if (eql(u8, child.definition.element.name, "base")) {
            base_element_count += 1;
        }
    }

    if (title_element_count != 1) {
        @compileError("InvalidContentModel: The head element must have exactly one title element.");
    }

    if (base_element_count > 1) {
        @compileError("InvalidContentModel: The head element must have at most one base element.");
    }

    if (internal.util.has_undefined_attribute(&element.attributes)) {
        @compileError("InvalidContentAttribute: Only global attributes and event handler attributes are supported in the head element.");
    }
}

pub fn validate_title(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;
    const error_message = "InvalidContentModel: The title element must only be a sanitized text.";

    if (children.len == 0) {
        @compileError("InvalidContentModel: The title element must not be blank.");
    }

    comptime var text_element_count = 0;

    for (children) |child| {
        if (child.definition == .text) {
            text_element_count += 1;
        }
    }

    if (children.len != text_element_count) {
        @compileError(error_message);
    }

    if (internal.util.has_undefined_attribute(&element.attributes)) {
        @compileError("InvalidContentAttribute: Only global attributes and event handler attributes are supported in the title element.");
    }
}

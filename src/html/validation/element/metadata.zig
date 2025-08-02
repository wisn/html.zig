const std = @import("std");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_head(children: *const []const Entity) void {
    comptime var title_element_count = 0;
    comptime var base_element_count = 0;

    for (children.*) |child| {
        if (child.definition == .comment) {
            continue;
        }

        if (eql(u8, child.definition.element.name, "title")) {
            title_element_count += 1;
        }

        if (eql(u8, child.definition.element.name, "base")) {
            base_element_count += 1;
        }
    }

    if (title_element_count != 1) {
        @compileError(InvalidContentModel("The head element must have exactly one title element."));
    }

    if (base_element_count > 1) {
        @compileError(InvalidContentModel("The head element must have at most one base element."));
    }
}

pub fn validate_title(children: *const []const Entity) void {
    if (children.len == 0) {
        @compileError(InvalidContentModel("The title element must not be blank."));
    }

    comptime var text_element_count = 0;

    for (children.*) |child| {
        if (child.definition == .comment) {
            continue;
        }

        if (child.definition == .text and child.definition.text.sanitize) {
            text_element_count += 1;
        }
    }

    if (children.len != text_element_count) {
        @compileError(InvalidContentModel("The title element must only be a sanitized text."));
    }
}

pub fn validate_style(children: *const []const Entity) void {
    comptime var text_element_count = 0;

    for (children.*) |child| {
        if (child.definition == .text) {
            text_element_count += 1;
        }
    }

    if (children.len != text_element_count) {
        @compileError(InvalidContentModel("The style element children support text only."));
    }
}

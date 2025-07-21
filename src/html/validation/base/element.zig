const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const InvalidElementName = internal.constant.errors.InvalidElementName;
const InvalidAttributeArgument = internal.constant.errors.InvalidAttributeArgument;
const InvalidElementArgument = internal.constant.errors.InvalidElementArgument;
const InvalidElementConstruct = internal.constant.errors.InvalidElementConstruct;

pub fn validate_name(name: []const u8) void {
    for (name) |char| {
        var is_legal = false;

        is_legal = is_legal or ('a' <= char and char <= 'z');
        is_legal = is_legal or ('A' <= char and char <= 'Z');
        is_legal = is_legal or ('0' <= char and char <= '9');

        if (!is_legal) {
            @compileError(InvalidElementName("The given name \"" ++ name ++ "\" contains non-alphanumeric character."));
        }
    }
}

pub fn validate_attributes(attributes: anytype) void {
    const fields = std.meta.fields(@TypeOf(attributes));
    const error_message = InvalidAttributeArgument("Only attribute is allowed.");

    for (fields) |field| {
        const entity = util.fetch_entity(@field(attributes, field.name));

        if (entity == null) {
            @compileError(InvalidAttributeArgument("Unknown type."));
        }

        if (entity.?.definition != .attribute) {
            @compileError(error_message);
        }
    }
}

pub fn validate_elements(elements: anytype) void {
    const fields = std.meta.fields(@TypeOf(elements));
    const error_message = InvalidElementArgument("Only element is allowed.");

    for (fields) |field| {
        const entity = util.fetch_entity(@field(elements, field.name));

        if (entity == null) {
            @compileError(InvalidElementArgument("Unknown type."));
        }

        if (entity.?.definition == .attribute) {
            @compileError(error_message);
        }
    }
}

pub fn validate_arguments(args: anytype, comptime has_attributes: *bool) void {
    const fields = std.meta.fields(@TypeOf(args));
    if (fields.len > 0) {
        const entity = util.fetch_entity(@field(args, fields[0].name));

        if (entity == null) {
            @compileError(InvalidElementConstruct("Unknown argument."));
        }

        switch (entity.?.definition) {
            .attribute => {
                validate_attributes(args);
            },
            .element, .comment, .text => {
                validate_elements(args);
                has_attributes.* = false;
            },
        }
    }
}

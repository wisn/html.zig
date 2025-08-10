const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const Entity = internal.entity.Entity;
const common = @import("common.zig");
const eql = std.mem.eql;
const InvalidContentAttribute = internal.constant.errors.InvalidContentAttribute;

pub fn validate_blockquote(attributes: *const []const Entity) void {
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
        .{"cite"},
    });

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);

        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the blockquote element."));
        }
    }
}

pub fn validate_ol(attributes: *const []const Entity) void {
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
        .{"reversed"},
        .{"start"},
        .{"type"},
    });

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);

        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the ol element."));
        }
    }
}

pub fn validate_li(attributes: *const []const Entity) void {
    // TODO: find a way to validate this if and onlly if the parent is ol element
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
        .{"value"},
    });

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);

        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the li element."));
        }
    }
}

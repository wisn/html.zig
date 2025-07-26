const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const Entity = internal.entity.Entity;
const common = @import("common.zig");
const InvalidContentAttribute = internal.constant.errors.InvalidContentAttribute;

pub fn validate_base(attributes: *const []const Entity) void {
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
        .{"href"},
        .{"target"},
    });

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);
        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the base element."));
        }
    }
}

pub fn validate_link(attributes: *const []const Entity) void {
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
        .{"href"},
        .{"crossorigin"},
        .{"rel"},
        .{"media"},
        .{"integrity"},
        .{"hreflang"},
        .{"type"},
        .{"referrerpolicy"},
        .{"sizes"},
        .{"imagesrcset"},
        .{"imagesizes"},
        .{"as"},
        .{"blocking"},
        .{"color"},
        .{"disabled"},
        .{"fetchpriority"},
    });

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);
        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the link element."));
        }
    }
}

pub fn validate_meta(attributes: *const []const Entity) void {
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
        .{"name"},
        .{"http-equiv"},
        .{"content"},
        .{"charset"},
        .{"media"},
    });

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);
        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the meta element."));
        }
    }
}

pub fn validate_style(attributes: *const []const Entity) void {
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
        .{"media"},
        .{"blocking"},
        .{"type"},
    });

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);
        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the style element."));
        }
    }
}

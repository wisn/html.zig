const std = @import("std");
const internal = @import("internal");
const constant = internal.constant;
const util = internal.util;
const Entity = internal.entity.Entity;
const InvalidContentAttribute = internal.constant.errors.InvalidContentAttribute;

pub fn global_attribute_only(attributes: *const []const Entity) void {
    for (attributes.*) |attribute| {
        if (!is_global_attribute(&attribute)) {
            @compileError(InvalidContentAttribute("Only global attribute supported."));
        }
    }
}

pub fn global_attribute_and_global_event_handler_only(attributes: *const []const Entity) void {
    for (attributes.*) |attribute| {
        if (!is_global_attribute(&attribute) and !is_global_event_handler_attribute(&attribute)) {
            @compileError(InvalidContentAttribute("Only global attribute and global event handler supported."));
        }
    }
}

pub fn is_global_attribute(attribute: *const Entity) bool {
    const attribute_name = util.to_lowercase(attribute.definition.attribute.name);
    return constant.attribute.GLOBAL_ATTRIBUTE.has(attribute_name);
}

pub fn is_global_event_handler_attribute(attribute: *const Entity) bool {
    const attribute_name = util.to_lowercase(attribute.definition.attribute.name);
    return constant.attribute.GLOBAL_EVENT_HANDLER_ATTRIBUTE.has(attribute_name);
}

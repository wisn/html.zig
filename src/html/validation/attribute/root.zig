const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const common = @import("common.zig");
const metadata = @import("metadata.zig");
const section = @import("section.zig");
const Entity = internal.entity.Entity;

pub fn validate_attributes(element_name: []const u8, attributes: *const []const Entity) void {
    const normalized_name = util.to_lowercase(element_name);
    if (validations.has(normalized_name)) {
        validations.get(normalized_name).?(attributes);
    }
}

const validations = std.StaticStringMap(*const fn (*const []const Entity) void).initComptime(.{
    .{ "html", &common.global_attribute_and_global_event_handler_only },
    .{ "head", &common.global_attribute_and_global_event_handler_only },
    .{ "title", &common.global_attribute_and_global_event_handler_only },
    .{ "base", &metadata.validate_base },
    .{ "link", &metadata.validate_link },
    .{ "meta", &metadata.validate_meta },
    .{ "style", &metadata.validate_style },
    .{ "body", &section.validate_body },
    .{ "article", &common.global_attribute_and_global_event_handler_only },
    .{ "section", &common.global_attribute_and_global_event_handler_only },
    .{ "nav", &common.global_attribute_and_global_event_handler_only },
    .{ "aside", &common.global_attribute_and_global_event_handler_only },
    .{ "h1", &common.global_attribute_and_global_event_handler_only },
    .{ "h2", &common.global_attribute_and_global_event_handler_only },
    .{ "h3", &common.global_attribute_and_global_event_handler_only },
    .{ "h4", &common.global_attribute_and_global_event_handler_only },
    .{ "h5", &common.global_attribute_and_global_event_handler_only },
    .{ "h6", &common.global_attribute_and_global_event_handler_only },
});

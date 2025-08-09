const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const common = @import("common.zig");
const metadata = @import("metadata.zig");
const section = @import("section.zig");
const content = @import("content.zig");
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
    .{ "hgroup", &common.global_attribute_and_global_event_handler_only },
    .{ "header", &common.global_attribute_and_global_event_handler_only },
    .{ "footer", &common.global_attribute_and_global_event_handler_only },
    .{ "address", &common.global_attribute_and_global_event_handler_only },
    .{ "p", &common.global_attribute_and_global_event_handler_only },
    .{ "hr", &common.global_attribute_and_global_event_handler_only },
    .{ "pre", &common.global_attribute_and_global_event_handler_only },
    .{ "blockquote", &content.validate_blockquote },
    .{ "ol", &content.validate_ol },
    .{ "ul", &common.global_attribute_and_global_event_handler_only },
    .{ "menu", &common.global_attribute_and_global_event_handler_only },
    // validate li attributes
    .{ "dl", &common.global_attribute_and_global_event_handler_only },
    .{ "dt", &common.global_attribute_and_global_event_handler_only },
    .{ "dd", &common.global_attribute_and_global_event_handler_only },
    .{ "figure", &common.global_attribute_and_global_event_handler_only },
    .{ "figcaption", &common.global_attribute_and_global_event_handler_only },
    .{ "main", &common.global_attribute_and_global_event_handler_only },
    .{ "search", &common.global_attribute_and_global_event_handler_only },
    .{ "div", &common.global_attribute_and_global_event_handler_only },
});

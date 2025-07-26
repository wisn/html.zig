const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const common = @import("common.zig");
const document = @import("document.zig");
const metadata = @import("metadata.zig");
const section = @import("section.zig");
const Entity = internal.entity.Entity;

pub fn validate_children(element_name: []const u8, children: *const []const Entity) void {
    const normalized_name = util.to_lowercase(element_name);
    const max_branches = children.len * validations.kvs.len * std.math.log2_int_ceil(usize, validations.kvs.len);
    @setEvalBranchQuota(max_branches);

    if (validations.has(normalized_name)) {
        validations.get(normalized_name).?(children);
    }
}

const validations = std.StaticStringMap(*const fn (*const []const Entity) void).initComptime(.{
    .{ "html", &document.validate_html },
    .{ "head", &metadata.validate_head },
    .{ "title", &metadata.validate_title },
    .{ "base", &common.validate_void_element },
    .{ "link", &common.validate_void_element },
    .{ "meta", &common.validate_void_element },
    .{ "style", &metadata.validate_style },
    .{ "body", &common.validate_flow_content },
    .{ "article", &common.validate_flow_content },
    .{ "section", &common.validate_flow_content },
    .{ "nav", &common.validate_flow_content },
    .{ "aside", &common.validate_flow_content },
    .{ "h1", &section.heading_validation },
    .{ "h2", &section.heading_validation },
    .{ "h3", &section.heading_validation },
    .{ "h4", &section.heading_validation },
    .{ "h5", &section.heading_validation },
    .{ "h6", &section.heading_validation },
});

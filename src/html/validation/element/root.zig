const std = @import("std");
const internal = @import("internal");
const document = @import("document.zig");
const metadata = @import("metadata.zig");
const section = @import("section.zig");
const Entity = internal.entity.Entity;

pub fn validate_element(entity: *const Entity) void {
    const element = entity.definition.element;
    if (validations.has(element.name)) {
        validations.get(element.name).?(entity);
    }
}

const validations = std.StaticStringMap(*const fn (*const Entity) void).initComptime(.{
    .{ "html", &document.validate_html },
    .{ "head", &metadata.validate_head },
    .{ "title", &metadata.validate_title },
    .{ "base", &metadata.validate_base },
    .{ "link", &metadata.validate_link },
    .{ "meta", &metadata.validate_meta },
    .{ "style", &metadata.validate_style },
    .{ "body", &section.validate_body },
    .{ "article", &section.basic_section_validation },
    .{ "section", &section.basic_section_validation },
    .{ "nav", &section.basic_section_validation },
    .{ "aside", &section.basic_section_validation },
    .{ "h1", &section.heading_validation },
    .{ "h2", &section.heading_validation },
    .{ "h3", &section.heading_validation },
    .{ "h4", &section.heading_validation },
    .{ "h5", &section.heading_validation },
    .{ "h6", &section.heading_validation },
});

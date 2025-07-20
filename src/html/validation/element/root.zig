const std = @import("std");
const internal = @import("internal");
const document = @import("document.zig");
const metadata = @import("metadata.zig");
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
});

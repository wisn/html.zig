const std = @import("std");
const internal = @import("internal");
const constant = internal.constant;
const Entity = internal.entity.Entity;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn heading_validation(children: *const []const Entity) void {
    for (children.*) |child| {
        if (child.definition == .comment or child.definition == .text) {
            continue;
        }

        const element_name = child.definition.element.name;
        if (!constant.content.PHRASING_CONTENT.has(element_name)) {
            @compileError(InvalidContentModel("This element children must be a phrasing content."));
        }
    }
}

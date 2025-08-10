const internal = @import("internal");
const constant = internal.constant;
const util = internal.util;
const Entity = internal.entity.Entity;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_void_element(children: *const []const Entity) void {
    if (children.len > 0) {
        @compileError(InvalidContentModel("A void element must not have any children."));
    }
}

pub fn validate_flow_content(children: *const []const Entity) void {
    for (children.*) |child| {
        if (child.definition != .element) {
            continue;
        }

        const child_name = util.to_lowercase(child.definition.element.name);

        if (!constant.content.FLOW_CONTENT.has(child_name)) {
            @compileError(InvalidContentModel("Only flow content is supported as the element descendants."));
        }
    }
}

pub fn validate_phrasing_content(children: *const []const Entity) void {
    for (children.*) |child| {
        if (child.definition != .element) {
            continue;
        }

        const child_name = util.to_lowercase(child.definition.element.name);

        if (!constant.content.PHRASING_CONTENT.has(child_name)) {
            @compileError(InvalidContentModel("Only phrasing content is supported as the element descendants."));
        }
    }
}

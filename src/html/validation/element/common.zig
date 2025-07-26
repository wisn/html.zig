const internal = @import("internal");
const constant = internal.constant;
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

        const element_name = child.definition.element.name;
        if (!constant.content.FLOW_CONTENT.has(element_name)) {
            @compileError(InvalidContentModel("Only flow content is supported as the child element."));
        }
    }
}

const std = @import("std");
const internal = @import("internal");
const constant = internal.constant;
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn heading_validation(children: *const []const Entity) void {
    for (children.*) |child| {
        if (child.definition == .comment or child.definition == .text) {
            continue;
        }

        const child_name = child.definition.element.name;
        if (!constant.content.PHRASING_CONTENT.has(child_name)) {
            @compileError(InvalidContentModel("This element children must be a phrasing content."));
        }
    }
}

pub fn validate_hgroup(children: *const []const Entity) void {
    comptime var heading_count = 0;
    const heading_element = std.StaticStringMap(void).initComptime(.{
        .{"h1"},
        .{"h2"},
        .{"h3"},
        .{"h4"},
        .{"h5"},
        .{"h6"},
    });
    const additional_child = std.StaticStringMap(void).initComptime(.{
        .{"p"},
        .{"script"},
        .{"template"},
    });

    for (children.*) |child| {
        if (child.definition == .comment or child.definition == .text) {
            continue;
        }

        const child_name = child.definition.element.name;
        if (!heading_element.has(child_name) and !additional_child.has(child_name)) {
            @compileError(InvalidContentModel("The \"" ++ child_name ++ "\" element is not supported in the hgroup element."));
        }

        if (heading_element.has(child_name)) {
            heading_count += 1;
        }
    }

    if (heading_count > 1) {
        @compileError(InvalidContentModel("There must be only one heading element in the hgroup element."));
    }
}

pub fn validate_header_or_footer(children: *const []const Entity) void {
    for (children.*) |child| {
        if (child.definition == .comment or child.definition == .text) {
            continue;
        }

        const child_name = child.definition.element.name;
        if (constant.content.FLOW_CONTENT.has(child_name)) {
            if (eql(u8, child_name, "header") or eql(u8, child_name, "footer")) {
                @compileError(InvalidContentModel("Both header and footer elements are not supported as the element descendants."));
            }
        } else {
            @compileError(InvalidContentModel("The element descendants must be a flow content, but with no header or footer element."));
        }
    }
}

pub fn validate_address(children: *const []const Entity) void {
    for (children.*) |child| {
        if (child.definition == .comment or child.definition == .text) {
            continue;
        }

        const child_name = child.definition.element.name;
        const error_message = "The \"" ++ child_name ++ "\" element is not supported in the address element.";

        if (constant.content.FLOW_CONTENT.has(child_name)) {
            comptime var has_illegal_child = false;
            has_illegal_child = has_illegal_child or constant.content.HEADING_CONTENT.has(child_name);
            has_illegal_child = has_illegal_child or constant.content.SECTIONING_CONTENT.has(child_name);
            has_illegal_child = has_illegal_child or eql(u8, child_name, "header");
            has_illegal_child = has_illegal_child or eql(u8, child_name, "footer");
            has_illegal_child = has_illegal_child or eql(u8, child_name, "address");

            if (has_illegal_child) {
                @compileError(InvalidContentModel(error_message));
            }
        } else {
            @compileError(InvalidContentModel(error_message));
        }
    }
}

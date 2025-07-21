const std = @import("std");
const internal = @import("internal");
const constant = internal.constant;
const util = internal.util;
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentAttribute = internal.constant.errors.InvalidContentAttribute;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_body(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;

    for (children) |child| {
        const element_name = child.definition.element.name;
        if (!constant.content.FLOW_CONTENT.has(element_name)) {
            @compileError(InvalidContentModel("The body element children must be a flow content."));
        }
    }

    const supported_attribute = std.StaticStringMap(void).initComptime(.{
        .{"onafterprint"},
        .{"onbeforeprint"},
        .{"onbeforeunload"},
        .{"onhashchange"},
        .{"onlanguagechange"},
        .{"onmessage"},
        .{"onmessageerror"},
        .{"onoffline"},
        .{"ononline"},
        .{"onpageswap"},
        .{"onpagehide"},
        .{"onpagereveal"},
        .{"onpageshow"},
        .{"onpopstate"},
        .{"onrejectionhandled"},
        .{"onstorage"},
        .{"onunhandledrejection"},
        .{"onunload"},
    });

    for (element.attributes) |attribute| {
        const attribute_name = attribute.definition.attribute.name;
        if (util.is_undefined_attribute(&attribute) and !supported_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the link element."));
        }
    }
}

pub fn basic_section_validation(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;

    for (children) |child| {
        const element_name = child.definition.element.name;
        if (!constant.content.FLOW_CONTENT.has(element_name)) {
            @compileError(InvalidContentModel("The body element children must be a flow content."));
        }
    }

    if (util.has_undefined_attribute(&element.attributes)) {
        @compileError(InvalidContentAttribute("Only global attributes and event handler attributes are supported in the title element."));
    }
}

pub fn heading_validation(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;

    for (children) |child| {
        if (child.definition == .comment or child.definition == .text) {
            continue;
        }

        const element_name = child.definition.element.name;
        if (!constant.content.PHRASING_CONTENT.has(element_name)) {
            @compileError(InvalidContentModel("The body element children must be a flow content."));
        }
    }

    if (util.has_undefined_attribute(&element.attributes)) {
        @compileError(InvalidContentAttribute("Only global attributes and event handler attributes are supported in the title element."));
    }
}

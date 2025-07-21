const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentAttribute = internal.constant.errors.InvalidContentAttribute;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_head(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;
    comptime var title_element_count = 0;
    comptime var base_element_count = 0;

    for (children) |child| {
        if (eql(u8, child.definition.element.name, "title")) {
            title_element_count += 1;
        }

        if (eql(u8, child.definition.element.name, "base")) {
            base_element_count += 1;
        }
    }

    if (title_element_count != 1) {
        @compileError(InvalidContentModel("The head element must have exactly one title element."));
    }

    if (base_element_count > 1) {
        @compileError(InvalidContentModel("The head element must have at most one base element."));
    }

    if (util.has_undefined_attribute(&element.attributes)) {
        @compileError(InvalidContentAttribute("Only global attributes and event handler attributes are supported in the head element."));
    }
}

pub fn validate_title(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;

    if (children.len == 0) {
        @compileError(InvalidContentModel("The title element must not be blank."));
    }

    comptime var text_element_count = 0;

    for (children) |child| {
        if (child.definition == .text) {
            text_element_count += 1;
        }
    }

    if (children.len != text_element_count) {
        @compileError(InvalidContentModel("The title element must only be a sanitized text."));
    }

    if (util.has_undefined_attribute(&element.attributes)) {
        @compileError(InvalidContentAttribute("Only global attributes and event handler attributes are supported in the title element."));
    }
}

pub fn validate_base(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;

    if (children.len > 0) {
        @compileError(InvalidContentModel("A void element must not have any children."));
    }

    const supported_attribute = std.StaticStringMap(void).initComptime(.{
        .{"href"},
        .{"target"},
    });

    for (element.attributes) |attribute| {
        const attribute_name = attribute.definition.attribute.name;
        if (util.is_undefined_attribute(&attribute) and !supported_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the base element."));
        }
    }
}

pub fn validate_link(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;

    if (children.len > 0) {
        @compileError(InvalidContentModel("A void element must not have any children."));
    }

    const supported_attribute = std.StaticStringMap(void).initComptime(.{
        .{"href"},
        .{"crossorigin"},
        .{"rel"},
        .{"media"},
        .{"integrity"},
        .{"hreflang"},
        .{"type"},
        .{"referrerpolicy"},
        .{"sizes"},
        .{"imagesrcset"},
        .{"imagesizes"},
        .{"as"},
        .{"blocking"},
        .{"color"},
        .{"disabled"},
        .{"fetchpriority"},
    });

    for (element.attributes) |attribute| {
        const attribute_name = attribute.definition.attribute.name;
        if (util.is_undefined_attribute(&attribute) and !supported_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the link element."));
        }
    }
}

pub fn validate_meta(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;

    if (children.len > 0) {
        @compileError(InvalidContentModel("A void element must not have any children."));
    }

    const supported_attribute = std.StaticStringMap(void).initComptime(.{
        .{"name"},
        .{"http-equiv"},
        .{"content"},
        .{"charset"},
        .{"media"},
    });

    for (element.attributes) |attribute| {
        const attribute_name = attribute.definition.attribute.name;
        if (util.is_undefined_attribute(&attribute) and !supported_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the meta element."));
        }
    }
}

pub fn validate_style(entity: *const Entity) void {
    const element = entity.definition.element;
    const children = element.chlidren;
    comptime var text_element_count = 0;

    for (children) |child| {
        if (child.definition == .text) {
            text_element_count += 1;
        }
    }

    if (children.len != text_element_count) {
        @compileError(InvalidContentModel("The title element must only be a sanitized text."));
    }

    const supported_attribute = std.StaticStringMap(void).initComptime(.{
        .{"media"},
        .{"blocking"},
        .{"type"},
    });

    for (element.attributes) |attribute| {
        const attribute_name = attribute.definition.attribute.name;
        if (util.is_undefined_attribute(&attribute) and !supported_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the meta element."));
        }
    }
}

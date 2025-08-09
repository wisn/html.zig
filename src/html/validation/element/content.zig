const std = @import("std");
const internal = @import("internal");
const constant = internal.constant;
const Entity = internal.entity.Entity;
const eql = std.mem.eql;
const InvalidContentModel = internal.constant.errors.InvalidContentModel;

pub fn validate_listing(children: *const []const Entity) void {
    const supported_child = std.StaticStringMap(void).initComptime(.{
        .{"li"},
        .{"script"},
        .{"template"},
    });

    for (children.*) |child| {
        if (child.definition == .comment) {
            continue;
        }

        if (child.definition == .text) {
            @compileError(InvalidContentModel("Text is not supported as a direct descendant of this element."));
        }

        const child_name = child.definition.element.name;
        if (!supported_child.has(child_name)) {
            @compileError(InvalidContentModel("The \"" ++ child_name ++ "\" element is not supported in this element."));
        }
    }
}

const supported_dl_child = std.StaticStringMap(void).initComptime(.{
    .{"dt"},
    .{"dd"},
    .{"div"},
    .{"script"},
    .{"template"},
});

pub fn validate_dl(children: *const []const Entity) void {
    comptime var found_div = false;
    comptime var found_dt_or_dd = false;

    for (children.*) |child| {
        if (child.definition == .comment) {
            continue;
        }

        if (child.definition == .text) {
            @compileError(InvalidContentModel("Text is not supported as a direct descendant of this element."));
        }

        const child_name = child.definition.element.name;
        if (!supported_dl_child.has(child_name)) {
            @compileError(InvalidContentModel("The \"" ++ child_name ++ "\" element is not supported in the dl element."));
        }

        if (eql(u8, child_name, "div")) {
            found_div = true;
        }

        if (eql(u8, child_name, "dt") or eql(u8, child_name, "dd")) {
            found_dt_or_dd = true;
        }
    }

    if ((!found_div and !found_dt_or_dd) or (found_div and found_dt_or_dd)) {
        @compileError(InvalidContentModel("The dl element must have either both dt and dd as its descendants, or div with dt and dd as its descendants."));
    }

    if (found_div) {
        for (children.*) |child| {
            if (child.definition == .element) {
                const child_name = child.definition.element.name;
                if (eql(u8, child_name, "div")) {
                    validate_dl_internal(&child.definition.element.chlidren);
                }
            }
        }
    } else {
        validate_dl_internal(children);
    }
}

fn validate_dl_internal(children: *const []const Entity) void {
    comptime var last_elm = "__";
    comptime var found_dt = false;
    comptime var has_one_valid_group = false;

    for (children.*) |child| {
        if (child.definition == .comment) {
            continue;
        }

        if (child.definition == .text) {
            @compileError(InvalidContentModel("Text is not supported as a direct descendant of this element."));
        }

        const child_name = child.definition.element.name;
        if (!supported_dl_child.has(child_name)) {
            @compileError(InvalidContentModel("The \"" ++ child_name ++ "\" element is not supported in the dl element."));
        }

        if (eql(u8, child_name, "div")) {
            @compileError(InvalidContentModel("A nested div element is not supported."));
        }

        if (eql(u8, child_name, "dt")) {
            if (eql(u8, last_elm, "dt")) {
                @compileError(InvalidContentModel("The next valid descendant after the dt element is the dd element."));
            }
            last_elm = "dt";
            found_dt = true;
        }

        if (eql(u8, child_name, "dd")) {
            if (!found_dt and !eql(u8, last_elm, "dd")) {
                @compileError(InvalidContentModel("The dd element must be after exactly one dt element."));
            }
            last_elm = "dd";
            found_dt = false;
            has_one_valid_group = true;
        }
    }

    if (!has_one_valid_group) {
        @compileError(InvalidContentModel("There must be at least one group of dt element that is followed by one or more dd elements."));
    }
}

const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const Entity = internal.entity.Entity;

pub fn transform(any: anytype) []const u8 {
    const meta_fields = std.meta.fields(@TypeOf(any));
    return struct {
        fn recurse(fields: []const std.builtin.Type.StructField) []const u8 {
            if (fields.len == 0) {
                return "";
            }

            const argument = @field(any, fields[0].name);
            const typeof = @TypeOf(argument);

            switch (typeof) {
                Entity => return comptime transform_internal(argument) ++ recurse(fields[1..]),
                fn (?[]const u8) Entity => {
                    const attribute = argument(null);
                    return comptime transform_internal(attribute) ++ recurse(fields[1..]);
                },
                fn (anytype) Entity => {
                    const element = argument(.{});
                    return comptime transform_internal(element) ++ recurse(fields[1..]);
                },
                fn (anytype) (fn (anytype) Entity) => {
                    const element = argument(.{})(.{});
                    return comptime transform_internal(element) ++ recurse(fields[1..]);
                },
                else => @compileError("InvalidTransformArgument: unknown type"),
            }
        }
    }.recurse(meta_fields);
}

fn transform_internal(entity: Entity) []const u8 {
    switch (entity.definition) {
        .attribute => {
            if (entity.definition.attribute.value == null) {
                return entity.definition.attribute.name;
            }
            return entity.definition.attribute.name ++ "=\"" ++ entity.definition.attribute.value.? ++ "\"";
        },
        .comment => {
            return "<!-- " ++ entity.definition.comment.value ++ " -->";
        },
        .text => {
            if (entity.definition.text.sanitize) {
                return util.sanitize_text(entity.definition.text.value);
            }
            return entity.definition.text.value;
        },
        .element => {
            const element = entity.definition.element;
            const tag_prepend = if (std.mem.eql(u8, element.name, "html")) "<!DOCTYPE html>" else "";
            const tag_start = "<" ++ element.name;
            const tag_attributes = comptime transform_all(element.attributes, " ");
            const tag_close = ">";
            const tag_children = if (element.is_void) "" else comptime transform_all(element.chlidren, "");
            const tag_end = if (element.is_void) "" else "</" ++ element.name ++ ">";
            return tag_prepend ++ tag_start ++ tag_attributes ++ tag_close ++ tag_children ++ tag_end;
        },
    }
}

fn transform_all(entities: []const Entity, prepend: []const u8) []const u8 {
    if (entities.len == 0) {
        return "";
    }
    return prepend ++ transform_internal(entities[0]) ++ transform_all(entities[1..], prepend);
}

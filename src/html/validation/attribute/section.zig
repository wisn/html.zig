const std = @import("std");
const internal = @import("internal");
const util = internal.util;
const Entity = internal.entity.Entity;
const common = @import("common.zig");
const InvalidContentAttribute = internal.constant.errors.InvalidContentAttribute;

pub fn validate_body(attributes: *const []const Entity) void {
    const additional_attribute = std.StaticStringMap(void).initComptime(.{
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

    for (attributes.*) |attribute| {
        if (common.is_global_attribute(&attribute) or common.is_global_event_handler_attribute(&attribute)) {
            continue;
        }

        const attribute_name = util.to_lowercase(attribute.definition.attribute.name);
        if (!additional_attribute.has(attribute_name)) {
            @compileError(InvalidContentAttribute("The \"" ++ attribute_name ++ "\" attribute is not supported in the body element."));
        }
    }
}

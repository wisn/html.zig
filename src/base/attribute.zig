const validator = @import("validator.zig");
const Entity = @import("entity.zig").Entity;

pub fn Attribute(name: []const u8) fn (?[]const u8) Entity {
    validator.Attribute.validate_name(name);
    return struct {
        fn compose_value(value: ?[]const u8) Entity {
            validator.Attribute.validate_value(value);
            return Entity{
                .name = .Attribute,
                .transform = struct {
                    fn lambda() []const u8 {
                        if (value) |string| {
                            return name ++ "=\"" ++ string ++ "\"";
                        }
                        return name;
                    }
                }.lambda,
            };
        }
    }.compose_value;
}

pub fn DataAttribute(name: []const u8) fn (?[]const u8) Entity {
    return Attribute("data-" ++ name);
}

pub fn InteractiveAttribute(name: []const u8) fn (?[]const u8) Entity {
    return Attribute("aria-" ++ name);
}

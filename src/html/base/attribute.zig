const internal = @import("internal");
const validation = @import("validation");
const Entity = internal.entity.Entity;

pub fn Attribute(name: []const u8) fn (?[]const u8) Entity {
    validation.base.attribute.validate_name(name);
    return struct {
        fn compose_value(value: ?[]const u8) Entity {
            validation.base.attribute.validate_value(value);
            return comptime Entity{
                .definition = .{
                    .attribute = .{
                        .name = name,
                        .value = value,
                    },
                },
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

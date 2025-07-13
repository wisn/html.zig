pub const Entity = struct {
    name: EntityName,
    transform: fn () []const u8,
};

pub const EntityName = enum {
    Attribute,
    Element,
    Comment,
};

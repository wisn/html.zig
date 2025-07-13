const Entity = @import("entity.zig").Entity;

pub fn fetch_entity(field: anytype) ?Entity {
    const typeof = @TypeOf(field);
    return switch (typeof) {
        Entity => field,
        fn (?[]const u8) Entity => field(null),
        fn (anytype) Entity => field(.{}),
        fn (anytype) (fn (anytype) Entity) => field(.{})(.{}),
        else => null,
    };
}

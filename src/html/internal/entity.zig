pub const Entity = struct {
    definition: EntityDefinition,
    // NOTE: passing function in a struct make it easy for us to do comptime operation.
    //       it is also good to provide transform function for each entity.
    //       we may call this method for transforming its entity to html text directly.
    transform: fn () []const u8 = struct {
        fn default() []const u8 {
            return "";
        }
    }.default,
};

pub const EntityDefinition = union(enum) {
    attribute: AttributeDefinition,
    comment: CommentDefinition,
    element: ElementDefinition,
    text: TextDefinition,
};

pub const AttributeDefinition = struct {
    name: []const u8,
    value: ?[]const u8 = null,
};

pub const CommentDefinition = struct {
    value: []const u8,
};

pub const ElementDefinition = struct {
    name: []const u8,
    is_void: bool = false,
    attributes: []const Entity = &[_]Entity{},
    chlidren: []const Entity = &[_]Entity{},
};

pub const TextDefinition = struct {
    sanitize: bool,
    value: []const u8,
};

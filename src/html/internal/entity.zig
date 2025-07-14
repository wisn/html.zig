pub const Entity = struct {
    definition: EnityDefinition,
    transform: fn () []const u8,
};

pub const EnityDefinition = union(enum) {
    attribute: AttributeDefintion,
    comment: CommentDefinition,
    element: ElementDefinition,
    text: TextDefinition,
};

pub const AttributeDefintion = struct {
    name: []const u8,
    value: ?[]const u8 = null,
};

pub const CommentDefinition = struct {
    value: []const u8,
};

pub const ElementDefinition = struct {
    name: []const u8,
    attributes: []Entity = &[_]Entity{},
    elements: []Entity = &[_]Entity{},
};

pub const TextDefinition = struct {
    sanitize: bool,
    value: []const u8,
};

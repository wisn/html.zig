pub const RenderOptions = struct {};

pub const AttributeRenderOptions = struct {};

pub const ElementRenderOptions = struct {};

pub const DefaultRenderOptions = RenderOptions{};

pub const RenderFn = fn (RenderOptions) []const u8;

pub const AttributeRenderFn = fn (AttributeRenderOptions) []const u8;

pub const ElementRenderFn = fn (ElementRenderOptions) []const u8;

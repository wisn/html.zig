pub const RenderOptions = struct {};

pub const DefaultRenderOptions = RenderOptions{};

pub const RenderFn = fn (RenderOptions) []const u8;

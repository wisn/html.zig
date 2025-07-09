const std = @import("std");

// ref https://html.spec.whatwg.org/multipage/syntax.html#syntax-tag-name
pub const ElementNameValidator = struct {
    pub fn validate(name: []const u8) void {
        for (name) |char| {
            var is_legal = false;

            is_legal = is_legal or ('a' <= char and char <= 'z');
            is_legal = is_legal or ('A' <= char and char <= 'Z');
            is_legal = is_legal or ('0' <= char and char <= '9');

            if (!is_legal) {
                @compileError("InvalidElementName: \"" ++ name ++ "\" contains non-alphanumeric character");
            }
        }
    }
};

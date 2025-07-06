const std = @import("std");
const unicode = std.unicode;
const NAMED_CHARACTERS = @import("constant").NAMED_CHARACTERS;

// ref https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
pub const AttributeNameValidator = struct {
    pub fn validate(name: []const u8) void {
        if (name.len == 0) {
            @compileError("InvalidAttributeName: must not be empty");
        }

        const utf8_view = try unicode.Utf8View.init(name);
        var utf8_iter = utf8_view.iterator();

        while (utf8_iter.nextCodepoint()) |codepoint| {
            var is_illegal = false;

            is_illegal = is_illegal or (0 <= codepoint and codepoint <= 31); // U+0000 NULL to U+001F INFORMATION SEPARATOR ONE
            is_illegal = is_illegal or (127 <= codepoint and codepoint <= 159); // U+007F DELETE to U+009F APPLICATION PROGRAM COMMAND
            is_illegal = is_illegal or codepoint == ' ' or codepoint == '\"' or codepoint == '\'' or codepoint == '>' or codepoint == '/' or codepoint == '=';
            is_illegal = is_illegal or (64976 <= codepoint and codepoint <= 65007); // U+FDD0 to U+FDE
            is_illegal = is_illegal or codepoint == 65534 or codepoint == 65535; // U+FFFE, U+FFFF
            is_illegal = is_illegal or codepoint == 131070 or codepoint == 131071; // U+1FFFE, U+1FFFF
            is_illegal = is_illegal or codepoint == 196606 or codepoint == 196607; // U+2FFFE, U+2FFFF
            is_illegal = is_illegal or codepoint == 262142 or codepoint == 262143; // U+3FFFE, U+3FFFF
            is_illegal = is_illegal or codepoint == 327678 or codepoint == 327679; // U+4FFFE, U+4FFFF
            is_illegal = is_illegal or codepoint == 393214 or codepoint == 393215; // U+5FFFE, U+5FFFF
            is_illegal = is_illegal or codepoint == 458750 or codepoint == 458751; // U+6FFFE, U+6FFFF
            is_illegal = is_illegal or codepoint == 524286 or codepoint == 524287; // U+7FFFE, U+7FFFF
            is_illegal = is_illegal or codepoint == 589822 or codepoint == 589823; // U+8FFFE, U+8FFFF
            is_illegal = is_illegal or codepoint == 655358 or codepoint == 655359; // U+9FFFE, U+9FFFF
            is_illegal = is_illegal or codepoint == 720894 or codepoint == 720895; // U+AFFFE, U+AFFFF
            is_illegal = is_illegal or codepoint == 786430 or codepoint == 786431; // U+BFFFE, U+BFFFF
            is_illegal = is_illegal or codepoint == 851966 or codepoint == 851967; // U+CFFFE, U+CFFFF
            is_illegal = is_illegal or codepoint == 917502 or codepoint == 917503; // U+DFFFE, U+DFFFF
            is_illegal = is_illegal or codepoint == 983038 or codepoint == 983039; // U+EFFFE, U+EFFFF
            is_illegal = is_illegal or codepoint == 1048574 or codepoint == 1048575; // U+FFFFE, U+FFFFF
            is_illegal = is_illegal or codepoint == 1114110 or codepoint == 1114111; // U+10FFFE, U+10FFFF

            if (is_illegal) {
                @compileError("InvalidAttributeName: \"" ++ name ++ "\" contains illegal character");
            }
        }
    }
};

// ref https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
pub const AttributeValueValidator = struct {
    pub fn validate(optional_value: ?[]const u8) void {
        if (optional_value) |value| {
            var left: usize = 0;
            const length = value.len;
            // the default max backward branches is 1000
            // for the static string map that we use (the `NAMED_CHARACTERS` constant), the max backward branches formula it is 10*N*log2(N)
            // since the attribute value need to be factored as well, we use M*10*N*log2(N) formula where M is the length of the attribute value
            // is it worth the sacrifice? may be answered later
            const max_branches = value.len * 10 * NAMED_CHARACTERS.kvs.len * std.math.log2_int_ceil(usize, NAMED_CHARACTERS.kvs.len);
            @setEvalBranchQuota(max_branches);

            while (left < length) : (left += 1) {
                if (value[left] == '&') {
                    var right = left;
                    while (right < length and value[right] != ';') : (right += 1) {}
                    const selection = value[left..@min(right + 1, length)];

                    if (selection[selection.len - 1] == ';') {
                        var buffer: [selection.len]u8 = undefined;
                        const entity = std.ascii.lowerString(&buffer, selection);
                        if (!NAMED_CHARACTERS.has(entity)) {
                            @compileError("InvalidAttributeValue: \"" ++ entity ++ "\" contains ambiguous ampersand");
                        }
                    }
                }
            }
        }
    }
};

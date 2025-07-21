pub fn InvalidAttributeName(message: []const u8) []const u8 {
    return "InvalidAttributeName: " ++ message;
}

pub fn InvalidAttributeValue(message: []const u8) []const u8 {
    return "InvalidAttributeValue: " ++ message;
}

pub fn InvalidElementName(message: []const u8) []const u8 {
    return "InvalidElementName: " ++ message;
}

pub fn InvalidAttributeArgument(message: []const u8) []const u8 {
    return "InvalidAttributeArgument: " ++ message;
}

pub fn InvalidElementArgument(message: []const u8) []const u8 {
    return "InvalidElementArgument: " ++ message;
}

pub fn InvalidElementConstruct(message: []const u8) []const u8 {
    return "InvalidElementConstruct: " ++ message;
}

pub fn InvalidTextArgument(message: []const u8) []const u8 {
    return "InvalidTextArgument: " ++ message;
}

pub fn InvalidContentAttribute(message: []const u8) []const u8 {
    return "InvalidContentAttribute: " ++ message;
}

pub fn InvalidContentModel(message: []const u8) []const u8 {
    return "InvalidContentModel: " ++ message;
}

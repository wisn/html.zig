const attribute = @import("attribute.zig");
const element = @import("element.zig");

pub const Attribute = attribute.Attribute;
pub const DataAttribute = attribute.DataAttribute;
pub const InteractiveAttribute = attribute.InteractiveAttribute;

pub const Element = element.Element;
pub const VoidElement = element.VoidElement;
pub const RawText = element.RawText;
pub const Text = element.Text;

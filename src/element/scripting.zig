const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;

pub fn Script(args: anytype) fn (anytype) Entity {
    return Element("script")(args);
}

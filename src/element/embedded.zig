const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;
const VoidElement = base.VoidElement;

pub fn Picture(args: anytype) fn (anytype) Entity {
    return Element("picture")(args);
}

pub fn Source(args: anytype) fn (anytype) Entity {
    return VoidElement("source")(args);
}

pub fn Img(args: anytype) fn (anytype) Entity {
    return VoidElement("img")(args);
}

pub fn Iframe(args: anytype) fn (anytype) Entity {
    return Element("iframe")(args);
}

pub fn Embed(args: anytype) fn (anytype) Entity {
    return VoidElement("embed")(args);
}

pub fn Object(args: anytype) fn (anytype) Entity {
    return Element("object")(args);
}

pub fn Video(args: anytype) fn (anytype) Entity {
    return Element("video")(args);
}

pub fn Track(args: anytype) fn (anytype) Entity {
    return VoidElement("track")(args);
}

pub fn Audio(args: anytype) fn (anytype) Entity {
    return Element("audio")(args);
}

pub fn Map(args: anytype) fn (anytype) Entity {
    return Element("map")(args);
}

pub fn Area(args: anytype) fn (anytype) Entity {
    return VoidElement("area")(args);
}

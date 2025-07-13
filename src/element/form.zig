const base = @import("base");
const internal = @import("internal");
const Entity = internal.entity.Entity;
const Element = base.Element;
const VoidElement = base.VoidElement;

pub fn Form(args: anytype) fn (anytype) Entity {
    return Element("form")(args);
}

pub fn Label(args: anytype) fn (anytype) Entity {
    return Element("label")(args);
}

pub fn Input(args: anytype) Entity {
    return VoidElement("input")(args);
}

pub fn Button(args: anytype) fn (anytype) Entity {
    return Element("button")(args);
}

pub fn Select(args: anytype) fn (anytype) Entity {
    return Element("select")(args);
}

pub fn DataList(args: anytype) fn (anytype) Entity {
    return Element("datalist")(args);
}

pub fn OptGroup(args: anytype) fn (anytype) Entity {
    return Element("optgroup")(args);
}

pub fn Option(args: anytype) fn (anytype) Entity {
    return Element("option")(args);
}

pub fn TextArea(args: anytype) fn (anytype) Entity {
    return Element("textarea")(args);
}

pub fn Output(args: anytype) fn (anytype) Entity {
    return Element("output")(args);
}

pub fn Progress(args: anytype) fn (anytype) Entity {
    return Element("progress")(args);
}

pub fn Meter(args: anytype) fn (anytype) Entity {
    return Element("meter")(args);
}

pub fn FieldSet(args: anytype) fn (anytype) Entity {
    return Element("fieldset")(args);
}

pub fn Legend(args: anytype) fn (anytype) Entity {
    return Element("legend")(args);
}

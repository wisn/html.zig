const std = @import("std");

pub const GLOBAL_ATTRIBUTE = std.StaticStringMap(void).initComptime(.{
    .{"accesskey"},
    .{"autocapitalize"},
    .{"autocorrect"},
    .{"autofocus"},
    .{"class"},
    .{"contenteditable"},
    .{"dir"},
    .{"draggable"},
    .{"enterkeyhint"},
    .{"hidden"},
    .{"id"},
    .{"inert"},
    .{"inputmode"},
    .{"is"},
    .{"itemid"},
    .{"itemprop"},
    .{"itemref"},
    .{"itemscope"},
    .{"itemtype"},
    .{"lang"},
    .{"nonce"},
    .{"popover"},
    .{"slot"},
    .{"spellcheck"},
    .{"style"},
    .{"tabindex"},
    .{"title"},
    .{"translate"},
    .{"writingsuggestions"},
});

pub const GLOBAL_EVENT_HANDLER_ATTRIBUTE = std.StaticStringMap(void).initComptime(.{
    .{"onauxclick"},
    .{"onbeforeinput"},
    .{"onbeforematch"},
    .{"onbeforetoggle"},
    .{"onblur"},
    .{"oncancel"},
    .{"oncanplay"},
    .{"oncanplaythrough"},
    .{"onchange"},
    .{"onclick"},
    .{"onclose"},
    .{"oncommand"},
    .{"oncontextlost"},
    .{"oncontextmenu"},
    .{"oncontextrestored"},
    .{"oncopy"},
    .{"oncuechange"},
    .{"oncut"},
    .{"ondblclick"},
    .{"ondrag"},
    .{"ondragend"},
    .{"ondragenter"},
    .{"ondragleave"},
    .{"ondragover"},
    .{"ondragstart"},
    .{"ondrop"},
    .{"ondurationchange"},
    .{"onemptied"},
    .{"onended"},
    .{"onerror"},
    .{"onfocus"},
    .{"onformdata"},
    .{"oninput"},
    .{"oninvalid"},
    .{"onkeydown"},
    .{"onkeypress"},
    .{"onkeyup"},
    .{"onload"},
    .{"onloadeddata"},
    .{"onloadedmetadata"},
    .{"onloadstart"},
    .{"onmousedown"},
    .{"onmouseenter"},
    .{"onmouseleave"},
    .{"onmousemove"},
    .{"onmouseout"},
    .{"onmouseover"},
    .{"onmouseup"},
    .{"onpaste"},
    .{"onpause"},
    .{"onplay"},
    .{"onplaying"},
    .{"onprogress"},
    .{"onratechange"},
    .{"onreset"},
    .{"onresize"},
    .{"onscroll"},
    .{"onscrollend"},
    .{"onsecuritypolicyviolation"},
    .{"onseeked"},
    .{"onseeking"},
    .{"onselect"},
    .{"onslotchange"},
    .{"onstalled"},
    .{"onsubmit"},
    .{"onsuspend"},
    .{"ontimeupdate"},
    .{"ontoggle"},
    .{"onvolumechange"},
    .{"onwaiting"},
    .{"onwheel"},
});

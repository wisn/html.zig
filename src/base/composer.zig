pub const AttributeComposeOption = struct {
    with_validation: bool,
};

pub const ElementComposeOption = struct {
    with_validation: bool,
    void_element: bool,
};

pub const ComposeOption = union {
    attribute: AttributeComposeOption,
    element: ElementComposeOption,
};

pub const DefaultAttributeComposeOptions = ComposeOption{
    .attribute = AttributeComposeOption{
        .with_validation = true,
    },
};

pub const DefaultElementComposeOptions = ComposeOption{
    .element = ElementComposeOption{
        .with_validation = true,
        .void_element = false,
    },
};

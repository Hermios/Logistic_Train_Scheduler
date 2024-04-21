data:extend({
    {
        type = "int-setting",
        name = "lts-delay-between-checks",
        order = "ab",
        setting_type = "startup",
        default_value = 2,
        minimum_value = 1,
        maximum_value = 120, -- one stop per second
    }
})
local waitconditions={
    {id="time",options={"ticks"},text="gui-train.add-time-condition"},
    {id="full",text="gui-train.add-full-condition"},
    {id="empty",text="gui-train.add-empty-condition"},
    {id="item_count",options={"condition"},text="gui-train.add-item-count-condition"},
    {id="circuit",options={"condition"},text="gui-train.add-circuit-condition"},
    {id="inactivity",options={"ticks"},text="gui-train.add-inactivity-condition"},
    {id="robots_inactive",text="gui-train.add-robots-inactive-condition"},
    {id="fluid_count",options={"condition"},text="gui-train.add-fluid-count-condition"},
    {id="passenger_present",text="gui-train-wait-condition-description.passenger-present"},
    {id="passenger_not_present",text="gui-train-wait-condition-description.passenger-not-present"}
}

custom_guis[prototype]={
    position="center",
    clear_default=true,
	gui={type="frame",direction="horizontal",tags={
        children={
            {type="frame",direction="horizontal",caption={"gui-decider.condition"},tags={
                id="activation_condition",
                children={
                    {type="choose-elem-button",elem_type="signal",tags={id="first_signal"}},
                    {type="drop-down",style="circuit_condition_comparator_dropdown",items={"=",">","<","≥",">=","≤","<=","≠","!="},tags={id="comparator"}},
                    {type="choose-elem-quantity-button",is_or=true,tags={id="second_signal"}}
                }
            }},
            {
                type="frame",direction="vertical",tags={
                id="schedule",
                children={
                    {type="label",caption="1",visible=false,tags={id="current"}},
                    {type="frame",direction="vertical",tags={
                        id="records",
                        add_text={"gui-train.add-station"},
                        model={
                            {type="drop-down", tags={id="station",on_load="load_trainstations"}},
                            {type="frame",direction="vertical",tags={
                                id="wait_conditions",
                                add_text={"gui-train.add-wait-condition"},
                                model={
                                    {
                                        type="drop-down",
                                        visible=false,
                                        selected_index=1,
                                        tags={
                                            id="compare_type",
                                            on_load="display_compare_type",
                                            get_or_set="get_or_set_compare_type",
                                        },
                                        items={{"gui-train-wait-condition-description.or"},{"gui-train-wait-condition-description.and"}}},
                                    {name="waitconditions", type="drop-down", tags={id="type", on_load="load_wait_conditions", on_action="update_wait_conditions", get_or_set="get_or_set_waitcondition"}},
                                    {name="ticks", visible=false, type="textfield",is_numeric=true,style="very_short_number_textfield",tags={id="ticks",default_hidden=true}},
                                    {name="condition", visible=false, type="frame",tags={id="condition",default_hidden=true, on_load="update_wait_conditions",children={
                                        {type="choose-elem-button",elem_type="signal",tags={id="first_signal"}},
                                        {type="drop-down",style="circuit_condition_comparator_dropdown",items={"=",">","<","≥",">=","≤","<=","≠","!="},tags={id="comparator"}},
                                        {type="choose-elem-quantity-button",is_or=true,tags={id="second_signal"}}
                                    }}}
                                }
                            }}
                        }
                    }}
                }
                }
            }
        }
    }}
}
function display_compare_type(lua_gui_element)
    lua_gui_element.visible=lua_gui_element.parent.get_index_in_parent()>2
end

function get_or_set_compare_type(lua_gui_element,value)
    if value then
        lua_gui_element.selected_index=(value=="and" and 2 or 1)
    else
        return lua_gui_element.selected_index>1 and "and" or "or"
    end
end

function get_or_set_waitcondition(lua_gui_element,value)
    if value then
        for index,condition in pairs(waitconditions) do
            if condition.id==value then
                lua_gui_element.selected_index=index
                return
            end
        end
    else
        return lua_gui_element.selected_index>0 and waitconditions[lua_gui_element.selected_index].id
    end
end

function update_wait_conditions(lua_gui_element)
    lua_gui_element=lua_gui_element.parent.waitconditions
    for _,gui_element in pairs(lua_gui_element.parent.children) do
        if gui_element.tags.default_hidden then
            gui_element.visible=false
        end
    end
    if lua_gui_element.selected_index==0 then
        return
    end
    for _,option in pairs(waitconditions[lua_gui_element.selected_index].options or {}) do
        lua_gui_element.parent[option].visible=true
    end
end

function load_wait_conditions(lua_gui_element)
    for _,condition in pairs(waitconditions) do
        lua_gui_element.add_item({condition.text})
    end
end

function load_trainstations(lua_gui_element)
    local result={}
    for _,trainstation in pairs(game.get_surface(1).find_entities_filtered{type="train-stop",force=game.get_player(1).force}) do
        if not has_value(result,trainstation.backer_name) then
            table.insert(result,trainstation.backer_name)
        end
    end
    lua_gui_element.items=result
end
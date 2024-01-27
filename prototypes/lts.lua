local lts_prototype={}
custom_prototypes[prototype]=lts_prototype

local function update_signal_in_table(schedule_table)
    local local_table={}
    for k,v in pairs(schedule_table) do
        if k=="second_signal" then
            local_table[type(v)=="number" and "constant" or k]=v
        elseif type(v)~="table" then
            local_table[k]=v
        elseif k~="second_signal" then
            local_table[k]=update_signal_in_table(v)
        end
    end
    return local_table
end

function lts_prototype:is_active()
    local wire_types={defines.wire_type.red,defines.wire_type.green}

    local condition=self.control_behavior.activation_condition
    for _,wire in pairs(wire_types) do
        local circuit_network=self.entity.get_circuit_network(wire,defines.circuit_connector_id.combinator_input)
        if circuit_network then
            local count1=circuit_network.get_signal(condition.first_signal)
            local count2=type(condition.second_signal)=="table" and circuit_network.get_signal(condition.second_signal) or condition.second_signal
            if compare_data(count1,condition.comparator,count2) then
                return true
            end
        end
    end
    return false
end

function lts_prototype:update_schedule(train)
    train.schedule=update_signal_in_table(self.control_behavior.schedule)
end
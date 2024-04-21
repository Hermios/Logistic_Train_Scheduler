local lts_prototype={}
custom_prototypes[prototype]=lts_prototype
local wire_types={defines.wire_type.red,defines.wire_type.green}

local function update_schedule(schedule_table)
    if schedule_table.records and #schedule_table.records==0 then
        return nil
    end
    local local_table={}
    for k,v in pairs(schedule_table) do
        if k=="second_signal" then
            local_table[type(v)=="number" and "constant" or k]=v
        elseif type(v)~="table" then
            local_table[k]=v
        elseif k~="second_signal" then
            local_table[k]=update_schedule(v)
        end
    end
    return local_table
end

function lts_prototype:is_active()
    if not self.control_behavior then
        return
    end
    local condition=self.control_behavior.activation_condition
    if not condition or not condition.first_signal or not condition.second_signal then
        return false
    end
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

function lts_prototype:check_data()
    if self:is_active() and self.entity.energy>=self.entity.prototype.energy_usage then
        self:update_train_data()
    end
end

function lts_prototype:update_train_data()
    local schedule=update_schedule(self.control_behavior.schedule)
    for _,connected_entities in pairs(self.entity.circuit_connected_entities) do
        for _,connected_entity in pairs(connected_entities)do
            local train=connected_entity.type=="train-stop" and connected_entity.get_stopped_train()
            if train then
                if remote.interfaces["TrainSignalSender"] then
                    remote.call("TrainSignalSender", "clear_signals", train.id)
                    remote.call("TrainSignalSender", "set_signals", train.id,self.control_behavior.signals)
                end
                for _,locomotive in pairs(train.locomotives.front_movers) do
                    locomotive.color=self.control_behavior.traincolor
                end
                for _,locomotive in pairs(train.locomotives.back_movers) do
                    locomotive.color=self.control_behavior.traincolor
                end
                train.schedule=schedule
            end
        end
    end
end
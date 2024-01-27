require "__Hermios_Gui_Framework__.control-libs"
require "constants"
require "guis.lts"
require "prototypes.lts"

local wire_types={defines.wire_type.red,defines.wire_type.green}
table.insert(list_events.on_train_changed_state,function(event)
    if event.train.station and event.train.station then
        local list_networks={}
        for _,wire in pairs(wire_types) do
            table.insert(list_networks,event.train.station.get_circuit_network(wire).network_id)
        end

        -- load lts entities
        for _,lts in pairs(global.custom_entities) do
            if lts.is_active and lts:is_active() and lts.entity.energy>=lts.entity.prototype.energy_usage then
                for _,wire in pairs(wire_types) do
                    if has_value(list_networks,lts.entity.get_circuit_network(wire,defines.circuit_connector_id.combinator_output).network_id) then
                        lts:update_schedule(event.train)
                        return
                    end
                end
            end
        end
    end
end)
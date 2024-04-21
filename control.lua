require "__Hermios_Gui_Framework__.control-libs"
require "constants"
require "guis.lts"
require "prototypes.lts"

table.insert(list_events.on_tick,function(event)
    if event.tick%settings.startup["lts-delay-between-checks"].value>0 then
        return
    end
    for _,lts in pairs(global.custom_entities) do
        lts:check_data()
    end
end)
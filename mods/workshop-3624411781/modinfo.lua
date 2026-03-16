name = "Storage Bags"
author = "ret"
version = "1.2"
api_version = 10

description = [[
Adds a Mincraft like bundle to the game.

Craftable at shadow manipulator using
2 slurper pelts, 1 rope, 2 nightmare fuels












󰀔 Mod Version: ]]..version

forumthread = ""

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- DS
dont_starve_compatible = true
reign_of_giants_compatible = true

-- DST
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

local function Title(title)
    return {
        name = title,
        hover = "",
        options={{description = "", data = 0}},
        default = 0,
    }
end

configuration_options = {
    Title("Slurper Bag"),
    { name  = "Bag Capacity",
        label = "Stack Capacity",
        hover = "Yes, it has its own stack units.\n(lowering may break stuff after putting the items inside)",
        options = {
            {description = "300"            ,data = 300  ,hover = "You should burn it at furnace, NOW!!!"},
            {description = "600"            ,data = 600  ,hover = "Half Stack"},
            {description = "1200 (Default)" ,data = 1200 ,hover = "1 Stack" },
            {description = "2400"           ,data = 2400 ,hover = "2 Stacks"},
            {description = "4800"           ,data = 4800 ,hover = "4 Stacks"}
        },
        default = 1200,
    },
    { name  = "Bag Spoilrate",
        label = "Spoilage Rate",
        hover = "Contents inside will receive a specific spoilage rate.",
        options = {
            {description = "100%"          ,data = 1.00 ,hover = "Unchanged"                       },
            {description = "75% (Default)" ,data = 0.75 ,hover = "Goes great with 'Belt of Hunger'"},
            {description = "50%"           ,data = 0.50 ,hover = "Goes best with 'Belt of Hunger'" },
            {description = "0%"            ,data = 0.00 ,hover = "Paused"                          }
        },
        default = 0.75,
    },
    Title("Misc"),
    { name  = "SoulJar",
        label = "Soul Jar Snatch Action",
        hover = "Snatch souls out of the jar instead of opening it.",
        options = {
            {description = "No (Default)" ,data = false ,hover = ":Open"  },
            {description = "Yes"          ,data = true  ,hover = ":Snatch"}
        },
        default = false,
    }
}
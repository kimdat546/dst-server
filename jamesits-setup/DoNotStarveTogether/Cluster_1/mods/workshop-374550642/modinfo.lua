--The name of the mod displayed in the 'mods' screen.
name = "Increased Stack size"

--A description of the mod.
description = "Changes the maximum size of itemstacks of all stackable items to the configured amount. (recommended value: 99)"

author = "ChaosMind42"
 
version = "1.9"

api_version = 10

-- Compatible with both the base game, reign of giants, and dst
dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true

forumthread = ""

icon_atlas = "modicon.xml"
icon = "modicon.tex"

--These let clients know if they need to get the mod from the Steam Workshop to join the game
all_clients_require_mod = true
clients_only_mod = false

--This lets people search for servers with this mod by these tags
server_filter_tags = {"utility"}

-- ModConfiguration option
configuration_options =
{
	{
		name = "STACK_SIZE_LARGEITEM",
		label = "Max stacksize for large items",
		options =	{
						{description = "5", data = 5},
						{description = "10", data = 10},
						{description = "20", data = 20},
						{description = "40", data = 40},
						{description = "60", data = 60},
						{description = "80", data = 80},
						{description = "99", data = 99},
						{description = "120", data = 120},
						{description = "150", data = 150},
						{description = "200", data = 200},
						{description = "250", data = 250},
						{description = "300", data = 300},
						{description = "350", data = 350},
						{description = "400", data = 400},
						{description = "450", data = 450},
						{description = "500", data = 500},
						{description = "600", data = 600},
						{description = "700", data = 700},
						{description = "800", data = 800},
						{description = "900", data = 900},
						{description = "999", data = 999},
					},

		default = 10,
	},
	{
		name = "STACK_SIZE_MEDITEM",
		label = "Max stacksize for medium items",
		options =	{
						{description = "5", data = 5},
						{description = "10", data = 10},
						{description = "20", data = 20},
						{description = "40", data = 40},
						{description = "60", data = 60},
						{description = "80", data = 80},
						{description = "99", data = 99},
						{description = "120", data = 120},
						{description = "150", data = 150},
						{description = "200", data = 200},
						{description = "250", data = 250},
						{description = "300", data = 300},
						{description = "350", data = 350},
						{description = "400", data = 400},
						{description = "450", data = 450},
						{description = "500", data = 500},
						{description = "600", data = 600},
						{description = "700", data = 700},
						{description = "800", data = 800},
						{description = "900", data = 900},
						{description = "999", data = 999},
					},

		default = 20,
	},
	{
		name = "STACK_SIZE_SMALLITEM",
		label = "Max stacksize for small items",
		options =	{
						{description = "5", data = 5},
						{description = "10", data = 10},
						{description = "20", data = 20},
						{description = "40", data = 40},
						{description = "60", data = 60},
						{description = "80", data = 80},
						{description = "99", data = 99},
						{description = "120", data = 120},
						{description = "150", data = 150},
						{description = "200", data = 200},
						{description = "250", data = 250},
						{description = "300", data = 300},
						{description = "350", data = 350},
						{description = "400", data = 400},
						{description = "450", data = 450},
						{description = "500", data = 500},
						{description = "600", data = 600},
						{description = "700", data = 700},
						{description = "800", data = 800},
						{description = "900", data = 900},
						{description = "999", data = 999},
					},

		default = 40,
	},
	{
		name = "STACK_SIZE_TINYITEM",
		label = "Max stacksize for tiny items",
		options =	{
						{description = "5", data = 5},
						{description = "10", data = 10},
						{description = "20", data = 20},
						{description = "40", data = 40},
						{description = "60", data = 60},
						{description = "80", data = 80},
						{description = "99", data = 99},
						{description = "120", data = 120},
						{description = "150", data = 150},
						{description = "200", data = 200},
						{description = "250", data = 250},
						{description = "300", data = 300},
						{description = "350", data = 350},
						{description = "400", data = 400},
						{description = "450", data = 450},
						{description = "500", data = 500},
						{description = "600", data = 600},
						{description = "700", data = 700},
						{description = "800", data = 800},
						{description = "900", data = 900},
						{description = "999", data = 999},
					},

		default = 60,
	},
	{
		name = "STACK_SIZE_PELLET",
		label = "Max stacksize for pellet items",
		options =	{
						{description = "5", data = 5},
						{description = "10", data = 10},
						{description = "20", data = 20},
						{description = "40", data = 40},
						{description = "60", data = 60},
						{description = "80", data = 80},
						{description = "99", data = 99},
						{description = "120", data = 120},
						{description = "150", data = 150},
						{description = "200", data = 200},
						{description = "250", data = 250},
						{description = "300", data = 300},
						{description = "350", data = 350},
						{description = "400", data = 400},
						{description = "450", data = 450},
						{description = "500", data = 500},
						{description = "600", data = 600},
						{description = "700", data = 700},
						{description = "800", data = 800},
						{description = "900", data = 900},
						{description = "999", data = 999},
					},

		default = 120,
	},
}

priority = 0.00374550642
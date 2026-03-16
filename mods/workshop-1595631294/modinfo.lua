
name = "Smart Minisign"
description = [[Can draw by itself
会自己画画的小木牌 
v1.16 更新了版本号 
v1.14 可以换皮肤(Support Skin)
v1.10 兼容盐箱(SaltBox)
v1.08 兼容mod物品 提供了一个API 允许其他mod调用]]
author = "小班花 mamjun1"
version = "1.1.6"

forumthread = ""

api_version = 10
priority = -99999 

dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
    {
        name = "Icebox",
        label = "Icebox/冰箱",
        hover = "Minisign for icebox/允许冰箱添加小木牌",
        options = 
        {
            {description = "No(关闭)", data = false},
            {description = "Yes(打开)", data = true},
        },
        default = false,
    },
    {
        name = "ChangeSkin",
        label = "ChangeSkin/皮肤",
        hover = "Minisign can change skin/允许小木牌切换皮肤",
        options = 
        {
            {description = "Yes(是)", data = true},
            {description = "No(否)", data = false},
        },
        default = true,
    },
    {
        name = "DragonflyChest",
        label = "DragonflyChest/龙鳞箱",
        hover = "Minisign for DragonflyChest/允许龙鳞箱子添加小木牌",
        options = 
        {
            {description = "No(关闭)", data = false},
            {description = "Yes(打开)", data = true},
        },
        default = false,
    },
    {
        name = "SaltBox",
        label = "SaltBox/盐盒",
        hover = "Minisign for SaltBox/允许盐箱添加小木牌",
        options = 
        {
            {description = "No(关闭)", data = false},
            {description = "Yes(打开)", data = true},
        },
        default = false,
    },
    {
        name = "BundleItems",
        label = "BundleItems/包裹",
        hover = "Show the item in bundle/显示包裹里面的物品",
        options = 
        {
            {description = "No(关闭)", data = false},
            {description = "Yes(打开)", data = true},
        },
        default = false,
    },
    {
        name = "Digornot",
        label = "CanbeDug/挖起",
        hover = "Can be Dug/是否可以被挖",
        options = 
        {
            {description = "No(关闭)", data = false},
            {description = "Yes(打开)", data = true},
        },
        default = false,
    },{
        name = "OnlyPlayer",
        label = "OnlyPlayer/仅玩家",
        hover = "OnlyDugByPlayer/只能被玩家挖",
        options = 
        {
            {description = "Yes(仅限玩家)", data = false},
            {description = "No(所有破坏)", data = true},
        },
        default = false,
    },
}

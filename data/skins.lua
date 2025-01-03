require "scripts.util"
local images = require "data.images"

local skins = {
	{
		anim_idle = {images.mio_idle, 0.2, 4},
		anim_wall_slide = {images.mio_wall_slide},
		img_walk_down = images.mio_walk_down,
		img_airborne = images.mio_airborne,
		spr_dead = images.mio_dead,
		color_palette = {color(0xf6757a), color(0xb55088), color(0xe43b44), color(0x9e2835), color(0x3a4466), color(0x262b44)},
		menu_color = color(0xf6757a),
		icon = "🐜",
		text_key = "mio",
	},
	{
		anim_idle = {images.cap_idle, 0.2, 4},
		anim_wall_slide = {images.cap_wall_slide},
		img_walk_down = images.cap_walk_down,
		img_airborne = images.cap_airborne,
		spr_dead = images.cap_dead,
		
		color_palette = {color(0x63c74d), color(0x3e8948), color(0x265c42), color(0x193c3e), color(0x5a6988), color(0x3a4466)},
		menu_color = color(0x3e8948),
		icon = "🐛",
		text_key = "cap",
	},
	{
		anim_idle = {images.bee_1, 0.2, 1},
		anim_wall_slide = {images.bee_2},
		img_walk_down = images.bee_1,
		img_airborne = images.bee_2,
		spr_dead = images.bee_dead,
		
		color_palette = {color(0xfee761), color(0xfeae34), color(0x743f39), color(0x3f2832), color(0xc0cbdc), color(0x9e2835)},
		menu_color = color(0x743f39),
		icon = "🐝",
		text_key = "zia",
	},
	{
		anim_idle = {images.beetle_1, 0.2, 1},
		anim_wall_slide = {images.beetle_2},
		img_walk_down = images.beetle_1,
		img_airborne = images.beetle_2,
		spr_dead = images.beetle_dead,

		color_palette = {color(0x2ce8f5), color(0x0195e9), color(0x9e2835), color(0x3a4466), color(0x262b44)},
		menu_color = color(0x0195e9), 
		icon = "🪲",
		text_key = "tok",
	},
	{
		anim_idle = {images.nel_idle, 0.2, 1},
		anim_wall_slide = {images.nel_idle},
		img_walk_down = images.nel_idle,
		img_airborne = images.nel_idle,
		spr_dead = images.nel_idle,

		color_palette = {COL_LIGHT_RED, COL_DARK_RED, color(0x9e2835), color(0x3a4466), color(0x262b44)},
		menu_color = COL_LIGHT_RED, 
		icon = "🐞",
		text_key = "nel",
	},
	
	{
		anim_idle = {images.rabbit_1, 0.2, 1},
		anim_wall_slide = {images.rabbit_2},
		img_walk_down = images.rabbit_1,
		img_airborne = images.rabbit_2,
		spr_dead = images.rabbit_dead,

		color_palette = {COL_WHITE, COL_LIGHTEST_GRAY, COL_MID_GRAY, COL_DARK_GRAY, COL_BLACK_BLUE},
		menu_color = COL_MID_GRAY, 
		icon = "🐰",
		text_key = "rico",
	},
	-- {
	-- 	spr_idle = images.leo,
	-- 	spr_jump = images.leo,
	-- 	spr_wall_slide = images.leo,
	-- 	spr_dead = images.leo,
	-- 	color_palette = {color(0x63c74d), color(0x3e8948), color(0x265c42), color(0x193c3e), color(0x5a6988), color(0x3a4466)},
	-- 	menu_color = color(0x3e8948), 
	-- 	icon = "🐰",
	-- 	text_key = "leo",
	-- },
}

for i, skin in pairs(skins) do
	skins[i].id = i
end

return skins
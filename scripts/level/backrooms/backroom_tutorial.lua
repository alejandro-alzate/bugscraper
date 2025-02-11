require "scripts.util"
local images = require "data.images"
local enemies = require "data.enemies"
local BackroomWithDoor = require "scripts.level.backrooms.backroom_with_door"
local BackgroundCafeteria = require "scripts.level.background.background_cafeteria"
local Rect = require "scripts.math.rect"
local cutscenes = require "data.cutscenes"

local BackroomTutorial = BackroomWithDoor:inherit()

function BackroomTutorial:init()
    BackroomTutorial.super.init(self)
	self.name = "tutorial"

	self.cafeteria_background = BackgroundCafeteria:new(self)
end

function BackroomTutorial:generate(world_generator)
	world_generator:reset()

	world_generator:write_rect_fill(Rect:new(0,  2,  2,  20), TILE_METAL) -- a
	world_generator:write_rect_fill(Rect:new(3,  13, 7,  20), TILE_METAL) -- b
	world_generator:write_rect_fill(Rect:new(8,  14, 8,  20), TILE_METAL) -- c
	world_generator:write_rect_fill(Rect:new(6,  15, 96, 20), TILE_METAL) -- d
	world_generator:write_rect_fill(Rect:new(25, 13, 65, 14), TILE_METAL) -- e
	world_generator:write_rect_fill(Rect:new(32, 6,  32, 12), TILE_METAL) -- f
	world_generator:write_rect_fill(Rect:new(47, 0,  47, 5),  TILE_METAL) -- g
	world_generator:write_rect_fill(Rect:new(54, 6,  56, 6),  TILE_SEMISOLID) -- h
	world_generator:write_rect_fill(Rect:new(60, 9,  61, 12), TILE_METAL) -- i
	world_generator:write_rect_fill(Rect:new(62, 10, 62, 12), TILE_METAL) -- j
	world_generator:write_rect_fill(Rect:new(63, 11, 63, 12), TILE_METAL) -- k
	world_generator:write_rect_fill(Rect:new(64, 12, 64, 12), TILE_METAL) -- l
	world_generator:write_rect_fill(Rect:new(66, 14, 96, 14), TILE_METAL) -- m
	world_generator:write_rect_fill(Rect:new(94, 0,  96, 13), TILE_METAL) -- n
	world_generator:write_rect_fill(Rect:new(57, 6,  60, 6),  TILE_METAL) -- o
	world_generator:write_rect_fill(Rect:new(60, 7,  60, 8),  TILE_METAL) -- p

	world_generator:write_rect_fill(Rect:new(3, 8, 3, 8),  TILE_SEMISOLID) -- d1
	
	game:new_actor(enemies.BreakableWall:new(47*16, 6*16))
	game:new_actor(enemies.Dummy:new(77*16, 13*16))
	game:new_actor(enemies.Dummy:new(80*16, 13*16))
	game:new_actor(enemies.Dummy:new(83*16, 13*16))
	
	local sign = game:new_actor(enemies.ExitSign:new(50, 160))
	sign.smash_easter_egg_probability = 0

	game:new_actor(enemies.PlayerTrigger:new(87*16, 9*16, 8*16, 5*16, function()
		game:play_cutscene(cutscenes.tutorial_end)
	end, {min_player_trigger = 0}))
	
	game.camera.max_x = 67*16
	game.music_player:set_disk("off")
	game.level.show_cabin = false

	if not Options:get("has_seen_intro_credits") then
		game:play_cutscene(cutscenes.tutorial_start)
	end
end

function BackroomTutorial:get_default_player_position(player_n)
	return 3*16, 12*16
end

function BackroomTutorial:get_default_camera_position()
	return 0, 48
end

function BackroomTutorial:get_x_target_after_join_game()
	return 95
end

function BackroomTutorial:on_player_joined(player)
	Particles:opened_door(3*16-1, 10*16)
end

function BackroomTutorial:can_exit()
	return false
	-- for _, a in pairs(game.actors) do
	-- 	if a.name == "upgrade_display" then
	-- 	end
	-- end

	-- return BackroomTutorial.super.can_exit(self)
end

function BackroomTutorial:update(dt)
	BackroomTutorial.super.update(self, dt)
end

function BackroomTutorial:on_fully_entered()
end

function BackroomTutorial:draw_background()
	self.cafeteria_background:draw()
end

function BackroomTutorial:draw_items()
	love.graphics.draw(images.tutorial_level_back, 0, 0)
end

function BackroomTutorial:draw_front_walls()
	love.graphics.draw(images.tutorial_level, 0, 0)
end

return BackroomTutorial
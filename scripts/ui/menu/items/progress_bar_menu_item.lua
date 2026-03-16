local MenuItem = require "scripts.ui.menu.items.menu_item"
local images   = require "data.images"

local ProgressBarMenuItem = MenuItem:inherit()

function ProgressBarMenuItem:init(i, x, y, params)
	params = params or {}

	ProgressBarMenuItem.super.init(self, i, x, y)
	self.ox = 0
	self.oy = 0
	self.w = CANVAS_WIDTH - 250

	self.type = "progress_bar"

	if params.on_click and type(params.on_click) == "function" then
		self.on_click = params.on_click
		self.is_selectable = true
	else
		self.is_selectable = false
	end

	self.overlay_value = 0
	self.min_value = 0
	self.max_value = 1
	self.value = 0
	self.update_value = param(params.update_value, function(_, _) end)
	self.init_value = param(params.init_value, function(_) end) 
	self.text = "azert"
end

function ProgressBarMenuItem:on_set()
	ProgressBarMenuItem.super.on_set(self)
	self.init_value(self)
end

function ProgressBarMenuItem:update(dt)
	ProgressBarMenuItem.super.update(self, dt) 	
	self.update_value(self, dt)

	self.ox = lerp(self.ox, 0, 0.3)
	self.oy = lerp(self.oy, 0, 0.3)
	if math.abs(self.ox) <= 0.1 then self.ox = 0 end
	if math.abs(self.oy) <= 0.1 then self.oy = 0 end
end

function ProgressBarMenuItem:draw()
	local w = self.w
	local x = self.x - w/2 + self.ox
	local y = self.y - 8 + 3 + self.oy

	local val = (clamp(self.value, self.min_value, self.max_value) - self.min_value) / (self.max_value - self.min_value)
	local over_val
	if self.overlay_value then
		over_val = (clamp(self.overlay_value, self.min_value, self.max_value) - self.min_value) / (self.max_value - self.min_value)
	end

	draw_3_slice(images.selection_left_small, nil, images.selection_right_small, COL_MID_GRAY, x, y, w, 10)
	draw_3_slice(images.selection_left_small, nil, images.selection_right_small, COL_WHITE,    x, y, w * val, 10)
	if self.overlay_value then
		draw_3_slice(images.selection_left_small, nil, images.selection_right_small, COL_LIGHTEST_GRAY, x, y, w * over_val, 10)
	end
	print_centered_outline(COL_WHITE, COL_MID_GRAY, self.text, floor(self.x + self.ox), y + 4)
end

function ProgressBarMenuItem:after_click()	
	self.oy = -self.selected_anim_offset
end

return ProgressBarMenuItem
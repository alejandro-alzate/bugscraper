local MenuItem = require "scripts.ui.menu.menu_item"
local images   = require "data.images"

local TextMenuItem = MenuItem:inherit()

-- Split into SelectableMenuItem ? Am I becoming a Java dev now?
-- THIS IS A MESS, *HELP*
-- AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
-- Should do:
-- MenuItem
-- -> TextMenuItem
-- -> SelectableMenuItem
--   -> ToggleMenuItem
--   -> SliderMenuItem
function TextMenuItem:init(i, x, y, text, on_click, update_value)
	self:init_textitem(i, x, y, text, on_click, update_value)
end
function TextMenuItem:init_textitem(i, x, y, text, on_click, update_value)
	self:init_menuitem(i, x, y)

	self.ox = 0
	self.oy = 0
	self.text = text or ""
	self.label_text = self.text
	self.value_text = ""

	self.value = nil
	self.type = "text"

	if on_click and type(on_click) == "function" then
		self.on_click = on_click
		self.is_selectable = true
	else
		self.is_selectable = false
	end

	-- -- Custom update value function
	-- if custom_update_value then
	-- 	self.update_value = custom_update_value
	-- end

	self.update_value = update_value or function() end

	-- if default_val ~= nil then
	-- 	self:update_value(default_val)
	-- end
end

function TextMenuItem:update(dt)
	self:update_textitem(dt)
end
function TextMenuItem:update_textitem(dt)
	self:update_menuitem()
	self:update_value()

	self.ox = lerp(self.ox, 0, 0.3)
	self.oy = lerp(self.oy, 0, 0.3)
	if math.abs(self.ox) <= 0.1 then self.ox = 0 end
	if math.abs(self.oy) <= 0.1 then self.oy = 0 end

	self.text = self.label_text
	-- if self.value == nil or #self.value_text == "0" then
	-- else
	-- 	self.text = concat(self.label_text, ": ", self.value_text)
	-- end
end

function TextMenuItem:draw()
	self:draw_textitem()
end
function TextMenuItem:draw_textitem()
	gfx.setColor(1, 1, 1, 1)
	local text_height = get_text_height(self.text)
	
	-- if self.is_selected then
	-- 	local col = Input:get_last_ui_player_color()
	-- 	local x = math.floor(self.x - MENU_PADDING - 8)
	-- 	local y = math.floor(self.y + self.oy - 6)
	-- 	local w = math.floor(MENU_PADDING*2 + 16)
	-- 	local h = math.floor(14)
	-- 	circle_color(col, "fill", x,   y+h/2, h/2)
	-- 	circle_color(col, "fill", x+w, y+h/2, h/2)
	-- 	rect_color(col, "fill", x, y, w, h)
	-- end
	
	if self.is_selected then
		local col = Input:get_last_ui_player_color()
		local x = math.floor(self.x - MENU_PADDING - 8)
		local y = math.floor(self.y + self.oy - 6)
		local w = math.floor(MENU_PADDING*2 + 16)
		local h = math.floor(16)

		exec_color(col, function()
			love.graphics.draw(images.selection_left, x-16, y)
			love.graphics.draw(images.selection_right, x + w, y)
			rect_color(col, "fill", x, y, w, h)
		end)
	end

	-- /!\ This is really sketchy. Too bad
	if type(self.value) == "nil" then
		self:draw_withoutvalue()
	else
		self:draw_withvalue()
	end
	
	gfx.setColor(1, 1, 1, 1)
end

function TextMenuItem:get_leftjustified_text_draw_function()
	local draw_func = ternary(self.is_selected,
		function(...) print_ycentered_outline(COL_WHITE, Input:get_last_ui_player_color(), ...) end,
		function(...) print_ycentered(...) end
	)

	return draw_func
end

function TextMenuItem:draw_withoutvalue()
	local draw_func = ternary(self.is_selected,
		function(...) print_centered_outline(COL_WHITE, Input:get_last_ui_player_color(), ...) end,
		function(...) print_centered(...) end
	)

	if not self.is_selectable then
		gfx.setColor(COL_LIGHT_GRAY)
	end
	draw_func(self.text, self.x, self.y + self.oy)
end

function TextMenuItem:draw_withvalue()
	local draw_func = self:get_leftjustified_text_draw_function()

	if not self.is_selectable then
		gfx.setColor(COL_LIGHT_GRAY)
	end
	draw_func(self.text, self.x - MENU_PADDING, self.y + self.oy)

	self:draw_value_text()
end

function TextMenuItem:draw_value_text()
	local draw_func = self:get_leftjustified_text_draw_function()
	local value_text_width = get_text_width(self.value_text)
	
	draw_func(self.value_text, self.x + CANVAS_WIDTH*0.25 - value_text_width + self.ox, self.y + self.oy)
end

function TextMenuItem:set_selected(val, diff)
	self.is_selected = val
	if val then
		self.oy = sign(diff or 1) * 4
	end
end

function TextMenuItem:after_click()
	Options:update_options_file()
	Audio:play("menu_select")
	self.oy = -4
end

return TextMenuItem
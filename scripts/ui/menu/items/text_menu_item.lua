local MenuItem = require "scripts.ui.menu.items.menu_item"
local images   = require "data.images"

local TextMenuItem = MenuItem:inherit()

function TextMenuItem:init(i, x, y, text, on_click, update_value)
	TextMenuItem.super.init(self, i, x, y)

	self.ox = 0
	self.oy = 0
	self:set_label_text(Text:parse(text))
	self:set_value_text("")

	self.selected_anim_offset = 4

	self.value = nil
	self.type = "text"

	self.text_ox = 0
	self.text_oy = 0

	if on_click and type(on_click) == "function" then
		self.on_click = on_click
		self.is_selectable = true
	else
		self.is_selectable = false
	end

	-- Custom update value function
	self.update_value = update_value or function(_) end

	self.annotation = nil

	self.override_text_color = nil

	-- if default_val ~= nil then
	-- 	self:update_value(default_val)
	-- end
end

function TextMenuItem:set_annotation(text)
	if text == nil then
		self.annotation = nil
		return
	end
	self.annotation = Text:parse(text)
end

function TextMenuItem:set_label_text(text)
	self.label_text = Text:parse(text)
end

function TextMenuItem:set_value_text(text)
	self.value_text = Text:parse(text)
end

function TextMenuItem:update(dt)
	TextMenuItem.super.update(self, dt)
	self.update_value(self)
	-- self.label_text = random_neighbor(3)

	self.ox = lerp(self.ox, 0, 0.3)
	self.oy = lerp(self.oy, 0, 0.3)
	if math.abs(self.ox) <= 0.5 then self.ox = 0 end
	if math.abs(self.oy) <= 0.5 then self.oy = 0 end
end

function TextMenuItem:draw()
	love.graphics.setColor(1, 1, 1, 1)
	local text_height = get_text_height(self.label_text)
	
	if self.is_selected and self.label_text ~= "" then
		local col, text_col = Input:get_last_ui_player_colors()
		local x = math.floor(game.menu_manager:get_menu_padding() + self.ox)
		local y = math.floor(self.y + self.oy - 6)
		local w = math.floor(CANVAS_WIDTH - game.menu_manager:get_menu_padding()*2)
		local h = 16
		
		draw_3_slice(images.selection_left, nil, images.selection_right, col, x, y, w, h)
		
		if Input:get_number_of_users() > 1 then
			self:draw_player_icon(text_col, col, x, y)
		end
	end
	
	self:draw_text()
	love.graphics.setColor(COL_WHITE)

	self:draw_annotation()
end

function TextMenuItem:draw_player_icon(text_col, col, x, y)
	x = x - 8

	local last_player_n = Input:get_last_ui_user_n()
	local text_bottom = Text:text("player.abbreviation", last_player_n)
	local text_top = ""

	local user = Input:get_user(last_player_n)
	local icon = nil
	if user and user:get_skin() then
		icon = user:get_skin().icon
		text_top = text_bottom 
		text_bottom = icon
	end
	
	local h = 10
	if icon then
		local w = get_text_width(icon)
		draw_3_slice(images.selection_left, nil, images.selection_right, col, x - w - 16, y, w + 32, 16)
	end
	print_outline(text_col, col, text_bottom, x - get_text_width(text_bottom), y)
	print_centered_outline(text_col, col, text_top, x - get_text_width(text_bottom)/2, y - 10)
end

function TextMenuItem:draw_annotation()
	if self.is_selected and self.annotation then
		local w = get_text_width(self.annotation) + 64
		local h = math.floor(16)

		local x = math.floor(CANVAS_WIDTH / 2 - w/2)
		local y = math.floor(self.y + self.oy - 6 + 24)

		draw_3_slice(images.selection_left, nil, images.selection_right, COL_WHITE, x, y, w, h)
		draw_centered(images.bubble_tip, x + w/2, y - images.bubble_tip:getHeight()/2)

		print_centered_outline(COL_BLACK_BLUE, COL_WHITE, self.annotation, x + w/2, y + h/2)

	end
end

function TextMenuItem:draw_text()
	-- Set text color 
	local text_color = COL_WHITE
	if self.is_selected then
		local _, skin_text_color = Input:get_last_ui_player_colors()
		text_color = skin_text_color or COL_WHITE
	end
	if not self.is_selectable then
		text_color = COL_LIGHT_GRAY
	end
	if self.override_text_color then
		text_color = self.override_text_color
	end
	love.graphics.setColor(text_color)

	-- Draw text
	if type(self.value) == "nil" then
		print_centered(self.label_text, floor(self.x + self.ox + self.text_ox), self.y + self.oy + self.text_oy)
	else
		print_ycentered(self.label_text, floor(game.menu_manager:get_menu_padding() + 16 + self.ox + self.text_ox), self.y + self.oy + self.text_oy)
		self:draw_value_text()
	end
end

function TextMenuItem:draw_value_text()
	local value_text_width = get_text_width(self.value_text)
	print_ycentered(self.value_text, CANVAS_WIDTH - game.menu_manager:get_menu_padding() - value_text_width - 16 + self.ox + self.text_ox, self.y + self.oy + self.text_oy)
end

function TextMenuItem:set_selected(val, diff)
	self.is_selected = val
	if val then
		self.oy = sign(diff or 1) * self.selected_anim_offset
	end
end

function TextMenuItem:after_click()
	Audio:play_var("ui_menu_select_{01-04}", 0.1, 1.2)
	Input:vibrate(Input:get_last_ui_user_n(), 0.03, 0.1)
	
	self.oy = -self.selected_anim_offset
end

function TextMenuItem:on_set(is_back)
	TextMenuItem.super.on_set(self)

	self.oy = 0
	if is_back then
		self.ox = -self.ox
	end
end

return TextMenuItem
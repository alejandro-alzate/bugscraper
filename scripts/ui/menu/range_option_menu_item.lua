local OptionMenuItem = require "scripts.ui.menu.option_menu_item"

local SliderOptionMenuItem = OptionMenuItem:inherit()

local default_formatters = {
	["default"] = function(value)
		return tostring(value) 
	end,
	["%"] = function(value)
		return string.format("%d%%", value * 100) 
	end
}

function SliderOptionMenuItem:init(i, x, y, text, property_name, range, step, text_formatter, additional_update)	
	if type(text_formatter) == "nil" then
		text_formatter = default_formatters["default"]

	elseif type(text_formatter) == "string" then
		text_formatter = default_formatters[text_formatter] or default_formatters["default"]
	end

	SliderOptionMenuItem.super.init(self, i, x, y, text, property_name, additional_update)
	
	self.range = range
	self.step = step
	self.property_name = property_name

	self.text_formatter = function(value)
		return string.format("< %s >", text_formatter(value))
	end
end

function SliderOptionMenuItem:update(dt)
	SliderOptionMenuItem.super.update(self, dt)

	if Input:action_pressed("ui_left") and self.is_selected then
		self:on_click(-1)
	end
	if Input:action_pressed("ui_right") and self.is_selected then
		self:on_click(1)
	end
end

function SliderOptionMenuItem:on_click(diff)
	diff = diff or 1
	self.ox = sign(diff) * 6 
	
	self.value = self.value + diff * self.step
	if self.value < self.range[1] then self.value = self.range[2] end
	if self.value > self.range[2] then self.value = self.range[1] end

	self:set_value_and_option(self.value)

	local ratio = (self.value - self.range[1]) / (self.range[2] - self.range[1])
	Audio:play("menu_select", nil, 0.8 + ratio*0.4)

	-- + sound preview for music & sfx
end

return SliderOptionMenuItem
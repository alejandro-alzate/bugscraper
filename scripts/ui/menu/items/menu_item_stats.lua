local TextMenuItem = require "scripts.ui.menu.items.text_menu_item"

local StatsMenuItem = TextMenuItem:inherit()

function StatsMenuItem:init(i, x, y, text, get_value)
	StatsMenuItem.super.init(self, i, x, y, text)
	self.get_value = get_value
	self.value = nil

	self.override_text_color = COL_WHITE
end

function StatsMenuItem:update(dt)
	StatsMenuItem.super.update(self, dt)
	self.value = self:get_value()
	self:set_value_text(tostring(self.value))
end

return StatsMenuItem

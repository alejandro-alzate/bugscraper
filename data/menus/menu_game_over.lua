require "scripts.util"
local menu_util             = require "scripts.ui.menu.menu_util"
local Menu                  = require "scripts.ui.menu.menu"
local Timer                 = require "scripts.timer"

local StatsMenuItem         = require "scripts.ui.menu.items.menu_item_stats"
local ProgressBarMenuItem   = require "scripts.ui.menu.items.progress_bar_menu_item"

local DEFAULT_MENU_BG_COLOR = menu_util.DEFAULT_MENU_BG_COLOR
local func_url              = menu_util.func_url
local PROMPTS_GAME_OVER     = menu_util.PROMPTS_GAME_OVER

local game_over_items       = {
    { "" },
    { "" },
    { StatsMenuItem, Text:parse("💀 {menu.game_over.kills}"), function(self)
        return
        game.stats.kills
    end },
    { StatsMenuItem, Text:parse("💀 {menu.game_over.deaths}"), function(self)
        return
            game.stats.deaths
    end },
    { StatsMenuItem, Text:parse("🕐 {menu.game_over.time}"), function(self)
        return time_to_string(game.stats.time)
    end },
    { StatsMenuItem, Text:parse("⏰ {menu.game_over.floor}"), function(self)
        return concat(game.stats.floor)
    end },
    { StatsMenuItem, Text:parse("🔥 {menu.game_over.max_combo}"), function(self) return concat(game.stats.max_combo) end },
    { StatsMenuItem, Text:parse("⭐ {menu.game_over.score}"), function(self)
        return concat(game.stats.score)
    end },
    { "" },
    { ProgressBarMenuItem,
        {
            -- This is so ridiculously overengineered
            update_value = function(item, dt)
                item.augment_xp_delay = math.max(0, item.augment_xp_delay - dt)

                local actual_xp = Metaprogression:get_xp()
                local actual_level = Metaprogression:get_xp_level()
                local shown_level_threshold = Metaprogression:get_xp_level_threshold(item.shown_level)

                -- Compute target value
                local value_target = actual_xp
                if actual_level > item.shown_level then
                    value_target = shown_level_threshold
                end

                -- New level
                if math.abs(item.value - shown_level_threshold) < 0.1 and actual_level > item.shown_level then
                    item.value = 0
                    item.overlay_value = nil
                    item.shown_level = item.shown_level + 1
                    item.augment_xp_delay = 0.5

                    local reward_info = Metaprogression:get_xp_level_info(item.shown_level - 1)
                    if reward_info then
                        Metaprogression.old_xp = 0
                        Metaprogression.old_xp_level = item.shown_level
                        game.has_finished_game_over_animation = false

                        game.menu_manager.menus["new_reward"]:set_rewards(reward_info.rewards)
                        game.menu_manager:set_menu("new_reward")
                    end
                end

                -- Set the progress bar value
                local old_value = item.value
                if item.augment_xp_delay <= 0 then
                    item.value = lerp(item.value, value_target, 0.1)
                end

                if math.floor(item.value / 5) * 5 > math.floor(old_value / 5) * 5 then
                    Audio:play("xp_tick", 1, lerp(1 - (item.value / item.max_value), 0.5, 1.5))
                end

                -- Shows the text
                local shown_xp = round(item.value)
                item.text = concat(shown_xp, "/", shown_level_threshold)
                if shown_level_threshold == math.huge then
                    item.text = concat(shown_xp)
                end

                -- Finish animation
                if item.augment_xp_delay <= 0 and (
                    shown_level_threshold == math.huge or
                    (actual_level == item.shown_level and math.abs(item.value - Metaprogression:get_xp()) < 0.1)
                ) then
                    if not game.has_finished_game_over_animation then
                        game.has_finished_game_over_animation = true
                    end 
                end

                if game.has_finished_game_over_animation and not game.menu_manager.sel_item then
                    game.menu_manager:set_selection(1, true)
                end
            end,
            init_value = function(item)
                local threshold = Metaprogression:get_xp_level_threshold(Metaprogression.old_xp_level)
                item.value = Metaprogression.old_xp
                item.overlay_value = item.value
                item.max_value = threshold
                item.shown_level = Metaprogression.old_xp_level

                if threshold == math.huge then
                    item.overlay_value = nil
                    item.max_value = 1
                end
                if Metaprogression.old_xp == 0 then
                    item.overlay_value = nil
                end

                item.augment_xp_delay = 0.5

                game.has_finished_game_over_animation = false
            end
        }
    },
    { "" },
    { "🔄 {menu.game_over.quick_restart}",
        function(item)
            if game.has_finished_game_over_animation then
                game.has_seen_controller_warning = true
                game:new_game({ quick_restart = true })
            end
        end,
        function(item)
            item.is_selectable = game.has_finished_game_over_animation
            -- item.is_selectable = not Options:get("convention_mode")
            item.is_visible = not Options:get("convention_mode")
        end
    },
    { "▶ {menu.pause.return_to_ground_floor}",
        function(item)
            -- scotch
            if game.has_finished_game_over_animation then
                game.has_seen_controller_warning = true
                game:new_game()
            end
        end,
        function(item)
            item.is_selectable = game.has_finished_game_over_animation
        end,
    },
}
if BUILD_TYPE == "demo" then
    table.insert(game_over_items,
        { "❤ {menu.win.wishlist} 🔗", func_url("steam://advertise/2957130/") }
    )
end

---------------------------------------------------------

local GameOverMenu = Menu:inherit()

function GameOverMenu:init(game)
    GameOverMenu.super.init(self, game, "{menu.game_over.title}", game_over_items, DEFAULT_MENU_BG_COLOR,
        PROMPTS_GAME_OVER, nil)

    self.is_backable = false

    self.auto_restart_timer = Timer:new(10.0)
end

function GameOverMenu:update(dt)
    GameOverMenu.super.update(self, dt)

    if self.auto_restart_timer:update(dt) then
        game:new_game()
    end
end

function GameOverMenu:on_set()
    GameOverMenu.super.on_set(self)

    if Options:get("convention_mode") then
        self.auto_restart_timer:start()
    end
end

local game_over_menu = GameOverMenu:new()

return game_over_menu

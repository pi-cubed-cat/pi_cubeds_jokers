SMODS.Joker { --Joker Circuit
	key = 'jokercircuit',
	loc_txt = {
		name = 'Joker Circuit',
		text = {
			"Every {C:attention}#1#{} {C:inactive}[#2#]{} hands", 
			"containing a {C:attention}Straight{},",
            "create a free {C:attention}Speed Tag{}",
		}
	},
	rarity = 2,
    config = { extra = { count_max = 3, count_current = 3 } },
	atlas = 'PiCubedsJokers',
	pos = { x = 7, y = 9 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
	    info_queue[#info_queue + 1] = { key = "speedtag_tooltip", set = "Other", vars = { G.GAME.skips*5 or 0 } }
        return { vars = { card.ability.extra.count_max, card.ability.extra.count_current } }
	end,
	calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint and next(context.poker_hands['Straight']) then
			card.ability.extra.count_current = card.ability.extra.count_current - 1
			if card.ability.extra.count_current > 0 then
				return {
					card = card,
					message = tostring(card.ability.extra.count_current),
					colour = G.C.MONEY
				}
			end
		end
		if context.before and context.main_eval and not context.blueprint and next(context.poker_hands['Straight']) and card.ability.extra.count_current <= 0 and not context.retrigger_joker then
			card.ability.extra.count_current = card.ability.extra.count_max
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+1 Tag", colour = G.C.MONEY})
			G.E_MANAGER:add_event(Event({
                func = (function()
                    card:juice_up()
					add_tag(Tag('tag_picubed_jokercircuitskip'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
		end
	end
}

SMODS.Tag { -- Speed Tag (special version for Joker Circuit - waits to activate if G.GAME.skips == 0, and otherwise activates *immediately* and )
    key = "jokercircuitskip",
    pos = { x = 0, y = 3 },
    config = { skip_bonus = 5 },
    in_pool = function(self, args) return false end,
	no_collection = true,
	discovered = true,
	loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.skip_bonus, tag.config.skip_bonus * ((G.GAME.skips or 0)) } }
    end,
    apply = function(self, tag, context)
        if G.GAME.skips and G.GAME.skips > 0 then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.skips or 0) * tag.config.skip_bonus)
            tag.triggered = true
            return true
        end
    end
}
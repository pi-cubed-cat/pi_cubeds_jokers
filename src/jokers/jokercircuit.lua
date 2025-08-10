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
	cost = 6,
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
		if context.before and context.main_eval and not context.blueprint and next(context.poker_hands['Straight']) and card.ability.extra.count_current <= 0 then
			card.ability.extra.count_current = card.ability.extra.count_max
			G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_skip'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
		end
	end
}
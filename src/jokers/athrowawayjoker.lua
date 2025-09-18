SMODS.Joker { --A Throwaway Joker
	key = 'athrowawayjoker',
	loc_txt = {
		name = 'A Throwaway Joker',
		text = {
			"This Joker gains {C:chips}+Chips{}",
			"equal to the base {C:mult}Mult{}",
            "of {C:attention}discarded poker hand{}",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 11 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = false,
	eternal_compat = true,
	config = { extra = { chips = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
        if context.pre_discard and not context.hook and not context.blueprint and not context.retrigger_joker then
			local text, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
			local basemult = G.GAME.hands[text].mult
			card.ability.extra.chips = card.ability.extra.chips + basemult
			return {
                message = '+'..tostring(basemult),
                colour = G.C.CHIPS
            }
		end
		if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
	end
}
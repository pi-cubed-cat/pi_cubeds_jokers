SMODS.Joker { --Table Expected, got nil
	key = 'tableexpectedgotnil',
	loc_txt = {
		name = 'Table Expected, got nil',
		text = {
			"{X:mult,C:white}X#1#{} Mult,",
            "All played cards are",
            "{C:attention}not scored{}", 
		}
	},
	rarity = 2,
    config = { extra = { Xmult = 3 } },
	atlas = 'PiCubedsJokers',
	pos = { x = 7, y = 10 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint then
            return {
                remove_from_hand = true 
            }
        end
		if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
	end
}
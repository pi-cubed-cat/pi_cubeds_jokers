SMODS.Joker { --Yawning Cat
	key = 'yawningcat',
	loc_txt = {
		name = 'Yawning Cat',
		text = {
			"If {C:attention}played hand{} contains",
			"at least {C:attention}#1#{} scoring",
			"cards, {C:attention}retrigger{} playing",
			"cards {C:attention}#2# additional times{}"
		}
	},
	rarity = 4,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 6 },
	soul_pos = { x = 9, y = 6 },
	cost = 20,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { num = 3, retriggers = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.num, card.ability.extra.retriggers } }
	end,
	calculate = function(self, card, context)
		if #(context.scoring_hand or {}) >= card.ability.extra.num and context.cardarea == G.play and context.repetition and not context.repetition_only then
			return {
                repetitions = card.ability.extra.retriggers,
                card = card
			}
		end
	end
}
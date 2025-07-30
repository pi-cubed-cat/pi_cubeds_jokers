SMODS.Joker { --Night Vision
	key = 'nightvision',
	loc_txt = {
		name = 'Night Vision',
		text = {
			"After Play, {C:attention}flip{} all cards in hand,",
			"earn {C:money}$#1#{} per card flipped",
			"{C:attention}face up{} by this Joker",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 7, y = 7 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local flip_count = 0
			for k, v in ipairs(G.hand.cards) do
				if v.facing ~= 'front' then
					flip_count = flip_count + 1
				end
				v:flip()
			end
			if flip_count > 0 then
				return {
                    dollars = card.ability.extra.money * flip_count,
                    card = card
				}
			end
		end
	end
}
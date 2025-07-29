SMODS.Joker { --Ox Plow
	key = 'oxplow',
	loc_txt = {
		name = 'Ox Plow',
		text = {
			"Earn {C:money}$#1#{} if played",
			"hand is {C:attention}not{} your {C:attention}most{}",
			"{C:attention}played poker hand{}"
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 5 },
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
		if context.after then
			local is_most = true
			local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
			for k, v in pairs(G.GAME.hands) do
				if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
					is_most = false
					break
				end
			end
			if not is_most then
				return {
					dollars = card.ability.extra.money,
					card = card
				}
			end
		end
	end
}
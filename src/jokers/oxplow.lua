SMODS.Joker { --Ox Plow
	key = 'oxplow',
	loc_txt = {
		name = 'Ox Plow',
		text = {
			"Earn {C:money}$#1#{} if {C:attention}most played{}",
			"{C:attention}poker hand{} wasn't played",
			"by end of round",
			"{C:inactive}(Currently #2#){}",
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 5 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 7, most_played = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money,
						localize { type = 'variable', key = ((card.ability.extra.most_played and 'k_picubeds_pot_inactive') or 'k_picubeds_pot_active'), vars = { card.ability.extra.most_played } },
	} }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.extra.most_played = false
		end
		if context.after then
			local is_most = true
			local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
			for k, v in pairs(G.GAME.hands) do
				if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
					is_most = false
					break
				end
			end
			if is_most then
				card.ability.extra.most_played = true
			end
		end
	end,
	calc_dollar_bonus = function(self, card)
        return (not card.ability.extra.most_played) and card.ability.extra.money or nil
    end
}
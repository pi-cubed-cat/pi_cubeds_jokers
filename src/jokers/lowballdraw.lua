SMODS.Joker { --Lowball Draw
	key = 'lowballdraw',
	loc_txt = {
		name = 'Lowball Draw',
		text = {
			"Earn {C:money}$#1#{} when a",
			"{C:attention}2{} or {C:attention}7{} is drawn",
			"to hand during Blind",
		}
	},
	pronouns = 'they_them',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 9, y = 7 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	calculate = function(self, card, context)
		local low_count = 0
		if (context.first_hand_drawn or context.hand_drawn) and G.GAME.blind.in_blind then
			for k,v in ipairs(context.hand_drawn) do
				if v:get_id() == 2 or v:get_id() == 7 then
					low_count = low_count + 1
				end
			end
			if low_count > 0 then
				local low_low_count = low_count
				low_count = 0
				return {
                    dollars = card.ability.extra.money * low_low_count,
                    card = card
				}
			end
		end
	end
}
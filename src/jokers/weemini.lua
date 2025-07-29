SMODS.Joker { --Wee Mini
	key = 'weemini',
	loc_txt = {
		name = 'Wee Mini',
		text = {
			"If played hand or cards held",
			"in hand contain a {C:attention}2{},",
			"played hand contains a",
			"{C:attention}Two Pair{} and apply {C:attention}Splash{}"
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 8 },
	cost = 3,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	in_pool = function(self, args)
		can_do_pokerhand_changer_jokers()
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_splash
		return { vars = { card.ability.max_highlighted } }
	end,
	calculate = function(self, card, context)
		if not can_do_pokerhand_changer_jokers() then
			print("Wee Mini has limited functionality due to a mod conflict, or the 'Hand type-affecting Jokers' config option being disabled.")
		end
		local count_2 = 0
		for k,v in ipairs(G.hand.highlighted) do
            if v:get_id() == 2 then 
                count_2 = count_2 + 1
            end
		end
		for k,v in ipairs(G.play.cards) do
            if v:get_id() == 2 then 
                count_2 = count_2 + 1
            end
		end
		for k,v in ipairs(G.hand.cards) do
            if v:get_id() == 2 then
                count_2 = count_2 + 1
            end
		end
		if context.modify_scoring_hand and not context.blueprint and count_2 >= 1 then
			return {
                add_to_hand = true
			}
		end
	end
}

-- relies on additional functions present in src/jokers.lua
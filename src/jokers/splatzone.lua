SMODS.Joker { --Splat Zone
	key = 'splatzone',
	loc_txt = {
		name = 'Splat Zone',
		text = {
			"{C:mult}+#1#{} Mult if all cards", 
			"{C:attention}held in hand{} share",
            "the {C:attention}same suit{}",
		}
	},
	rarity = 1,
    config = { extra = { mult = 20 } },
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 9 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
 		if context.joker_main and #G.hand.cards > 0 then
			local all_same_suit = false
			local suit_list = {}
            for k, v in pairs(SMODS.Suits) do
                suit_list[k] = 0
            end
			for k, v in ipairs(G.hand.cards) do
				for kk, vv in pairs(suit_list) do
					if v:is_suit(kk, true) then 
						suit_list[kk] = suit_list[kk] + 1
					end 
				end
            end
			for kk, vv in pairs(suit_list) do
                if suit_list[kk] == #G.hand.cards then 
                    all_same_suit = true
					break
                end 
            end 
            if all_same_suit then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
	end
}
SMODS.Joker { --Hierarchy
	key = 'hierarchy',
	loc_txt = {
		name = 'Hierarchy',
		text = {
			"If scoring hand contains a {C:attention}King{},", 
			"the {C:attention}first{} scoring card of",
            "each {C:attention}rank{} gives {X:mult,C:white}X#1#{} Mult",
		}
	},
	pronouns = 'he_they',
	rarity = 3,
    config = { extra = { Xmult = 2, has_king = false } },
	atlas = 'PiCubedsJokers',
	pos = { x = 0, y = 10 },
	cost = 8,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
        if context.before then
			for k,v in ipairs(context.scoring_hand) do
				if v:get_id() == 13 then
					card.ability.extra.has_king = true
				end
			end
		end
		if card.ability.extra.has_king and context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card) then
			local is_first = false
			for k,v in ipairs(context.scoring_hand) do
				if v:get_id() == context.other_card:get_id() then
					if v == context.other_card then
						is_first = true
					end
					break
				end
			end
			if is_first then
				return {
					xmult = card.ability.extra.Xmult
				}
			end
        end
		if context.after then
			card.ability.extra.has_king = false
		end
	end
}
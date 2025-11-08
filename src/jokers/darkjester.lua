SMODS.Joker { --Dark Jester
    key = 'darkjester',
    loc_txt = {
        name = 'Dark Jester',
        text = {
            "This Joker gains {C:mult}+#1#{} Mult when",
            "a {C:spades}Spade{} or {C:clubs}Club{} card scores,",
            "{C:attention}resets{} when a {C:hearts}Heart{} or",
            "{C:diamonds}Diamond{} card scores",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        }
    },
    pronouns = 'he_him',
    rarity = 1,
    config = { extra = { mult_mod = 1, mult = 0 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 11 },
    cost = 6,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
	end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not 
		SMODS.has_no_suit(context.other_card)
        and not context.blueprint 
        and not context.retrigger_joker
        and not context.other_card.debuff then
			if (context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds")) and card.ability.extra.mult ~= 0 then
                card.ability.extra.mult = 0
                return {
                    message = localize('k_reset'),
                    colour = G.C.MULT,
                    card = card,
                }
			end
            if context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs") then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    card = card
                }
			end
		end
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				message = localize{type='variable', key='a_mult', vars = {card.ability.extra.mult} },
				mult_mod = card.ability.extra.mult, 
				colour = G.C.MULT
			}
		end
    end
}
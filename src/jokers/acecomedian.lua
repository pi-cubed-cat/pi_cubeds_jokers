SMODS.Joker { --Ace Comedian
    key = 'acecomedian',
    loc_txt = {
        name = 'Ace Comedian',
        text = {
            "Retrigger each played",
            "{C:attention}Ace{}, {C:attention}10{}, {C:attention}9{}, and {C:attention}8{}"
        }
    },
    rarity = 2,
    config = { extra = { repetitions = 1 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 1 },
    cost = 7,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if 
            context.other_card:get_id() == 8 or
            context.other_card:get_id() == 9 or
            context.other_card:get_id() == 10 or
            context.other_card:get_id() == 14 then
				return {
					message = localize('k_again_ex'),
                    repetitions = card.ability.extra.repetitions,
                    card = card
				}
			end
		end
    end
}
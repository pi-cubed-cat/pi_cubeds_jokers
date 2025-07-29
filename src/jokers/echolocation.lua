SMODS.Joker { --Echolocation
    key = 'echolocation',
    loc_txt = {
        name = 'Echolocation',
        text = {
            "{C:attention}+#3#{} hand size,",
            "{C:green}#1# in #2#{} playing cards",
            "are drawn {C:attention}face down"
        }
    },
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 1 },
    cost = 3,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { odds = 5, hand_increase = 2 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_echolocation')
        return { vars = { numerator, denominator, card.ability.extra.hand_increase} }
    end,
    
    add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_increase)
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_increase)
	end,
    
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.stay_flipped then
                if SMODS.pseudorandom_probability(card, 'picubed_echolocation', 1, card.ability.extra.odds) then
                    return { stay_flipped = true }
                end
                -- else return { stay_flipped = false }
            end
        end
        if context.cardarea == G.jokers and context.before then
            for k, v in ipairs(context.full_hand) do
                if v.facing == 'back' then
                    v:flip()
                end
            end
        end
    end
}
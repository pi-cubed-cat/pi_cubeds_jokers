SMODS.Joker { --Surgeon
	key = 'surgeon',
	loc_txt = {
		name = 'Surgeon',
		text = {
			"This card gains {C:attention}+#1#{} Hand Size", 
			"when a {C:attention}6{} is destroyed",
            "{C:inactive}(Currently {C:attention}+#2#{C:inactive} Hand Size)",
		}
	},
	rarity = 3,
    config = { extra = { hand_increase = 0, hand_increase_mod = 1 } },
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 10 },
	cost = 8,
	discovered = true,
	blueprint_compat = false,
    perishable_compat = false,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand_increase_mod, card.ability.extra.hand_increase } }
	end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_increase)
    end,
	calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            local sixes = 0
            for _, removed_card in ipairs(context.removed) do
                if removed_card:get_id() == 6 then sixes = sixes + 1 end
            end
            if sixes > 0 then
                card.ability.extra.hand_increase = card.ability.extra.hand_increase + sixes * card.ability.extra.hand_increase_mod
				G.hand:change_size(sixes * card.ability.extra.hand_increase_mod)
                return { message = "+"..tostring(card.ability.extra.hand_increase), }
            end
        end
	end
}
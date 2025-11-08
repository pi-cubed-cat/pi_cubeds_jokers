SMODS.Joker { --Pocket Lint
    key = 'pocketlint',
    loc_txt = {
        name = 'Pocket Lint',
        text = {
            "Gain {C:red}+#1#{} Discard if",
            "played hand contains",
            "a {C:attention}Two Pair{}",
        }
    },
    pronouns = 'she_they',
    rarity = 1,
    config = { extra = { discards_mod = 1 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 13 },
    cost = 4,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discards_mod } }
	end,
    calculate = function(self, card, context)
        if context.after and next(context.poker_hands["Two Pair"]) then 
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_discard(card.ability.extra.discards_mod, nil, true)
                    card_eval_status_text(card, 'extra', nil, nil, nil, 
                        {
                            message = localize { 
                                type = 'variable', 
                                key = 'k_picubeds_a_discards', 
                                vars = { card.ability.extra.discards_mod }
                            },
                            colour = G.C.RED
                        }
                    )
                    return true
                end
            }))
        end
    end
}
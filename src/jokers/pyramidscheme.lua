SMODS.Joker { -- Pyramid Scheme
	key = 'pyramidscheme',
	pronouns = 'she_they',
	rarity = 1,
	atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 12 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { cards_req = 1, cards_req_mod = 1, mult_mod = 2, mult = 0, cards_remain = 1, has_upgraded = false } },
    demicoloncompat = true,
	attributes = { 'mult', 'scaling', 'reset' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.cards_req, card.ability.extra.mult_mod, 
            card.ability.extra.cards_req_mod, card.ability.extra.mult,
            card.ability.extra.cards_remain
        } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if not card.ability.extra.has_upgraded and card.ability.extra.mult ~= 0 then
                return {
                    card = card,
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "mult",
                            scalar_table = { -card.ability.extra.mult },
                            scalar_value = 1,
                            scaling_message = {
                                message = localize('k_reset'),
                                colour = G.C.RED
                            }
                        })
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "cards_req",
                            scalar_table = { -card.ability.extra.cards_req + 1},
                            scalar_value = 1,
                            no_message = true,
                        })
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "cards_remain",
                            scalar_table = { -card.ability.extra.cards_remain + 1 },
                            scalar_value = 1,
                            no_message = true,
                        })
                    end
                } 
            else
                card.ability.extra.has_upgraded = false
            end
        end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "cards_remain",
                scalar_table = { -1 },
                scalar_value = 1,
                no_message = true,
            })
            if card.ability.extra.cards_remain <= 0 then
                card.ability.extra.has_upgraded = true
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "cards_req",
                    scalar_value = "cards_req_mod",
                    no_message = true,
                })
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "cards_remain",
                    scalar_table = { card.ability.extra.cards_req },
                    scalar_value = 1,
                    no_message = true,
                })
                return {
                    card = card,
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "mult",
                            scalar_value = "mult_mod",
                            scaling_message = {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.RED
                            },
                        })
                    end
                } 
            end
        end
        if context.joker_main or context.forcetrigger then
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}
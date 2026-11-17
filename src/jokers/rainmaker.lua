SMODS.Joker { -- Rainmaker
	key = 'rainmaker',
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
    pos = { x = 4, y = 12 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = false,
	config = { extra = { chips = 100, chips_reset = 100, chips_destruct = 0, money = 20 } },
    demicoloncompat = true,
	attributes = { 'chips', 'reset', 'economy', 'scaling', 'rank' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.chips, card.ability.extra.chips_destruct, card.ability.extra.money
        } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips_reset
            return {
                message = localize('k_reset'),
                colour = G.C.CHIPS
            }
        end
        if context.after and card.ability.extra.chips <= card.ability.extra.chips_destruct then
            SMODS.destroy_cards(card, nil, nil, true)
            return {
                dollars = card.ability.extra.money
			}
        end
        if context.individual and context.cardarea == G.play and context.other_card then
            if not SMODS.has_no_rank(context.other_card) then
                return {
                    card = card,
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "chips",
                            scalar_table = { -context.other_card.base.nominal },
                            scalar_value = 1,
                            scaling_message = {
                                message = tostring(-context.other_card.base.nominal),
                                colour = G.C.CHIPS
                            }
                        })
                    end
                }
			end
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
        if context.forcetrigger then
			return {
				chip_mod = card.ability.extra.chips_reset,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } },
                dollars = card.ability.extra.money
			}
		end
	end
}
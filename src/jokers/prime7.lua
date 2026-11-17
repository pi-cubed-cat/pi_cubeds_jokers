SMODS.Joker { --Prime 7
    key = 'prime7',
    pronouns = 'she_her',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 0 },
    soul_pos = { x = 3, y = 3},
    cost = 7,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { is_active = true, money = 2 } },
    attributes = { 'rank', 'seven', 'editions', 'modify_card', 'economy', 'on_sell' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'e_negative_playing_card', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} }
        return {
            vars = { localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } }, card.ability.extra.money }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and card.ability.extra.is_active == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.is_active = true
			return {
				message = localize('k_picubeds_active'),
			}
		end
        if context.before and not context.blueprint then 
            if #context.full_hand == 1 then
                for k, v in ipairs(context.scoring_hand) do
                    if not v.debuff and v.base.value == '7' and card.ability.extra.is_active then 
                        card.ability.extra.is_active = false
                        v:set_edition('e_negative', false, true)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            func = function()
                                play_sound('negative', 1.5, 0.4)
                                v:juice_up()
                                return true
                            end
                        }))
                        return {
                            colour = G.C.PURPLE,
                            message = localize("k_picubeds_prime"),
                            card = card
                        }
                    end
                end
            end
        end
        if context.selling_self and not context.blueprint then
            local negative_count = 0
            for k,v in ipairs(G.playing_cards) do
                if v.edition and v.edition.key == 'e_negative' then
                    v:set_edition(nil, false, true)
                    v:juice_up()
                    negative_count = negative_count + 1
                end
            end
            if negative_count > 0 then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                return {
                    dollars = card.ability.extra.money,
                    delay = 0.45,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}
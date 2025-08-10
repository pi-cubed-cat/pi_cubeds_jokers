SMODS.Joker { --Landslide
    key = 'landslide',
    loc_txt = {
        name = 'Landslide',
        text = {
            "A random card held in hand",
            "becomes a {C:attention}Stone Card{}",
            "if {C:chips}Chips{} exceeds {C:mult}Mult",
            "after scoring"
        }
    },
    atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 0 },
    cost = 5,
    rarity = 1,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return {
            vars = { card.ability.max_highlighted }
        }
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.after then 
            if to_big(hand_chips) > to_big(mult) and #G.hand.cards >= 1 then
                local rndcard = pseudorandom_element(G.hand.cards, pseudoseed('Landslide'..G.GAME.round_resets.ante))
                if not SMODS.has_enhancement(rndcard, 'm_stone') then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.2,
                        func = function() 
                            rndcard:flip()
                            play_sound('tarot1', 0.2)
                            return true
                        end
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_picubeds_tumble"), colour = G.C.ORANGE})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function() 
                            rndcard:set_ability('m_stone', nil, true)
                            rndcard:flip()
                            play_sound('tarot1', 1.0)
                            return true
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            rndcard:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end
}
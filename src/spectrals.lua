SMODS.Consumable { --Commander (Spectral card)
    set = "Spectral",
    key = "commander",
    loc_txt = {
        name = 'Commander',
        text = {
            "{C:attention}Destroy{} 1 random",
            "Consumable if slots are",
            "filled, add {C:dark_edition}Negative{}",
            "to all others"
        }
    },
    discovered = true,
    config = { 
        extra = { num = 1 }
    },
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 3 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} }
        return { vars = { card.ability.extra.num } }
    end,
    can_use = function(self, card)
        return #G.consumeables.cards >= 1
    end,
    in_pool = function(self, args)
        return #G.consumeables.cards >= 1
    end,
    use = function(self, card, area, copier)
        if (#G.consumeables.cards >= G.consumeables.config.card_limit) or (card.edition and card.edition.key == 'e_negative' and #G.consumeables.cards + 1 >= G.consumeables.config.card_limit) then
            local rndcard = pseudorandom_element(G.consumeables.cards, pseudoseed('Commander'..G.GAME.round_resets.ante))
            if rndcard ~= nil then
                --This event bit taken from Extra Credit's Toby the Corgi
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        rndcard.T.r = -0.2
                        rndcard:juice_up(0.3, 0.4)
                        rndcard.states.drag.is = true
                        rndcard.children.center.pinch.x = true
                        rndcard:start_dissolve()
                        rndcard = nil
                        delay(0.3)
                        return true
                    end
                }))
            end
        end
        for k, v in ipairs(G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.25,
                func = function()
                    v:set_edition('e_negative', false, true)
                    v:juice_up()
                    play_sound('negative', 1.5, 0.4)
                    return true
                end
            }))
        end
    end
}

SMODS.Consumable { --Rupture (Spectral card)
    set = "Spectral",
    key = "rupture",
    loc_txt = {
        name = 'Rupture',
        text = {
            "{C:attention}Destroy{} left-most Joker,",
            "create {C:attention}#1#{} random",
            "{C:spectral}Spectral{} cards"
        }
    },
    discovered = true,
    config = { 
        extra = { num = 2 }
    },
    atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 8 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.num } }
    end,
    can_use = function(self, card)
            return true
    end,
    use = function(self, card, area, copier)
        if G.jokers.cards and G.jokers.cards[1] then
            if not SMODS.is_eternal(G.jokers.cards[1]) then
                G.jokers.cards[1]:start_dissolve(nil, nil)
            end
        end
        for i = 1, math.min(card.ability.extra.num, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'Spectral' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,
}

SMODS.Consumable { --Extinction (Spectral card)
    set = "Spectral",
    key = "extinction",
    loc_txt = {
        name = 'Extinction',
        text = {
            "{C:attention}Destroy{} all cards of",
            "a {C:attention}random rank{}",
            "from your deck"
        }
    },
    discovered = true,
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 8 },
    cost = 4,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        if next(SMODS.find_card('j_gros_michel')) then
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.name == 'Gros Michel' then
                    check_for_unlock({type = 'picubed_extinction_grossedoff'})
                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_extinct_ex') })
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            v.T.r = -0.2
                            v:juice_up(0.3, 0.4)
                            v.states.drag.is = true
                            v.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                func = function()
                                    G.jokers:remove_card(v)
                                    v:remove()
                                    v = nil
                                return true; end})) 
                            return true
                        end
                    }))
                    G.GAME.pool_flags.gros_michel_extinct = true
                end
            end
        end
        local rank_list = {2,3,4,5,6,7,8,9,10,11,12,13,14}
        local chrank = pseudorandom_element(rank_list, "extinction"..G.GAME.round_resets.ante)
        local the_key = chrank
        if the_key == 11 then the_key = 'Jack'
        elseif the_key == 12 then the_key = 'Queen'
        elseif the_key == 13 then the_key = 'King'
        elseif the_key == 14 then the_key = 'Ace' end
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(tostring(the_key), 'ranks'),
            colour = G.C.SECONDARY_SET.Spectral })
        for k, v in ipairs(G.playing_cards) do
            if v:get_id() == chrank then
                SMODS.destroy_cards(v)
            end
        end
    end
}

if picubed_config.editions then

SMODS.Consumable { --Glamour (Spectral card)
    set = "Spectral",
    key = "glamour",
    loc_txt = {
        name = 'Glamour',
        text = {
            "Each card held in hand",
            "has a {C:green}#1# in #2#{} chance to",
            "receive the {C:dark_edition}Bisexual{} edition",
        }
    },
    discovered = true,
    atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 12 },
    cost = 4,
    config = { 
        extra = { odds = 6 }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_picubed_bisexual
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_glamour')
        return { vars = { numerator, denominator } }
    end,
    can_use = function(self, card)
        for k,v in ipairs(G.hand.cards or {}) do
            if not v.edition or not v.edition.key == 'e_picubed_glamour' then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        for k,v in ipairs(G.hand.cards or {}) do
            if not v.edition or not v.edition.key == 'e_picubed_glamour' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        if SMODS.pseudorandom_probability(card, 'picubed_glamour', 1, card.ability.extra.odds) then
                            v:set_edition('e_picubed_bisexual', true)
                            card:juice_up(0.3, 0.5)
                        else
                            attention_text({
                                text = localize('k_nope_ex'),
                                scale = 1,
                                hold = 1.4,
                                major = v,
                                backdrop_colour = G.C.SECONDARY_SET.Spectral,
                                align = 'cm',
                                offset = { x = 0, y = -0.4 },
                                silent = true
                            })
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.06 * G.SETTINGS.GAMESPEED,
                                blockable = false,
                                blocking = false,
                                func = function()
                                    play_sound('tarot2', 0.76, 0.4)
                                    return true
                                end
                            }))
                            play_sound('tarot2', 1, 0.4)
                            card:juice_up(0.3, 0.5)
                        end
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Consumable { --Partition (Spectral card)
    set = "Spectral",
    key = "partition",
    loc_txt = {
        name = 'Partition',
        text = {
            "A random Joker with ",
            "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
            "{C:dark_edition}Polychrome{} has its edition",
            "replaced with {C:dark_edition}Bisexual{}",
        }
    },
    discovered = true,
    atlas = 'PiCubedsJokers',
    pos = { x = 1, y = 12 },
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_picubed_bisexual
    end,
    in_pool = function(self, args)
        for k,v in ipairs(G.jokers.cards or {}) do
            if v.edition then
                if v.edition.key == 'e_foil' or v.edition.key == 'e_holo' or v.edition.key == 'e_polychrome' then
                    return true
                end
            end
        end
        return false
    end,
    can_use = function(self, card)
        for k,v in ipairs(G.jokers.cards or {}) do
            if v.edition then
                if v.edition.key == 'e_foil' or v.edition.key == 'e_holo' or v.edition.key == 'e_polychrome' then
                    return true
                end
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local editioned_jokers = {}
        for k,v in ipairs(G.jokers.cards or {}) do
            if v.edition then
                if v.edition.key == 'e_foil' or v.edition.key == 'e_holo' or v.edition.key == 'e_polychrome' then
                    editioned_jokers[#editioned_jokers+1] = v
                end
            end
        end
        local eligible_card = pseudorandom_element(editioned_jokers, 'picubed_partition')
        eligible_card:set_edition('e_picubed_bisexual', true)
    end
}

end
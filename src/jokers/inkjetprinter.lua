SMODS.Joker { --Inkjet Printer
     key = 'inkjetprinter',
    loc_txt = {
        name = 'Inkjet Printer',
        text = {
            "{C:attention}Consumables{} have a {C:green}#1# in #2#",
            "chance to be {C:attention}recreated{} on use,",
            "this card has a {C:green}#3# in #4#{} chance to",
            "be {C:attention}destroyed{} after activating",
            "{C:inactive}(Must have room){}"
        }
    },
    pronouns = 'it_its',
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 2 },
    cost = 6,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = { extra = { copy_odds = 2, destroy_odds = 4, copied = {} } },
    loc_vars = function(self, info_queue, card)
        local numerator_copy, denominator_copy = SMODS.get_probability_vars(card, 1, card.ability.extra.copy_odds, 'picubed_inkjetprinter_copy')
        local numerator_destroy, denominator_destroy = SMODS.get_probability_vars(card, 1, card.ability.extra.destroy_odds, 'picubed_inkjetprinter_destroy')
        return { vars = { numerator_copy, denominator_copy, numerator_destroy, denominator_destroy } }
    end,
    in_pool = function(self, args)
            return #SMODS.find_card('j_picubed_laserprinter') < 1
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            
            G.E_MANAGER:add_event(Event({
                func = function()
            
                    if SMODS.pseudorandom_probability(card, 'picubed_inkjetprinter_copy', 1, card.ability.extra.copy_odds) then
                        local has_activated = false
                        local has_destroyed = false

                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            func = function()
                                if (#G.consumeables.cards < G.consumeables.config.card_limit) then
                                    card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = localize("k_picubeds_print") })
                                    local copied_card = copy_card(context.consumeable, nil)
                                    --G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                                    copied_card:add_to_deck()
                                    G.consumeables:emplace(copied_card)
                                    has_activated = true
                                    --G.GAME.consumeable_buffer = 0
                                end
                                return true
                            end
                        }))

                        if SMODS.pseudorandom_probability(card, 'picubed_inkjetprinter_destroy', 1, card.ability.extra.destroy_odds) then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    if has_activated then
                                        card_eval_status_text(card, 'extra', nil, nil, nil,
                                            { message = localize("k_picubeds_error"), sound = 'tarot1', colour = G.C.RED })
                                        has_destroyed = true
                                        G.E_MANAGER:add_event(Event({
                                            trigger = 'after',
                                            func = function()
                                                check_for_unlock({type = 'picubed_printer_error'})
                                                G.GAME.pool_flags.picubed_printer_error = true
                                                local mpcard = SMODS.create_card({ set = 'Joker', area = G.jokers, key = 'j_misprint', key_append = 'pri' })
                                                mpcard:set_edition(card.edition, false, true)
                                                G.jokers:emplace(mpcard)
                                                G.jokers:remove_card(card)
                                                card:remove()
                                                card = nil
                                                return true;
                                            end
                                        }))
                                    end
                                    return true
                                end
                            }))
                        end
                    end

                    return true
                end
            }))

        end
    end
}

-- relies on additional functions present in src/jokers.lua
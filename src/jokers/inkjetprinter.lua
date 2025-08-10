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
            if SMODS.pseudorandom_probability(card, 'picubed_inkjetprinter_copy', 1, card.ability.extra.copy_odds) then
                local has_activated = false
                local has_destroyed = false
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if #G.consumeables.cards < G.consumeables.config.card_limit then
                            local copied_card = copy_card(context.consumeable, nil)
                            copied_card:add_to_deck()
                            G.consumeables:emplace(copied_card)
                            has_activated = true
                            card_eval_status_text(card, 'extra', nil, nil, nil,
                                { message = localize("k_picubeds_print") })
                        end
                        return true
                    end
                }))

                if SMODS.pseudorandom_probability(card, 'picubed_inkjetprinter_destroy', 1, card.ability.extra.destroy_odds) then
                    card_eval_status_text(card, 'extra', nil, nil, nil,
                        { message = localize("k_picubeds_error"), sound = 'tarot1', colour = G.C.RED })
                    G.E_MANAGER:add_event(Event({
					func = function()
						if has_activated then
                            has_destroyed = true
                            play_sound('tarot1')
                                card.T.r = -0.2
                                card:juice_up(0.3, 0.4)
                                card.states.drag.is = true
                                card.children.center.pinch.x = true
                                -- This part destroys the card.
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'after',
                                    delay = 0.3,
                                    blockable = false,
                                    func = function()
                                        check_for_unlock({type = 'picubed_printer_error'})
                                        local mpcard = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_misprint', 'pri')
                                        mpcard:set_edition(card.edition, false, true)
                                        mpcard:add_to_deck()
                                        G.jokers:emplace(mpcard)
                                        mpcard:start_materialize()
                                        G.GAME.pool_flags.picubed_printer_error = true
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
        end
    end
}

-- relies on additional functions present in src/jokers.lua
SMODS.Joker { --Hidden Gem
    key = 'hiddengem',
    loc_txt = {
        name = 'Hidden Gem',
        text = {
            "{C:attention}Discarded{} cards have a {C:green}#1# in #2#{}",
            "chance to be {C:attention}destroyed{} and",
            "create a {C:spectral}Spectral{} card",
            "{C:inactive}(Must have room)"
        }
    },
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 4, y = 1 },
    cost = 8,
    config = { extra = { odds = 15 } },
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_hiddengem')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.discard then
            if not context.other_card.debuff and not context.blueprint then
                if SMODS.pseudorandom_probability(card, 'picubed_hiddengem', 1, card.ability.extra.odds) then
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sixth')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)}))
                        return {
                            message = localize('k_plus_spectral'),
                            colour = G.C.SECONDARY_SET.Spectral,
                            card = card,
                            remove = true
                        }
                    else
                        return {
                            remove = true
                        }
                    end
                end
            end
        end
    end
}
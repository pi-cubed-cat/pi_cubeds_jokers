SMODS.Atlas {
    key = "picubed_partners",
    path = "picubedspartner.png",
    px = 46,
    py = 58
}

Partner_API.Partner { --Roof
    key = "roof",
    name = "Roof",
    atlas = "picubed_partners",
    unlocked = true,
    discovered = true,
    pos = {x = 0, y = 0},
    config = {extra = {related_card = "j_picubed_itsaysjokerontheceiling", money_ceil = 10, odds = 2, has_triggered = false }},
    link_config = {j_picubed_itsaysjokerontheceiling = 1},
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_roof')
        return { vars = { card.ability.extra.money_ceil * (2 ^ #SMODS.find_card("j_picubed_itsaysjokerontheceiling") or 0), numerator, denominator } } 
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.has_triggered = true
        end
        if context.end_of_round and tonumber(G.GAME.dollars) < 1e308 and card.ability.extra.has_triggered then
            card.ability.extra.has_triggered = false
            if SMODS.pseudorandom_probability(card, 'picubed_roof', 1, card.ability.extra.odds) then
                local ceil = 10
                local money = tonumber(G.GAME.dollars)
                local me = (#SMODS.find_card("j_picubed_itsaysjokerontheceiling") or 0)
                ceil = ceil * (2 ^ me)
                ceil = math.ceil(money / ceil) * ceil
                ceil = ceil - money
                if ceil ~= 0 then
                return {
                    message_card = card,
                    dollars = ceil
                }
                end
            else
                return {
                    message_card = localize('k_nope_ex'),
                    sound = 'tarot2',
                }
            end
        end
    end,
}

Partner_API.Partner { --Refine
    key = "refine",
    name = "Refine",
    atlas = "picubed_partners",
    unlocked = true,
    discovered = true,
    pos = {x = 1, y = 0},
    config = {extra = {related_card = "j_picubed_stonemason", mult_bonus = 2 }},
    link_config = {j_picubed_stonemason = 1},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_bonus ^ (1 + (#SMODS.find_card("j_picubed_stonemason") or 0))  } } 
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if (context.other_card.config.center ~= G.P_CENTERS.c_base or SMODS.get_enhancements(context.other_card)["m_lucky"] == true) and not context.other_card.debuff then
                local me = (#SMODS.find_card("j_picubed_stonemason") or 0)
                local mult_b = card.ability.extra.mult_bonus ^ (me + 1)
                context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0 
                context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult_bonus
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
    end,
}

Partner_API.Partner { --Copy
    key = "copy",
    name = "Copy",
    atlas = "picubed_partners",
    unlocked = true,
    discovered = true,
    pos = {x = 2, y = 0},
    config = {extra = {related_card = "j_picubed_inkjetprinter", copy_odds = 4, destroy_odds = 2, is_disabled = false }},
    link_config = {j_picubed_inkjetprinter = 1},
    loc_vars = function(self, info_queue, card)
        local numerator_copy, denominator_copy = SMODS.get_probability_vars(card, 1, card.ability.extra.copy_odds, 'picubed_copy_copy')
        local numerator_destroy, denominator_destroy = SMODS.get_probability_vars(card, 1, card.ability.extra.destroy_odds ^ (1 + (#SMODS.find_card("j_picubed_inkjetprinter") or 0)), 'picubed_copy_destroy')
        return { vars = { numerator_copy, denominator_copy, numerator_destroy, denominator_destroy } } 
    end,
    update = function(self, card, dt)
        if not card.ability.extra.is_disabled then
            card.children.center:set_sprite_pos({x = 2, y = 0})
        else
            card.children.center:set_sprite_pos({x = 2, y = 1})
        end
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not card.ability.extra.is_disabled then
            if SMODS.pseudorandom_probability(card, 'picubed_copy_copy', 1, card.ability.extra.copy_odds) then
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

                if SMODS.pseudorandom_probability(card, 'picubed_copy_destroy', 1, card.ability.extra.destroy_odds ^ (1 + (#SMODS.find_card("j_picubed_inkjetprinter") or 0))) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if has_activated then
                        has_destroyed = true
                        play_sound('tarot1')
                            card:juice_up(0.3, 0.4)
                            -- This part destroys the card.
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    play_sound('tarot1')
                                    card.ability.extra.is_disabled = true
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
            
        if context.end_of_round and G.GAME.blind.boss then
            card.ability.extra.is_disabled = false
        end
    end,
}

Partner_API.Partner { --Polymelia
    key = "polymelia",
    name = "Polymelia",
    atlas = "picubed_partners",
    unlocked = true,
    discovered = true,
    pos = {x = 3, y = 0},
    config = {extra = {card_limit_mod = 1, related_card = "j_picubed_extralimb", chips_mod = 10, card_limit_total = 0, consm_diff = 0 }},
    link_config = {j_picubed_extralimb = 1},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.card_limit_mod * (1 + (#SMODS.find_card("j_picubed_extralimb") or 0)), card.ability.extra.chips_mod * (1 + 4 *(#SMODS.find_card("j_picubed_extralimb") or 0))  } } 
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
        return true end }))
    end,
    calculate = function(self, card, context)
        if G.consumeables then
            card.ability.extra.card_limit_mod = math.ceil(card.ability.extra.card_limit_mod)
            card.ability.extra.card_limit_total = card.ability.extra.card_limit_mod * (1 + (#SMODS.find_card("j_picubed_extralimb") or 0))
            while card.ability.extra.card_limit_total > card.ability.extra.consm_diff do
                card.ability.extra.consm_diff = card.ability.extra.consm_diff + 1
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            end
            while card.ability.extra.card_limit_total < card.ability.extra.consm_diff do
                card.ability.extra.consm_diff = card.ability.extra.consm_diff - 1
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
            end
        end
        if context.other_consumeable or context.partner_other_consumeable then
            --print("hi")
            local chips_c = card.ability.extra.chips_mod * (1 + 4 *((#SMODS.find_card("j_picubed_extralimb") or 0)))
            return {
                chip_mod = chips_c,
                --message_card = context.other_consumable
                message = localize { type = 'variable', key = 'a_chips', colour = G.C.CHIPS, vars = { chips_c } }
            }
        end
        --[[if (context.joker_main or context.partner_main) and #G.consumeables.cards > 0 then
            local chips_c = #G.consumeables.cards * card.ability.extra.chips_mod * (1 + 9 *((#SMODS.find_card("j_picubed_extralimb") or 0)))
            return {
            message = localize{type = "variable", key = "a_chips", vars = {chips_c}},
            chip_mod = chips_c,
            colour = G.C.CHIPS
            }
        end]]
    end,
}
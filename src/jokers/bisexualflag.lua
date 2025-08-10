SMODS.Joker { --Bisexual Flag
    key = 'bisexualflag',
    loc_txt = {
        name = 'Bisexual Flag',
        text = {
            "If {C:attention}played hand{} contains a",
            "{C:attention}Straight{} and {C:attention}four suits{},",
            "create #1# {C:dark_edition}Negative {C:purple}Tarot{} cards",
        }
    },
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 2 },
    cost = 8,
    config = { extra = { tarots = 3 } },
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        return {
            vars = { card.ability.extra.tarots }
        }
    end,
    --[[in_pool = function(self, args)
        if not G.GAME.challenge == 'ch_c_picubed_balalajokerpoker' then return true end
    end,]]
    calculate = function(self, card, context)
        if context.joker_main then
            local suit_list = {}
            for k, v in pairs(SMODS.Suits) do
                suit_list[k] = 0
            end
            for k, v in ipairs(context.scoring_hand) do --checking for all non-wild cards
                if not SMODS.has_any_suit(v) then
                    for kk, vv in pairs(suit_list) do
                        if v:is_suit(kk, true) and suit_list[kk] ~= 1 then 
                            suit_list[kk] = 1
                            break
                        end 
                    end
                end
            end
            for k, v in ipairs(context.scoring_hand) do --checking for all wild cards
                if SMODS.has_any_suit(v) then
                    for kk, vv in pairs(suit_list) do
                        if v:is_suit(kk, true) and suit_list[kk] ~= 1 then 
                            suit_list[kk] = 1
                            break
                        end 
                    end
                end
            end
            local suit_count = 0
            for kk, vv in pairs(suit_list) do
                if suit_list[kk] == 1 then 
                    suit_count = suit_count + 1
                end 
            end 
            if string.find(context.scoring_name, "Straight Spectrum") or (next(context.poker_hands["Straight"]) or next(context.poker_hands["Straight Flush"])) and 
            suit_count >= 4 then
                local card_type = 'Tarot'
                for i=1,card.ability.extra.tarots do
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
                            card:set_edition('e_negative', true)
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    )}))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_picubeds_pride"), colour = G.C.PURPLE})
                end
            end
        end
    end
}
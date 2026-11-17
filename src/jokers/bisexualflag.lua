local function create_random_consumable(card, context, edition)
    if edition == 'e_negative' 
    or #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        if edition ~= 'e_negative' then 
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1 
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                SMODS.add_card({ set = 'Consumeables', edition = edition or nil, immediate = true, allow_duplicates = false, soulable = false })
                if edition ~= 'e_negative' then G.GAME.consumeable_buffer = 0 end
                return true
            end)
        }))
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize("k_picubeds_pride"), colour = G.C.PURPLE})
    end
end

SMODS.Joker { --Bisexual Flag
    key = 'bisexualflag',
    pronouns = 'it_its',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 2 },
    cost = 7,
    config = { extra = { r_consumables = 2, n_consumables = 1 } },
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    attributes = { 'hand_type', 'generation', 'edition' },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        return {
            vars = { card.ability.extra.r_consumables, card.ability.extra.n_consumables }
        }
    end,
    --[[in_pool = function(self, args)
        if not G.GAME.challenge == 'ch_c_picubed_balalajokerpoker' then return true end
    end,]]
    calculate = function(self, card, context)
        if context.joker_main then
            if card.edition and card.edition.key == 'e_picubed_bisexual' then
                check_for_unlock({type = 'picubed_bisexual_squared'})
            end
            
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
                for i=1,card.ability.extra.r_consumables do
                    create_random_consumable(card, context, nil)
                end
                for i=1,card.ability.extra.n_consumables do
                    create_random_consumable(card, context, 'e_negative')
                end
            end
        end
        if context.forcetrigger then
            for i=1,card.ability.extra.r_consumables do
                create_random_consumable(card, context, nil)
            end
            for i=1,card.ability.extra.n_consumables do
                create_random_consumable(card, context, 'e_negative')
            end
        end
    end
}
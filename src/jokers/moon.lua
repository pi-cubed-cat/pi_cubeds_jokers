SMODS.Joker { -- Moon
    key = 'moon',
    pronouns = 'she_her',
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 15 },
    cost = 6,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    demicoloncompat = true,
    config = { extra = { chips_mod = 25, chips = 0, suits = 3 } },
    attributes = { 'chips', 'scaling', 'suit', 'hands' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips, card.ability.extra.suits } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
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
            if suit_count >= card.ability.extra.suits then
                return {
                    card = card,
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "chips",
                            scalar_value = "chips_mod",
                            scaling_message = {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.CHIPS,
                            }
                        })
                    end
                }
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
				chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
        end
    end
}
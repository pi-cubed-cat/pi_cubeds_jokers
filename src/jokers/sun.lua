SMODS.Joker { -- Sun
    key = 'sun',
    pronouns = 'she_her',
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 1, y = 15 },
    cost = 6,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    demicoloncompat = true,
    config = { extra = { mult_mod = 4, mult = 0, suits = 3 } },
    attributes = { 'mult', 'scaling', 'suit', 'hands' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult, card.ability.extra.suits } }
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
                            ref_value = "mult",
                            scalar_value = "mult_mod",
                            scaling_message = {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.MULT,
                            }
                        })
                    end
                }
            end
        end
        if context.joker_main or context.forcetrigger then
            return {
				mult = card.ability.extra.mult
			}
        end
    end
}
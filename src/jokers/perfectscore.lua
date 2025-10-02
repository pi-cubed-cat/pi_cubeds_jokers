SMODS.Joker { --Perfect Score
    key = 'perfectscore',
    loc_txt = {
        name = 'Perfect Score',
        text = {
            "{C:chips}+#1# {}Chips if scoring",
            "hand contains a {C:attention}10{}"
        }
    },
    pronouns = 'they_them',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 1, y = 4 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { chips = 100 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local has_10 = false
            for k, v in ipairs(context.scoring_hand) do
                if v.base.value == '10' then
                    has_10 = true
                end
            end
            if has_10 then
                return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
                }
            end
        end
    end
}
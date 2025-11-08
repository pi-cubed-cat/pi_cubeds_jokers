SMODS.Joker { --Hitting a Sick Clip
    key = 'hittingasickclip',
    loc_txt = {
        name = 'Hitting a Sick Clip',
        text = {
            "{C:attention}Retrigger{} all cards",
            "with a {C:attention}Clip{}",
        }
    },
    pronouns = 'she_her',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 1, y = 14 },
    config = { extra = { repetitions = 1 } },
    cost = 7,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    in_pool = function(self, args)
        for _, v in ipairs(G.playing_cards or {}) do
            if PB_UTIL.has_paperclip(v) then return true end
        end
    end,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and context.other_card and context.other_card.config and context.other_card.config.center
        and (context.other_card.config.center.key == 'j_paperback_clothespin' or context.other_card.config.center.key == 'j_paperback_clippy') then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.repetitions,
                message_card = context.blueprint_card or card,
            }
        elseif context.repetition and
                context.other_card and PB_UTIL.has_paperclip(context.other_card) and not context.other_card.debuff then
            return {
                message = localize("k_again_ex"),
                repetitions = card.ability.extra.repetitions,
                card = card,
            }
        end
    end
}
SMODS.Joker { --Got the Worm
    key = 'gottheworm',
    loc_txt = {
        name = 'Got the Worm',
        text = {
            "{C:attention}Skipping{} a blind",
            "also gives {C:money}$#1#{}"
        }
    },
    pronouns = 'she_her',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 3 },
    cost = 4,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money = 15 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind then
            return {
                dollars = card.ability.extra.money,
                card = card
            }
        end
    end
}
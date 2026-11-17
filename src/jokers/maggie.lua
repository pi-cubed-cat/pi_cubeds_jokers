SMODS.Joker { -- Maggie
    key = 'maggie',
    pronouns = 'she_her',
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 4, y = 15 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money = 7, dark_cards = 5 } },
    demicoloncompat = true,
    attributes = { 'economy', 'suits', 'spades', 'clubs', 'hands' },
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.money, card.ability.extra.dark_cards
        } }
	end,
    calculate = function(self, card, context)
        if context.before then
            local dark_count = 0
            for k,v in ipairs(context.scoring_hand) do
                if (v:is_suit("Spades") or v:is_suit("Clubs")) and not SMODS.has_no_suit(v) then
                    dark_count = dark_count + 1
                end
            end
            if dark_count >= card.ability.extra.dark_cards then
                return {
                    dollars = card.ability.extra.money
                }
            end
        end
    end
}
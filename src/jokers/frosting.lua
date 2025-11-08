SMODS.Joker { --Frosting
    key = 'frosting',
    loc_txt = {
        name = 'Frosting',
        text = {
            {
                "All Jokers and playing cards in",
                "{C:attention}shop{} are given an {C:attention}edition{}",
            },
            {
                "{C:green}#1# in #2#{} chance this Joker",
                "is destroyed on {C:attention}shop reroll{}",
            }
        }
    },
    pronouns = 'it_its',
    rarity = 1,
    config = { extra = { odds = 2 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 13 },
    cost = 3,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    pools = { ["Food"] = true },
    loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_d2')
		return { vars = { numerator, denominator } }
	end,
    update = function(self, card, dt)
        if G.shop_jokers and G.shop_jokers.cards and next(SMODS.find_card('j_picubed_frosting')) then
            for k,v in ipairs(G.shop_jokers.cards) do
                if v.ability.set == "Joker" or v.ability.set == "Default" or v.ability.set == "Enhanced" then
                    if not v.edition then
                        local edition = poll_edition('aura', nil, false, true)
                        v:set_edition(edition, true)
                    end
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if context.reroll_shop and not context.blueprint and not context.joker_retrigger then
            if SMODS.pseudorandom_probability(card, 'picubed_frosting', 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.PURPLE
                }
            end
        end
    end
}
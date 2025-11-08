SMODS.Joker { --Intermission
    key = 'intermission',
    loc_txt = {
        name = 'Intermission',
        text = {
            "{C:green}#1# in #2#{} chance to create",
            "a {C:attention}Food Joker{} if played",
            "hand contains a {C:attention}Straight{}",
        }
    },
    pronouns = 'he_they',
    rarity = 1,
    config = { extra = { odds = 2, has_straight = false } },
    atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 11 },
    cost = 6,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_d2')
		return { vars = { numerator, denominator } }
	end,
    calculate = function(self, card, context)
        if context.after and next(context.poker_hands["Straight"]) then 
            if SMODS.pseudorandom_probability(card, 'picubed_intermission', 1, card.ability.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card({set = "Food", area = G.Jokers })
                        return true
                    end
                }))
                return {
                    message = localize('k_plus_joker')
                }
            end
        end
    end
}
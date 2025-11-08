SMODS.Joker { --Illusion of Choice
    key = 'illusionofchoice',
    loc_txt = {
        name = 'Illusion of Choice',
        text = {
            {
                "Choose #1# additional card",
                "in {C:attention}Booster Packs{}",
                "to obtain or use",
            },
            {
                "All cards in a Booster",
                "Pack are {C:attention}the same{}",
            }
        }
    },
    pronouns = 'she_her',
    rarity = 1,
    config = { extra = { choices = 1, held_joker = false } },
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 11 },
    cost = 6,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.choices } }
	end,
    add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.choices
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.choices
	end,
    update = function(self, card, dt)
        if card.ability.extra.held_joker and G.pack_cards and G.pack_cards.cards and G.pack_cards.cards[1] then
            local first_card = G.pack_cards.cards[1]
            local not_first_card_stickers = {}
            for k,v in pairs(SMODS.Stickers) do
                if not first_card.ability[k] then
                    table.insert(not_first_card_stickers, k)
                end
            end
            for k,v in ipairs(G.pack_cards.cards) do
                copy_card(first_card, v)
                for kk,vv in pairs(not_first_card_stickers) do
                    if v.ability[vv] then
                        v.ability[vv] = nil
                    end
                end
            end
        end
    end,
    calculate = function(self, card, context)
        card.ability.extra.held_joker = false
        if context.open_booster and not context.blueprint and not context.joker_retrigger then
            card.ability.extra.held_joker = true
        end
    end
}
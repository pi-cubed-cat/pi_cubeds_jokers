SMODS.Joker { --Illusion of Choice
    key = 'illusionofchoice',
    pronouns = 'she_her',
    rarity = 2,
    config = { extra = { held_joker = false, copying_card = nil } },
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 11 },
    cost = 7,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    pools = { ["Meme"] = true },
    attributes = { 'passive' },
    add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + 999
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) - 999
	end,

    update = function(self, card, dt)
        if card.ability.extra.held_joker and G.pack_cards and G.pack_cards.cards and G.pack_cards.cards[1] 
        and not card.ability.extra.copying_card then
            local copied_card = pseudorandom_element(G.pack_cards.cards, 'picubed_illusionofchoice')
            if G.GAME.used_vouchers["v_telescope"] and (SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == "Celestial") then 
                copied_card = G.pack_cards.cards[1] 
            end
            if copied_card and copied_card.ability then
                card.ability.extra.copying_card = copied_card
                local not_copied_card_stickers = {}
                for k,v in pairs(SMODS.Stickers) do
                    if not copied_card.ability[k] then
                        table.insert(not_copied_card_stickers, k)
                    end
                end
                for k,v in ipairs(G.pack_cards.cards) do
                    copy_card(copied_card, v)
                    for kk,vv in pairs(not_copied_card_stickers) do
                        if v.ability[vv] then
                            v.ability[vv] = nil
                        end
                    end
                    if not copied_card.children.front then
                        v.children.front = nil
                    end
                end
                card.ability.extra.held_joker = false
            end
        end
    end,
    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint and not context.joker_retrigger then
            card.ability.extra.held_joker = true
            card.ability.extra.copying_card = nil
        end
    end
}
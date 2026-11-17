SMODS.Sound({
	key = "splat",
	path = "splat.ogg",
})

SMODS.Sound({
	key = "splat_reverse",
	path = "splat_reverse.ogg",
})

SMODS.Joker { -- Lancer
	key = 'lancer',
	pronouns = 'he_him',
	rarity = 2,
	atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 12 },
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
    demicoloncompat = false,
	attributes = { 'jack', 'spades' },
    add_to_deck = function(self, card, from_debuff)
		if picubed_config.custom_sound_effects then
            play_sound("picubed_splat")
        end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if picubed_config.custom_sound_effects then
            play_sound("picubed_splat_reverse")
        end
	end,
    calculate = function(self, card, context)
        if context.playing_card_added and not context.blueprint then
            for i=1,#context.cards do
                local card_added = context.cards[i]
                if card_added:is_suit("Spades") or card_added:get_id() == 11 then
                    if not card_added.seal then
                        card_added:set_seal(SMODS.poll_seal({guaranteed = true}), nil, nil)
                    end
                    if not card_added.edition then
                        card_added:set_edition(SMODS.poll_edition({no_negative = true, guaranteed = true}), nil, nil)
                    end
                    if card_added.config.center_key == 'c_base' then
                        card_added:set_ability(SMODS.poll_enhancement({guaranteed = true}), nil, nil)
                    end
                end
            end
        end
    end,
}
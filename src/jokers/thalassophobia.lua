SMODS.Joker { -- Thalassophobia
	key = 'thalassophobia',
	pronouns = 'she_they',
	rarity = 1,
	atlas = 'PiCubedsJokers',
    pos = { x = 4, y = 14 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 20, target_face = nil } },
    demicoloncompat = true,
	attributes = { 'mult', 'face', 'destroy_card', 'hands' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.mult
        } }
	end,
	calculate = function(self, card, context)
        if context.before and not context.blueprint 
        and G.GAME.current_round.hands_left == 0 then
            local face_cards = {}
            for k,v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    face_cards[#face_cards+1] = v
                end
            end
            if #face_cards > 0 then
                card.ability.extra.target_face = pseudorandom_element(face_cards, 'picubed_thalassophobia')
            end
        end
        if context.individual and context.cardarea == G.play 
        and G.GAME.current_round.hands_left == 0 and card.ability.extra.target_face
        and context.other_card == card.ability.extra.target_face then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.destroying_card and context.cardarea == G.play and not context.blueprint then
            if G.GAME.current_round.hands_left == 0 and card.ability.extra.target_face
            and context.destroy_card == card.ability.extra.target_face then
                return {
                    remove = true
                }
            end
        end
		if context.forcetrigger then
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}
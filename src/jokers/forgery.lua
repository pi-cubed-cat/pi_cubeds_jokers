SMODS.Joker { --Forgery
	key = 'forgery',
	loc_txt = {
		name = 'Forgery',
		text = {
			"When {C:attention}Blind{} is selected,",
			"{C:attention}destroy{} a random card in {C:attention}deck{},",
			"and add a {C:attention}quarter{} of its",
			"{C:chips}Chips{} to this Joker as {C:mult}Mult",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	pronouns = 'he_they',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 5 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { mult = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and not context.retrigger_joker and #G.playing_cards > 0 then
			local card_list = {}
			for k,v in ipairs(G.playing_cards) do
				if not v.getting_sliced then
					table.insert(card_list, v)
				end
			end

			if #card_list > 0 then
				local card_is_kil = pseudorandom_element(card_list, pseudoseed('forgery'..G.GAME.round_resets.ante))
				card_is_kil.getting_sliced = true
				local card_mult = 0
				if SMODS.has_no_rank(card_is_kil) then -- rankless cards
					card_mult = card_mult + 0
				else
					card_mult = card_is_kil.base.nominal or 0
				end
				card_mult = card_mult + (card_is_kil.ability.perma_bonus or 0) + (card_is_kil.ability.perma_h_chips or 0)
				if SMODS.has_enhancement(card_is_kil, 'm_bonus') then -- bonus card (vanilla)
					card_mult = card_mult + 30
				elseif SMODS.has_enhancement(card_is_kil, 'm_stone') then -- stone card (vanilla)
					card_mult = card_mult + 50
				elseif SMODS.has_enhancement(card_is_kil, 'm_akyrs_ash_card') then -- ash card (aikoyori's shenanigans)
					card_mult = card_mult + 30
				end
				if card_is_kil.edition then
					if card_is_kil.edition.key == 'e_foil' then -- foil (vanilla)
							card_mult = card_mult + 50
					elseif card_is_kil.edition.key == 'e_cry_noisy' then -- noisy (cryptid)
							card_mult = card_mult + pseudorandom('noisy') * 150
					elseif card_is_kil.edition.key == 'e_ortalab_anaglyphic' then -- anaglyphic (ortalab)
							card_mult = card_mult + 20
					elseif card_is_kil.edition.key == 'e_cry_mosaic' then -- mosaic (cryptid)
							card_mult = 2.5 * card_mult
					elseif card_is_kil.edition.key == 'e_akyrs_texelated' then -- texelated (aikoyori's shenanigans)
							card_mult = 0.8 * card_mult
					elseif card_is_kil.edition.key == 'e_bunc_glitter' then -- glitter (bunco)
							card_mult = 1.3 * card_mult
					elseif card_is_kil.edition.key == 'e_yahimod_evil' then -- evil (yahimod)
							card_mult = 1.5 * card_mult
					end
				end
				if card_is_kil.ability.perma_x_chips and card_is_kil.ability.perma_x_chips > 1 then
					card_mult = card_mult * card_is_kil.ability.perma_x_chips
				end
				if card_is_kil.ability.perma_h_x_chips and card_is_kil.ability.perma_h_x_chips > 1 then
					card_mult = card_mult * card_is_kil.ability.perma_h_x_chips
				end			 
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.1,
					func = function()
						draw_card(G.deck, G.play, 90, 'up', nil, card_is_kil)
						delay(1)
						return true
					end
				}))
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.1,
					func = function()
						SMODS.destroy_cards(card_is_kil)
						SMODS.calculate_effect({ message = localize { type = 'variable', key = 'a_mult', vars = { card_mult * 0.25 } }, colour = G.C.MULT, sound = 'slice1', pitch = 0.96 + math.random() * 0.08 }, card )
						return true 
					end
				}))
				if card_mult * 0.25 >= 40 then
					check_for_unlock({type = 'picubed_forgery_criticalhit'})
				end
				card.ability.extra.mult = card.ability.extra.mult + card_mult * 0.25
			end

		end
		if context.joker_main then
			return {
                mult = card.ability.extra.mult,
                card = card
			}
		end
	end
}
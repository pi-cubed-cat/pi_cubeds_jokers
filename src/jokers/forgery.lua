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
	config = { extra = { mult = 0, mult_mod = 0.25 } },
	attributes = { 'mult', 'chips', 'destroy_card', 'scaling' },
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
				-- permanent +chips or holding +chips
				card_mult = card_mult + (card_is_kil.ability.perma_bonus or 0) + (card_is_kil.ability.perma_h_chips or 0)
				
				-- enhancement +chips
				card_mult = card_mult + (card_is_kil.ability.bonus or 0)
				
				if card_is_kil.edition then
					-- edition +chips
					if card_is_kil.edition.key == 'e_cry_noisy' then -- noisy (cryptid)
						card_mult = card_mult + pseudorandom('noisy') * (card_is_kil.edition.max_chips or 0) + (card_is_kil.edition.min_chips or 0)
					else
						card_mult = card_mult + (card_is_kil.edition.chips or 0)
					end

					-- edition xchips
					card_mult = card_mult * (card_is_kil.edition.x_chips or 1)
				end

				-- enhancement xchips or holding xchips
				card_mult = card_mult * (card_is_kil.ability.x_chips or 0)
				card_mult = card_mult * (card_is_kil.ability.h_x_chips or 0)

				-- permanent xchips or holding xchips
				card_mult = card_mult * ((card_is_kil.ability.perma_x_chips or 0) + 1)
				card_mult = card_mult * ((card_is_kil.ability.perma_h_x_chips or 0) + 1)

				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.1,
					func = function()
						draw_card(G.deck, G.play, 90, 'up', nil, card_is_kil)
						delay(1)
						return true
					end
				}))

				return { 
					func = function()
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.1,
							func = function()
								local mult_mod = card.ability.extra.mult_mod
								if card_mult * mult_mod >= 40 then
									check_for_unlock({type = 'picubed_forgery_criticalhit'})
								end
								SMODS.destroy_cards(card_is_kil)
								SMODS.scale_card(card, {
									ref_table = card.ability.extra,
									ref_value = "mult",
									scalar_table = { card_mult * mult_mod },
									scalar_value = 1,
									scaling_message = {
										message = localize { type = 'variable', key = 'a_mult', vars = { card_mult * mult_mod } },
										colour = G.C.MULT,
										sound = 'slice1', 
										pitch = 0.96 + math.random() * 0.08,
									}
								})
								return true
							end
						}))
					end
				}
			end

		end
		if context.joker_main or context.forcetrigger then
			return {
                mult = card.ability.extra.mult,
                card = card
			}
		end
	end
}
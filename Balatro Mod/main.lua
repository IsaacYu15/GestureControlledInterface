local https = require "SMODS.https"
local last_thresh_level = 0;

local derek_dialogue = {
    [9] = 'OK!',
    [10] = 'NICE!',
    [11] = 'WOAH!',
    [12] = 'BIGG!',
    [13] = 'HUGE!',
    [14] = 'WOOOOW!!!',
}

local function postEffect(sequenceId)
    print("posting effect: " .. sequenceId)
    local url = "http://192.168.2.19/elm/groups/Group01/performer?active=1&sequenceId=" .. sequenceId
    local options = {
        method = "POST",
            headers = {
                ["Content-Type"] = "application/json"
            }
    }
    https.request(url, options)
end

local function scoreEffects(total_amount, blind_amount)
    local score_effect = total_amount / blind_amount;

    local thresh_level = math.min(math.max(math.floor(score_effect * 6), 0), 6);

    if (thresh_level > last_thresh_level) then
        
        last_thresh_level = thresh_level
        local sequence_id = last_thresh_level + 8

        G.E_MANAGER:add_event(Event({
            func = function() 
                postEffect(sequence_id);
                return {true, derek_dialogue[sequence_id]} 
            end
        }))

        return {true, derek_dialogue[sequence_id]}
    end

    return {false, ''}
end

sendDebugMessage("Loading Mahjong Table", "MyDebugLogger")
postEffect(25);

SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Joker{
    key = 'derek', --joker key
    loc_txt = { -- local text
        name = 'Derek',
        text = {
          'Connects to {C:attention}Mahjong Table{}',
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 4, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 123, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        Xmult = 100,
      }
    },
    add_to_deck = function(self, card, from_debuff)
        card:set_edition({negative = true}, true, true)
    end,
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_joker --adds "Joker"'s description next to this card's description
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'derek_loves_you' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)

        if context.starting_shop then
            print("Shop Start")
            postEffect(26)
        end
        
        if context.ending_shop then
            print("Shop End")
            postEffect(25)
        end

        if context.open_booster then 
            print("Booster Pack Start")
            postEffect(27)
        end 

        if context.ending_booster then 
            print("Booster Pack Start")
            postEffect(26)
        end 

                
        if context.drawing_cards and last_thresh_level ~= 0 or context.round_eval then
            last_thresh_level = 0
            postEffect(25);
        end

        if context.individual or context.final_scoring_step then
            local safe_chips = hand_chips or 0
            local safe_mult = mult or 0
            local safe_score = safe_chips * safe_mult

            local scoring_data = scoreEffects(safe_score, G.GAME.blind["chips"]);
            if scoring_data[1] then
                card_eval_status_text(
                    card, 
                    'extra', 
                    nil, nil, nil,
                    {message = scoring_data[2]}
                )
            end

        end

    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
    calc_dollar_bonus = function(self,card)
        return 123
    end,
}

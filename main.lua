
local roPrompts = require(game.ServerScriptService.roPrompts)
local bans = {}

function prompt(user)
    local prompt = roPrompts.New({ -- Create a prompt object
        Type = roPrompts.PromptType.Confirm, -- Define what type of prompt you want
        Title = 'Confirm Action', -- Title of the prompt
        Description = 'Are you sure you would like to ban '..user..'?', -- Description of the prompt
        PrimaryButton = 'Confirm', -- Main button of the prompt
        SecondaryButton = 'Cancel' -- Secondary/cancel button of the prompt
    })

    return prompt
end

function findUser(user)
    local player: Instance

    for i, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():sub(1, user:len()) == user:lower() then
            player = v
        end
    end

    return player
end

--[[ CONFIG ]]

local Admins = {
    264614164, -- Nepzerox
    1, -- Roblox
}

local banMessage = 'You are banned from this server'

----------------------

--// command handler
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        if msg:sub(1,1) == '/' then
            local split = msg:lower():split(' ')

            if split[1] == '/ban' then
                if table.find(Admins, player.UserId) then
                    local found = findUser(split[2])

                    if split[2] and found then
                        if roPrompts:PromptPlayer(player, prompt(found.Name)) then
                            bans[#bans+1] = found.UserId
                        end
                    end
                end
            end
        end
    end)
end)

--// ban handler
game.Players.PlayerAdded:Connect(function(player)
    if table.find(bans, player.UserId) then
        player:Kick(banMessage)
    end
end)
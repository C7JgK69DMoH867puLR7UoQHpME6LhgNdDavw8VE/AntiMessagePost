if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LP, Chatted = game:GetService('Players').LocalPlayer, Instance.new('BindableEvent')
local Chat, MessagePosted = game:GetService('Chat')

Chatted.Name = LP.Name..'_Chatted_Event'

if Chat and Chat:FindFirstChild('ChatScript') and Chat.ChatScript:FindFirstChild('ChatMain') then
    MessagePosted = require(Chat.ChatScript.ChatMain).MessagePosted

    local Old
    Old = hookmetamethod(game, '__namecall', function(self, ...)
        local Method = getnamecallmethod()
       
        if self == MessagePosted and not checkcaller() and Method == 'Fire' then
            Chatted:Fire(...)
            return
        end
       
        return Old(self, ...)
    end)

    local Old2
    Old2 = hookmetamethod(game, '__index', newcclosure(function(self, Index)
        if checkcaller() and self == LP and Index == 'Chatted' then
            return Chatted.Event
        end
       
        return Old2(self, Index)
    end))
end
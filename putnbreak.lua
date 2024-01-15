-------------
Magplant_X      = MAIN_PANEL.MAIN_SET.Magplant_X
Magplant_Y      = MAIN_PANEL.MAIN_SET.Magplant_Y
CONSUME_ARROZ   = MAIN_PANEL.MAIN_SET.CONSUME_ARROZ
CONSUME_CLOVER  = MAIN_PANEL.MAIN_SET.CONSUME_CLOVER
DROP_GEMS       = MAIN_PANEL.MAIN_SET.DROP_GEMS
PosBreak_X      = MAIN_PANEL.MAIN_SET.PosBreak_X
PosBreak_Y      = MAIN_PANEL.MAIN_SET.PosBreak_Y
CV_WL_DL_BGL    = MAIN_PANEL.MAIN_SET.CV_WL_DL_BGL
CV_IRENG        = MAIN_PANEL.MAIN_SET.CV_IRENG
WEBHOOK_URL     = MAIN_PANEL.WEBHOOK_SET.WEBHOOK_URL
WEBHOOK_TIME    = MAIN_PANEL.WEBHOOK_SET.WEBHOOK_TIME
-------------
if PosBreak_X == -1 or PosBreak_Y == -1 then      --JANGAN DISENTUH
PosBreak_X      = math.floor(GetLocal().pos.x/32) --JANGAN DISENTUH
PosBreak_Y      = math.floor(GetLocal().pos.y/32) --JANGAN DISENTUH
end
WORLD           = GetWorld().name                 --JANGAN DISENTUH
REMOTE_X        = Magplant_X                      --JANGAN DISENTUH
REMOTE_Y        = Magplant_Y                      --JANGAN DISENTUH
EMPTY_MAGPLANT  = false                           --JANGAN DISENTUH
CHANGE_MAGPLANT = false                           --JANGAN DISENTUH
LEFT_MAG_X      = Magplant_X                      --JANGAN DISENTUH
TIME_WEBHOOK    = os.time()                       --JANGAN DISENTUH
CURRENT_GEMS    = GetPlayerInfo().gems            --JANGAN DISENTUH
BLACK_GEM_COUNT = 0
MEMEK           = math.floor(WEBHOOK_TIME * 60)   --JANGAN DISENTUH
-------------
function log(txt)
    LogToConsole("`0[`^ALFIRST-STORE`0]`#: "..txt)
end

function findItem(id)
    for _, itm in pairs(GetInventory()) do
        if itm.id == id then
        return itm.amount
        end
    end
return 0
end
----------------
BLGL = math.floor(findItem(11550))
BGL = math.floor(findItem(7188))
DL = math.floor(findItem(1796))
WL = math.floor(findItem(242))
TOTAL_LOCKS = (BLGL*1000000) + (BGL*10000) + (DL*100) + WL
----------------
for _, item in pairs(GetObjectList()) do
	if GetWorld() == nil then return end
	if item.id == 14668 then
		BLACK_GEM_COUNT = BLACK_GEM_COUNT + item.amount
	end
end
----------------

function CV(id)
    pkt = {}
    pkt.value = id
    pkt.type = 10
    SendPacketRaw(false, pkt)
end

function Place(id,x,y)
    pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

function wrench(x,y)
    pkt = {}
    pkt.type = 3
    pkt.value = 32
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

function hook(varlist)
    if varlist[0]:find("OnTalkBubble") and (varlist[2]:find("The MAGPLANT 5000 is empty")) then
        CHANGE_MAGPLANT = true
        EMPTY_MAGPLANT = true
        return true
    end

    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("magplant_edit") then
        local x = varlist[1]:match('embed_data|x|(%d+)')
        local y = varlist[1]:match('embed_data|y|(%d+)')
        return true
    end

    if varlist[0] == "OnConsoleMessage" then
      if varlist[1]:find("`oYour luck has worn off.") then
         CONSUME_CLOVER = true
      elseif varlist[1]:find("`oYour stomach's rumbling.") then
         CONSUME_ARROZ = true
      end
    end
    if varlist[0]:find("OnDialogRequest") and (varlist[1]:find("Item Finder") or varlist[1]:find("The MAGPLANT 5000 is disabled.")) then
        return true
    end
    if varlist[0]:find("OnConsoleMessage") and varlist[1]:find("Cheat Active") then
        return true
    end
    if varlist[0]:find("OnConsoleMessage") and varlist[1]:find("Whoa, calm down toggling cheats on/off... Try again in a second!") then
        return true
    end
    if varlist[0]:find("OnConsoleMessage") and varlist[1]:find("Applying cheats...") then
        return true
    end
    if varlist[0]:find("OnConsoleMessage") and varlist[1]:find("You're now") then
        return true
    end
    if varlist[0]:find("OnConsoleMessage") and varlist[1]:find("Cheat Disable:") then
        return true
    end
    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|telephone")then
        return true
    end
end

function BlockParticles(packet)
   if (packet.type == 17 or packet.type == 8) then
      return true
   end
end

AddHook("onprocesstankupdatepacket", "??", BlockParticles)
AddHook("onvariant", "Main Hook", hook)

function cekPos()
    if GetWorld() == nil then return end
        FindPath(PosBreak_X,PosBreak_Y,100)
        Sleep(100)
end

function removeColor(str)
    local cleanedStr = string.gsub(str, "`(%S)", '')
    cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
    return cleanedStr
end

function FormatNumber(num)
   num = math.floor(num + 0.5)

   local formatted = tostring(num)
   local k = 3
   while k < #formatted do
      formatted = formatted:sub(1, #formatted - k) .. "," .. formatted:sub(#formatted - k + 1)
      k = k + 4
   end

   return formatted
end

function EARNED_LOCKS(LOCK_COUNT)
    local EARNED_BLGL = 0
    local EARNED_BGL = 0
    local EARNED_DL = 0
    local EARNED_WL = 0

    while LOCK_COUNT >= 1000000 do
        LOCK_COUNT = LOCK_COUNT - 1000000
        EARNED_BLGL = EARNED_BLGL + 1
    end

    while LOCK_COUNT >= 10000 do
        LOCK_COUNT = LOCK_COUNT - 10000
        EARNED_BGL = EARNED_BGL + 1
    end

    while LOCK_COUNT >= 100 do
        LOCK_COUNT = LOCK_COUNT - 100
        EARNED_DL = EARNED_DL + 1
    end

    while LOCK_COUNT >= 1 do
        LOCK_COUNT = LOCK_COUNT - 1
        EARNED_WL = EARNED_WL + 1
    end

    return EARNED_BLGL, EARNED_BGL, EARNED_DL, EARNED_WL
end

function CVBGL()
if GetWorld() == nil then return end
SendPacket(2, "action|dialog_return\ndialog_name|telephone\nnum|53785|\nx|"..math.floor(GetLocal().pos.x//32).."|\ny|"..math.floor(GetLocal().pos.y//32).. "|\nbuttonClicked|bglconvert")
end

function CheckRemote()
    if GetWorld() == nil then return end
    if findItem(5640) < 1 then
        Sleep(800)
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_gems|0")
        Sleep(200)
        TakeRemote()
        Sleep(200)
        cekPos()
        Sleep(100)
        end

    if findItem(5640) >= 1 and EMPTY_MAGPLANT then
        EMPTY_MAGPLANT = false
    end
    Sleep(800)
    return findItem(5640) >= 1
end

function TakeRemote()
    if GetWorld() == nil then return end
    Sleep(100)
    FindPath(REMOTE_X, REMOTE_Y - 1, 100)
    wrench(0,1)
    Sleep(200)
    SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. REMOTE_X .."|\ny|" .. REMOTE_Y .. "|\nbuttonClicked|getRemote")
    Sleep(200)
end

function WebhookBgems()
    if GetWorld() == nil then return end
    BEFORE_BLACK_GEMS = BLACK_GEM_COUNT
    BLACK_GEM_COUNT = 0

    for _, item in pairs(GetObjectList()) do
		if item.id == 14668 then
			BLACK_GEM_COUNT = BLACK_GEM_COUNT + item.amount
		end
	end

    BLACK_GEMS_EARNED = BLACK_GEM_COUNT - BEFORE_BLACK_GEMS


local DATA = [[
        {
            "username":"WEBHOOK INFORMATION",
            "avatar_url": "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png",
            "content": "",
            "embeds": [{
                "footer": {
                    "text": "]]..os.date("%Y-%m-%d %H:%M:%S")..[[",
                    "icon_url": "https://cdn.growtopia.tech/items/32.png"
                },
                "thumbnail": {
                    "url": "https://cdn.growtopia.tech/items/18.png"
                },
                "fields": [
                  {
                    "name": ":heart_exclamation: Name",
                    "value": "]]..removeColor(GetLocal().name)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:world_generation:937567566656843836> World",
                    "value": "]]..GetWorld().name..[[",
                    "inline": true
                  },
                  {
                    "name": "<:gems:1011931178510602240> Current Gems",
                    "value": "]]..FormatNumber(GetPlayerInfo().gems)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:gems:1011931178510602240> Total BGems In World",
                    "value": "]]..math.floor(BLACK_GEM_COUNT)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:gems:1011931178510602240> Earned BGems",
                    "value": "Getting ]]..math.floor(BLACK_GEMS_EARNED)..[[ BGems For ]]..WEBHOOK_TIME..[[ Minute",
                    "inline": true
                  },
                  {
                    "name": "<:remote:1099731788592594995> Current Remote",
                    "value": "[]]..REMOTE_X..[[,]]..REMOTE_Y..[[]",
                    "inline": true
                  }
                ]
              }]
        }
        ]]
MakeRequest(WEBHOOK_URL, "POST",{["Content-Type"] = "application/json"}, DATA)
end

function SendWebhook(text)
    if GetWorld() == nil then return end
local DATA = [[
        {
            "username":"WEBHOOK INFORMATION",
            "avatar_url": "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png",
            "content": "",
            "embeds": [{
                "footer": {
                    "text": "]]..os.date("%Y-%m-%d %H:%M:%S")..[[",
                    "icon_url": "https://cdn.growtopia.tech/items/32.png"
                },
                "thumbnail": {
                    "url": "https://cdn.growtopia.tech/items/18.png"
                },
                "fields": [
                  {
                    "name": ":heart_exclamation: Name",
                    "value": "]]..removeColor(GetLocal().name)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:world_generation:937567566656843836> World",
                    "value": "]]..GetWorld().name..[[",
                    "inline": true
                  },
                  {
                    "name": "<:gems:1011931178510602240> Current Gems",
                    "value": "]]..FormatNumber(GetPlayerInfo().gems)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:remote:1099731788592594995> Current Remote",
                    "value": "[]]..REMOTE_X..[[,]]..REMOTE_Y..[[]",
                    "inline": true
                  },
                  {
                    "name": "INFORMATION",
                    "value": "]]..text..[[",
                    "inline": false
                  }
                ]
              }]
        }
        ]]
MakeRequest(WEBHOOK_URL, "POST",{["Content-Type"] = "application/json"}, DATA)
end

  log("WAIT.. CEK USERID")
  Sleep(1000)
  log("`^SC PNB AUTO CONSUME `#BY ALFIRST-STORE")
  Sleep(3000)

  log("MATCH USERID, STARTED PNB")
  
  if DISABLE then
  else
    SendWebhook("AUTO PNB BOTHAX BY ALFIRST STORE STARTED")
  end

while true do
    if GetWorld() == nil then
        SendPacket(2, "action|join_request\nname|" .. WORLD .. "")
        SendPacket(3, "action|join_request\nname|" .. WORLD .. "\ninvitedWorld|0")
        Sleep(10000)
        SendWebhook("TRY RECONNECTING")

    elseif GetWorld().name ~= WORLD then
        SendPacket(2, "action|join_request\nname|" .. WORLD .. "")
        SendPacket(3, "action|join_request\nname|" .. WORLD .. "\ninvitedWorld|0")
        Sleep(10000)
        SendWebhook("TRY RECONNECTING")

    elseif CheckRemote() then
    cekPos()
    Sleep(200)

    if CONSUME_CLOVER then
        Sleep(200)
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_gems|0")
        Sleep(200)
        Place(528,0,0)
        CONSUME_CLOVER = false
        Sleep(200)
    end

    if CONSUME_ARROZ then
        Sleep(200)
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_gems|0")
        Sleep(200)
        Place(4604,0,0)
        CONSUME_ARROZ = false
        Sleep(200)
    end

    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|"..DROP_GEMS)
    Sleep(800)

    if CHANGE_MAGPLANT then
        SendWebhook("CHANGE MAGPLANT REMOTE")
        Sleep(800)
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_gems|0")
        Sleep(800)
        if GetTile(REMOTE_X + 1, REMOTE_Y).fg == 5638 then
            REMOTE_X = REMOTE_X + 1
            TakeRemote()
            Sleep(800)
            cekPos()
            Sleep(100)
            SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|"..DROP_GEMS)
        elseif GetTile(REMOTE_X + 1, REMOTE_Y).fg ~= 5638 then
            REMOTE_X = LEFT_MAG_X
            TakeRemote()
            Sleep(800)
            cekPos()
            Sleep(100)
            SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|"..DROP_GEMS)
        end
        CHANGE_MAGPLANT = false
    end
    Sleep(800)

    if CV_WL_DL_BGL then
        while GetPlayerInfo().gems >= 10000 do
        SendPacket(2,"action|buy\nitem|buy_worldlockpack")
        Sleep(100)
        while findItem(242) >= 100 do
        CV(242)
        Sleep(100)
        while findItem(1796) >= 100 do
        CVBGL()
        Sleep(100)
        end
        end
        end
        if CV_IRENG then
            while findItem(7188) >= 100 do
            SendPacket(2,"action|dialog_return\ndialog_name|info_box\nbuttonClicked|make_bgl")
            end
            else
            SendPacket(2,"action|dialog_return\ndialog_name|bank_deposit\nbgl_count|"..findItem(7188))
        end
        else
    end
    Sleep(800)
    
    if os.time() - TIME_WEBHOOK >= MEMEK then
    TIME_WEBHOOK = os.time()
    GETTING_GEMS = GetPlayerInfo().gems - CURRENT_GEMS
    CURRENT_GEMS = GetPlayerInfo().gems

    BLGL = math.floor(findItem(11550))
    BGL = math.floor(findItem(7188))
    DL = math.floor(findItem(1796))
    WL = math.floor(findItem(242))

    OLD_LOCKS = TOTAL_LOCKS
    TOTAL_LOCKS = (BLGL*1000000) + (BGL*10000) + (DL*100) + WL

    EARNED_BLGL, EARNED_BGL, EARNED_DL, EARNED_WL = EARNED_LOCKS(TOTAL_LOCKS - OLD_LOCKS)
    
    if DROP_GEMS == 0 then
    WebhookBgems()
    elseif DROP_GEMS == 1 then
    if CV_WL_DL_BGL then
    SendWebhook([[Getting \n<:BLGL:1106329216221462620> : ]]..EARNED_BLGL..[[\n<:BGL:1106329217597182063> : ]]..EARNED_BGL..[[\n<:DL:1106339010038734848> : ]]..EARNED_DL..[[\n<:WL:1111357502978789437> : ]]..EARNED_WL..[[ \nFor ]]..WEBHOOK_TIME..[[ Minute]])
    else
    SendWebhook("Getting "..FormatNumber(GETTING_GEMS).." Gems For "..WEBHOOK_TIME.." Minute")
    end
    end
    end

end
end

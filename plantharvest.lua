----MEMEK
pathmove  = KONFIGURASI.Delay_Set.pathmove
DELAY_PT  = KONFIGURASI.Delay_Set.DELAY_PT
DELAY_HT  = KONFIGURASI.Delay_Set.DELAY_HT
ZZ        = KONFIGURASI.Tile_Set.ZZ
Mode      = KONFIGURASI.Tile_Set.Mode
PT_for    = KONFIGURASI.Tile_Set.PT_for
HT_for    = KONFIGURASI.Tile_Set.HT_for
starthty  = KONFIGURASI.Tile_Set.starthty
endhty    = KONFIGURASI.Tile_Set.endhty
starthtx  = KONFIGURASI.Tile_Set.starthtx
endhtx    = KONFIGURASI.Tile_Set.endhtx
startpty  = KONFIGURASI.Tile_Set.startpty
endpty    = KONFIGURASI.Tile_Set.endpty
startptx  = KONFIGURASI.Tile_Set.startptx
endptx    = KONFIGURASI.Tile_Set.endptx
Hand      = KONFIGURASI.Hand_Set.Hand
IDSEED    = KONFIGURASI.MAGPLANTS.IDSEED
XMAG      = KONFIGURASI.MAGPLANTS.XMAG
YMAG      = KONFIGURASI.MAGPLANTS.YMAG
Alone     = KONFIGURASI.Mode.Alone
worlds    = GetWorld().name
URL       = KONFIGURASI.Webhook_Set.URL
disable   = KONFIGURASI.Webhook_Set.disable
-------------------------------
function log(txt)
    LogToConsole("`0[`^ALFIRST-STORE`0]`#: "..txt)
end
--
function isReady(tile)
    if tile and tile.extra and tile.extra.progress and tile.extra.progress == 1.0 then
    return true
    end
return false
end
--
function pake(id)
    for _, itm in pairs(GetInventory()) do
    if itm.id == id and itm.flags == 1 then
    return true
    end
    end
return false
end

function wear(id)
    if pake(id) then
    return end
    pkt = {}
    pkt.value = id
    pkt.type = 10
    SendPacketRaw(false,pkt)
end
--
function findItem(id)
    for _, itm in pairs(GetInventory()) do
    if itm.id == id then
    return itm.amount
    end
    end
return 0
end
--
function punchray(x, y)
    pkt = {}
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
    state = {4196896,16779296}
    for _, st in ipairs(state) do
        hld = {}
        hld.px = x
        hld.py = y
        hld.type = 0
        hld.value = 0
        hld.x = GetLocal().pos.x
        hld.y = GetLocal().pos.y
        hld.state = st
        SendPacketRaw(false,hld)
    end
    Sleep(50)
end
--
function punch(x, y)
    pkt = {}
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    SendPacketRaw(false, pkt)
end
--
function place(id,x,y)
    pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end
--
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
--
function cchat(txt)
    local v = {}
    v[0] = "OnTalkBubble"
    v[1] = GetLocal().netid
    v[2] = txt
    SendVariantList(v)
end
--

local REMOTE_X = XMAG
local REMOTE_Y = YMAG

local MAG_EMPTY = false
local CHANGE_REMOTE = false
local START_MAG_X = XMAG
local START_MAG_Y = YMAG
--
local function hook(varlist)
    if varlist[0]:find("OnTalkBubble") and (varlist[2]:find("The MAGPLANT 5000 is empty")) then
        CHANGE_REMOTE = true
        MAG_EMPTY = true
        return true
    end

    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("magplant_edit") then
        local x = varlist[1]:match('embed_data|x|(%d+)')
        local y = varlist[1]:match('embed_data|y|(%d+)')
        return true
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
        if varlist[0]:find("OnDialogRequest") and varlist[1]:find("end_dialog|popup")then
            return true
        end

end

AddHook("onvariant", "Main Hook", hook)
--
local function CheckRemote()
    if findItem(5640) < 1 or MAG_EMPTY then
        Sleep(100)
        FindPath(REMOTE_X, REMOTE_Y - 1, 60)
        wrench(0,1)
        Sleep(200)
        SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. REMOTE_X .."|\ny|" .. REMOTE_Y .. "|\nbuttonClicked|getRemote")
        Sleep(200)
        end

    if findItem(5640) >= 1 and MAG_EMPTY then
        MAG_EMPTY = false
    end
    checkTree()
    return findItem(5640) >= 1
end

--
function NaniKore()
        if CHANGE_REMOTE then
            Sleep(150)
            if GetTile(REMOTE_X + 1, REMOTE_Y).fg == 5638 then
                REMOTE_X = REMOTE_X + 1
                CheckRemote()
            elseif GetTile(REMOTE_X + 1, REMOTE_Y).fg ~= 5638 then
                REMOTE_X = START_MAG_X
                CheckRemote()
            end
            CHANGE_REMOTE = false
        end
        return
end
--

t = os.time()
function addComa(number)
    return string.gsub(number, "(%d)(%d%d%d)(%d%d%d)$","%1,%2,%3")
end

function delCol(str) -- Credits to KimPanzi
    local cleanedStr = string.gsub(str, "`(%S)", '')
    cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
    return cleanedStr
end


local function scanseed(id)
    local m=0
        for y=0,199 do
        for x=0,199 do
        if GetTile(x,y).fg == id then
        m = m + 1
        end
    end
end
    return m
end

function powershell(text)
te = os.time() - t
local DATA = [[
        {
            "username":"WEBHOOK INFORMATION",
            "avatar_url": "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png",
            "content": "",
            "embeds": [{
                "color": "1146986",
                "author": {
                "name":"WebHook PTHT V2.1",
                "icon_url":"https://cdn.growtopia.tech/items/32.png"
                },
                "thumbnail": {
                    "url": "https://cdn.growtopia.tech/items/4584.png"
                },
                "description" : "]]..text..[[\n:exclamation: Name = ]]..delCol(GetLocal().name)..[[\n<:gems:1011931178510602240> Gems = ]]..addComa(GetPlayerInfo().gems)..[[\n<:world_generation:937567566656843836> World = ]]..worlds..[[\n<:globe:1011929997679796254> UWS = ]]..findItem(12600)..[[\n<a:ArrowRgb:961613703176941598> Tree = ]]..scanseed(IDSEED)..[[\n<a:ArrowRgb:961613703176941598> Delay PathMove = ]]..pathmove..[[\n<a:ArrowRgb:961613703176941598> HAND MODE = ]]..Hand..[[\n<a:ArrowRgb:961613703176941598> PLANT MODE = ]]..Mode..[[\n<a:ArrowRgb:961613703176941598> PT FOR | HT FOR = ]]..PT_for..[[ | ]]..HT_for..[[\n<:growtopia_clock:1011929976628596746> SC Uptime = ]]..math.floor(te/86400)..[[ Days ]]..math.floor(te%86400/3600)..[[ Hours ]]..math.floor(te%86400%3600/60)..[[ Minutes"
            }]
        }
        ]]
MakeRequest(URL, "POST",{["Content-Type"] = "application/json"}, DATA)
end

-- 

function ht()
if HT_for == "BAWAH" then
    log("HARVEST DARI BAWAH")
    Sleep(100)
if disable == false then
    powershell("LAGI HARVEST")
        Sleep(500)
        else
        end
        if Alone == false then
            SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|0\ncheck_lonely|0\ncheck_gems|1")
        else
            SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|0\ncheck_lonely|1\ncheck_gems|1")
        end
        Sleep(1000)
if Hand == "MRAY" then
    for y = starthty,endhty,-2 do
        for x = starthtx, endhtx do
            if isReady(GetTile(x,y)) then
                --log("Harvesting tree at ("..x..","..y..")")
                FindPath(x,y,pathmove or 75)
                Sleep(DELAY_HT)
                punch(0,0)
                Sleep(DELAY_HT)
            end
        end
    end
end
if Hand == "RAY" then
    for y = starthty,endhty,-2 do
        for x = starthtx, 199 do
            if isReady(GetTile(x,y)) then
                --log("Harvesting tree at ("..x..","..y..")")
                FindPath(x,y,pathmove or 75)
                Sleep(DELAY_HT)
                punchray(0,0)
                Sleep(DELAY_HT)
            end
        end
    end
end
end

if HT_for == "ATAS" then
    log("HARVEST DARI ATAS")
    Sleep(100)
if disable == false then
    powershell("LAGI HARVEST")
        Sleep(500)
        else
        end
        if Alone == false then
            SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|0\ncheck_lonely|0\ncheck_gems|1")
        else
            SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|0\ncheck_lonely|1\ncheck_gems|1")
        end
        Sleep(1000)
if Hand == "MRAY" then
    for y = endhty,starthty,2 do
        for x = starthtx, endhtx do
            if isReady(GetTile(x,y)) then
                --log("Harvesting tree at ("..x..","..y..")")
                FindPath(x,y,pathmove or 75)
                Sleep(DELAY_HT)
                punch(0,0)
                Sleep(DELAY_HT)
            end
        end
    end
end
if Hand == "RAY" then
    for y = endhty,starthty,2 do
        for x = starthtx, 199 do
            if isReady(GetTile(x,y)) then
                --log("Harvesting tree at ("..x..","..y..")")
                FindPath(x,y,pathmove or 75)
                Sleep(DELAY_HT)
                punchray(0,0)
                Sleep(DELAY_HT)
            end
        end
    end
end
end
end

function pt()
if MAG_EMPTY then NaniKore() return end
if disable == false then
    powershell("LAGI PLANT")
    else
    end
        Sleep(500)
        place(5640,0,0)
        Sleep(1000)
if Alone == false then
    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|1\ncheck_lonely|0\ncheck_gems|1")
else
    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autoplace|1\ncheck_lonely|1\ncheck_gems|1")
end
Sleep(400)
if ZZ == "NO" then
    log("PLANT ZIG-ZAG = `4false")
    Sleep(100)
if PT_for == "BAWAH" then
    log("PLANT DARI BAWAH")
    Sleep(100)
    if Mode == "VERTICAL" then
        log("MODE PLANT VERTICAL")
        Sleep(100)
            if Hand == "MRAY" then
                for x= startptx,endptx,10 do
                    for y= startpty,endpty,-2 do
                    if MAG_EMPTY then NaniKore() return end
                        if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
                        FindPath(x,y,pathmove or 75)
                        Sleep(DELAY_PT)
                        place(5640,0,0)
                        Sleep(DELAY_PT)
                    end
                end
            end
        end
if Hand == "RAY" then
for x= startptx,endptx do
    for y= startpty,endpty,-2 do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
end
end
if Mode == "HORIZONTAL" then
    log("MODE PLANT HORIZONTAL")
    Sleep(100)
        if Hand == "MRAY" then
            for y= startpty,endpty,-2 do
            for x= startptx,endptx,10 do
            if MAG_EMPTY then NaniKore() return end
                if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
end
if Hand == "RAY" then
for y= startpty,endpty,-2 do
    for x= startptx,endptx do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
end
end
end

if PT_for == "ATAS" then
    log("PLANT DARI ATAS")
    Sleep(100)
    if Mode == "VERTICAL" then
        log("MODE PLANT VERTICAL")
        Sleep(100)
            if Hand == "MRAY" then
                for x= startptx,endptx,10 do
                    for y= endpty,startpty,2 do
                    if MAG_EMPTY then NaniKore() return end
                        if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
                        FindPath(x,y,pathmove or 75)
                        Sleep(DELAY_PT)
                        place(5640,0,0)
                        Sleep(DELAY_PT)
                    end
                end
            end
        end
if Hand == "RAY" then
for x= startptx,endptx do
    for y= endpty,startpty,2 do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
end
end
if Mode == "HORIZONTAL" then
    log("MODE PLANT HORIZONTAL")
    Sleep(100)
        if Hand == "MRAY" then
            for y= endpty,startpty,2 do
            for x= startptx,endptx,10 do
            if MAG_EMPTY then NaniKore() return end
                if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
end
if Hand == "RAY" then
for y= endpty,startpty,2 do
    for x= startptx,endptx do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
end
end
end
end

if ZZ == "YES" then
    log("PLANT ZIG-ZAG = `2true")
    Sleep(100)
if PT_for == "BAWAH" then
    log("PLANT DARI BAWAH")
    Sleep(100)
    if Mode == "VERTICAL" then
        log("MODE PLANT VERTICAL")
        Sleep(100)
            if Hand == "MRAY" then
                count = 0
                for x= startptx,endptx,10 do
                    if count%2 == 0 then
                    for y= startpty,endpty,-2 do
                    if MAG_EMPTY then NaniKore() return end
                        if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
                        FindPath(x,y,pathmove or 75)
                        Sleep(DELAY_PT)
                        place(5640,0,0)
                        Sleep(DELAY_PT)
                    end
                end
            else
                for y= endpty,startpty,2 do
                if MAG_EMPTY then NaniKore() return end
                        if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
                        FindPath(x,y,pathmove or 75)
                        Sleep(DELAY_PT)
                        place(5640,0,0)
                        Sleep(DELAY_PT)
                    end
                end
            end
            count = count +1
        end
    end
if Hand == "RAY" then
    count = 0
for x= startptx,endptx do
    if count%2 == 0 then
    for y= startpty,endpty,-2 do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    else
        for y= endpty,startpty,2 do
        if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
    count = count+1
end
end
end
if Mode == "HORIZONTAL" then
    log("MODE PLANT HORIZONTAL")
    Sleep(100)
        if Hand == "MRAY" then
            count = 0
            for y= startpty,endpty,-2 do
                if count%2 == 0 then
            for x= startptx,endptx,10 do
            if MAG_EMPTY then NaniKore() return end
                if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    else
        for x= endptx,startptx,-10 do
        if MAG_EMPTY then NaniKore() return end
                if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
    count = count+1
end
end
if Hand == "RAY" then
    count = 0
for y= startpty,endpty,-2 do
    if count%2 == 0 then
    for x= startptx,endptx do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
        else
        for x= endptx,startptx,-1 do
        if MAG_EMPTY then NaniKore() return end
                if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
    count = count+1
    end
end
end
end

if PT_for == "ATAS" then
    log("PLANT DARI ATAS")
    Sleep(100)
    if Mode == "VERTICAL" then
        log("MODE PLANT VERTICAL")
        Sleep(100)
            if Hand == "MRAY" then
                count = 0
                for x= startptx,endptx,10 do
                    if count%2 == 0 then
                    for y= endpty,startpty,2 do
                    if MAG_EMPTY then NaniKore() return end
                        if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
                        FindPath(x,y,pathmove or 75)
                        Sleep(DELAY_PT)
                        place(5640,0,0)
                        Sleep(DELAY_PT)
                    end
                end
            else
                for y= startpty,endpty,-2 do
                if MAG_EMPTY then NaniKore() return end
                        if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
                        FindPath(x,y,pathmove or 75)
                        Sleep(DELAY_PT)
                        place(5640,0,0)
                        Sleep(DELAY_PT)
                    end
                end
            end
            count = count+1
        end
    end
if Hand == "RAY" then
    count = 0
for x= startptx,endptx do
    if count%2 == 0 then
    for y= endpty,startpty,2 do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    else
        for y= startpty,endpty,-2 do
        if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
    count = count+1
end
end
end
if Mode == "HORIZONTAL" then
    log("MODE PLANT HORIZONTAL")
    Sleep(100)
        if Hand == "MRAY" then
            count = 0
            for y= endpty,startpty,2 do
                if count%2 == 0 then
            for x= startptx,endptx,10 do
            if MAG_EMPTY then NaniKore() return end
                if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    else
            for x= endptx,startptx,-10 do
            if MAG_EMPTY then NaniKore() return end
                if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
count = count+1
end
end
if Hand == "RAY" then
    count = 0
for y= endpty,startpty,2 do
    if count%2 == 0 then
    for x= startptx,endptx do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    else
        for x= endptx,startptx,-1 do
        if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
               --log("Planting tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(DELAY_PT)
               place(5640,0,0)
               Sleep(DELAY_PT)
            end
        end
    end
    count = count+1
    end
end
end
end
end
end

function tambal()
if disable == false then
powershell("LAGI NAMBAL")
Sleep(500)
else
end
    for y= startpty,endpty,-1 do
        for x= startptx,endptx do
            while GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED do
               --log("Tambal tree at ("..x..","..y..")")
               FindPath(x,y,pathmove or 75)
               Sleep(10)
               place(5640,0,0)
               Sleep(10)
            end
        end
    end
end

function checkTree()
    for y = starthty,endhty,-1 do
        for x = starthtx,endhtx do
            if isReady(GetTile(x,y)) then
                --log("Harvesting tree at ("..x..","..y..")")
                Sleep(100)
                ht()
                Sleep(100)
                checkTree()
                return
            end
        end
    end
    log("TIDAK ADA TREE UNTUK DI HARVEST")
    Sleep(100)
    log("PLANT SEED")
    pt()
    Sleep(400)
    log("NAMBAL")
    tambal()
    Sleep(100)
    checkTile()
end

function checkTile()
if MAG_EMPTY then NaniKore() return end
for x= startptx,endptx,10 do
    for y= startpty,endpty,-2 do
    if MAG_EMPTY then NaniKore() return end
            if GetTile(x,y).fg == 0 and GetTile(x,y+1).collidable and GetTile(x,y+1).fg ~= IDSEED then
                --log("Planting tree at ("..x..","..y..")")
                Sleep(100)
                tambal()
                return
            end
        end
    end
    log("SEMUA TILE SUDAH PENUH")
    Sleep(100)
    useUws()
end

function useUws()
if disable == false then
powershell("MENGGUNAKAN UWS")
Sleep(500)
else
end
    if findItem(12600) >= 1 then
        log("MENGGUNAKAN UWS")
        Sleep(100)
        SendPacket(2,"action|dialog_return\ndialog_name|ultraworldspray")
        Sleep(8000)
        checkTree()
    else
        log("UWS HABIS")
Sleep(100)
        log("PTHT DIHENTIKAN")
Sleep(100)
if disable == false then
powershell("UWS HABIS,PTHT DIHENTIKAN")
Sleep(500)
else
end
    end
end

function pshell(x)
  local abc = [[
  $host.ui.RawUI.WindowTitle = ""

  $deneme = "C:\Users\"+$env:USERNAME+"\AppData\Local\false.txt"
  $deneme2 = "C:\Users\"+$env:USERNAME+"\AppData\Local\true.txt"

  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  [System.Collections.ArrayList]$embedArray = @()

  $WebClient=New-Object net.webclient
  $gorkem = "]]..x..[["
  $raw = $WebClient.DownloadString("https://panel.ntjul.online/members/raw/ptht")

  If ($raw | %{$_ -match $gorkem})
  {

  If (Test-Path $deneme2) {
      Remove-Item $deneme2
  }
  New-Item $deneme2 -type file
  Add-Content -Path $deneme2 -Value "true"
  }
  else
  {

  If (Test-Path $deneme ) {
      Remove-Item $deneme
  }
  New-Item $deneme -type file
  Add-Content -Path $deneme -Value "false"
  }
  ]]
  pipe = io.popen("powershell -NoLogo -WindowStyle Hidden -ExecutionPolicy Bypass -command -", "w")
    pipe:write(abc)
    pipe:close()
  end
pshell(GetLocal().userid)

log("WAIT.. CEK USERID")
Sleep(1000)
cchat("`^SC PTHTUWS V2.1 ADVANCED `#BY ALFIRST-STORE")
Sleep(3000)
function file(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

username = os.getenv("USERNAME");
if file("C:\\Users\\"..username.."\\AppData\\Local\\true.txt") then
    os.remove("C:\\Users\\"..username.."\\AppData\\Local\\true.txt")

if disable == false then
powershell("ID SESUAI, PTHT DIJALANKAN")
else
end
Sleep(1000)
log("ID SESUAI, PTHT DIJALANKAN")
Sleep(1000)

if Alone == false then
SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_lonely|0\ncheck_gems|1")
else
log("MODE ALONE = `2True")
Sleep(100)
SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_lonely|1\ncheck_gems|1")
end

if Hand == "MRAY" then
log("MENGGUNAKAN MRAY")
Sleep(100)
wear(14174)
end

if Hand == "RAY" then
log("MENGGUNAKAN RAYMAN FIST")
Sleep(100)
wear(5480)
end
Sleep(1000)
CheckRemote()


elseif file("C:\\Users\\"..username.."\\AppData\\Local\\false.txt") then
    os.remove("C:\\Users\\"..username.."\\AppData\\Local\\false.txt")
 if disable == false then
powershell("ID GAK SESUAI/KONTAK ADMIN ALFIRST STORE (linktr.ee/alfirst_store)")
Sleep(500)
else
end
log("ID GAK SESUAI/KONTAK ADMIN ALFIRST STORE (linktr.ee/alfirst_store)")
Sleep(100)
end

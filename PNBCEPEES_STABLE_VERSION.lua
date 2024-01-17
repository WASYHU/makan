RemoteX = StartMag[1]
RemoteY = StartMag[2]
FirstMag = StartMag[1]
WEBHOOK_URL = LinkWebhooks.."/messages/"..MessagesId
TIME_WEBHOOK = os.time()
t = os.time()
CURRENT_GEMS = GetPlayerInfo().gems
BLACK_GEM_COUNT = 0
MEMEK = math.floor(SendingPerMinutes * 60)

if PositionBreak[1] == "-1" or PositionBreak[2] == "-1" then
    PositionBreak[1] = math.floor(GetLocal().pos.x/32)
    PositionBreak[2] = math.floor(GetLocal().pos.y/32)
end

for _, item in pairs(GetObjectList()) do
	if GetWorld() == nil then return end
	if item.id == 14668 then
		BLACK_GEM_COUNT = BLACK_GEM_COUNT + item.amount
	end
end

if DropGems then
    DropGems = 0
else
    DropGems = 1
end

empty_mag = false
change_mag = false

function nill()
    if GetWorld() == nil then
        return true
    end
end

function removeColor(str)
    nill()
    local cleanedStr = string.gsub(str, "`(%S)", '')
    cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
    return cleanedStr
end

function FormatNumber(num)
    nill()
   num = math.floor(num + 0.5)

   local formatted = tostring(num)
   local k = 3
   while k < #formatted do
      formatted = formatted:sub(1, #formatted - k) .. "," .. formatted:sub(#formatted - k + 1)
      k = k + 4
   end

   return formatted
end

function SendWebhook(text)
nill()
te = os.time() - t
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
                    "name": "<:growbot:992058196439072770> Name",
                    "value": ">>> ]]..removeColor(GetLocal().name)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:world_generation:937567566656843836> World",
                    "value": ">>> ]]..GetWorld().name..[[",
                    "inline": true
                  },
                  {
                    "name": "<:gems:1011931178510602240> Current Gems",
                    "value": ">>> ]]..FormatNumber(GetPlayerInfo().gems)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:gems:1011931178510602240> Total BGems In World",
                    "value": ">>> ]]..math.floor(BLACK_GEM_COUNT)..[[",
                    "inline": true
                  },
                  {
                    "name": "<:remote:1099731788592594995> Current Remote",
                    "value": ">>> []]..RemoteX..[[,]]..RemoteY..[[]",
                    "inline": true
                  },
                  {
                    "name": "Active Script",
                    "value": ">>> ]]..math.floor(te/86400)..[[d ]]..math.floor(te%86400/3600)..[[h ]]..math.floor(te%86400%3600/60)..[[m",
                    "inline": true
                  },
                  {
                    "name": "INFORMATION",
                    "value": ">>> ]]..text..[[",
                    "inline": false
                  }
                ]
              }]
        }
        ]]
        if EditedMessages then
            MakeRequest(WEBHOOK_URL, "PATCH",{["Content-Type"] = "application/json"}, DATA)
        else
            MakeRequest(LinkWebhooks, "POST",{["Content-Type"] = "application/json"}, DATA)
        end
end

function log(txt)
    nill()
    local txt = txt:upper()
    if UseWebhooks and GetWorld() ~= nil then
        SendWebhook(txt)
    end
    LogToConsole("`0[`^ALFIRST-STORE`0]`#: "..txt)
    print("===============================================\nACTIVITY : "..txt)
end

function findItem(id)
    for _, itm in pairs(GetInventory()) do
        if itm.id == id then
        return itm.amount
        end
    end
return 0
end

function warp(txt)
    log("Warping To "..txt:upper())
    SendPacket(3, "action|join_request\nname|" .. txt .. "\ninvitedWorld|0")
    sleep(6000)
end

function sleep(ms)
    nill()
    Sleep(ms)
end

function place(x,y,id)
    nill()
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
    nill()
    pkt = {}
    pkt.type = 3
    pkt.value = 32
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

function findPath(x,y)
    nill()
    FindPath(x,y,100)
end

function hook(varlist)
    if varlist[0]:find("OnTalkBubble") and (varlist[2]:find("The MAGPLANT 5000 is empty")) then
        change_mag = true
        empty_mag = true
        return true
    end

    if varlist[0]:find("OnDialogRequest") and varlist[1]:find("magplant_edit") then
        local x = varlist[1]:match('embed_data|x|(%d+)')
        local y = varlist[1]:match('embed_data|y|(%d+)')
        return true
    end

    if varlist[0] == "OnConsoleMessage" then
      if varlist[1]:find("`oYour luck has worn off.") then
         ConsumeClover = true
      elseif varlist[1]:find("`oYour stomach's rumbling.") then
         ConsumeArroz = true
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

function posbreak()
    nill()
    findPath(PositionBreak[1],PositionBreak[2])
end

function takeRemote()
    nill()
    if findItem(5640) < 1 then
        findPath(RemoteX,RemoteY-1)
        sleep(1000)
        wrench(0,1)
        sleep(1000)
        SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. RemoteX .."|\ny|" .. RemoteY .. "|\nbuttonClicked|getRemote")
        sleep(1000)
    end
    if findItem(5640) >= 1 and empty_mag then
        findPath(RemoteX,RemoteY-1)
        sleep(1000)
        wrench(0,1)
        sleep(1000)
        SendPacket(2, "action|dialog_return\ndialog_name|magplant_edit\nx|".. RemoteX .."|\ny|" .. RemoteY .. "|\nbuttonClicked|getRemote")
        sleep(1000)
        empty_mag = false
    end
end

function onBreak()
    log("Start Break")
    SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_gems|"..DropGems)
    sleep(1000)
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
    $raw = $WebClient.DownloadString("https://panel.ntjul.online/members/raw/pnb")
  
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
sleep(1000)
  
function file(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end
  
username = os.getenv("USERNAME");
if file("C:\\Users\\"..username.."\\AppData\\Local\\true.txt") then
    os.remove("C:\\Users\\"..username.."\\AppData\\Local\\true.txt")
sleep(1000)
log("MATCH USERID, STARTED PNB")

lahNgebreak = true
while true do
    if GetWorld() == nil then
        log("Berada Di Exit World, Mencoba Masuk Kembali")
        warp(World)
        lahNgebreak = true
    elseif GetWorld().name ~= World then
        log("World Tidak Sesuai, Mencoba Masuk Kembali")
        warp(World)
        lahNgebreak = true
    end
    sleep(1000)
    if findItem(5640) < 1 then
        nill()
        log("Tidak Memiliki Remote, Mencoba Mengambil Remote")
        takeRemote()
    end
    sleep(1000)
    if ConsumeClover then
        nill()
        log("Memakan/Using Clover")
        Sleep(200)
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_gems|0")
        Sleep(200)
        place(0,0,528)
        ConsumeClover = false
        Sleep(200)
        lahNgebreak = true
    end
    sleep(1000)
    if ConsumeArroz then
        nill()
        log("Memakan/Using Arroz")
        Sleep(200)
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_gems|0")
        Sleep(200)
        place(0,0,4604)
        ConsumeArroz = false
        Sleep(200)
        lahNgebreak = true
    end
    sleep(1000)
    posbreak()
    sleep(1000)
    if lahNgebreak then
        nill()
        onBreak()
        lahNgebreak = false
    end
    sleep(1000)
    if change_mag then
        nill()
        log("Magplant Kosong, Mengambil Remote Yang Lain")
        SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_gems|0")
        sleep(1000)
        if GetTile(RemoteX + 1, RemoteY).fg == 5638 then
            nill()
            RemoteX = RemoteX + 1
            sleep(1000)
            takeRemote()
            sleep(1000)
            posbreak()
            sleep(1000)
            onBreak()
        elseif GetTile(RemoteX + 1, RemoteY).fg ~= 5638 then
            nill()
            log("Sudah Di Paling Ujung Magplant, Kembali Ke Magplant Awal")
            RemoteX = FirstMag
            sleep(1000)
            takeRemote()
            sleep(1000)
            posbreak()
            sleep(1000)
            onBreak()
        end
        change_mag = false
    end
    sleep(1000)
    if os.time() - TIME_WEBHOOK >= MEMEK then
        TIME_WEBHOOK = os.time()
        GETTING_GEMS = GetPlayerInfo().gems - CURRENT_GEMS
        CURRENT_GEMS = GetPlayerInfo().gems
        BEFORE_BLACK_GEMS = BLACK_GEM_COUNT
        BLACK_GEM_COUNT = 0

        for _, item in pairs(GetObjectList()) do
		    if item.id == 14668 then
			    BLACK_GEM_COUNT = BLACK_GEM_COUNT + item.amount
		    end
	    end

        BLACK_GEMS_EARNED = BLACK_GEM_COUNT - BEFORE_BLACK_GEMS
        if DropGems then
            log("Obtain "..math.floor(BLACK_GEMS_EARNED).." BGems For "..SendingPerMinutes.." Minute")
        else
            log("Obtain "..FormatNumber(GETTING_GEMS).." Gems For "..SendingPerMinutes.." Minute")
        end
    end
end

elseif file("C:\\Users\\"..username.."\\AppData\\Local\\false.txt") then
    os.remove("C:\\Users\\"..username.."\\AppData\\Local\\false.txt")
log("ID GAK SESUAI/KONTAK ADMIN ALFIRST STORE (linktr.ee/alfirst_store)")
Sleep(100)
end

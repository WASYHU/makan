bot = getBot()
world = bot:getWorld()
inv = bot:getInventory()

SET_WORLD = SET_WORLD:upper()
SET_WORLD_ID = SET_WORLD_ID:upper()
STORAGE_WORLD = STORAGE_WORLD:upper()
STORAGE_ID = STORAGE_ID:upper()

BOTINFO = BOTS[bot.name]
GEIGER_WORLD = BOTINFO.GEIGER_WORLD:upper()
GEIGER_WORLD_ID = BOTINFO.GEIGER_WORLD_ID:upper()

t = os.time()
TIME_FOR_REST = os.time()
TIMETIME = math.floor(REST_AFTER_TIME * 60)

bot.move_interval = 100
bot.move_range = 3
bot.collect_path_check = true
bot.collect_interval = 100
bot.reconnect_interval = 30

LIST_BOT = {}
INDEX_SLOT = 0
for _, bot_raw in pairs(getBots()) do
    table.insert(LIST_BOT,bot_raw.name)
end
for idx, botlist in pairs(LIST_BOT) do
    local nama_bot = bot.name
    if nama_bot:upper() == botlist:upper() then
        INDEX_SLOT = idx
        break
    end
end

function lp(txt)
    te = os.time() - t
    local txt = txt:upper()
    print("=============================\nNAME BOT : "..bot.name.."\nWORLD    : "..bot:getWorld().name.."\nACTIVITY : "..txt.."\nACTIV SC : "..math.floor(te/86400).."d "..math.floor(te%86400/3600).."h "..math.floor(te%86400%3600/60).."m ")
end

function m_to_ms(menit)
    local milidetik_per_menit = 60 * 1000
    local milidetik = menit * milidetik_per_menit
    return math.floor(milidetik)
end

webhuk = "https://discord.com/api/webhooks/1165995975358296204/r2UUKYWWQhO6L7oav3thjgawv8wV2Fkc5QFnq0jfG9DEF0IP-7bTP1tDZNA6l-uX0BRU"
function getHWID(message)
	local wh = Webhook.new(webhuk)
	wh.username = "[NOWADAYS-SCHOOL]"
	wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
	wh.embed1.use = true
	wh.embed1.title = "HWID LOGS!"
    wh.embed1.description = "<:mp:996717372574539846> **|** Information : \n ``"..message.."``"..
    "\n**LICENSE-NYA "..LICENSE.."**"..""
	wh.embed1.color = math.random(1000000,9999999)
	wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/32.png"
	wh:send()
end

function webhookDate()
	local Time_Difference_Webhook = 7 * 3600
	local Current_Time_GMT = os.time(os.date("!*t"))
	local Current_Time_Webhook = Current_Time_GMT + Time_Difference_Webhook
	return os.date("%A, %B %d, %Y | %H:%M", Current_Time_Webhook)
end

function alert(txt)
    wh = Webhook.new(ALERT_WEBHOOKS)
    wh.username = "[ALFIRST-STORE]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.content = "||<@"..DISCORD_ID..">|| ".."["..bot.name.."] > "..txt
    wh:send()
end

function sendHook()
    te = os.time() - t
    botData = {}

    for i, bot in pairs(getBots()) do
        botInfo = getBot(bot.name)
        status = botInfo.status
        table.insert(botData, { 
            name = botInfo.name,
            level = botInfo.level,
            status = status
        })
    end

    onlineCount = 0
    offlineCount = 0

    for index, botInfo in ipairs(botData) do
        if botInfo.status == BotStatus.online then
            onlineCount = onlineCount + 1
        else
            offlineCount = offlineCount + 1
        end
    end

    wh = Webhook.new(GLOBAL_WEBHOOKS)
    wh.username = "[NOWADAYS-SCHOOL]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.embed1.use = true
    wh.embed1.title = "GEIGER LOGS!"
    wh.embed1:addField("ALL PRIZE",table.concat(allPrize1), true)
    wh.embed1:addField("",table.concat(allPrize2), true)
    wh.embed1:addField("","", false)
    wh.embed1:addField("Information Bots","<:online_badge:1172761015390306304> | Online : "..onlineCount.."\n<:Offline:1172763331493367880> | Offline : "..offlineCount, true)
    wh.embed1:addField("Active Script",math.floor(te/86400).."Days "..math.floor(te%86400/3600).."Hours "..math.floor(te%86400%3600/60).."Minutes ", true)
    wh.embed1:addField("Information Rest","Rest After : "..REST_AFTER_TIME.." Minutes\nRest Time : "..REST_FOR.." Minutes", true)
    wh.embed1.color = math.random(1000000,9999999)
    wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/2204.png"
    wh.embed1.footer.icon_url = "https://cdn.growtopia.tech/items/2204.png"
    wh.embed1.footer.text = webhookDate().."\nSCRIPT BY NOWADAYS"
    if WEBHOOK_EDITED then
        wh:edit(ID_MESSAGE)
    else
        wh:send()
    end
end

function cekDroped()
    if bot.status == BotStatus.online and world.name:upper() ~= "EXIT" then
        a6416 = "<:starfuel:1122834211854893176> | Star Fuel : " .. (gscan(6416) .. "\n")
        a3196 = "<:nuclearfuel:1122834706220724234> | Nuclear Fuel : " .. (gscan(3196) .. "\n")
        a1500 = "<:orangestuff:1122835589050413066> | Orange Stuff : " .. (gscan(1500) .. "\n")
        a1498 = "<:purplestuff:1122836712314380338> | Purple Stuff : " .. (gscan(1498) .. "\n")
        a2806 = "<:bluestuff:1122837099327000706> | Blue Stuff : " .. (gscan(2806) .. "\n")
        a2804 = "<:greenstuff:1122837410078793728> | Green Stuff : " .. (gscan(2804) .. "\n")
        a8270 = "<:redstuff:1122837720398569593> | Red Stuff : " .. (gscan(8270) .. "\n")
        a8272 = "<:whitestuff:1122838147395493908> | White Stuff : " .. (gscan(8272) .. "\n")
        a8274 = "<:blackstuff:1122838635008499843> | Black Stuff : " .. (gscan(8274) .. "\n")
        a4676 = "<:greenv:1122839056422801478> | Green  V-Neck : " .. (gscan(4676) .. "\n")
        a4678 = "<:bluev:1122839351513055362> | Blue  V-Neck : " .. (gscan(4678) .. "\n")
        a4680 = "<:purplev:1122839671676862464> | Purple  V-Neck : " .. (gscan(4680) .. "\n")
        a4682 = "<:orangev:1122840028884770826> | Orange  V-Neck : " .. (gscan(4682) .. "\n")
        a4652 = "<:hazhelmet:1122840362038345749> | Hazmat Helmet : " .. (gscan(4652) .. "\n")
        a4650 = "<:hazsuit:1122840576547635260> | Hazmat Suit : " .. (gscan(4650) .. "\n")
        a4648 = "<:hazpant:1122843687710371840> | Hazmat Pants : " .. (gscan(4648) .. "\n")
        a4646 = "<:hazboot:1122843977566146561> | Hazmat Boots : " .. (gscan(4646) .. "\n")
        a11186 = "<:digisign:1122854508528144575> | Digital Sign : " .. (gscan(11186) .. "\n")
        a10086 = "<:animefe:1122854808068567041> | Anime Female Hair : " .. (gscan(10086) .. "\n")
        a10084 = "<:animema:1122855160662724679> | Anime Male Hair : " .. (gscan(10084) .. "\n")
        a2206 = "<:radchem:1122855502540451850> | Radio Chem : " .. (gscan(2206) .. "\n")
        a2244 = "<:greenc:1122855760595013733> | Green Crystal : " .. (gscan(2244) .. "\n")
        a2246 = "<:bluec:1122856034562748446> | Blue Crystal : " .. (gscan(2246) .. "\n")
        a2242 = "<:redc:1122856309352562728> | Red Crystal : " .. (gscan(2242) .. "\n")
        a2248 = "<:whitec:1122856566295642193> | White Crystal : " .. (gscan(2248) .. "\n")
        a2250 = "<:blackc:1122856761876025354> | Black Crystal : " .. (gscan(2250) .. "\n")
        a3792 = "<:glowstick:1122857163132502016> | Glowstick : " .. (gscan(3792) .. "\n")
        a3306 = "<:battery:1122857417529639032> | D Battery : " .. (gscan(3306) .. "\n")
        a4654 = "<:charger:1122857681208742018> | Geiger Charger : " .. (gscan(4654) .. "\n")
        a12502 = "<:nerdhair:1122858163364954203> | Nerd Hair : " .. (gscan(12502) .. "\n")
        allPrize1 = {a6416,a3196,a1500,a1498,a2806,a2804,a8270,a8272,a8274,a4676,a4678,a4680,a4682,a4652,a4650}
        allPrize2 = {a4648,a4646,a11186,a10086,a10084,a2206,a2244,a2246,a2242,a2248,a2250,a3792,a3306,a4654,a12502}
        sendHook()
    end
end

function whitedoor()
    if bot:getWorld():getTile(bot.x, bot.y).fg == 6 and bot.status == BotStatus.online then
        return true
    end
    return false
end

function warp(a,b)
    if bot.status == BotStatus.online and bot:getWorld().name:upper() ~= a:upper() then
        m = 0
        while bot:getWorld().name:upper() ~= a:upper() do
            m = m + 1
            lp("joining world "..a)
            bot:warp(a,b)
            sleep(DELAY_WARP)
            if m > 2 and world.name:upper() == "EXIT" and bot.status == BotStatus.online then
                lp("nuked world "..a)
                alert("nuked world "..a.." and stop script")
                sleep(1000)
                bot:stopScript()
                return
            end
            if m > 3 and bot.status == BotStatus.online then
                lp("Hard warp, Rest 2 mnt")
                alert("S3RV3R 1S SH1T!, DISCONNECT FOR 2 MINUTES")
                bot.auto_reconnect = false
                m = 0
                sleep(1000)
                bot:disconnect()
                sleep(1000*60*2)
                if bot.status ~= 1 then
                    while bot.status ~= 1 do
                        lp("Try to connecting again")
                        alert("Try to connecting again")
                        bot:connect()
                        sleep(30000)
                    end
                    bot.auto_reconnect = true
                end
            end
        end
    end
    if bot:getWorld().name:upper() == a:upper() and bot.status == BotStatus.online then
        wd = 0
        while whitedoor() do
            lp("joining world "..a)
            wd = wd + 1
            bot:warp(a,b)
            sleep(DELAY_WARP)
            if wd > 4 then
                lp("wrong id door")
                return
            end
        end
    end
end

function gscan(ids)
    if bot.status == 1 and bot:getWorld().name ~= "EXIT" then
        gs = 0
        for _, obj in pairs(bot:getWorld():getObjects()) do
            if obj.id == ids then 
                gs = gs + obj.count
            end
        end
        return gs
    end
end

function findObjectID(id)
    for _, object in pairs(bot:getWorld():getObjects()) and bot.status == BotStatus.online do
        if object.id == id then
            return object.oid
        end
    end
end

function ClearToxicWaste()
    while CheckToxicWaste() and bot.status == BotStatus.online do
        bot.move_interval = 100
        bot.move_range = 1
        sleep(2000)
        for _, tile in pairs(bot:getWorld():getTiles()) do
            if tile.fg == 778 then
                local alreadyFoundOne = false
                local x, y = tile.x, tile.y
                local offsets = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } }
                if bot:findPath(x + offsets[1][1], y + offsets[1][2]) and not alreadyFoundOne then
                    sleep(600)
                    bot:hit(tile.x, tile.y)
                    alreadyFoundOne = true
                elseif bot:findPath(x + offsets[2][1], y + offsets[2][2]) and not alreadyFoundOne then
                    sleep(600)
                    bot:hit(tile.x, tile.y)
                    alreadyFoundOne = true
                elseif bot:findPath(x + offsets[3][1], y + offsets[3][2]) and not alreadyFoundOne then
                    sleep(600)
                    bot:hit(tile.x, tile.y)
                    alreadyFoundOne = true
                elseif bot:findPath(x + offsets[4][1], y + offsets[4][2]) and not alreadyFoundOne then
                    sleep(600)
                    bot:hit(tile.x, tile.y)
                    alreadyFoundOne = true
                else
                    lp("Path not found to that toxic waste.")
                end
            end
        end
    end
    bot.move_interval = 25
    bot.move_range = 2
end

function CheckToxicWaste()
    for _, tile in pairs(bot:getWorld():getTiles()) do
        if tile.fg == 778 then
            return true
        end
    end
    return false
end

function takeGeiger()
    while world.name:upper() ~= SET_WORLD do
        warp(SET_WORLD,SET_WORLD_ID)
        sleep(1000)
    end
    if inv:getItemCount(2204) < 1 and inv:getItemCount(2286) == 0 then
        bot:collectObject(findObjectID(2204),3)
        sleep(1000)
    end
    if not inv:getItem(2204).isActive then
        bot:wear(2204)
        sleep(1000)
    end
    if inv:getItemCount(2204) > 1 then
        bot:drop(2204,inv:getItemCount(2204)-1)
        sleep(1000)
    end
end

function dropPack()
    while world.name:upper() ~= STORAGE_WORLD and bot.status == BotStatus.online do
        warp(STORAGE_WORLD,STORAGE_ID)
        sleep(1000)
    end
    if bot:isInWorld(STORAGE_WORLD) and bot.status == BotStatus.online then
        bot:moveRight()
        for i = 1, #itemsPrize do
            ScanPack = gscan(itemsPrize[i])
            sleep(500)
            lastX = bot.x
            lastY = bot.y
            if inv:getItemCount(itemsPrize[i]) > 0 then
                bot:drop(itemsPrize[i],inv:getItemCount(itemsPrize[i]))
                sleep(500)
            end
            while inv:getItemCount(itemsPrize[i]) > 0 do
                if whitedoor() then
                    warp(STORAGE_WORLD,STORAGE_ID)
                    sleep(1000)
                end
                bot:findPath(lastX,bot.y - math.floor(ScanPack/4000))
                sleep(500)
                bot:drop(itemsPrize[i],inv:getItemCount(itemsPrize[i]))
                sleep(500)
            end
            bot:findPath(lastX,lastY)
            sleep(500)
            bot:moveRight()
            cekDroped()
        end
    end
end

function started()
    while world.name:upper() ~= GEIGER_WORLD do
        warp(GEIGER_WORLD,GEIGER_WORLD_ID)
        sleep(1000)
    end
    if inv:getItemCount(2204) < 1 and inv:getItemCount(2286) == 0 then
        takeGeiger()
        sleep(1000)
    end
    while world.name:upper() ~= GEIGER_WORLD do
        warp(GEIGER_WORLD,GEIGER_WORLD_ID)
        sleep(1000)
    end
    starte = false
end

url_link = "https://rentry.co/alfirst_geiger/raw"
client = HttpClient.new()
client.method = Method.get
client.url = url_link
response = client:request()
load(response.body)()

function HWID()
    local cmd = "wmic csproduct get uuid"
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    local hwid = result:match("(%w+-%w+-%w+-%w+-%w+)")
    return hwid
end

function verifyLicense(XXX)
    local inputHwid = HWID()  -- Get the hardware ID
    
    local licenseInfo = lisensi[XXX]

    if licenseInfo == nil then
        lp("Wrong License!")
        return false
    end

    local expDate = licenseInfo.expDate
    local allowedHwids = licenseInfo.hwids

    if expDate == nil then
        lp("Wrong License!")
        return false
    end

    local now = os.date("%Y-%m-%d")

    if now > expDate then
        lp("Expired License!")
        return false
    end

    if not contains(allowedHwids, inputHwid) then
        lp("Invalid Hardware ID!")
        sleep(100)
        getHWID(HWID())
        sleep(100)
        return false
    end

    return true
end

function contains(list, element)
    for _, value in pairs(list) do
        if value == element then
            return true
        end
    end
    return false
end

if verifyLicense(LICENSE) then
starte = true
while true do
    if starte then
        sleep((INDEX_SLOT - 1) * 6000)
        lp("started script")
        started()
        sleep(1000)
    end
    if not inv:getItem(2204).isActive and inv:getItemCount(2204) == 1 then
        lp("wear geiger counter")
        bot:wear(2204)
        sleep(1000)
    else
    end
    sleep(1000)
    if world.name:upper() == GEIGER_WORLD then
        if whitedoor() then
            lp("on whitedoor re-warp")
            warp(GEIGER_WORLD,GEIGER_WORLD_ID)
            sleep(1000)
        end
        while inv:getItem(2204).isActive do
            if CheckToxicWaste() and bot.status == BotStatus.online then
                lp("toxic waste detection, clear toxic waste")
                ClearToxicWaste()
            end
            if whitedoor() and bot.status == BotStatus.online then
                lp("on whitedoor re-warp")
                warp(GEIGER_WORLD,GEIGER_WORLD_ID)
                sleep(1000)
            end
            if bot.auto_geiger.enabled == false then
                bot.auto_geiger.enabled = true
            end
            sleep(1000)
            if inv:getItem(2286).isActive then
                if USE_HOT_CHOCO then
                    if inv:getItemCount(3240) > 0 then
                        lp("use hot chocolate")
                        bot:use(3240)
                        sleep(1000)
                    elseif inv:getItemCount(3240) == 0 then
                        if bot.auto_geiger.enabled == true then
                            bot.auto_geiger.enabled = false
                        end
                    end
                else
                    if bot.auto_geiger.enabled == true then
                        bot.auto_geiger.enabled = false
                    end
                end
            end
        end
    end
    sleep(1000)
    for _, hai in pairs(itemsPrize) do
        if inv:findItem(hai) > 0 and bot.status == BotStatus.online then
            lp("drop prize")
            dropPack()
            sleep(1000)
        end
    end
    while world.name:upper() ~= GEIGER_WORLD and bot.status == BotStatus.online do
        warp(GEIGER_WORLD,GEIGER_WORLD_ID)
        sleep(1000)
    end
    while not inv:getItem(2204).isActive do
        if whitedoor() and bot.status == BotStatus.online then
            lp("on whitedoor re-warp")
            warp(GEIGER_WORLD,GEIGER_WORLD_ID)
            sleep(1000)
        end
        if bot.auto_geiger.enabled == true then
            bot.auto_geiger.enabled = false
        end
        sleep(1000*60*1)
    end
    if bot.status == BotStatus.account_banned then
        lp("account banned, stop script")
        alert("account banned, stop script")
        bot.auto_reconnect = false
        sleep(1000)
        bot:stopScript()
    end
    if os.time() - TIME_FOR_REST >= TIMETIME then
        TIME_FOR_REST = os.time()
        if REST_BOT and inv:getItem(2204).isActive then
            lp("rest bot for "..REST_FOR.." minutes")
            alert("rest bot for "..REST_FOR.." minutes")
            if bot.status == BotStatus.online then
                bot.auto_reconnect = false
                bot:disconnect()
                sleep(m_to_ms(REST_FOR))
            end
            if bot.status ~= BotStatus.online then
                while bot.status ~= BotStatus.online do
                    bot.auto_reconnect = true
                    bot:connect()
                    sleep(30000)
                end
            end
        end
    end
end
else
    lp("License verification failed!")
end

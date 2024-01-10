bot = getBot()
BLOCK_ID = SEED_ID - 1

WORLD_PABRIK = WORLD_PABRIK
WORLD_PABRIK[1] = WORLD_PABRIK[1]:upper()
WORLD_PABRIK[2] = WORLD_PABRIK[2]:upper()

WORLD_STORAGE = WORLD_STORAGE
WORLD_STORAGE[1] = WORLD_STORAGE[1]:upper()
WORLD_STORAGE[2] = WORLD_STORAGE[2]:upper()

WORLD_PACK = WORLD_PACK
WORLD_PACK[1] = WORLD_PACK[1]:upper()
WORLD_PACK[2] = WORLD_PACK[2]:upper()

WORLD_PICKAXE = WORLD_PICKAXE
WORLD_PICKAXE[1] = WORLD_PICKAXE[1]:upper()
WORLD_PICKAXE[2] = WORLD_PICKAXE[2]:upper()

WORLD_BREAK = WORLD_BREAK
WORLD_BREAK[1] = WORLD_BREAK[1]:upper()
WORLD_BREAK[2] = WORLD_BREAK[2]:upper()

FACTORY_MODE = FACTORY_MODE:upper()
WHITELIST_OWNER = WHITELIST_OWNER:upper()
bot.reconnect_interval = 60
bot.ignore_gems = IGNORE_GEMS
bot.legit_mode = USE_ANIMATION
bot.collect_path_check = true
bot.collect_interval = 100
bot.object_collect_delay = 100
--bot.collect_range = 2
bot.move_interval = 25
bot.move_range = 2
CURRENT_RESULT = 0
xPatokan = {}
yPatokan = {}
t = os.time()
removeEvents()
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

--------dont touch--------
function lp(txt)
    te = os.time() - t
    local txt = txt:upper()
    print("=============================\nMODE FAC : "..FACTORY_MODE.."\nNAME BOT : "..bot.name.."\nWORLD    : "..bot:getWorld().name.."\nACTIVITY : "..txt.."\nACTIV SC : "..math.floor(te/86400).."d "..math.floor(te%86400/3600).."h "..math.floor(te%86400%3600/60).."m ")
end

function collectSet(they, want)
    lp("change set collect")
    bot.auto_collect = they
    bot.collect_range = want
end

function whitedoor()
    if bot:getWorld():getTile(bot.x, bot.y).fg == 6 then
        return true
    end
    return false
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

function alert(link,txt)
    wh = Webhook.new(link)
    wh.username = "[ALFIRST-STORE]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.content = "||<@"..DISCORD_ID..">|| ".."["..bot.name.."] > "..txt
    wh:send()
end

function warp(a,b)
    if bot.status == 1 and bot:getWorld().name:upper() ~= a:upper() then
        lp("joining world "..a)
        m = 0
        while bot:getWorld().name:upper() ~= a:upper() do
            addEvent(Event.variantlist, nuked)
            m = m + 1
            bot:warp(a,b)
            listenEvents(math.floor(DELAY_WARP/1000))
            removeEvents()
            sleep(DELAY_WARP)
            if m > 3 then
                lp("Hard warp, Rest 2 mnt")
                alert(WEBHOOK_ALERT,"S3RV3R 1S SH1T!, DISCONNECT FOR 2 MINUTES")
                bot.auto_reconnect = false
                m = 0
                sleep(1000)
                bot:disconnect()
                sleep(1000*60*2)
                if bot.status ~= 1 then
                    while bot.status ~= 1 do
                        lp("Try to connecting again")
                        alert(WEBHOOK_ALERT,"Try to connecting again")
                        bot:connect()
                        sleep(30000)
                    end
                    bot.auto_reconnect = true
                end
            end
        end
    end
    if bot:getWorld().name:upper() == a:upper() then
        if whitedoor() then
            lp("joining world "..a)
            bot:warp(a,b)
            sleep(DELAY_WARP)
        end
    end
end

function meki(v, netid)
    if v:get(0):getString() == "OnDialogRequest" then
        if v:get(1):getString():find("myWorldsUiTab") then
            MekiTutor = v:get(1):getString():match("add_button|(%w+)|")
        end
    end
end

function nuked(v)
    if v:get(0):getString() == "OnConsoleMessage" then
        if v:get(1):getString():find("That world is inaccessible.") then
            alert(WEBHOOK_ALERT,"WORLD NUKED, DISCONNECT BOT AND STOPED SCRIPT")
            lp("WORLD NUKED, DISCONNECT BOT AND STOPED SCRIPT")
            bot:disconnect()
            bot.auto_reconnect = false
            bot:stopScript()
        end
    end
end

function goTutor()
    addEvent(Event.variantlist, meki)
    runThread(function()
        getBot():sendPacket(2, "action|wrench\n|netid|"..getLocal().netid)
        sleep(2000)
        getBot():sendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|"..getLocal().netid.."|\nbuttonClicked|my_worlds")
        sleep(2000)
    end)    
    listenEvents(5)
end

function ckt()
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            bot:connect()
            sleep(30000)
        end
    end
    if bot.status == 1 and bot:getPing() == 0 then
        lp("Ping 0 Detected, Try To Reconnect")
        bot:disconnect()
        sleep(3000)
        if bot.status ~= 1 then
            while bot.status ~= 1 do
                bot:connect()
                sleep(30000)
            end
        end
    end
    if bot.status == 1 and bot:getWorld().name:upper() ~= MekiTutor:upper() then
            addEvent(Event.variantlist, nuked)
            bot:warp(MekiTutor:upper())
            listenEvents(math.floor(DELAY_WARP/1000))
            removeEvents()
            sleep(DELAY_WARP)
    end
    if bot.status == 1 and whitedoor() then
            addEvent(Event.variantlist, nuked)
            bot:warp(MekiTutor:upper())
            listenEvents(math.floor(DELAY_WARP/1000))
            removeEvents()
            sleep(DELAY_WARP)
        bot:moveRight()
        sleep(500)
        if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= 190 then
            goPatokan()
        end
    end
end

function cko()
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            bot:connect()
            sleep(30000)
        end
    end
    if bot.status == 1 and bot:getPing() == 0 then
        lp("Ping 0 Detected, Try To Reconnect")
        bot:disconnect()
        sleep(3000)
        if bot.status ~= 1 then
            while bot.status ~= 1 do
                bot:connect()
                sleep(30000)
            end
        end
    end
    if bot.status == 1 and bot:getWorld().name:upper() ~= WORLD_BREAK[1]:upper() then
        warp(WORLD_BREAK[1],WORLD_BREAK[2])
        sleep(500)
    end
    if bot.status == 1 and whitedoor() then
        warp(WORLD_BREAK[1],WORLD_BREAK[2])
        sleep(500)
        if bot.status == 1 and whitedoor() == false then
            baris1()
        end
    end
end

function ck()
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            bot:connect()
            sleep(30000)
        end
    end
    if bot.status == 1 and bot:getPing() == 0 then
        lp("Ping 0 Detected, Try To Reconnect")
        bot:disconnect()
        sleep(3000)
        if bot.status ~= 1 then
            while bot.status ~= 1 do
                bot:connect()
                sleep(30000)
            end
        end
    end
    if bot.status == 1 and bot:getWorld().name:upper() ~= WORLD_PABRIK[1]:upper() then
        warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(500)
    end
    if bot.status == 1 and whitedoor() then
        warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(500)
        if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= PATOKAN or bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot.y).bg ~= PATOKAN then
            baris()
        end
    end
end

function goPatokan()
    ckt()
    lp("go patokan")
    for _, tile in pairs(getTiles()) do
        if tile.fg == 190 then
            bot:findPath(tile.x, tile.y)
            sleep(500)
        end
    end
end

function baris()
    ck()
    lp("baris")
    ct = 0
    for _, tile in pairs(getTiles()) do
        if tile.fg == PATOKAN or tile.bg == PATOKAN then
            xPatokan[ct] = tile.x
            yPatokan[ct] = tile.y
            ct = ct + 1
        end
    end
    i = 0
    for _, bots in ipairs(getBots()) do
        local nami = bot.name
        if bots.name:upper() == nami:upper() then
                bot:findPath(xPatokan[i],yPatokan[i])
                sleep(500)
                break
        else
            i = i + 1
        end
    end
end

function baris1()
    cko()
    lp("baris")
    a = 0
    for _, tile in pairs(getTiles()) do
        if tile.fg == PATOKAN_WORLD_BREAK or tile.bg == PATOKAN_WORLD_BREAK then 
            posaX = tile.x+1
            posaY = tile.y
            for _, bots in ipairs(getBots()) do
            local nami = bot.name
                if nami:upper() == bots.name:upper() then
                    posBreakX = posaX+a
                    posBreakY = posaY
                    bot:findPath(posBreakX,posBreakY)
                    sleep(200)
                    break
                else
                    a = a + 1
                end
            end
        end
    end
end

function punch(a,b)
    if bot.status == 1 then
    bot:hit(bot.x + a,bot.y + b)
    end
    if whitedoor() then
        ck()
    end
end

function place(a,b,id)
    if bot.status == 1 then
    bot:place(bot.x + a,bot.y + b,id)
    end
    if whitedoor() then
        ck()
    end
end

function punch1(a,b)
    if bot.status == 1 then
    bot:hit(bot.x + a,bot.y + b)
    end
    if whitedoor() then
        ckt()
        sleep(1000)
    end
end

function place1(a,b,id)
    if bot.status == 1 then
    bot:place(bot.x + a,bot.y + b,id)
    end
    if whitedoor() then
        ckt()
        sleep(1000)
    end
end

function punch2(a,b)
    if bot.status == 1 then
    bot:hit(bot.x + a,bot.y + b)
    end
    if whitedoor() then
        cko()
        sleep(1000)
    end
end

function place2(a,b,id)
    if bot.status == 1 then
    bot:place(bot.x + a,bot.y + b,id)
    end
    if whitedoor() then
        cko()
        sleep(1000)
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

function CheckEmptyTile()
    if bot.status == 1 and bot:getWorld().name ~= "EXIT" then
        m=0
            for _,tile in pairs(getTiles()) do
                if tile.y == bot.y and bot:getWorld():getTile(tile.x,tile.y).fg == 0 and bot:getWorld():getTile(tile.x,tile.y+1).fg ~= 0 then
                    m = m + 1
                end
            end
        return m
    end
end

function statusBotDescription(status)
	if status == BotStatus.online then
		return "<:online_badge:1172761015390306304>"
	else 
		return "<:Offline:1172763331493367880>"
	end
end

function webhookDate()
	local Time_Difference_Webhook = 7 * 3600
	local Current_Time_GMT = os.time(os.date("!*t"))
	local Current_Time_Webhook = Current_Time_GMT + Time_Difference_Webhook
	return os.date("%A, %B %d, %Y | %H:%M", Current_Time_Webhook)
end

function webhooks(link, edits)
    lp("sending webhook")
    te = os.time() - t
    descriptions = {}
    botData = {}
    totalGems = 0

    for i, bot in pairs(getBots()) do
        botInfo = getBot(bot.name)
        status = botInfo.status
        totalGems = totalGems + botInfo.gem_count
        table.insert(botData, { 
            name = botInfo.name,
            level = botInfo.level,
            status = status, 
            gemsnya = botInfo.gem_count,
            description = statusBotDescription(status),
            worldname = botInfo:getWorld().name
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
    
    wh = Webhook.new(link)
    wh.username = "[ALFIRST-STORE]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.embed1.use = true
    wh.embed1.title = "PABRIK LOGS!"
    if HIDDEN_WORLD then
        for _, botInfo in ipairs(botData) do
            local description = string.format("<:growbot:992058196439072770> `Level  : %s `\n<:monitor_oxy:978016089227268116> `Status :` %s \n<:world_generation:937567566656843836> `World  :` ||HIDDEN||\n <:gems:1011931178510602240> `Gems   : %s `", botInfo.level, botInfo.description, botInfo.gemsnya)
            wh.embed1:addField(
                string.format("<:birth_certificate:1011929949076193291> **%s**", botInfo.name),
                description,
                true
            )
        end
    else
        for _, botInfo in ipairs(botData) do
            local description = string.format("<:growbot:992058196439072770> `Level  : %s `\n<:monitor_oxy:978016089227268116> `Status :` %s \n<:world_generation:937567566656843836> `World  :` %s\n <:gems:1011931178510602240> `Gems   : %s `", botInfo.level, botInfo.description, botInfo.worldname, botInfo.gemsnya)
            wh.embed1:addField(
                string.format("<:birth_certificate:1011929949076193291> **%s**", botInfo.name),
                description,
                true
            )
        end
    end
    wh.embed1.color = math.random(1000000, 9999999)
    wh.embed1:addField("", "", false)
    wh.embed1:addField("Online Bots",">>> " .. onlineCount, true)
    wh.embed1.footer.text = webhookDate()
    if FACTORY_MODE == "FLOUR" then
        wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/4562.png"
        wh.embed1.footer.icon_url = "https://cdn.growtopia.tech/items/4562.png"
    elseif FACTORY_MODE == "SEED" then
        wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/"..SEED_ID..".png"
        wh.embed1.footer.icon_url = "https://cdn.growtopia.tech/items/"..SEED_ID..".png"
    elseif FACTORY_MODE == "BLOCK" then
        wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/"..BLOCK_ID..".png"
        wh.embed1.footer.icon_url = "https://cdn.growtopia.tech/items/"..BLOCK_ID..".png"
    end
    wh.embed1:addField("Total Results",">>> "..tonumber(readFromFile("total_result.txt")), true)
    wh.embed1:addField("Active Script",">>> "..math.floor(te/86400).."d "..math.floor(te%86400/3600).."h "..math.floor(te%86400%3600/60).."m ", true)
    if WEBHOOK_EDITED then
        wh:edit(edits)
    else
        wh:send()
    end
end

-- Fungsi untuk membaca nilai dari file
function readFromFile(filePath)
    local file = io.open(filePath, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return content
    end
    return nil
end

-- Fungsi untuk menulis nilai ke dalam file
function writeToFile(filePath, content)
    local file = io.open(filePath, "w")
    if file then
        file:write(content)
        file:close()
    end
end

function ignoreUnder(text)
    return string.match(text, "([^_]+)")
end

function cekPlayers()
    ::back::
    for _, player in pairs(bot:getWorld():getPlayers()) do
        if player.name:upper() ~= WHITELIST_OWNER:upper() and ignoreUnder(player.name:upper()) ~= bot.name:upper() and bot:getWorld().name:upper() == MekiTutor:upper() then
        bot:say("/ban "..player.name:upper())
        sleep(10000)
        goto back
        end
    end
end

function ClearToxicWaste()
    while CheckToxicWaste() do
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

function trasher()
    lp("trashing item")
    for i, trashs in ipairs(TRASH_LIST) do
        if bot:getInventory():findItem(trashs) > 1 and whitedoor() == false then
            if whitedoor() then
                warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
            end
            bot:trash(trashs)
            sleep(1000)
            bot:trash(trashs,bot:getInventory():findItem(trashs))
            sleep(1000)
        end
    end
    if whitedoor() then
        ck()
    end
end

function dropSeed()
    lp("drop seed")
    if bot.auto_collect == true and bot:getWorld().name ~= WORLD_STORAGE[1] then
        collectSet(false, 2)
    end
    sleep(1000)
    while bot:getWorld().name ~= WORLD_STORAGE[1] do
        warp(WORLD_STORAGE[1],WORLD_STORAGE[2])
        sleep(4000)
    end
    if bot:isInWorld(WORLD_STORAGE[1]) and whitedoor() == false and bot:getInventory():findItem(SEED_ID) > 0 then
        SEEDER = gscan(SEED_ID)
        sleep(500)
        lastX = math.floor(getLocal().posx/32) + math.ceil(SEEDER/4000)
        lastY = math.floor(getLocal().posy/32)
        sleep(500)
        if SEEDER == 0 then
            bot:moveRight()
        else
            bot:findPath(lastX, lastY)
            sleep(500)
        end
        bot:drop(SEED_ID,bot:getInventory():findItem(SEED_ID))
        sleep(500)
        while bot:getInventory():findItem(SEED_ID) > 0 do
            if whitedoor() then
                warp(WORLD_STORAGE[1],WORLD_STORAGE[2])
            end
            bot:moveRight()
            sleep(500)
            bot:drop(SEED_ID,bot:getInventory():findItem(SEED_ID))
            sleep(500)
        end
        CURRENT_RESULT = gscan(SEED_ID)
        previousResult = tonumber(readFromFile("total_result.txt")) or 0
        if CURRENT_RESULT >= previousResult then
            writeToFile("total_result.txt", tostring(CURRENT_RESULT))
        end
        webhooks(LINK_WEBHOOK, ID_MESSAGE)
    end
end

function dropFlour()
    lp("drop flour")
    if bot.auto_collect == true and bot:getWorld().name ~= WORLD_STORAGE[1] then
        collectSet(false, 2)
    end
    sleep(1000)
    while bot:getWorld().name ~= WORLD_STORAGE[1] do
        warp(WORLD_STORAGE[1],WORLD_STORAGE[2])
        sleep(4000)
    end
    if bot:isInWorld(WORLD_STORAGE[1]) and whitedoor() == false and bot:getInventory():findItem(4562) > 0 then
        Flour = gscan(4562)
        sleep(500)
        lastX = math.floor(getLocal().posx/32) + math.ceil(Flour/4000)
        lastY = math.floor(getLocal().posy/32)
        sleep(500)
        if Flour == 0 then
            bot:moveRight()
        else
            bot:findPath(lastX, lastY)
            sleep(500)
        end
        bot:drop(4562,bot:getInventory():findItem(4562))
        sleep(500)
        while bot:getInventory():findItem(4562) > 0 do
            if whitedoor() then
                warp(WORLD_STORAGE[1],WORLD_STORAGE[2])
            end
            bot:moveRight()
            sleep(500)
            bot:drop(4562,bot:getInventory():findItem(4562))
            sleep(500)
        end
        CURRENT_RESULT = gscan(4562)
        previousResult = tonumber(readFromFile("total_result.txt")) or 0
        if CURRENT_RESULT >= previousResult then
            writeToFile("total_result.txt", tostring(CURRENT_RESULT))
        end
        webhooks(LINK_WEBHOOK, ID_MESSAGE)
    end
end

function dropPack()
    lp("drop pack")
    if bot.auto_collect == true and bot:getWorld().name ~= WORLD_PACK[1] then
        collectSet(false, 2)
    end
    sleep(1000)
    while bot:getWorld().name ~= WORLD_PACK[1] do
        warp(WORLD_PACK[1],WORLD_PACK[2])
        sleep(4000)
    end
    if bot:isInWorld(WORLD_PACK[1]) then
        if bot.gem_count >= TARGET_GEMS then
            while bot.gem_count >= PRICE_PACK do
                bot:buy(NAME_PACK)
                sleep(1500)
            end
        end
        bot:moveRight()
        for i = 1, #ID_PACK do
            ScanPack = gscan(ID_PACK[i])
            sleep(500)
            lastX = math.floor(getLocal().posx/32)
            lastY = math.floor(getLocal().posy/32)
            bot:drop(ID_PACK[i],bot:getInventory():findItem(ID_PACK[i]))
            sleep(500)
            while bot:getInventory():findItem(ID_PACK[i]) > 0 do
                if whitedoor() then
                    warp(WORLD_PACK[1],WORLD_PACK[2])
                end
                bot:findPath(lastX,math.floor(getLocal().posy/32) - math.floor(ScanPack/4000))
                sleep(500)
                bot:drop(ID_PACK[i],bot:getInventory():findItem(ID_PACK[i]))
                sleep(500)
            end
            bot:findPath(lastX,lastY)
            sleep(500)
            bot:moveRight()
        end
    end
end

function takePickaxe()
    lp("take pickaxe")
    warp(WORLD_PICKAXE[1],WORLD_PICKAXE[2])
    sleep(3000)
    while not bot:isInWorld(WORLD_PICKAXE[1]) do
        takePickaxe()
    end
    if bot.auto_collect == false then
        collectSet(true, 2)
    end
    if bot:getInventory():findItem(98) > 1 then
        bot:wear(98)
    elseif bot:getInventory():findItem(98) == 0 then
        takePickaxe()
    end
    if not bot:getInventory():getItem(98).isActive then
        bot:wear(98)
        sleep(1000)
    end
    if bot.auto_collect == true then
        collectSet(false, 2)
    end
    sleep(2000)
    while bot:getInventory():findItem(98) > 1 do
        bot:drop(98, bot:getInventory():findItem(98) - 1)
        sleep(1000)
    end
end

function harvest()
    lp("harvesting")
    sleep(100)
    if bot.auto_collect == false and bot:getWorld().name == WORLD_PABRIK[1] then
        collectSet(true, 3)
    end
    if bot.status == 1 and bot:getWorld().name ~= "EXIT" and bot:getWorld().name == WORLD_PABRIK[1] then
        for i, tile in ipairs(getTiles()) do
            while tile.y == bot.y and bot.status == 1 and tile.fg == SEED_ID and tile:canHarvest() and bot:getInventory():findItem(BLOCK_ID) <= 180 do
                bot:findPath(tile.x, tile.y)
                sleep(DELAY_HARVEST)
                punch(0, 0)
                sleep(DELAY_HARVEST)
                ck()
                while 0 == bot:getWorld():getTile(tile.x, tile.y).fg and HT_WITH_PT and bot:getInventory():findItem(SEED_ID) > 0 do
                    place(0,0,SEED_ID)
                    sleep(DELAY_PLANT)
                    ck()
                end
            end
        end
    end
end

function plant()
    lp("planting")
    sleep(100)
    if bot.status == 1 and bot:getWorld().name ~= "EXIT" and bot:getWorld().name == WORLD_PABRIK[1] then
        for i, tile in ipairs(getTiles()) do
            while tile.y == bot.y and bot.status == 1 and tile.fg == 0 and bot:getWorld():getTile(tile.x, tile.y + 1).fg ~= 0 and bot:getWorld():getTile(tile.x, tile.y + 1).fg ~= SEED_ID and bot:getInventory():findItem(SEED_ID) > 0 do
                bot:findPath(tile.x, tile.y)
                place(0,0,SEED_ID)
                sleep(DELAY_PLANT)
                ck()
            end
        end
    end
end

function grinder()
    if bot.status == 1 and CheckEmptyTile() == 0 and bot:getInventory():findItem(BLOCK_ID) >= 150 and whitedoor() == false then
        lp("grinding")
        for _, tile in pairs(getTiles()) do
            if tile.fg == 4582 then
                bot:findPath(tile.x,tile.y+1)
                sleep(500)
                place(0,-1,880)
                sleep(1000)
                bot:sendPacket(2, "action|dialog_return\ndialog_name|grinder\ntilex|"..tile.x.."|\ntiley|"..tile.y.."|\nitemID|880|\ncount|3")
                sleep(2000)
                break
            end
        end
        sleep(1000)
        dropFlour()
        sleep(1000)
        warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(1000)
        if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= PATOKAN or bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot.y).bg ~= PATOKAN then
            baris()
        end
        sleep(1000)
    end
end

function PNB()
    bot.ignore_gems = false
    lp("pnb")
    if bot.auto_collect == false then
        collectSet(true, 2)
    end
    if BREAK_OTHER_WORLD then
        if ON_TUTORIAL then
            lp("pnb other world on tutorial")
            addEvent(Event.variantlist, nuked)
            bot:warp(MekiTutor:upper())
            listenEvents(math.floor(DELAY_WARP/1000))
            removeEvents()
            sleep(DELAY_WARP)
            if whitedoor then
                goPatokan()
                sleep(1000)
            end
            if bot:getInventory():findItem(BLOCK_ID) > 0 then
                if bot:getWorld().name ~= MekiTutor:upper() then
                    addEvent(Event.variantlist, nuked)
                    bot:warp(MekiTutor:upper())
                    listenEvents(math.floor(DELAY_WARP/1000))
                    removeEvents()
                    sleep(DELAY_WARP)
                    if whitedoor then
                        goPatokan()
                        sleep(1000)
                    end
                end
                while 1 == bot.status and bot:getWorld().name ~= "EXIT" and whitedoor() == false and bot:getInventory():findItem(BLOCK_ID) > 0 do
                    if 1 == bot.status and bot:getWorld().name ~= "EXIT" and whitedoor() == false and 0 == bot:getWorld():getTile(bot.x, bot.y-1).fg or 0 == bot:getWorld():getTile(bot.x, bot.y-1).bg then
                        place1(0,-1,BLOCK_ID)
                        sleep(DELAY_PLACE)
                    end
                    ckt()
                    if #bot:getWorld():getPlayers() > 0 and bot:getWorld().name == MekiTutor:upper() then
                        while cekPlayers() do
                            cekPlayers()
                        end
                    end
                    while 1 == bot.status and bot:getWorld().name ~= "EXIT" and whitedoor() == false and bot:getWorld():getTile(bot.x, bot.y-1).fg ~= 0 and bot:getWorld():getTile(bot.x, bot.y-1).fg ~= 9640 or bot:getWorld():getTile(bot.x, bot.y-1).bg ~= 0 do
                        punch1(0,-1)
                        sleep(DELAY_BREAK)
                        ckt()
                    end
                end
            end
        else
            lp("pnb other world on "..WORLD_BREAK[1])
            if bot:getWorld().name ~= WORLD_BREAK[1] then
                while bot:getWorld().name ~= WORLD_BREAK[1] do
                    warp(WORLD_BREAK[1],WORLD_BREAK[2])
                    sleep(1000)
                end
            end
            if bot:getWorld().name == WORLD_BREAK[1] then
                if whitedoor() then
                    warp(WORLD_BREAK[1],WORLD_BREAK[2])
                    sleep(1000)
                end
                if bot.status == 1 and whitedoor() == false then
                    baris1()
                end
                if bot:getInventory():findItem(BLOCK_ID) > 0 then
                    while whitedoor() == false and 1 == bot.status and bot:getInventory():findItem(BLOCK_ID) > 0 and string.upper(bot:getWorld().name) == WORLD_BREAK[1]:upper() do
                        if 0 == bot:getWorld():getTile(bot.x, bot.y-2).fg or 0 == bot:getWorld():getTile(bot.x, bot.y-2).bg then
                            place2(0,-2,BLOCK_ID)
                            sleep(DELAY_PLACE)
                        end
                        cko()
                        while whitedoor() == false and 1 == bot.status and bot:getWorld():getTile(bot.x, bot.y-2).fg ~= 0 or bot:getWorld():getTile(bot.x, bot.y-2).bg ~= 0 do
                            punch2(0, -2)
                            sleep(DELAY_BREAK)
                            cko()
                        end
                    end
                end
            end
        end
        if bot.auto_collect == true then
            collectSet(false, 2)
        end
        if bot:getWorld().name ~= WORLD_PABRIK[1] then
            while bot:getWorld().name ~= WORLD_PABRIK[1] do
                warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
                sleep(1000)
            end
        end
        if bot:getWorld().name == WORLD_PABRIK[1] then
            if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= PATOKAN or bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot.y).bg ~= PATOKAN then
                baris()
            end
        end
    else
        if bot:getInventory():findItem(BLOCK_ID) > 0 then
            while whitedoor() == false and 1 == bot.status and bot:getInventory():findItem(BLOCK_ID) > 0 and string.upper(bot:getWorld().name) == WORLD_PABRIK[1]:upper() do
                if 0 == bot:getWorld():getTile(bot.x - 1, bot.y).fg or 0 == bot:getWorld():getTile(bot.x - 1, bot.y).bg then
                    place(-1,0,BLOCK_ID)
                    sleep(DELAY_PLACE)
                end
                ck()
                while whitedoor() == false and 1 == bot.status and bot:getWorld():getTile(bot.x - 1, bot.y).fg ~= 0 or bot:getWorld():getTile(bot.x - 1, bot.y).bg ~= 0 do
                    punch(-1, 0)
                    sleep(DELAY_BREAK)
                    ck()
                end
            end
        end
        if bot.auto_collect == true then
            collectSet(false, 2)
        end
    end
end

function starting()
    bot:getLog():clear()
    sleep((INDEX_SLOT - 1) * DELAY_RUN_SC)
    if TAKE_PICKAXE and bot:getInventory():findItem(98) < 1 then
        sleep((INDEX_SLOT - 1) * 3000)
        takePickaxe()
    end
    warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
    sleep(1000)
    while not bot:isInWorld(WORLD_PABRIK[1]) do
        warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(1000)
    end
    if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= PATOKAN or bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot.y).bg ~= PATOKAN then
        baris()
    end
    start = false
    if FACTORY_MODE == "FLOUR" then
        pabrik = true
        pabrik1 = false
        pabrik2 = false
    elseif FACTORY_MODE == "SEED" then
        pabrik = false
        pabrik1 = true
        pabrik2 = false
    elseif FACTORY_MODE == "BLOCK" then
        pabrik = false
        pabrik1 = false
        pabrik2 = true
    end
end

url_link = "https://rentry.co/alfirst_factory/raw"
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
        print("Wrong License!")
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
start = true
while true do
    if start then
        starting()
        sleep(1000)
        goTutor()
        sleep(1000)
        writeToFile("total_result.txt", tostring(CURRENT_RESULT))
    end
    ---------------------------------pabrik(flour)---------------------------------
    if pabrik then
        webhooks(LINK_WEBHOOK, ID_MESSAGE)
        if CheckToxicWaste() then
            ClearToxicWaste()
            sleep(1000)
        end
        if bot:getInventory():findItem(BLOCK_ID) < 1 then
            harvest()
            sleep(1000)
        end
        if bot:getInventory():findItem(SEED_ID) > 0 then
            plant()
            sleep(1000)
        end
        grinder()
        sleep(1000)
        if UPGRADE_BP then
            if bot.gem_count >= 500 then
                while bot:getInventory().slotcount <= TARGET_BP do
                    bot:buy("upgrade_backpack")
                    sleep(1500)
                end
            end
        end
        if BUY_PACK then
            if bot.gem_count >= TARGET_GEMS then
                dropPack()
                sleep(1000)
                warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
            end
        end
        sleep(1000)
        if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= PATOKAN or bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot.y).bg ~= PATOKAN then
            baris()
        end
        if bot:getInventory():findItem(BLOCK_ID) > 0 and bot:getWorld().name ~= "EXIT" then
            PNB()
        end
        trasher()
        sleep(1000)
        if IGNORE_GEMS then
            bot.ignore_gems = true
        else
            bot.ignore_gems = false
        end
    end
    ---------------------------------pabrik1(SEED)---------------------------------
    if pabrik1 then
        webhooks(LINK_WEBHOOK, ID_MESSAGE)
        if CheckToxicWaste() then
            ClearToxicWaste()
            sleep(1000)
        end
        if bot:getInventory():findItem(BLOCK_ID) < 1 then
            harvest()
            sleep(1000)
        end
        if bot:getInventory():findItem(SEED_ID) > 0 then
            plant()
            sleep(1000)
        end
        if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= PATOKAN or bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot.y).bg ~= PATOKAN then
            baris()
        end
        if bot:getInventory():findItem(BLOCK_ID) > 0 and bot:getWorld().name ~= "EXIT" then
            PNB()
        end
        trasher()
        sleep(1000)
        if IGNORE_GEMS then
            bot.ignore_gems = true
        else
            bot.ignore_gems = false
        end
        sleep(1000)
        if CheckEmptyTile() == 0 and bot:getInventory():findItem(SEED_ID) > 0 then
            dropSeed()
            sleep(1000)
            warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
            sleep(1000)
            if bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot,y).fg ~= PATOKAN or bot.status == 1 and whitedoor() == false and bot:getWorld():getTile(bot.x,bot.y).bg ~= PATOKAN then
                baris()
            end
            if UPGRADE_BP then
                if bot.gem_count >= 500 then
                    while bot:getInventory().slotcount <= TARGET_BP do
                        bot:buy("upgrade_backpack")
                        sleep(1500)
                    end
                end
            end
            if BUY_PACK then
                if bot.gem_count >= TARGET_GEMS then
                    dropPack()
                    sleep(1000)
                    warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
                end
            end
        end
    end
    ---------------------------------pabrik2(BLOCK)---------------------------------
    if pabrik2 then
        
    end
end
else
    lp("License verification failed!")
end

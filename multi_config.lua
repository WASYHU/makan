bot = getBot()
world = bot:getWorld()
inv = bot:getInventory()
t= os.time()

botInfo = BOTS[bot.name]
MODE = botInfo.MODE:upper()
WORLD_LIST = botInfo.WORLD_LIST
ID_WORLD_LIST = botInfo.ID_WORLD_LIST:upper()
BOT_LIST = botInfo.BOT_LIST

STORAGE_SEED = STORAGE_SEED
STORAGE_SEED[1] = STORAGE_SEED[1]:upper()
STORAGE_SEED[2] = STORAGE_SEED[2]:upper()
STORAGE_BLOCK = STORAGE_BLOCK
STORAGE_BLOCK[1] = STORAGE_BLOCK[1]:upper()
STORAGE_BLOCK[2] = STORAGE_BLOCK[2]:upper()
STORAGE_PACK = STORAGE_PACK
STORAGE_PACK[1] = STORAGE_PACK[1]:upper()
STORAGE_PACK[2] = STORAGE_PACK[2]:upper()
BLOCK_ID = SEED_ID-1

CURRENT_SEED = 0
CURRENT_BLOCK = 0
CURRENT_PACK = 0

bot.legit_mode = USE_ANIMATION
bot.collect_path_check = true
bot.collect_interval = 100
bot.object_collect_delay = 0
bot.ignore_gems = IGNORE_GEMS
bot.collect_range = 2
bot.move_interval = 40
bot.move_range = 2
bot.reconnect_interval = 60
---------------------

function removeBotForList(growid)
    for i, bot in ipairs(BOT_LIST) do
        if bot:match(growid) then
            table.remove(BOT_LIST, i)
            break
        end
    end
end

function switchBot()
    local currentBot = BOT_LIST[1]
    if currentBot then
        local growid, password = currentBot:match("([^|]+)|([^|]+)")
        bot:leaveWorld()
        sleep(1000)
        bot:updateBot(growid, password)
        sleep(1000)
        removeBotForList(growid)
        lp("Switched to bot "..growid)
    else
        lp("No available bot to switch. ")
        bot:leaveWorld()
        sleep(1000)
        if REMOVE_BOT_AFTER_DONE then
            removeBot(bot.name)
        else
            bot:stopScript()
        end
    end
end

function lp(txt)
    te = os.time() - t
    local txt = txt:upper()
    print("=============================\nNAME BOT : "..bot.name.."\nWORLD    : "..world.name.."\nACTIVITY : "..txt.."\nACTIV SC : "..math.floor(te/86400).."d "..math.floor(te%86400/3600).."h "..math.floor(te%86400%3600/60).."m ")
end

function collectSet(they, want)
    lp("change set collect")
    bot.auto_collect = they
    bot.collect_range = want
end

function punch(a,b)
    if bot.status == 1 and whitedoor() == false then
    bot:hit(bot.x + a,bot.y + b)
    end
end

function place(a,b,id)
    if bot.status == 1 and whitedoor() == false then
    bot:place(bot.x + a,bot.y + b,id)
    end
end

function alert(txt)
    wh = Webhook.new(ALERT_WEBHOOKS)
    wh.username = "[ALFIRST-STORE]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.content = "||<@"..DISCORD_ID..">|| ".."["..bot.name.."] > "..txt
    wh:send()
end

function whitedoor()
    if world:getTile(bot.x, bot.y).fg == 6 and bot.status == BotStatus.online then
        return true
    end
    return false
end

function warp(a,b)
    if bot.status == BotStatus.online and world.name:upper() ~= a:upper() then
        m = 0
        while world.name:upper() ~= a:upper() do
            m = m + 1
            lp("joining world "..a)
            bot:warp(a,b)
            sleep(DELAY_WARP)
            if m > 2 and world.name:upper() == "EXIT" and bot.status == BotStatus.online then
                lp("nuked world "..a.." and stop script")
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
    if world.name:upper() == a:upper() and bot.status == BotStatus.online then
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

function gscan(id)
    gs = 0
    for _, obj in pairs(world:getObjects()) do
        if obj.id == id and bot.status == BotStatus.online then 
            gs = gs + obj.count
        end
    end
    return gs
end

function statusBotDescription(status)
	if status == BotStatus.online then
		return "<:online_badge:1172761015390306304>"
	elseif status == BotStatus.offline then
		return "<:Offline:1172763331493367880>"
	elseif status == BotStatus.wrong_password then
		return "Wrong Password"
	elseif status == BotStatus.account_banned then
		return "Account Banned"
	elseif status == BotStatus.location_banned then
		return "Location Banned"
	elseif status == BotStatus.version_update then
		return "Version Update"
	elseif status == BotStatus.advanced_account_protection then
		return "Advanced Account Protection"
	elseif status == BotStatus.server_overload then
		return "Server Overload"
	elseif status == BotStatus.too_many_login then
		return "Too Many Login"
	elseif status == BotStatus.maintenance then
		return "Maintenance"
	elseif status == BotStatus.http_block then
		return "Http Block"
	elseif status == BotStatus.captcha_requested then
		return "Captcha Requested"
    elseif status == BotStatus.changing_subserver then
        return "C. Subserver"
	else 
		return "-"
	end
end

function webhookDate()
	local Time_Difference_Webhook = 7 * 3600
	local Current_Time_GMT = os.time(os.date("!*t"))
	local Current_Time_Webhook = Current_Time_GMT + Time_Difference_Webhook
	return os.date("%A, %B %d, %Y | %H:%M", Current_Time_Webhook)
end

function sendGlobal()
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
    
    wh = Webhook.new(LINK_WEBHOOK)
    wh.username = "[ALFIRST-STORE]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.embed1.use = true
    wh.embed1.title = "GLOBAL WEBHOOKS LOGS!"
    for _, botInfo in ipairs(botData) do
        local description = string.format("<:growbot:992058196439072770> `Level  : %s `\n<:monitor_oxy:978016089227268116> `Status :` %s \n<:world_generation:937567566656843836> `World  :` %s\n <:gems:1011931178510602240> `Gems   : %s `", botInfo.level, botInfo.description, botInfo.worldname, botInfo.gemsnya)
        wh.embed1:addField(
            string.format("<:birth_certificate:1011929949076193291> **%s**", botInfo.name),
            description,
            true
        )
    end
    wh.embed1.color = math.random(1000000, 9999999)
    wh.embed1:addField("", "", false)
    wh.embed1:addField("Total Seed","```java\n "..tonumber(readFromFile("total_seed.txt")).."```", true)
    wh.embed1:addField("Total Block","```java\n "..tonumber(readFromFile("total_block.txt")).."```", true)
    wh.embed1:addField("Total Pack","```java\n "..readFromFile("total_pack.txt").."```", true)
    wh.embed1:addField("", "", false)
    wh.embed1:addField("Online Bots",">>> " .. onlineCount, true)
    wh.embed1:addField("Active Script",">>> "..math.floor(te/86400).."d "..math.floor(te%86400/3600).."h "..math.floor(te%86400%3600/60).."m ", true)
    wh.embed1.footer.text = webhookDate()
    wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/"..BLOCK_ID..".png"
    wh.embed1.footer.icon_url = "https://cdn.growtopia.tech/items/"..BLOCK_ID..".png"
    if WEBHOOK_EDITED then
        wh:edit(ID_MESSAGE)
    else
        wh:send()
    end
end

-- Fungsi untuk membaca nilai dari file
function readFromFile(filePath)
    local file = io.open(filePath, "r+")
    if file then
        local content = file:read("*a")
        file:close()
        return content
    end
    return nil
end

-- Fungsi untuk menulis nilai ke dalam file
function writeToFile(filePath, content)
    local file = io.open(filePath, "w+")
    if file then
        file:write(content)
        file:close()
    end
end

function CheckTree()
    m=0
    for y = 1,53,2 do
        for x = 0,99,1 do
            if world:getTile(x,y).fg == SEED_ID and world:getTile(x,y+1).fg ~= 0 and world:hasAccess(x,y) ~= 0 and bot.status == BotStatus.online then
            m = m + 1
            end
        end
    end
return m
end

function CheckEmptyTile()
    local m=0
    for y = 1,53,2 do
        for x = 0,99,1 do
            if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 and bot.status == BotStatus.online then
            m = m + 1
            end
        end
    end
return m
end

function tkz()
    for _,obj in pairs(world:getObjects()) do
        if obj.id == BLOCK_ID or obj.id == SEED_ID then
            xw = math.floor(obj.x / 32)
            yw = math.floor(obj.y / 32)
            bot:findPath(xw,yw)
            sleep(50)
            bot:collectObject(obj.oid,3)
            sleep(50)
            if inv:getItemCount(BLOCK_ID) >= 190 or inv:getItemCount(SEED_ID) >= 190 then
                break
            end
        end
    end
end

function takeSeed()
    while world.name ~= STORAGE_SEED[1] do
        warp(STORAGE_SEED[1],STORAGE_SEED[2])
        sleep(1000)
    end
    if bot:isInWorld(STORAGE_SEED[1]) then
        for _,sid in pairs(world:getObjects()) do
            if sid.id == SEED_ID and whitedoor() == false and bot.status == BotStatus.online then
                xw = math.floor(sid.x / 32)
                yw = math.floor(sid.y / 32)
                bot:findPath(xw,yw)
                sleep(50)
                bot:collectObject(sid.oid,3)
                sleep(50)
                if inv:getItemCount(SEED_ID) >= 1 then
                    break
                end
            end
        end
    end
end

function plant(list)
    if bot:isInWorld(list) then
    count = 0
        for y= 1,53,2 do
            if count%2 == 0 then
                for x= 0,99,1 do
                    if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 and world:getTile(x,y+1).fg ~= SEED_ID and inv:getItemCount(SEED_ID) > 0 and world:hasAccess(x,y) ~= 0 and bot.status == BotStatus.online then
                        bot:findPath(x,y)
                        sleep(DELAY_PT)
                        place(0,0,SEED_ID)
                        sleep(DELAY_PT)
                    end
                end
            else
                for x= 99,0,-1 do
                    if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 and world:getTile(x,y+1).fg ~= SEED_ID and inv:getItemCount(SEED_ID) > 0 and world:hasAccess(x,y) ~= 0 and bot.status == BotStatus.online then
                        bot:findPath(x,y)
                        sleep(DELAY_PT)
                        place(0,0,SEED_ID)
                        sleep(DELAY_PT)
                    end
                end
            end
            count = count+1
        end
    end
end

function harvest(list)
    tkz()
    collectSet(true,3)
    sleep(500)
    count = 0
        for y= 1,53,2 do
            if count%2 == 0 then
                for x= 0,99,1 do
                    if world:getTile(x,y).fg == SEED_ID and inv:getItemCount(SEED_ID-1) <= 180 and world:getTile(x,y):canHarvest() and world:hasAccess(x,y) ~= 0 and bot.status == BotStatus.online then
                    bot:findPath(x,y)
                    sleep(DELAY_HT)
                    punch(0,0)
                    sleep(DELAY_HT)
                    end
                end
            else
                for x= 99,0,-1 do
                    if world:getTile(x,y).fg == SEED_ID and inv:getItemCount(SEED_ID-1) <= 180 and world:getTile(x,y):canHarvest() and world:hasAccess(x,y) ~= 0 and bot.status == BotStatus.online then
                    bot:findPath(x,y)
                    sleep(DELAY_HT)
                    punch(0,0)
                    sleep(DELAY_HT)
                    end
                end
            end
        count = count+1
        end
    tkz()
    collectSet(false,3)
    sleep(500)
end

function dropSeed()
    lp("drop seed")
    if bot.auto_collect == true and bot:getWorld().name ~= STORAGE_SEED[1] then
        collectSet(false, 2)
    end
    sleep(1000)
    while bot:getWorld().name ~= STORAGE_SEED[1] do
        warp(STORAGE_SEED[1],STORAGE_SEED[2])
        sleep(1000)
    end
    if bot:isInWorld(STORAGE_SEED[1]) and whitedoor() == false and bot:getInventory():getItemCount(SEED_ID) > 0 then
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
        bot:fastDrop(SEED_ID,bot:getInventory():getItemCount(SEED_ID))
        sleep(500)
        while bot:getInventory():getItemCount(SEED_ID) > 0 do
            if whitedoor() then
                warp(STORAGE_SEED[1],STORAGE_SEED[2])
            end
            bot:moveRight()
            sleep(500)
            bot:fastDrop(SEED_ID,bot:getInventory():getItemCount(SEED_ID))
            sleep(500)
        end
    end
    CURRENT_SEED = gscan(SEED_ID)
    previousSEED = tonumber(readFromFile("total_seed.txt")) or 0
    if CURRENT_SEED >= previousSEED then
        writeToFile("total_seed.txt", tostring(CURRENT_SEED))
    end
    sendGlobal()
end

function dropBlock()
    lp("drop block")
    if bot.auto_collect == true and bot:getWorld().name ~= STORAGE_BLOCK[1] then
        collectSet(false, 2)
    end
    sleep(1000)
    while bot:getWorld().name ~= STORAGE_BLOCK[1] do
        warp(STORAGE_BLOCK[1],STORAGE_BLOCK[2])
        sleep(1000)
    end
    if bot:isInWorld(STORAGE_BLOCK[1]) and whitedoor() == false and bot:getInventory():getItemCount(BLOCK_ID) > 0 then
        BLOCKER = gscan(BLOCK_ID)
        sleep(500)
        lastX = math.floor(getLocal().posx/32) + math.ceil(BLOCKER/4000)
        lastY = math.floor(getLocal().posy/32)
        sleep(500)
        if BLOCKER == 0 then
            bot:moveRight()
        else
            bot:findPath(lastX, lastY)
            sleep(500)
        end
        bot:fastDrop(BLOCK_ID,bot:getInventory():getItemCount(BLOCK_ID))
        sleep(500)
        while bot:getInventory():getItemCount(BLOCK_ID) > 0 do
            if whitedoor() then
                warp(STORAGE_BLOCK[1],STORAGE_BLOCK[2])
                sleep(1000)
            end
            bot:moveRight()
            sleep(500)
            bot:fastDrop(BLOCK_ID,bot:getInventory():getItemCount(BLOCK_ID))
            sleep(500)
        end
    end
    CURRENT_BLOCK = gscan(BLOCK_ID)
    previousBLOCK = tonumber(readFromFile("total_block.txt")) or 0
    if CURRENT_BLOCK >= previousBLOCK then
        writeToFile("total_block.txt", tostring(CURRENT_BLOCK))
    end
    sendGlobal()
end

function dropPack()
    lp("drop pack")
    if bot.auto_collect == true and bot:getWorld().name ~= STORAGE_PACK[1] then
        collectSet(false, 2)
    end
    sleep(1000)
    while bot:getWorld().name ~= STORAGE_PACK[1] do
        warp(STORAGE_PACK[1],STORAGE_PACK[2])
        sleep(1000)
    end
    if bot:isInWorld(STORAGE_PACK[1]) then
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
            bot:fastDrop(ID_PACK[i],bot:getInventory():getItemCount(ID_PACK[i]))
            sleep(500)
            while bot:getInventory():getItemCount(ID_PACK[i]) > 0 do
                if whitedoor() then
                    warp(STORAGE_PACK[1],STORAGE_PACK[2])
                    sleep(1000)
                end
                bot:findPath(lastX,math.floor(getLocal().posy/32) - math.floor(ScanPack/4000))
                sleep(500)
                bot:fastDrop(ID_PACK[i],bot:getInventory():getItemCount(ID_PACK[i]))
                sleep(500)
            end
            bot:findPath(lastX,lastY)
            sleep(500)
            bot:moveRight()
        end
    end
    local packkan = {}
    for ion, itemId in ipairs(ID_PACK) do
        local pack = getInfo(itemId).name .. " : " .. gscan(itemId)
        table.insert(packkan, pack)
    end

    writeToFile("total_pack.txt", table.concat(packkan, "\n"))
    sleep(1000)
    sendGlobal()
end

function mainPT()
    for _, list in ipairs(WORLD_LIST) do
        list = list:upper()
        while world.name:upper() ~= list do
            warp(list,ID_WORLD_LIST)
            sleep(1000)
        end
        bot.auto_reconnect = true
        if bot:isInWorld(list) and whitedoor() == false then
            if inv:getItemCount(SEED_ID) < 1 then
                takeSeed()
                sleep(1000)
                while world.name:upper() ~= list do
                    warp(list,ID_WORLD_LIST)
                    sleep(1000)
                end
            end
            while CheckEmptyTile() ~= 0 do
                if inv:getItemCount(SEED_ID) > 0 then
                    plant(list)
                    sleep(1000)
                elseif inv:getItemCount(SEED_ID) < 1 then
                    takeSeed()
                    sleep(1000)
                    while world.name:upper() ~= list do
                        warp(list,ID_WORLD_LIST)
                        sleep(1000)
                    end
                end
            end
        end
    end
    if CheckEmptyTile() == 0 then
        if inv:getItemCount(SEED_ID) > 0 then
            dropSeed()
            sleep(1000)
        end
        bot:leaveWorld()
        sleep(1000)
        if REMOVE_BOT_AFTER_DONE then
            removeBot(bot.name)
        else
            bot.auto_reconnect = false
            bot:disconnect()
            sleep(1000)
            bot:stopScript()
        end
    end
end

function mainHT()
    for _, list in ipairs(WORLD_LIST) do
        list = list:upper()
        while world.name:upper() ~= list do
            warp(list,ID_WORLD_LIST)
            sleep(1000)
        end
        bot.auto_reconnect = true
        if bot:isInWorld(list) and whitedoor() == false then
            while CheckTree() ~= 0 do
                if inv:getItemCount(BLOCK_ID) < 1 then
                    harvest(list)
                    sleep(1000)
                elseif inv:getItemCount(BLOCK_ID) >= 1 then
                    dropBlock()
                    sleep(1000)
                    if inv:getItemCount(SEED_ID) >= 1 then
                        dropSeed()
                        sleep(1000)
                    end
                    if BUY_PACK then
                        if bot.gem_count >= TARGET_GEMS then
                            dropPack()
                            sleep(1000)
                        end
                    end
                    if LIMIT_LEVEL then
                        if bot.level >= MAX_LEVEL then
                            if SWITCH_IF_LEVEL then
                                lp("level match, switch bot")
                                switchBot()
                                sleep(30000)
                                while bot.status ~= BotStatus.online do
                                    bot:connect()
                                    sleep(30000)
                                end
                            end
                        end
                    end
                    while world.name:upper() ~= list do
                        warp(list,ID_WORLD_LIST)
                        sleep(1000)
                    end
                end
            end
        end
    end
    if CheckTree() == 0 then
        if inv:getItemCount(BLOCK_ID) > 0 then
            dropBlock()
            sleep(1000)
        elseif inv:getItemCount(SEED_ID) > 0 then
            dropSeed()
            sleep(1000)
        end
        bot:leaveWorld()
        sleep(1000)
        if REMOVE_BOT_AFTER_DONE then
            removeBot(bot.name)
        else
            bot.auto_reconnect = false
            bot:disconnect()
            sleep(1000)
            bot:stopScript()
        end
    end
end

url_link = "https://rentry.co/alfirst_multiconfig/raw"
client = HttpClient.new()
client.method = Method.get
client.url = url_link
response = client:request()
load(response.body)()

function verifyLicense(LICENSE)
    local expDate = lisensi[LICENSE]

    if expDate == nil then
        print("Wrong License!")
        return false
    end

    local now = os.date("%Y-%m-%d")
    if now > expDate then
        print("Expired License!")
        return false
    end

    return true
end

if verifyLicense(LICENSE) then
    writeToFile("total_seed.txt", tostring(CURRENT_SEED))
    writeToFile("total_block.txt", tostring(CURRENT_BLOCK))
    writeToFile("total_pack.txt", tostring(CURRENT_PACK))

    if MODE == "HARVEST" then
        mainHT()
    elseif MODE == "PLANT" then
        mainPT()
    end
end

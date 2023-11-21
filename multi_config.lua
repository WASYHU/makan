---------------------
bot = getBot()
world = bot:getWorld()
inv = bot:getInventory()
t= os.time()
botData = {}
totalGems = 0
CURRENT_BLOCK = 0
CURRENT_SEED = 0
Mole = 0
botInfo = BOTS[bot.name]
MODE = botInfo.MODE:upper()
WORLD_LIST = botInfo.WORLD_LIST
ID_WORLD_LIST = botInfo.ID_WORLD_LIST:upper()
---------------------
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
bot.collect_path_check = true
bot.collect_interval = 100
bot.object_collect_delay = 0
bot.ignore_gems = IGNORE_GEMS
bot.collect_range = 2
bot.move_interval = 25
bot.move_range = 2
---------------------
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

function getKeterangan(worldName)
    local keterangan = "-"  -- Default value

    for _, world in ipairs(WORLD_LIST) do
        if worldName == world then
            if MODE == "HARVEST" then
                keterangan = "HARVESTING"
            elseif MODE == "PLANT" then
                keterangan = "PLANTING"
            end
            break  -- Keluar dari loop jika sudah ditemukan
        end
    end

    return keterangan
end

function webhooks(link, edits)
    te = os.time() - t
    descriptions = {}

    botData = {}
    totalGems = 0

    for i, bot in pairs(getBots()) do
        botInfo = getBot(bot.name)
        status = botInfo.status
        totalGems = totalGems + botInfo.gem_count
        worldName = botInfo:getWorld().name  -- Menambahkan deteksi world

        local keterangan
        -- Menentukan keterangan berdasarkan kondisi
        if worldName == STORAGE_SEED[1] then
            if MODE == "HARVEST" then
                keterangan = "DROP SEED"
            elseif MODE == "PLANT" then
                keterangan = "TAKE SEED"
            end
        elseif worldName == STORAGE_BLOCK[1] then
            keterangan = "DROP BLOCK"
        elseif worldName == STORAGE_PACK[1] then
            keterangan = "DROP PACK"
        else
            keterangan = getKeterangan(worldName)
        end

        table.insert(botData, { 
            name = botInfo.name,
            status = status, 
            description = statusBotDescription(status),
            world = worldName,
            keterangan = keterangan,  -- Menambahkan keterangan berdasarkan worldName
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


    -- Add header
    header = "SCRIPT PTHT BY NOWADAYS"
    table.insert(descriptions, "`" .. header .. "`")

    for urutan, botInfo in ipairs(botData) do
        -- Format the output as `[NAMABOT] [STATUS] [KETERANGAN]`
        table.insert(descriptions, string.format("`[%s] [ %s ] [`%s`] [ %s ]`",urutan , botInfo.name, botInfo.description, botInfo.keterangan))
    end
    table.insert(descriptions, string.format("<:pgems:996716107845075015> `Total Gems: %s`\n", totalGems))

    table.insert(descriptions, "**[ALFIRST X NOWADAYS](https://linktr.ee/ALFIRST_STORE/) - <@"..DISCORD_ID..">**")

    wh = Webhook.new(link)
    wh.username = "[ALFIRST-STORE]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.embed1.use = true
    wh.embed1.title = "PTHT LOGS!"
    wh.embed1.description = table.concat(descriptions, "\n") -- Concatenate bot names with newline
    wh.embed1.color = math.random(1000000, 9999999)
    wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/"..BLOCK_ID..".png"
    wh.embed1:addField("Online Bots",onlineCount , true)
    wh.embed1:addField("Offline Bots",offlineCount , true)
    wh.embed1:addField("UPTIME SCRIPT", math.floor(te/86400).." Days "..math.floor(te%86400/3600).." Hours "..math.floor(te%86400%3600/60).." Minutes ", false)
    wh.embed2.use = true
    wh.embed2.color = math.random(1000000, 9999999)
    wh.embed2.footer.text = webhookDate()
    wh.embed2.footer.icon_url = "https://cdn.growtopia.tech/items/"..BLOCK_ID..".png"
    wh.embed2:addField("TOTAL SEED", CURRENT_SEED, true)
    wh.embed2:addField("TOTAL BLOCK", CURRENT_BLOCK, true)

    -- Add ID_PACK information with names
    local totalPacks = ""

for i = 1, #ID_PACK do
    local packInfo = getInfo(ID_PACK[i])
    local packName = packInfo.name

    totalPacks = totalPacks .. packName .. " : " .. Mole .. "\n"
end

wh.embed2:addField("TOTAL PACK", totalPacks, true)



    if WEBHOOK_EDITED then
        wh:edit(edits)
    else
        wh:send()
    end
end

function punch(x,y)
    local packet = GameUpdatePacket.new()
    packet.type = 3
    packet.int_data = 18
    packet.pos_x = getLocal().posx
    packet.pos_y = getLocal().posy
    packet.int_x = math.floor(getLocal().posx/32+x)
    packet.int_y = math.floor(getLocal().posy/32+y)
    bot:sendRaw(packet)
end

function pl4ce(x,y,id)
    local packet = GameUpdatePacket.new()
    packet.type = 3
    packet.int_data = id
    packet.pos_x = getLocal().posx
    packet.pos_y = getLocal().posy
    packet.int_x = math.floor(getLocal().posx/32+x)
    packet.int_y = math.floor(getLocal().posy/32+y)
    bot:sendRaw(packet)
end

function gscan(id)
    gs = 0
    for _, obj in pairs(world:getObjects()) do
        if obj.id == id then 
            gs = gs + obj.count
        end
    end
    return gs
end

function CheckTree()
    m=0
    for y = 1,53,2 do
        for x = 0,99,1 do
            if world:getTile(x,y).fg == SEED_ID and world:getTile(x,y):canHarvest() then
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
            if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 then
            m = m + 1
            end
        end
    end
return m
end

function cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        localBot = world:getLocal()
        if localBot then
            posBotX = math.floor(localBot.posx / 32) 
            posBotY = math.floor(localBot.posy / 32)
        end
    end
end

function goesTo(a,b) 
    bot:warp(a,b)
    sleep(1000)
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        if world:getTile(posBotX,posBotY).fg == 6 then
            goesTo(a,b)
            sleep(1000)
        end
    end
end

function handleAccountBanned()
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    bot.auto_reconnect = false
    bot:stopScript()
end

function handleConnection()
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    bot:connect()
    bot.auto_reconnect = true
    bot.reconnect_interval = 15
    sleep(15000)
end

function reconList(txt)
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    if bot.status == BotStatus.account_banned then
        handleAccountBanned()
    end
    while not (bot.status == BotStatus.online or bot.status == BotStatus.account_banned) do
        handleConnection()
    end
    if world.name ~= txt then
        goesTo(txt,ID_WORLD_LIST)
        sleep(1000)
    end
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        while world:getTile(posBotX,posBotY).fg == 6 do
            goesTo(txt,ID_WORLD_LIST)
            sleep(DELAY_WARP)
        end
    end
end

function reconSeed(txt)
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    if bot.status == BotStatus.account_banned then
        handleAccountBanned()
    end
    while not (bot.status == BotStatus.online or bot.status == BotStatus.account_banned) do
        handleConnection()
    end
    if world.name ~= txt then
        goesTo(txt,STORAGE_SEED[2])
        sleep(1000)
    end
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        while world:getTile(posBotX,posBotY).fg == 6 do
            goesTo(txt,STORAGE_SEED[2])
            sleep(DELAY_WARP)
        end
    end
end

function reconBlock(txt)
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    if bot.status == BotStatus.account_banned then
        handleAccountBanned()
    end
    while not (bot.status == BotStatus.online or bot.status == BotStatus.account_banned) do
        handleConnection()
    end
    if world.name ~= txt then
        goesTo(txt,STORAGE_BLOCK[2])
        sleep(1000)
    end
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        while world:getTile(posBotX,posBotY).fg == 6 do
            goesTo(txt,STORAGE_BLOCK[2])
            sleep(DELAY_WARP)
        end
    end
end

function reconPack(txt)
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    if bot.status == BotStatus.account_banned then
        handleAccountBanned()
    end
    while not (bot.status == BotStatus.online or bot.status == BotStatus.account_banned) do
        handleConnection()
    end
    if world.name ~= txt then
        goesTo(txt,STORAGE_PACK[2])
        sleep(1000)
    end
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        while world:getTile(posBotX,posBotY).fg == 6 do
            goesTo(txt,STORAGE_PACK[2])
            sleep(DELAY_WARP)
        end
    end
end

function tkz()
    for _,obj in pairs(world:getObjects()) do
        if obj.id == BLOCK_ID or obj.id == SEED_ID then
            xw = math.floor(obj.x / 32)
            yw = math.floor(obj.y / 32)
            bot:findPath(xw,yw)
            sleep(5)
            bot:collect(3)
            sleep(5)
        end
    end
end

function takeSeed()
    if bot:isInWorld(STORAGE_SEED[1]) then
        if USE_WEBHOOK then
            webhooks(LINK_WEBHOOK,ID_MESSAGE)
        end
        for _,sid in pairs(world:getObjects()) do
            if sid.id == SEED_ID then
                xw = math.floor(sid.x / 32)
                yw = math.floor(sid.y / 32)
                bot:findPath(xw,yw)
                sleep(5)
                bot:collect(3)
                sleep(5)
                if inv:findItem(SEED_ID) >= 1 then
                    break
                end
            end
            CURRENT_SEED = gscan(SEED_ID)
            if USE_WEBHOOK then
                webhooks(LINK_WEBHOOK,ID_MESSAGE)
            end
        end
    else
        reconSeed(STORAGE_SEED[1])
        sleep(1000)
        takeSeed()
    end
end

function tambal(list)
    if bot:isInWorld(list) then
    count = 0
        for y= 1,53,2 do
            if count%2 == 0 then
                for x= 0,99,1 do
                    if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 and world:getTile(x,y+1).fg ~= SEED_ID and inv:findItem(SEED_ID) > 0 then
                        bot:findPath(x,y)
                        sleep(DELAY_PT)
                        pl4ce(0,0,SEED_ID)
                        sleep(DELAY_PT)
                    end
                end
            else
                for x= 99,0,-1 do
                    if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 and world:getTile(x,y+1).fg ~= SEED_ID and inv:findItem(SEED_ID) > 0 then
                        bot:findPath(x,y)
                        sleep(DELAY_PT)
                        pl4ce(0,0,SEED_ID)
                        sleep(DELAY_PT)
                    end
                end
            end
            count = count+1
        end
    else
        reconList(list)
        sleep(7000)
        tambal(list)
    end
end

function plant(list)
    if bot:isInWorld(list) then
        if USE_WEBHOOK then
            webhooks(LINK_WEBHOOK,ID_MESSAGE)
        end
    count = 0
        for y= 1,53,2 do
            if count%2 == 0 then
                for x= 0,99,1 do
                    if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 and world:getTile(x,y+1).fg ~= SEED_ID and inv:findItem(SEED_ID) > 0 then
                        bot:findPath(x,y)
                        sleep(DELAY_PT)
                        pl4ce(0,0,SEED_ID)
                        sleep(DELAY_PT)
                    end
                end
            else
                for x= 99,0,-1 do
                    if world:getTile(x,y).fg == 0 and world:getTile(x,y+1).fg ~= 0 and world:getTile(x,y+1).fg ~= SEED_ID and inv:findItem(SEED_ID) > 0 then
                        bot:findPath(x,y)
                        sleep(DELAY_PT)
                        pl4ce(0,0,SEED_ID)
                        sleep(DELAY_PT)
                    end
                end
            end
            count = count+1
        end
    else
        reconList(list)
        sleep(7000)
        plant(list)
    end
    if CheckEmptyTile() ~= 0 then
        tambal(list)
    end
    if inv:findItem(SEED_ID) == 0 then
        reconSeed(STORAGE_SEED[1])
        sleep(2000)
        goesTo(STORAGE_SEED[1],STORAGE_SEED[2])
        takeSeed()
        sleep(2000)
        goesTo(list,ID_WORLD_LIST)
        sleep(2000)
        plant(list)
        sleep(1000)
    end
end

function harvest(list)
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    tkz()
    count = 0
        for y= 1,53,2 do
            if count%2 == 0 then
                for x= 0,99,1 do
                    if world:getTile(x,y).fg == SEED_ID and inv:getItemCount(SEED_ID-1) <= 180 and world:getTile(x,y):canHarvest() then
                    bot:findPath(x,y)
                    sleep(DELAY_HT)
                    punch(0,0)
                    sleep(DELAY_HT)
                    bot:collect(3)
                    sleep(10)
                    end
                end
            else
                for x= 99,0,-1 do
                    if world:getTile(x,y).fg == SEED_ID and inv:getItemCount(SEED_ID-1) <= 180 and world:getTile(x,y):canHarvest() then
                    bot:findPath(x,y)
                    sleep(DELAY_HT)
                    punch(0,0)
                    sleep(DELAY_HT)
                    bot:collect(3)
                    sleep(10)
                    end
                end
            end
        count = count+1
        end
    tkz()
    reconList(list)
end

function dropSeed()
    reconSeed(STORAGE_SEED[1])
    bot.auto_collect = false
    if bot:isInWorld(STORAGE_SEED[1]) then
        goesTo(STORAGE_SEED[1],STORAGE_SEED[2])
        AWALS = gscan(SEED_ID)
        sleep(200)
        bot:moveTo(1,0)
        sleep(500)
        bot:drop(SEED_ID,inv:getItemCount(SEED_ID))
        sleep(500)
        while inv:getItemCount(SEED_ID) > 0 do
            bot:moveTo(1,0)
            sleep(200)
            bot:drop(SEED_ID,inv:getItemCount(SEED_ID))
            sleep(500)
        end
        CURRENT_SEED = gscan(SEED_ID)
        if USE_WEBHOOK then
            webhooks(LINK_WEBHOOK,ID_MESSAGE)
        end
    else
        dropSeed()
    end
end

function dropBlock()
    reconBlock(STORAGE_BLOCK[1])
    bot.auto_collect = false
    if bot:isInWorld(STORAGE_BLOCK[1]) then
        goesTo(STORAGE_BLOCK[1],STORAGE_BLOCK[2])
        AWALS = gscan(BLOCK_ID)
        sleep(200)
        bot:moveTo(1,0)
        sleep(500)
        lastX = math.floor(getLocal().posx/32)+math.floor(gscan(BLOCK_ID)/4000)
        lastY = math.floor(getLocal().posy/32)
        bot:drop(BLOCK_ID,inv:getItemCount(BLOCK_ID))
        sleep(500)
        while inv:getItemCount(BLOCK_ID) > 0 do
            bot:findPath(lastX,lastY)
            sleep(200)
            bot:drop(BLOCK_ID,inv:getItemCount(BLOCK_ID))
            sleep(500)
            while inv:getItemCount(BLOCK_ID) > 0 do
                bot:moveTo(1,0)
                sleep(200)
                bot:drop(BLOCK_ID,inv:getItemCount(BLOCK_ID))
                sleep(500)
            end
        end
        CURRENT_BLOCK = gscan(BLOCK_ID)
        if USE_WEBHOOK then
            webhooks(LINK_WEBHOOK,ID_MESSAGE)
        end
    else
        dropBlock()
    end
end

function dropPack()
    reconPack(STORAGE_PACK[1])
    bot.auto_collect = false
    if bot:isInWorld(STORAGE_PACK[1]) then
        goesTo(STORAGE_PACK[1],STORAGE_PACK[2])
        sleep(200)
            while bot.gem_count >= PRICE_PACK do
            bot:buy(NAME_PACK)
            sleep(3000)
            end
        bot:moveTo(1,0)
        sleep(500)
        for i = 1, #ID_PACK do
        lasA = math.floor(getLocal().posx/32)
        lasB = math.floor(getLocal().posy/32)-math.floor(gscan(ID_PACK[i])/2000)
        lasY = math.floor(getLocal().posy/32)
        bot:drop(ID_PACK[i],inv:getItemCount(ID_PACK[i]))
        sleep(500)
            while inv:getItemCount(ID_PACK[i]) > 0 do
            bot:findPath(lasA,lasB)
            sleep(500)
            bot:drop(ID_PACK[i],inv:getItemCount(ID_PACK[i]))
            sleep(500)
            bot:findPath(lasA,lasY)
            end
        bot:moveTo(1,0)
        sleep(500)
        Mole = gscan(ID_PACK[i])
        if USE_WEBHOOK then
            webhooks(LINK_WEBHOOK,ID_MESSAGE)
        end
        end
    else
        dropPack()
    end
end

function mainHT()
    for _, list in ipairs(WORLD_LIST) do
        list = list:upper()
        reconList(list)
        sleep(7000)
        if bot:isInWorld(list) then
            while CheckTree() ~= 0 do
                if inv:getItemCount(BLOCK_ID) < 1 then
                    goesTo(list,ID_WORLD_LIST)
                    sleep(1000)
                    harvest(list)
                    sleep(1000)
                end
                if inv:getItemCount(BLOCK_ID) > 1 then
                    reconBlock(STORAGE_BLOCK[1])
                    sleep(1000)
                    dropBlock()
                    if inv:getItemCount(SEED_ID) > 1 then
                    reconSeed(STORAGE_SEED[1])
                    sleep(1000)
                    dropSeed()
                    end
                    sleep(1000)
                    if BUY_PACK then
                        if bot.gem_count >= PRICE_PACK then
                            reconPack(STORAGE_PACK[1])
                            sleep(1000)
                            if inv.slotcount <= 26 then
                                bot:buy("upgrade_backpack")
                                sleep(3000)
                            end
                            dropPack()
                        end
                    end
                    if inv:getItemCount(BLOCK_ID) < 1 then
                        goesTo(list,ID_WORLD_LIST)
                        sleep(1000)
                        harvest(list)
                        sleep(1000)
                    end
                end
            end
        else
            reconList(list)
        end
        if CheckTree() == 0 then
            dropBlock()
            dropSeed()
        end
    end
bot.auto_reconnect = false
bot:disconnect()
end

function mainPT()
    for _, list in ipairs(WORLD_LIST) do
        list = list:upper()
        reconList(list)
        sleep(7000)
        if bot:isInWorld(list) then
            if CheckEmptyTile() ~= 0 then
                if inv:findItem(SEED_ID) > 0 then
                    if bot:isInWorld(list) then
                        goesTo(list,ID_WORLD_LIST)
                        sleep(2000)
                        plant(list)
                        sleep(1000)
                    end
                elseif inv:findItem(SEED_ID) == 0 then
                    reconSeed(STORAGE_SEED[1])
                    sleep(2000)
                    goesTo(STORAGE_SEED[1],STORAGE_SEED[2])
                    sleep(2000)
                    takeSeed()
                    sleep(2000)
                    if inv:findItem(SEED_ID) > 0 then
                        goesTo(list,ID_WORLD_LIST)
                        sleep(2000)
                        plant(list)
                        sleep(1000)
                    end
                end
            end
        else
            reconList(list)
        end
        if CheckEmptyTile() == 0 then
            dropSeed()
        end
    end
bot.auto_reconnect = false
bot:disconnect()
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
    print("Matched License!, Running SC")
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
    sleep(100)
    if MODE == "HARVEST" then
        mainHT()
    elseif MODE == "PLANT" then
        mainPT()
    end
    if USE_WEBHOOK then
        webhooks(LINK_WEBHOOK,ID_MESSAGE)
    end
end

-------------------------
bot = getBot()
world = bot:getWorld()
inv = bot:getInventory()
BLOCK_ID = SEED_ID-1
MODE = MODE:upper()

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

bot.ignore_gems = IGNORE_GEMS
bot.collect_path_check = true
bot.collect_interval = 25
bot.object_collect_delay = 0
bot.collect_range = 2
bot.move_interval = 25
bot.move_range = 2
CURRENT_RESULT = 0
t = os.time()
LIST_BOT = {}
INDEX_SLOT = 0
--------dont touch--------
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
-------------------------

-- List kata
List_kata = {
    "Capek tolol lu nyuruh ptht gini terus",
    "Lu enak anj, bisa tiduran, lah gw",
    "Bang udh bang, capek banget ini",
    "Bener bener tega anak anj",
    "Minimal bayar gaji gw anak anj",
    "Jiko dulu Kairi",
    "Ijin kompe ges",
    "MELODEAN JAYA JAYA JAYA",
  }
  
  -- Fungsi untuk mengambil satu kata secara acak dari list
  function getRandomKata(list)
    math.randomseed(os.time()) -- Inisialisasi seed random berdasarkan waktu
    local randomIndex = math.random(#list)
    return list[randomIndex]
  end

function sendGameUpdate(types, intData, x, y)
    local packet = GameUpdatePacket.new()
    packet.type = types
    packet.int_data = intData
    packet.pos_x = getLocal().posx
    packet.pos_y = getLocal().posy
    packet.int_x = math.floor(getLocal().posx / 32 + x)
    packet.int_y = math.floor(getLocal().posy / 32 + y)
    bot:sendRaw(packet)
end

function punch(x, y)
    cekKoneksi()
    sendGameUpdate(3, 18, x, y)
end

function pasang(x, y, id)
    cekKoneksi()
    sendGameUpdate(3, id, x, y)
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

function webhooks(link, edits)
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
            description = statusBotDescription(status) 
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
    for urutan, botInfo in ipairs(botData) do
        -- Format the output as `[NAMABOT] [LEVEL] [STATUS]`
        table.insert(descriptions, string.format("`[%s] [ %s ] [ %s ] [`%s`]`", urutan, botInfo.name, botInfo.level, botInfo.description))
    end

    local currentResult = CURRENT_RESULT
    local totalResultPath = "total_result.txt"
    local previousResult = tonumber(readFromFile(totalResultPath)) or 0
    if currentResult > previousResult then
        writeToFile(totalResultPath, tostring(currentResult))
    end

    wh = Webhook.new(link)
    wh.username = "[ALFIRST-STORE]"
    wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
    wh.embed1.use = true
    wh.embed1.title = "PABRIK LOGS!"
    wh.embed1.description = table.concat(descriptions, "\n") -- Concatenate bot names with newline
    wh.embed1.color = math.random(1000000, 9999999)
    wh.embed1:addField("| Online Bots |", onlineCount .. " <:online_badge:1172761015390306304>", true)
    wh.embed1.footer.text = webhookDate()
    wh.embed1.footer.icon_url = "https://cdn.growtopia.tech/items/" .. BLOCK_ID .. ".png"
    wh.embed1:addField("| Total Hasil |", tonumber(readFromFile(totalResultPath)), true)

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

-- Fungsi untuk membaca nilai TOTAL PACK dari file
function readPackValuesFromFile(filePath)
    local file = io.open(filePath, "r")
    local packValues = {}
    if file then
        for line in file:lines() do
            local packName, value = line:match("([^:]+)%s*:%s*([^\n]+)")
            if packName and value then
                packValues[packName] = tonumber(value)
            end
        end
        file:close()
    end
    return packValues
end

-- Fungsi untuk menulis nilai TOTAL PACK ke dalam file
function writePackValuesToFile(filePath, packValues)
    local file = io.open(filePath, "w")
    if file then
        for packName, value in pairs(packValues) do
            file:write(packName .. " : " .. value .. "\n")
        end
        file:close()
    end
end

function baris()
    xPatokan = {}
    yPatokan = {}
    ct = 0
    for _, tile in pairs(world:getTiles()) do
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
                sleep(200)
                break
        else
            i = i + 1
        end
    end
end

function cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        localBot = world:getLocal()
        if localBot then
            pBotX = math.floor(localBot.posx / 32) 
            pBotY = math.floor(localBot.posy / 32)
        end
    end
end

function goesTo(a,b) 
    bot:warp(a,b)
    sleep(DELAY_WARP)
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" then
        if world:getTile(pBotX,pBotY).fg == 6 then
            goesTo(a,b)
            sleep(500)
        end
    end
    bot:say("Assalamualaikum")
end
function handlePing0()
    bot:disconnect()
end

function handleAccountBanned()
    bot.auto_reconnect = false
    bot:stopScript()
end

function handleConnection()
    bot:connect()
    bot.auto_reconnect = true
    bot.reconnect_interval = 15
    sleep(15000)
end

function Reconnect(a,b)
    if bot:getPing() == 0 then
        handlePing0()
    end
    if bot.status == BotStatus.account_banned then
        handleAccountBanned()
    end
    while not (bot.status == BotStatus.online or bot.status == BotStatus.account_banned) do
        handleConnection()
    end
    bot.auto_reconnect = false
    if world.name ~= txt then
        goesTo(a, b)
    end
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" and world:getTile(pBotX, pBotY).fg == 6 then
        goesTo(a,b)
        sleep(DELAY_WARP)
    end
end

function cekKoneksi()
    if bot:getPing() == 0 then
        handlePing0()
    end
    if bot.status == BotStatus.account_banned then
        handleAccountBanned()
    end
    while not (bot.status == BotStatus.online or bot.status == BotStatus.account_banned) do
        handleConnection()
    end
    bot.auto_reconnect = false
    cekPos()
    currentWorld = tostring(world.name)
    if currentWorld ~= "" and currentWorld ~= "EXIT" and world:getTile(pBotX, pBotY).fg == 6 then
        Reconnect(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(DELAY_WARP)
        baris()
    end
end

trashList = {882,1406,9346,5040,5042,5044,5032,5034,5036,5038,5024,5026,5028,7162,7164}
function trasher()
    for i, trash in ipairs(trashList) do
        if inv:getItemCount(trash) >= 100 then
          bot:trash(trash)
          sleep(1000)
          bot:trash(trash,inv:findItem(trash))
          sleep(1000)
        end
    end
end

function harvest()
    bot:say(getRandomKata(List_kata))
    posBotY = math.floor(getLocal().posy/32)
    for _, tile in pairs(world:getTiles()) do
        while world:getTile(tile.x,posBotY).fg == SEED_ID and world:getTile(tile.x,posBotY):canHarvest() and inv:getItemCount(BLOCK_ID) <= 180 do
        cekKoneksi()
        bot:findPath(tile.x, posBotY)
        sleep(DELAY_HARVEST)
        punch(0, 0)
        sleep(DELAY_HARVEST)
        bot:collect(2)
        sleep(DELAY_HARVEST)
        end 
    end
    bot:collect(2)
    sleep(500)
end

function plant()
    bot:say(getRandomKata(List_kata))
    posBotY = math.floor(getLocal().posy/32)
    for _, tile in pairs(world:getTiles()) do
        while world:getTile(tile.x,posBotY).fg == 0 and world:getTile(tile.x,posBotY+1).fg ~= 0 and world:getTile(tile.x,posBotY+1).fg ~= SEED_ID and inv:findItem(SEED_ID) > 0 do
        cekKoneksi()
        bot:findPath(tile.x, posBotY)
        sleep(DELAY_PLANT)
        pasang(0, 0, SEED_ID)
        sleep(DELAY_PLANT)
        end 
    end
end

function grindWheat()
    for _, tile in pairs(world:getTiles()) do
        if world:getTile(tile.x,tile.y).fg == 4582 then
            cekKoneksi()
            bot:findPath(tile.x,tile.y+1)
            sleep(100)
            pasang(0,-1,880)
            sleep(800)
            bot:sendPacket(2, "action|dialog_return\ndialog_name|grinder\ntilex|"..tile.x.."|\ntiley|"..tile.y.."|\nitemID|880|\ncount|3")
            sleep(500)
            break
        end
    end
end

function goPatokan()
    posBotY = math.floor(getLocal().posy/32)
    for _, tile in pairs(world:getTiles()) do
        if world:getTile(tile.x,posBotY).fg == PATOKAN then
            cekKoneksi()
            bot:findPath(tile.x,posBotY)
            break
        end
    end
end

function PNB()
    webhooks(LINK_WEBHOOK, ID_MESSAGE)
    cekKoneksi()
    posBreakX = math.floor(getLocal().posx/32)
    posBreakY = math.floor(getLocal().posy/32)
    while inv:findItem(BLOCK_ID) > 0 do
        if world:getTile(posBreakX-1,posBreakY).fg == 0 or world:getTile(posBreakX-1,posBreakY).bg == 0 then
            pasang(-1,0,BLOCK_ID)
            sleep(DELAY_PLACE)
        end
        cekKoneksi()
        while world:getTile(posBreakX-1,posBreakY).fg ~= 0 or world:getTile(posBreakX-1,posBreakY).bg ~= 0 do
            punch(-1,0)
            sleep(DELAY_BREAK)
            bot:collect(2)
        end
    end
    trasher()
end

function CheckEmptyTile()
    posBotY = math.floor(getLocal().posy/32)
    m=0
        for _,tile in pairs(world:getTiles()) do
            if world:getTile(tile.x,posBotY).fg == 0 and world:getTile(tile.x,posBotY+1).fg ~= 0 then
                m = m + 1
            end
        end
    return m
end

function dropFlour()
    Reconnect(WORLD_STORAGE[1],WORLD_STORAGE[2])
    bot.auto_collect = false
    if bot:isInWorld(WORLD_STORAGE[1]) then
        sleep(200)
        bot:moveTo(1,0)
        sleep(500)
        bot:drop(4562,inv:getItemCount(4562))
        sleep(500)
        while inv:getItemCount(4562) > 0 do
            bot:moveTo(1,0)
            sleep(200)
            bot:drop(4562,inv:getItemCount(4562))
            sleep(500)
        end
        CURRENT_RESULT = gscan(4562)
        webhooks(LINK_WEBHOOK, ID_MESSAGE)
    else
        dropFlour()
    end
end

function dropSeed()
    Reconnect(WORLD_STORAGE[1],WORLD_STORAGE[2])
    bot.auto_collect = false
    if bot:isInWorld(WORLD_STORAGE[1]) then
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
        CURRENT_RESULT = gscan(SEED_ID)
        webhooks(LINK_WEBHOOK, ID_MESSAGE)
    else
        dropSeed()
    end
end

function dropPack()
    Reconnect(WORLD_PACK[1],WORLD_PACK[2])
    while not bot:isInWorld(WORLD_PACK[1]) do
        dropPack()
    end
    sleep(200)
    while bot.gem_count >= PRICE_PACK do
        bot:buy(NAME_PACK)
        sleep(1500)
    end
    bot:moveTo(1, 0)
    sleep(500)
    for i = 1, #ID_PACK do
        bot:drop(ID_PACK[i], inv:getItemCount(ID_PACK[i]))
        sleep(500)
        while inv:getItemCount(ID_PACK[i]) > 0 do
            bot:findPath(math.floor(getLocal().posx/32), math.floor(getLocal().posy/32) - math.floor(gscan(ID_PACK[i])/2000))
            sleep(500)
            bot:drop(ID_PACK[i], inv:getItemCount(ID_PACK[i]))
            sleep(500)
        end
        bot:findPath(math.floor(getLocal().posx/32), math.floor(getLocal().posy/32) + math.floor(gscan(ID_PACK[i])/2000))
        sleep(500)
        webhooks(LINK_WEBHOOK, ID_MESSAGE)
        sleep(1000)
        bot:moveTo(1, 0)
    end
    sleep(100)
    Reconnect(WORLD_PABRIK[1],WORLD_PABRIK[2])
    sleep(100)
    baris()
    sleep(100)
end

function storeFlour()
    if CheckEmptyTile() == 0 and inv:findItem(SEED_ID) > 0 and inv:findItem(BLOCK_ID) >= 150 then
        grindWheat()
        sleep(100)
        dropFlour()
        sleep(100)
        Reconnect(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(100)
        baris()
        sleep(100)
    end
    if BUY_PACK then
        if UPGRADE_BP then
            if bot.gem_count >= 500 then
                while inv.slotcount <= 26 do
                    bot:buy("upgrade_backpack")
                    sleep(1500)
                end
            end
        end
        if bot.gem_count >= PRICE_PACK then
            dropPack()
        end
    end
end

function storeSeed()
    if CheckEmptyTile() == 0 and inv:findItem(SEED_ID) > 0 then
        dropSeed()
        sleep(100)
        Reconnect(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(100)
        baris()
        sleep(100)
    end
    if BUY_PACK then
        if UPGRADE_BP then
            if bot.gem_count >= 500 then
                while inv.slotcount <= 26 do
                    bot:buy("upgrade_backpack")
                    sleep(1500)
                end
            end
        end
        if bot.gem_count >= PRICE_PACK then
            dropPack()
        end
    end
end

function takePickaxe()
    Reconnect(WORLD_PICKAXE[1],WORLD_PICKAXE[2])
    sleep(3000)
    while not bot:isInWorld(WORLD_PICKAXE[1]) do
        takePickaxe()
    end
    bot:collect(2)
    sleep(1000)
    if inv:getItemCount(98) > 1 then
        bot:wear(98)
    elseif inv:getItemCount(98) == 0 then
        takePickaxe()
    end
    sleep(1000)
    while inv:getItemCount(98) > 1 do
        bot:drop(98, inv:getItemCount(98) - 1)
        sleep(1000)
    end
end

function start()
    sleep((INDEX_SLOT - 1) * 500)
    if TAKE_PICKAXE and inv:getItemCount(98) < 1 then
        sleep((INDEX_SLOT - 1) * 3000)
        takePickaxe()
    end
    Reconnect(WORLD_PABRIK[1],WORLD_PABRIK[2])
    sleep(1000)
    while not bot:isInWorld(WORLD_PABRIK[1]) do
        Reconnect(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(1000)
    end
    webhooks(LINK_WEBHOOK, ID_MESSAGE)
    baris()
end

function mainSeed()
    while true do
        harvest()
        sleep(500)
        plant()
        sleep(500)
        goPatokan()
        sleep(500)
        while inv:findItem(BLOCK_ID) > 0 do
            bot.ignore_gems = false
            PNB()
            if IGNORE_GEMS then
                bot.ignore_gems = true
            else
                bot.ignore_gems = false
            end
        end
        sleep(500)
        storeSeed()
        sleep(500)
    end
end

function mainFlour()
    while true do
        harvest()
        sleep(500)
        plant()
        sleep(500)
        storeFlour()
        sleep(500)
        goPatokan()
        sleep(500)
        while inv:findItem(BLOCK_ID) > 0 do
            bot.ignore_gems = false
            PNB()
            if IGNORE_GEMS then
                bot.ignore_gems = true
            else
                bot.ignore_gems = false
            end
        end
    end
end

start()
if MODE == "FACTORY_SEED" then
    mainSeed()
elseif MODE == "FACTORY_FLOUR" then
    mainFlour()
end

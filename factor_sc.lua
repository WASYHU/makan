-------------------------
bot = getBot()
BLOCK_ID = SEED_ID-1

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

FACTORY_MODE = FACTORY_MODE:upper()
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
    local txt = txt:upper()
    print("=============================\nMODE FAC : "..FACTORY_MODE.."\nNAME BOT : "..bot.name.."\nACTIVITY : "..txt)
end

function collectSet(they, want)
    lp("change set collect")
    bot.auto_collect = they
    bot.collect_range = want
end

function wd()
    if bot:getWorld():getTile(math.floor(getLocal().posx/32), math.floor(getLocal().posy/32)).fg == 6 then
      return true
    end
    return false
end

function warp(a,b)
    if bot.status == 1 and bot:getWorld().name:upper() ~= a:upper() then
        lp("joining world "..a)
        bot:warp(a,b)
        sleep(DELAY_WARP)
    end
    if bot:isInWorld(a:upper()) then
        if wd() then
            lp("joining world "..a)
            bot:warp(a,b)
            sleep(DELAY_WARP)
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
        bot:disconnect()
        sleep(15000)
        if bot.status ~= 1 then
            while bot.status ~= 1 do
                bot:connect()
                sleep(30000)
            end
        end
    end
    if bot.status == 1 and wd() then
        warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
        sleep(500)
        if bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).fg ~= PATOKAN or bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).bg ~= PATOKAN then
            baris()
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

function punch(a,b)
    if bot.status == 1 then
    bot:hit(math.floor(getLocal().posx/32)+a,math.floor(getLocal().posy/32)+b)
    end
    if wd() then
        ck()
    end
end

function place(a,b,id)
    if bot.status == 1 then
    bot:place(math.floor(getLocal().posx/32)+a,math.floor(getLocal().posy/32)+b,id)
    end
    if wd() then
        ck()
    end
end

function gscan(ids)
    gs = 0
    for _, obj in pairs(bot:getWorld():getObjects()) do
        if obj.id == ids then 
            gs = gs + obj.count
        end
    end
    return gs
end

function CheckEmptyTile()
    m=0
        for _,tile in pairs(getTiles()) do
            if tile.y == math.floor(getLocal().posy/32) and bot:getWorld():getTile(tile.x,tile.y).fg == 0 and bot:getWorld():getTile(tile.x,tile.y+1).fg ~= 0 then
                m = m + 1
            end
        end
    return m
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
    wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/4562.png"
    for _, botInfo in ipairs(botData) do
        local description = string.format("<:growbot:992058196439072770> `Level  : %s `\n<:monitor_oxy:978016089227268116> `Status :` %s \n<:world_generation:937567566656843836> `World  :` ||HIDDEN||", botInfo.level, botInfo.description)
        wh.embed1:addField(
            string.format("<:birth_certificate:1011929949076193291> **%s**", botInfo.name),
            description,
            true
        )
    end
    wh.embed1.color = math.random(1000000, 9999999)
    wh.embed1:addField("", "", false)
    wh.embed1:addField("Online Bots",">>> " .. onlineCount, true)
    wh.embed1.footer.text = webhookDate()
    wh.embed1.footer.icon_url = "https://cdn.growtopia.tech/items/4562.png"
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

trashList = {882,1406,9346,5040,5042,5044,5032,5034,5036,5038,5024,5026,5028,7162,7164}
function trasher()
    lp("trashing item")
    for i, trashs in ipairs(trashList) do
        if bot:getInventory():findItem(trashs) > 1 and wd() == false then
            if wd() then
                warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
            end
            bot:trash(trashs)
            sleep(1000)
            bot:trash(trashs,bot:getInventory():findItem(trashs))
            sleep(1000)
        end
    end
end

function dropSeed()
    lp("drop seed")
    if bot.auto_collect == true then
        collectSet(false, 2)
    end
    sleep(1000)
    warp(WORLD_STORAGE[1],WORLD_STORAGE[2])
    if bot:isInWorld(WORLD_STORAGE[1]) and wd() == false and bot:getInventory():findItem(SEED_ID) > 0 then
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
            if wd() then
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
    if bot.auto_collect == true then
        collectSet(false, 2)
    end
    sleep(1000)
    warp(WORLD_STORAGE[1],WORLD_STORAGE[2])
    if bot:isInWorld(WORLD_STORAGE[1]) and wd() == false and bot:getInventory():findItem(4562) > 0 then
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
            if wd() then
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
    if bot.auto_collect == true then
        collectSet(false, 2)
    end
    sleep(1000)
    warp(WORLD_PACK[1],WORLD_PACK[2])
    if bot:isInWorld(WORLD_PACK[1]) then
        sleep(500)
        while bot.gem_count >= PRICE_PACK do
            bot:buy(NAME_PACK)
            sleep(3000)
        end
        bot:moveRight()
        sleep(500)
        for i = 1, #ID_PACK do
            bot:drop(ID_PACK[i], bot:getInventory():findItem(ID_PACK[i]))
            sleep(500)
            while bot:getInventory():findItem(ID_PACK[i]) > 0 do
                if wd() then
                    warp(WORLD_PACK[1],WORLD_PACK[2])
                end
                bot:findPath(math.floor(getLocal().posx/32), math.floor(getLocal().posy/32) - math.ceil(gscan(ID_PACK[i])/4000))
                sleep(500)
                bot:drop(ID_PACK[i], bot:getInventory():findItem(ID_PACK[i]))
                sleep(500)
            end
            bot:findPath(math.floor(getLocal().posx/32), math.floor(getLocal().posy/32) + math.ceil(gscan(ID_PACK[i])/4000))
            sleep(1000)
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
    if bot.auto_collect == false then
        collectSet(true, 2)
    end
    for i, tile in ipairs(getTiles()) do
        if tile.y == math.floor(getLocal().posy/32) and bot.status == 1 and tile.fg == SEED_ID and tile:canHarvest() and bot:getInventory():findItem(BLOCK_ID) <= 180 then
            bot:findPath(tile.x, tile.y)
            sleep(DELAY_HARVEST)
            punch(0, 0)
            sleep(DELAY_HARVEST)
            while 0 == bot:getWorld():getTile(tile.x, tile.y).fg and HT_WITH_PT and bot:getInventory():findItem(SEED_ID) > 0 do
                place(0,0,SEED_ID)
                sleep(DELAY_PLANT)
            end
        end
    end
end

function plant()
    lp("planting")
    sleep(100)
    for i, tile in ipairs(getTiles()) do
        if tile.y == math.floor(getLocal().posy/32) and bot.status == 1 and tile.fg == 0 and bot:getWorld():getTile(tile.x, tile.y + 1).fg ~= 0 and bot:getWorld():getTile(tile.x, tile.y + 1).fg ~= SEED_ID and bot:getInventory():findItem(SEED_ID) > 0 then
            bot:findPath(tile.x, tile.y)
            place(0,0,SEED_ID)
            sleep(DELAY_PLANT)
        end
    end
end

function grinder()
    if bot.status == 1 and bot:getInventory():findItem(SEED_ID) > 0 and bot:getInventory():findItem(BLOCK_ID) >= 150 and wd() == false then
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
        if bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).fg ~= PATOKAN or bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).bg ~= PATOKAN then
            baris()
        end
        sleep(1000)
    end
end

function starting()
    bot:getLog():clear()
    sleep((INDEX_SLOT - 1) * 500)
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
    if bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).fg ~= PATOKAN or bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).bg ~= PATOKAN then
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

start = true
while true do
    if start then
        starting()
        sleep(1000)
        writeToFile("total_result.txt", tostring(CURRENT_RESULT))
    end
    ---------------------------------pabrik(flour)---------------------------------
    if pabrik then
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
                while inv.slotcount <= TARGET_BP do
                    bot:buy("upgrade_backpack")
                    sleep(1500)
                end
            end
        end
        if BUY_PACK then
            if bot.gem_count >= PRICE_PACK then
                dropPack()
                sleep(1000)
                warp(WORLD_PABRIK[1],WORLD_PABRIK[2])
            end
        end
        sleep(1000)
        if bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).fg ~= PATOKAN or bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).bg ~= PATOKAN then
            baris()
            sleep(1000)
        end
        bot.ignore_gems = false
        lp("pnb")
        if bot.auto_collect == false then
            collectSet(true, 2)
        end
        while bot.status == 1 and wd() == false and bot:getInventory():findItem(BLOCK_ID) > 0 do
            if bot.status == 1 and bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).fg == 0 or bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).bg == 0 then
                place(-1,0,BLOCK_ID)
                sleep(DELAY_PLACE)
                while bot.status == 1 and bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).fg > 0 or bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).bg > 0 and wd() == false do
                    punch(-1, 0)
                    sleep(DELAY_BREAK)
                end
            end
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
        if bot:getInventory():findItem(BLOCK_ID) < 1 then
            harvest()
            sleep(1000)
        end
        if bot:getInventory():findItem(SEED_ID) > 0 then
            plant()
            sleep(1000)
        end
        if bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).fg ~= PATOKAN or bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).bg ~= PATOKAN then
            baris()
            sleep(1000)
        end
        bot.ignore_gems = false
        lp("pnb")
        if bot.auto_collect == false then
            collectSet(true, 2)
        end
        while bot.status == 1 and wd() == false and bot:getInventory():findItem(BLOCK_ID) > 0 do
            if bot.status == 1 and bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).fg == 0 or bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).bg == 0 then
                place(-1,0,BLOCK_ID)
                sleep(DELAY_PLACE)
                while bot.status == 1 and bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).fg > 0 or bot:getWorld():getTile(math.floor(getLocal().posx/32)-1,math.floor(getLocal().posy/32)).bg > 0 and wd() == false do
                    punch(-1, 0)
                    sleep(DELAY_BREAK)
                end
            end
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
            if bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).fg ~= PATOKAN or bot.status == 1 and wd() == false and bot:getWorld():getTile(math.floor(getLocal().posx/32),math.floor(getLocal().posy/32)).bg ~= PATOKAN then
                baris()
                sleep(1000)
            end
            if UPGRADE_BP then
                if bot.gem_count >= 500 then
                    while inv.slotcount <= TARGET_BP do
                        bot:buy("upgrade_backpack")
                        sleep(1500)
                    end
                end
            end
            if BUY_PACK then
                if bot.gem_count >= PRICE_PACK then
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

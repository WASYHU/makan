---- script ----
bot = getBot()
world = bot:getWorld()
idWorld = idWorld:upper()
worldTakeSet = worldTakeSet:upper()
idWorldTake = idWorldTake:upper()
worldDropFossil = worldDropFossil:upper()
idWorldDrop = idWorldDrop:upper()
CURRENT_RESULT = 0
START = 0
STOP = #listWorld
bot.move_range = 2
bot.move_interval = 100
bot.collect_path_check = true

function botleg(xxx)
	if xxx == BotStatus.online then
		return "Online"
	elseif xxx == BotStatus.offline then
		return "Offline"
	elseif xxx == BotStatus.wrong_password then
		return "Wrong Password"
	elseif xxx == BotStatus.account_banned then
		return "Account Banned"
	elseif xxx == BotStatus.location_banned then
		return "Location Banned"
	elseif xxx == BotStatus.version_update then
		return "Version Update"
	elseif xxx == BotStatus.advanced_account_protection then
		return "Advanced Account Protection"
	elseif xxx == BotStatus.server_overload then
		return "Server Overload"
	elseif xxx == BotStatus.too_many_login then
		return "Too Many Login"
	elseif xxx == BotStatus.maintenance then
		return "Maintenance"
	elseif xxx == BotStatus.http_block then
		return "Http Block"
	elseif xxx == BotStatus.captcha_requested then
		return "Captcha Requested"
	else 
		return "-"
	end
end

function sendHook()
    wh = Webhook.new(linkWebhooks)
	wh.username = "[NOWADAYS-SCHOOL]"
	wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
	wh.embed1.use = true
	wh.embed1.title = "AUTO FOSSIL LOGS!"
    wh.embed1.description = "<===========================>\n<:mp:996717372574539846> **| Information Bots :** \n<===========================>\n<:growbot:992058196439072770> **| GROWID :** "..bot.name.."\n<:monitor_oxy:978016089227268116> **| STATUS :** "..botleg(bot.status).."\n<:growbot:992058196439072770> **| LEVEL :** "..bot.level.."\n<:gems:994218103032520724> **| GEMS :** "..bot.gem_count.."\n\n<===========================>\n<:mp:996717372574539846> **| Information World :** \n<===========================>\n<:globez:1011929997679796254> **| WORLD :** ||"..world.name:upper().."||\n<:globez:1011929997679796254> **| PROGRESS WORLD :** "..START.."/"..STOP.."\n<:fossilrock:1064165167992156240> **| FOSSIL WORLD :** "..scanFossil().."\n<:fossilrock:1064165167992156240> **| DROPED FOSSIL :** "..tonumber(readFromFile("result.txt"))
    wh.embed1.color = math.random(1000000,9999999)
	wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/4134.png"
    if editedWebhooks then
        wh:edit(idMessage)
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
    local file = io.open(filePath, "w+")
    if file then
        file:write(content)
        file:close()
    end
end

function whitedoor()
    if bot:getWorld():getTile(bot.x, bot.y).fg == 6 then
        return true
    end
    return false
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

function warp(a,b)
    if bot.status == 1 and bot:getWorld().name:upper() ~= a:upper() then
        m = 0
        while bot:getWorld().name:upper() ~= a:upper() do
            m = m + 1
            bot:warp(a,b)
            sleep(7000)
            if m > 1 and world.name:upper() == "EXIT" then
                return
            end
            if m > 3 then
                bot.auto_reconnect = false
                m = 0
                sleep(1000)
                bot:disconnect()
                sleep(1000*60*2)
                if bot.status ~= 1 then
                    while bot.status ~= 1 do
                        bot:connect()
                        sleep(30000)
                    end
                    bot.auto_reconnect = true
                end
            end
        end
    end
    if bot:getWorld().name:upper() == a:upper() then
        wd = 0
        while whitedoor() do
            wd = wd + 1
            bot:warp(a,b)
            sleep(7000)
            if wd > 1 then
                return
            end
        end
    end
end

function hookfossil(varlist, netid) -- Using the variantlist event parameters. You can view them from enums.md
    if varlist:get(0):getString() == "OnTalkBubble" then
    ontext = varlist:get(2):getString()
        if ontext:match("`2I unearthed a Fossil!`` I better be careful getting it out...") then
            bot:wear(3934)
            sleep(200)
            while world:getTile(bot.x,bot.y+1).fg == 3918 do
                bot:hit(bot.x,bot.y+1)
                sleep(200)
            end
        end
     end
end

function goFossil()
    for _, tile in pairs(world:getTiles()) do
        if bot.status == BotStatus.online and whitedoor() == false then
            if tile.fg == 3918 and world:hasAccess(tile.x, tile.y) ~= 0 then
                bot:findPath(tile.x, tile.y-1)
                break
            end
        end
    end        
end

function dropPoli()
    while world.name ~= worldDropFossil do
        warp(worldDropFossil,idWorldDrop)
        sleep(4000)
    end
    if bot:isInWorld(worldDropFossil) and whitedoor() == false and bot:getInventory():getItemCount(4134) > 0 then
        Poli = gscan(4134)
        sleep(500)
        lastX = bot.x + math.ceil(Poli/4000)
        lastY = bot.y
        sleep(500)
        if Poli == 0 then
            bot:moveRight()
        else
            bot:findPath(lastX, lastY)
            sleep(500)
        end
        bot:drop(4134,bot:getInventory():getItemCount(4134))
        sleep(500)
        while bot:getInventory():getItemCount(4134) > 0 do
            if whitedoor() then
                warp(worldDropFossil,idWorldDrop)
            end
            bot:moveRight()
            sleep(500)
            bot:drop(4134,bot:getInventory():getItemCount(4134))
            sleep(500)
        end
    end
    CURRENT_RESULT = gscan(4134)
    previousResult = tonumber(readFromFile("result.txt")) or 0
    if CURRENT_RESULT >= previousResult then
        writeToFile("result.txt", tostring(CURRENT_RESULT))
    end
    sendHook()
end

function scanFossil()
    local m = 0
    for _,tile in pairs(world:getTiles()) do
        if bot.status == BotStatus.online then
            if tile.fg == 3918 and world:hasAccess(tile.x, tile.y) ~= 0 then
                m = m + 1
            end
        end
    end
    return m
end

function takeBahan()
    while world.name ~= worldTakeSet do
        warp(worldTakeSet,idWorldTake)
        sleep(4000)
    end
    if world.name:upper() == worldTakeSet then
        --take rock hammer
        if bot:getInventory():getItemCount(3932) < 1 then
            for _, hammer in pairs(world:getObjects()) do
                if hammer.id == 3932 then
                    hammerX = math.floor(hammer.x / 32)
                    hammerY = math.floor(hammer.y / 32)
                    bot:findPath(hammerX,hammerY)
                    sleep(500)
                    bot:collectObject(hammer.oid,2)
                    sleep(500)
                    if bot:getInventory():getItemCount(3932) >= 1 then
                        break
                    end
                end
            end
        end
        --take rock chisel
        if bot:getInventory():getItemCount(3934) < 1 then
            for _, chisel in pairs(world:getObjects()) do
                if chisel.id == 3934 then
                    chiselX = math.floor(chisel.x / 32)
                    chiselY = math.floor(chisel.y / 32)
                    bot:findPath(chiselX,chiselY)
                    sleep(500)
                    bot:collectObject(chisel.oid,2)
                    sleep(500)
                    if bot:getInventory():getItemCount(3934) >= 1 then
                        break
                    end
                end
            end
        end
    end
end

function takeBrush(xxxx)
    while world.name ~= worldTakeSet do
        warp(worldTakeSet,idWorldTake)
        sleep(4000)
    end
    if world.name:upper() == worldTakeSet then
        --take brush
        if bot:getInventory():getItemCount(4132) < 20 then
            for _, brush in pairs(world:getObjects()) do
                if brush.id == 4132 then
                    brushX = math.floor(brush.x / 32)
                    brushY = math.floor(brush.y / 32)
                    bot:findPath(brushX,brushY)
                    sleep(500)
                    bot:collectObject(brush.oid,2)
                    sleep(500)
                    if bot:getInventory():getItemCount(4132) >= 20 then
                        bot:drop(4132,bot:getInventory():getItemCount(4132)-20)
                        sleep(500)
                        break
                    end
                end
            end
        end
    end
    while world.name ~= xxxx do
        warp(xxxx,idWorld)
        sleep(4000)
    end
end

writeToFile("result.txt", tostring(CURRENT_RESULT))
for _, worlds in ipairs(listWorld) do
    START = START+1
    worlds = worlds:upper()
    warp(worlds,idWorld)
    if bot:getInventory():getItemCount(3932) < 1 or bot:getInventory():getItemCount(3934) < 1 then
        takeBahan()
        sleep(1000)
    end
    while scanFossil() ~= 0 do
        sendHook()
        if bot:getInventory():getItem(3932).isActive then
        else
            bot:wear(3932)
            sleep(1000)
        end
        if bot:getInventory():getItemCount(4132) <= 1 then
            takeBrush(worlds)
            sleep(1000)
        end
        goFossil()
        sleep(100)
        local hit = 0
        while world:getTile(bot.x,bot.y+1).fg == 3918 and hit <= 15 do
            addEvent(Event.variantlist, hookfossil)
            bot:hit(bot.x,bot.y+1)
            listenEvents(1)
            hit = hit + 1
            if hit > 15 then
                sleep(6000)
                hit = 0
            end
        end
        removeEvents()
        sleep(1000)
        bot:place(bot.x, bot.y+1, 4132)
        sleep(1000)
        for _, floatPoli in pairs(world:getObjects()) do
            if floatPoli.id == 4134 then
                bot:collect(3, 100)
                sleep(500)
                if bot:getInventory():getItemCount(10) > 0 or bot:getInventory():getItemCount(2) > 0 then
                    bot:place(bot.x, bot.y+1, 10)
                    sleep(80)
                    bot:place(bot.x,bot.y+1, 2)
                    sleep(80)
                end
            end
        end
    end
    if scanFossil() == 0 then
        sendHook()
    end
    if scanFossil() == 0 and bot:getInventory():getItemCount(4134) >= 1 then
        dropPoli()
    end
    if START == STOP then
        sendHook()
    end
end

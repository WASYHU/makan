bot = getBot()
world = bot:getWorld()
blockId = seedId - 1
aman = {}
nuket = {}
statz = "?"
START = 0
STOP = #listWorld
outputSafe = "Safe_file.txt"
outputNuked = "Nuked_file.txt"

function writeFile(xxx,aaa)
	local file = io.open(xxx, "a+")  
	file:write(aaa)
	file:close()
end  

function whitedoor()
    if bot:getWorld():getTile(bot.x, bot.y).fg == 6 then
        return true
    end
    return false
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

function readyTreeScan()
    local readyTree = 0
    for _, tile in pairs(world:getTiles()) do
        if tile.fg == seedId and tile:canHarvest() and bot.status == BotStatus.online and world:hasAccess(tile.x, tile.y) ~= 0 then
            readyTree = readyTree + 1
        end
    end
    return readyTree
end

function unreadyTreeScan()
    local readyTree = 0
    local unreadyTree = 0
    for _, tile in pairs(world:getTiles()) do
        if tile.fg == seedId and bot.status == BotStatus.online then
            if world:getTile(tile.x, tile.y):canHarvest() and world:hasAccess(tile.x, tile.y) ~= 0 then
                readyTree = readyTree + 1
            else
                unreadyTree = unreadyTree + 1
            end
        end
    end
    return unreadyTree
end

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

function sendHook(txt)
    wh = Webhook.new(linkWebhooks)
	wh.username = "[NOWADAYS-SCHOOL]"
	wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
	wh.embed1.use = true
	wh.embed1.title = "WORLD CHECKER LOGS!"
    wh.embed1.description = txt
    wh.embed1.color = math.random(1000000,9999999)
	wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/32.png"
    wh:send()
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
            sleep(delayWarp)
            if m > 1 and bot:getWorld().name:upper() == "EXIT" then
                table.insert(nuket, a)
                print("NUKED WORLD "..a)
                sendHook(a:upper().." NUKED")
                writeFile(outputNuked,a:upper().." NUKED\n")
                nukedd = true
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
            sleep(delayWarp)
            if wd > 4 then
                statz = "ID WORLD WRONG"
                return
            end
        end
    end
    statz = "ID WORLD CORRECT"
    table.insert(aman, a)
    print("SAFE WORLD "..a)
end

for i = 1 , #listWorld do
    START = START+1
    warp(listWorld[i],idWorld)
    sleep(1000)
    if not nukedd then
        writeFile(outputSafe, "<===========================>\nInformation World : \n<===========================>\nWORLD : "..world.name:upper().."\nREADY TREE : "..readyTreeScan().."\nUNREADY TREE : "..unreadyTreeScan().."\nFOSSIL WORLD : "..scanFossil().."\nFLOATING GEMS : "..gscan(112).."\nFLOATING BLOCK : "..gscan(blockId).."\nFLOATING SEED : "..gscan(seedId).."\nID DOOR : "..statz.."\n")
        sendHook("<===========================>\n<:mp:996717372574539846> **| Information Bots :** \n<===========================>\n<:birth_certificate:1011929949076193291> **| GROWID :** "..bot.name.."\n<:monitor_oxy:978016089227268116> **| STATUS :** "..botleg(bot.status).."\n<:growbot:992058196439072770> **| LEVEL :** "..bot.level.."\n<:gems:994218103032520724> **| GEMS :** "..bot.gem_count.."\n\n<===========================>\n<:mp:996717372574539846> **| Information World :** \n<===========================>\n<:globez:1011929997679796254> **| WORLD :** ||"..world.name:upper().."||\n:globe_with_meridians: **| PROGRESS WORLD :** "..START.."/"..STOP.."\n<:peppertree:999318156696887378> **| READY TREE :** "..readyTreeScan().."\n<:pepper_tree_seed:1012630107715797073> **| UNREADY TREE :** "..unreadyTreeScan().."\n<:fossilrock:1064165167992156240> **| FOSSIL WORLD :** "..scanFossil().."\n<:100gems:988942738466684978> **| FLOATING GEMS :** "..gscan(112).."\n<:peppertree:999318156696887378> **| FLOATING BLOCK :** "..gscan(blockId).."\n<:pepper_tree_seed:1012630107715797073> **| FLOATING SEED :** "..gscan(seedId).."\n:door: **| ID DOOR :** "..statz)
        sleep(1000)
    else
        nukedd = false
    end
    if START == STOP then
        writeFile(outputSafe, 'SAFE WORLD = \n{"' .. table.concat(aman, '","') .. '"}\n')
        sendHook('SAFE WORLD = \n{"' .. table.concat(aman, '","') .. '"}\n')
        print('SAFE WORLD = \n{"' .. table.concat(aman, '","') .. '"}\n')
        sleep(1000)
        writeFile(outputNuked, 'NUKED = \n{"' .. table.concat(nuket, '","') .. '"}\n')
        sendHook('NUKED = \n{"' .. table.concat(nuket, '","') .. '"}\n')
        print('NUKED = \n{"' .. table.concat(nuket, '","') .. '"}\n')
    end
end

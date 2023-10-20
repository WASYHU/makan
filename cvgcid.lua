separatorGuest = "|"
separatorEmail = ":"
macs = {}
rids = {}
emails = {}
passwords = {}
function randomChar()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    return string.char(charset:byte(math.random(1, #charset)))
end

for _, input in ipairs(list_guest) do
    local temp_mac, temp_rid = string.match(input, "(.-)" .. separatorGuest .. "(.+)")
    if temp_mac and temp_rid then
        table.insert(macs, temp_mac)
        table.insert(rids, temp_rid)
    end
end

for _, input in ipairs(list_email) do
    local temp_email, temp_password = string.match(input, "(.-)".. separatorEmail .."(.+)")
    if temp_email and temp_password then
        table.insert(emails, temp_email)
        table.insert(passwords, temp_password)
    end
end

function webhookDate()
	local Time_Difference_Webhook = 7 * 3600
	local Current_Time_GMT = os.time(os.date("!*t"))
	local Current_Time_Webhook = Current_Time_GMT + Time_Difference_Webhook
	return os.date("***%A, %B %d, %Y*** | ***%H:%M***", Current_Time_Webhook)
end

function powershell(message)
	local wh = Webhook.new(Webhook_link)
	wh.username = "[NOWADAYS-SCHOOL]"
	wh.avatar_url = "https://mystickermania.com/cdn/stickers/anime/jujutsu-kaisen-satoru-gojo-512x512.png"
	wh.embed1.use = true
	wh.embed1.title = "CV GUEST TO CID LOGS!"
	wh.embed1.description = "<:mp:996717372574539846> **|** Information : \n "..message..""..
	"\n\n"..webhookDate()
	wh.embed1.color = math.random(1000000,9999999)
	wh.embed1.thumbnail = "https://cdn.growtopia.tech/items/32.png"
	wh:send()
end

for i = 1, #macs do
    local randomStr = firstLatter
    for _= 1, latter do
        randomStr = randomStr .. randomChar()
    end
    addBot(randomStr:upper(),macs[i],rids[i])
    sleep(delay*1000)
    powershell("### Processing\nMAC = "..macs[i].."\nRID = "..rids[i].."\nEMAIL = "..emails[i])
    	if getBot(randomStr:upper()).status ~= 1 then
		while getBot(randomStr:upper()).status ~= 1 do
			getBot(randomStr:upper()):connect()
			sleep(delay*1000)
		end
	end
	if getBot(randomStr:upper()).status == 1 then
        while getBot(randomStr:upper()):getWorld().name:find("TUTORIAL") ~= nil do
            if getBot(randomStr:upper()).auto_tutorial == false then
                getBot(randomStr:upper()).auto_tutorial = true
            end
            sleep(25*1000)
        end
            getBot(randomStr:upper()):sendPacket(2, "action|growid")
            sleep(3000)
            getBot(randomStr:upper()):sendPacket(2, "action|dialog_return\ndialog_name|growid_apply\nlogon|"..randomStr:upper().."\npassword|"..setPasswordCid.."\npassword_verify|"..setPasswordCid.."\nemail|"..emails[i])
            sleep(400)
            getBot(randomStr:upper()):sendPacket(2, "action|growid")
            sleep(400)
            getBot(randomStr:upper()):sendPacket(2, "action|dialog_return\ndialog_name|growid_apply\nlogon|"..randomStr:upper().."\npassword|"..setPasswordCid.."\npassword_verify|"..setPasswordCid.."\nemail|"..emails[i])
            sleep(400)
	    getBot(randomStr:upper()):sendPacket(2, "action|dialog_return\ndialog_name|growid_apply\nlogon|"..randomStr:upper().."\npassword|"..setPasswordCid.."\npassword_verify|"..setPasswordCid.."\nemail|"..emails[i])
            sleep(4000)
            getBot(randomStr:upper()):updateBot(randomStr:upper(),setPasswordCid)
        sleep(delay*1000)
    end
    if getBot(randomStr:upper()).status == 6 then
        powershell("### CID Need AAP!!\n\nGrowID = "..randomStr:upper().."\nPassword = ||"..setPasswordCid.."||\nEmail = "..emails[i].."\nPassword Email = "..passwords[i].."\nSAVE AT AAP.txt")
        local file = io.open("AAP.txt", "a")
        if file then
        file:write([["]]..randomStr:upper()..[[|]]..setPasswordCid..[[",
]])
            file:close()
        end
    end
    removeBot(randomStr:upper())
end

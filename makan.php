--LO KONTOL
function place(id,x,y)
    pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end
function punch(x,y)
    local pkt = {}
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y 
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    SendPacketRaw(false,pkt)
end
local function findItem(id)
    for _, itm in pairs(GetInventory()) do
        if itm.id == id then
            return itm.amount
        end    
    end
    return 0
end
function rice()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 4618 or tile.fg == 4498 or tile.fg == 4620 then
            FindPath(tile.x,tile.y,50)
            Sleep(150)
            SendPacket(2, "action|dialog_return\ndialog_name|homeoven_edit\nx|" .. math.floor(GetLocal().pos.x / 32) .. "|\ny|" .. math.floor(GetLocal().pos.y /32) .. "|\ncookthis|3472|\nbuttonClicked|low")
            Sleep(150)
        end
    end
end

function onion()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 4618 or tile.fg == 4498 or tile.fg == 4620 then
            FindPath(tile.x,tile.y,50)
            Sleep(100)
            place(4602,0,0) --onion
            Sleep(150)
            place(4588,0,0) --chicken
            Sleep(100)
        end
    end
end

function tomat()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 4618 or tile.fg == 4498 or tile.fg == 4620 then
            FindPath(tile.x,tile.y,50)
            Sleep(150)
            place(962,0,0) --onion
            Sleep(150)
        end
    end
end

function ambil()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 4618 or tile.fg == 4498 or tile.fg == 4620 then
            FindPath(tile.x,tile.y,50)
            Sleep(150)
            punch(0,0)
            Sleep(150)
        end
    end
end

function findgrinder()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 4582 then 
            FindPath(tile.x,tile.y,50)
            break
        end
    end
end

function tambahan()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 4618 or tile.fg == 4498 or tile.fg == 4620 then
            FindPath(tile.x,tile.y,50)
            Sleep(100)
            place(4568,0,0) -- salt
            Sleep(150)
            place(4570,0,0) -- pepper
            Sleep(150)
            place(4570,0,0) -- pepper
            Sleep(100)
        end
    end
end

function findcuttingkanan()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 3470 then
            FindPath(tile.x+1,tile.y,50)
            break
        end
    end
end

function findcuttingkiri()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 3470 then
            FindPath(tile.x-1,tile.y,50)
            break
        end
    end
end

local function drop(id)
SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|"..id.."|\nitem_count|"..findItem(id))
end
function trash(id)
    SendPacket(2, "action|dialog_return\ndialog_name|trash\nitem_trash|"..id.."|\nitem_count|"..findItem(id))
end
function move(x,y)
    FindPath(math.floor(GetLocal().pos.x /32+x),math.floor(GetLocal().pos.y /32+y),50)
end
function IsReady(tile)
if tile and tile.extra and tile.extra.progress and tile.extra.progress == 1.0 then
return true
end
return false
end

AddHook("onvariant", "hook", function(var)
if var[0] == "OnDialogRequest" and var[1]:find("end_dialog|homeoven_edit") then
return true
end
if var[0] == "OnDialogRequest" and var[1]:find("end_dialog|item_finder") then
return true
end
return false
end)

function plantfoliage()
    while findItem(4602) < 30 do
        while findItem(455) < 1 do
            SendPacket(2, "action|dialog_return\ndialog_name|item_search\n454|0\n455|1")
            Sleep(1000)
        end
        while findItem(1105) < 1 do
            SendPacket(2,"action|dialog_return\ndialog_name|item_search\n1104|0\n1105|1\n7226|0\n7227|0\n7448|0\n7449|0\n8932|0\n8933|0")
            Sleep(1000)
        end
        for x= 60,60 do
            FindPath(x,24)
            Sleep(100)
            while GetTile(x,24).fg == 0 and findItem(1105) > 0 do
                place(1105,0,0)
                Sleep(10)
            end
            while GetTile(x,24).fg == 1105 and findItem(455) > 0 do
                place(455,0,0)
                Sleep(10)
            end
            while GetTile(x,24).fg == 4603 and not IsReady(GetTile(x,24)) do
            place(1062,0,0)
            Sleep(10)
            end
            while GetTile(x,24).fg == 4603 and IsReady(GetTile(x,24)) do
                punch(0, 0)
                Sleep(100)
            end
        end
    end
end
function taketomato()
    for _, obj in pairs(GetObjectList()) do
        if obj.id == 926 then
            local x = math.floor(obj.pos.x / 32)
            local y = math.floor(obj.pos.y / 32)
            FindPath(x,y,100)
            break
        end
    end
end

function find()
    SendPacket(2, "action|dialog_return\ndialog_name|item_search\n1096|1\n1098|1\n1828|1\n1656|0")
end

function drop2()
    while findItem(1096) > 1 do
        SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|1096|\nitem_count|250")
        Sleep(1000)
    end
    while findItem(1098) > 1 do
        SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|1098|\nitem_count|250")
        Sleep(1000)
    end
    while findItem(1828) > 1 do
        SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|1828|\nitem_count|250")
        Sleep(1000)
    end
end

function drop1()
    while findItem(1096) > 1 do
        SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|1096|\nitem_count|250")
        Sleep(1000)
    end
    while findItem(1098) > 1 do
        SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|1098|\nitem_count|250")
        Sleep(1000)
    end
    while findItem(1056) > 1 do
        SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|1056|\nitem_count|"..findItem(1056))
        Sleep(1000)
    end
end
function crateugs()
    while findItem(1062) < 30 do
        if GetLocal().isleft then
            findovenkiri()
            find()
            drop2()
            Sleep(100)
            punch(-1,0)
            Sleep(500)
            punch(-1,0)
            Sleep(500)
            move(-1,0)
            Sleep(1000)
            move(1,0)
            Sleep(500)
            find()
            Sleep(100)
            drop1()
            Sleep(500)
            punch(-1,0)
            Sleep(500)
            punch(-1,0)
            Sleep(1000)
            move(-1,0)
            Sleep(500)
            move(1,0)
            Sleep(500)
        else
            findovenkanan()
            find()
            drop2()
            Sleep(100)
            punch(1,0)
            Sleep(500)
            punch(1,0)
            Sleep(500)
            move(1,0)
            Sleep(1000)
            move(-1,0)
            Sleep(500)
            find()
            Sleep(100)
            drop1()
            Sleep(500)
            punch(1,0)
            Sleep(500)
            punch(1,0)
            Sleep(1000)
            move(1,0)
            Sleep(500)
            move(-1,0)
            Sleep(500)
        end
    end
end
function findovenkiri()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 952 then
            FindPath(tile.x+1,tile.y,100)
            break
        end
    end
end

function findovenkanan()
    for _, tile in pairs(GetTiles()) do
        if tile.fg == 952 then
            FindPath(tile.x-1,tile.y,100)
            break
        end
    end
end

function move(x,y)
    FindPath(math.floor(GetLocal().pos.x /32+x),math.floor(GetLocal().pos.y /32+y),50)
end

while true do
    while findItem(4568) < 30 do
        findgrinder()
        SendPacket(2,"action|dialog_return\ndialog_name|item_search\n4566|1\n4567|0")
        Sleep(100)
        if findItem(4566) > 200 then
            SendPacket(2,"action|dialog_return\ndialog_name|grinder\nx|"..math.floor(GetLocal().pos.x / 32).."|\ny|"..math.floor(GetLocal().pos.y / 32).."|\nitemID|4566|\namount|2")
            Sleep(4000)
        elseif findItem(4566) > 100 then
            SendPacket(2,"action|dialog_return\ndialog_name|grinder\nx|"..math.floor(GetLocal().pos.x / 32).."|\ny|"..math.floor(GetLocal().pos.y / 32).."|\nitemID|4566|\namount|1")
            Sleep(4000)
        end
        LogToConsole("`4found "..findItem(4568).." salt")
    end
    if findItem(4568) > 30 and findItem(4566) > 0 then
        if findItem(4566) > 0 then
            trash(4566)
            Sleep(1000)
        end
    end
    while findItem(4570) < 60 do
        findgrinder()
        SendPacket(2,"action|dialog_return\ndialog_name|item_search\n4584|1\n4585|0")
        Sleep(100)
        if findItem(4584) > 200 then
            SendPacket(2,"action|dialog_return\ndialog_name|grinder\nx|"..math.floor(GetLocal().pos.x / 32).."|\ny|"..math.floor(GetLocal().pos.y / 32).."|\nitemID|4584|\namount|2")
            Sleep(4000)
        elseif findItem(4584) > 100 then
            SendPacket(2,"action|dialog_return\ndialog_name|grinder\nx|"..math.floor(GetLocal().pos.x / 32).."|\ny|"..math.floor(GetLocal().pos.y / 32).."|\nitemID|4584|\namount|1")
            Sleep(4000)
        end
        LogToConsole("`4found "..findItem(4570).." pepper")
    end
    if findItem(4570) > 60 and findItem(4584) > 0 then
            if findItem(4584) > 0 then
                trash(4584)
                Sleep(1000)
            end
        end
    while findItem(3472) < 30 do
        SendPacket(2,"action|dialog_return\ndialog_name|item_search\n3010|0\n3011|0\n3472|1\n3473|0\n3976|0\n3977|0\n3980|0\n3981|0\n3982|0\n3983|0\n4008|0\n4009|0\n4012|0\n4013|0\n4014|0\n4015|0\n4040|0\n4041|0\n4044|0\n4045|0\n4046|0\n4047|0\n4072|0\n4073|0\n4076|0\n4077|0\n4078|0\n4079|0\n11276|0\n11277|0\n11278|0\n11279|0\n12588|0\n12589|0")
        Sleep(1000)
    end
    while findItem(4588) < 30 do
        if GetLocal().isleft then
            findcuttingkanan()
            SendPacket(2, "action|dialog_return\ndialog_name|item_search\n872|1\n873|0\n4588|0\n4589|0\n5018|0\n5019|0\n5022|0\n5023|0\n8482|0\n8483|0")
            Sleep(1000)
            drop(872)
            Sleep(1000)
            while findItem(872) > 0 do
                drop(872)
                Sleep(1000)
            end
            punch(-1,0)
            Sleep(1000)
            move(-1,0)
            Sleep(1000)
        else 
            findcuttingkiri()
            SendPacket(2, "action|dialog_return\ndialog_name|item_search\n872|1\n873|0\n4588|0\n4589|0\n5018|0\n5019|0\n5022|0\n5023|0\n8482|0\n8483|0")
            Sleep(1000)
            drop(872)
            Sleep(1000)
            while findItem(872) > 0 do
                drop(872)
                Sleep(1000)
            end
            punch(1,0)
            Sleep(1000)
            move(1,0)
            Sleep(1000)
        end
    end
crateugs()
plantfoliage()
Sleep(2000)
taketomato()
rice() --9000
Sleep(24700)
onion() --10500
--44200
Sleep(25800)
tomat() --9000
Sleep(150)
tambahan() --15000
Sleep(3400)
ambil()
end

function log(txt)
    LogToConsole("`0[`^ALFIRST-STORE`0]`#: "..txt)
end
--
function isReady(tile)
    if tile and tile.extra and tile.extra.progress and tile.extra.progress == 1.0 then
    return true
    end
return false
end
--
function pake(id)
    for _, itm in pairs(GetInventory()) do
    if itm.id == id and itm.flags == 1 then
    return true
    end
    end
return false
end

function wear(id)
    if pake(id) then
    return end
    pkt = {}
    pkt.value = id
    pkt.type = 10
    SendPacketRaw(false,pkt)
end
--
function findItem(id)
    for _, itm in pairs(GetInventory()) do
    if itm.id == id then
    return itm.amount
    end
    end
return 0
end
--
function punchray(x, y)
    pkt = {}
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
    state = {4196896,16779296}
    for _, st in ipairs(state) do
        hld = {}
        hld.px = x
        hld.py = y
        hld.type = 0
        hld.value = 0
        hld.x = GetLocal().pos.x
        hld.y = GetLocal().pos.y
        hld.state = st
        SendPacketRaw(false,hld)
    end
    Sleep(50)
end
--
function punch(x, y)
    pkt = {}
    pkt.type = 3
    pkt.value = 18
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    SendPacketRaw(false, pkt)
end
--
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
--
function wrench(x,y)
    pkt = {}
    pkt.type = 3
    pkt.value = 32
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end
--
function cchat(txt)
    local v = {}
    v[0] = "OnTalkBubble"
    v[1] = GetLocal().netid
    v[2] = txt
    SendVariantList(v)
end
--
function drop(id, count)
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            if id < 13670 then
                local dropCount = count or inv.amount
                SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|"..id.."|\nitem_count|"..dropCount)
            else
                if id % 2 == 1 then
                    local dropCount = count or inv.amount
                    local idDrop = 13670 - id + 2
                    SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|"..idDrop.."|\nitem_count|"..dropCount)
                else
                    local dropCount = count or inv.amount
                    local idDrop = 13670 - id
                    SendPacket(2, "action|dialog_return\ndialog_name|drop\nitem_drop|"..idDrop.."|\nitem_count|"..dropCount)
                end
            end
        end
    end
end
--
function trash(id, count)
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            if id < 13670 then
                local trashCount = count or inv.amount
                SendPacket(2, "action|dialog_return\ndialog_name|trash\nitem_trash|"..id.."|\nitem_count|"..trashCount)
            else
                if id % 2 == 1 then
                    local trashCount = count or inv.amount
                    local idDrop = 13670 - id + 2
                    SendPacket(2, "action|dialog_return\ndialog_name|trash\nitem_trash|"..idDrop.."|\nitem_count|"..trashCount)
                else
                    local trashCount = count or inv.amount
                    local idDrop = 13670 - id
                    SendPacket(2, "action|dialog_return\ndialog_name|trash\nitem_trash|"..idDrop.."|\nitem_count|"..trashCount)
                end
            end
        end
    end
end
--
function getObjects()
    local old_obj = GetObjectList()
    local ret_obj = {}
    for _, v in pairs(old_obj) do table.insert(ret_obj, v) end
    table.sort(ret_obj, function(left, right)
    return
    (left.pos.y < right.pos.y) or
    (left.pos.y == right.pos.y and left.pos.x < right.pos.x)
    end)
    return ret_obj
end
--
function collect(x,y,delay)
    for _, obj in pairs(GetObjectList()) do
        if math.floor(obj.pos.x / 32) == math.floor(GetLocal().pos.x / 32) + x and math.floor(obj.pos.y / 32) == math.floor(GetLocal().pos.y / 32) + y then
            SendPacketRaw(false, {type=11,value=obj.oid,x=obj.pos.x,y=obj.pos.y})
            Sleep(delay or 100)
        end
    end
end
--
function say(txt)
SendPacket(2,"action|input\ntext|"..txt)
end

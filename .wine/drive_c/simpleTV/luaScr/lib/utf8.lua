-- UTF8 functions
-- Author: Andrew Stacey
-- Website: http://www.math.ntnu.no/~stacey/HowDidIDoThat/iPad/Codea.html
-- Licence: CC0 http://wiki.creativecommons.org/CC0

--[[
This file provides some basic functionality for dealing with utf8
strings.  The basic lua string operations act on a byte-by-byte basis
and these have to be modified to work on a utf8-character basis.
--]]

--[[
This is an iterator over the characters in a utf8 string.  It can be
used in for loops.
--]]

function utf8_char(s)
    local i = 1
    if not s then
        s = ""
    end
    return function ()
        local a,l,d
        while true do
            c = string.sub(s,i,i)
            if c == "" then
                return nil
            end
            i = i + 1
            a = string.byte(c)
            if a < 127 then
                return a
            elseif a > 191 then
                -- first byte
                l = 1
                a = a - 192
                if a > 31 then
                    l = l + 1
                    a = a - 32
                    if a > 15 then
                        l = l + 1
                        a = a - 16
                    end
                end
                d = a
            else
                l = l - 1
                d = d * 64 + (a - 128)
                if l == 0 then
                    return d
                end
            end
        end
    end
end

--[[
Returns the length of a utf8 string.
--]]

function utf8_len(s)
    local c,n,a,i
    n = 0
    i = 1
    while true do
        c = string.sub(s,i,i)
        i = i + 1
        if c == "" then
            return n
        end
        a = string.byte(c)
        if a > 191 or a < 127 then
            n = n + 1
        end
    end
end

--[[
Returns the substring from i to j of the utf8 string s.  The arguments
behave in the same fashion as string.sub with regard to negatives.
--]]


function utf8_sub(s,i,j)
    local l
    l = utf8_len(s)
    if i < 0 then
        i = i + l + 1
    end
    if j < 0 then
        j = j + l + 1
    end
    if i < 1 or i > l or j < 1 or j > l or i > j then
        return ""
    end
    local k,m,add,sub
    k = 1
    m = 0
    sub = ""
    add = false
    while true do
        c = string.sub(s,k,k)
        if c == "" then
            return sub
        end
        k = k + 1
        a = string.byte(c)
        if a > 191 or a < 127 then
            -- first byte
            m = m + 1
            if m == i then
                add = true
            end
            if m == j + 1 then
                add = false
            end
        end
        if add then
            sub = sub .. c
        end
    end
    return sub
end

--[[
This splits a utf8 string at the specified spot.
--]]

function utf8_split(s,i)
    local l
    l = utf8_len(s)
    if i < 0 then
        i = i + l + 1
    end
    if i < 1 then
        return s,""
    end
    if i > l then
        return "",s
    end
    local k,m,add,st,en
    k = 1
    m = 0
    st = ""
    en = ""
    add = false
    while true do
        c = string.sub(s,k,k)
        if c == "" then
            return st,en
        end
        k = k + 1
        a = string.byte(c)
        if a > 191 or a < 127 then
            -- first byte
            m = m + 1
            if m == i then
                add = true
            end
        end
        if add then
            en = en .. c
        else
            st = st .. c
        end
    end
    return st,en
end

--[[
This takes in a hexadecimal number and converts it to a utf8 character.
--]]

function utf8hex(s)
    return utf8dec(Hex2Dec(s))
end

--[[
This takes in a decimal number and converts it to a utf8 character.
--]]

function utf8dec(a)
    a = tonumber(a)
    if a < 128 then
        return string.char(a)
    elseif a < 2048 then
        local b,c
        b = a%64 + 128
        c = math.floor(a/64) + 192
        return string.char(c,b)
    elseif a < 65536 then
        local b,c,d
        b = a%64 + 128
        c = math.floor(a/64)%64 + 128
        d = math.floor(a/4096) + 224
        return string.char(d,c,b)
    elseif a < 1114112 then
        local b,c,d,e
        b = a%64 + 128
        c = math.floor(a/64)%64 + 128
        d = math.floor(a/4096)%64 + 128
        e = math.floor(a/262144) + 240
        return string.char(e,d,c,b)
    else
        return nil
    end
end

--[[
This uses the utf8_upper array to convert a character to its
corresponding uppercase variant, if such exists.
--]]

function utf8_toupper(s)
    local t = ""
    for c in utf8_char(s) do
        if utf8_upper[c] then
            t = t .. utf8dec(utf8_upper[c])
        else
            t = t .. utf8dec(c)
        end
    end
    return t
end

--[[
This uses the utf8_lower array to convert a character to its
corresponding lowercase variant, if such exists.
--]]

function utf8_tolower(s)
    local t = ""
    for c in utf8_char(s) do
        if utf8_lower[c] then
            t = t .. utf8dec(utf8_lower[c])
        else
            t = t .. utf8dec(c)
        end
    end
    return t
end



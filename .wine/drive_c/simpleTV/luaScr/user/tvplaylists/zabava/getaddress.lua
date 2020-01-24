--script zabava.ru (12/08/2018)

--quality High - 1 / Medium - 2 / Low - 0
local quality = 1
------------------------------------------------------------------------------

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end

local inAdr =  m_simpleTV.Control.CurrentAdress
if inAdr==nil then return end

if not string.match( inAdr, '^%$zabavatv=' ) and not string.match(inAdr, '^%$zabavastrm=' ) then return end

m_simpleTV.Control.ChangeAdress='Yes'
m_simpleTV.Control.CurrentAdress = ''

if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.Zabava01==nil then m_simpleTV.User.Zabava01={} end

if m_simpleTV.User.TVTimeShift==nil then m_simpleTV.User.TVTimeShift={} end

if quality==1 and m_simpleTV.User.Zabava01.MaxResolution==nil then 
   m_simpleTV.User.Zabava01.MaxResolution = 1080
elseif quality==2 and m_simpleTV.User.Zabava01.MaxResolution==nil then
   m_simpleTV.User.Zabava01.MaxResolution = 480
elseif quality==0 and m_simpleTV.User.Zabava01.MaxResolution==nil then 
   m_simpleTV.User.Zabava01.MaxResolution = 360
end

------------------------------------------------------------------------------
local session = m_simpleTV.Http.New()
if session == nil then return end
------------------------------------------------------------------------------
local function GetQuality(bw)
   local qlty
   if bw > 0 and bw < 1000001 then qlty = '240' 
   elseif bw > 1000000 and bw < 1500001 then qlty = '360'
   elseif bw > 1500000 and bw < 2000001 then qlty = '480'
   elseif bw > 2000000 and bw < 4000001 then qlty = '720'
   elseif bw > 4000000 then qlty = '1080'
   end
     return qlty
end
------------------------------------------------------------------------------
local function GetMaxResolutionIndex(t)

   local index = m_simpleTV.Control.GetMultiAddressIndex()
   if index==nil and m_simpleTV.User.Zabava01.MaxResolution==nil then
      m_simpleTV.User.Zabava01.MaxResolution = t[#t].res
   elseif index~=nil then
      m_simpleTV.User.Zabava01.MaxResolution = t[index+1].res
   end
   --debug_in_file(m_simpleTV.User.Zabava01.MaxResolution .. '\n')

   if m_simpleTV.User.Zabava01.MaxResolution > 0 then
      index=1 
      for u=1, #t do
         if t[u].res~=nil and  m_simpleTV.User.Zabava01.MaxResolution > t[u].res then break end
         index = u
      end
    end
   return index
end
------------------------------------------------------------------------------

if string.match(inAdr, '^%$zabavastrm=' ) then
   if m_simpleTV.User.Zabava01.ResolutionTable then
      local index = GetMaxResolutionIndex(m_simpleTV.User.Zabava01.ResolutionTable) or 1
      local retAdr=string.gsub(m_simpleTV.User.Zabava01.ResolutionTable[index].Adress,'%$zabavastrm=','')
      retAdr=decode64(retAdr)

      if m_simpleTV.User.TVTimeShift.isZabava01_Offset == true then
         local offset = m_simpleTV.User.TVTimeShift.Zabava01_Offset
         retAdr=retAdr .. '&offset=' .. offset
      end
      --debug_in_file(retAdr .. '\n')
      m_simpleTV.Control.CurrentAdress = retAdr .. m_simpleTV.User.Zabava01.ExtOpt
   end
   return
end
------------------------------------------------------------------------------
m_simpleTV.User.Zabava01.ExtOpt = ''
m_simpleTV.User.TVTimeShift.isZabava01_Offset = false

local url = string.gsub(inAdr, '%$zabavatv=', '')
url=decode64(url)
--debug_in_file('inAdr= '.. inAdr .. '\n' .. url .. '\n')

if string.match( url, '%$zabavasvr' ) then

local ttt ={'hlsstr01','hlsstr02','hlsstr03','hlsstr04'}

local tt={}

for i, v in ipairs(ttt) do 
         tt[i] = {}
         tt[i].Id   =  i
         tt[i].Name = 'Server ' .. i
         tt[i].Adress  = string.gsub(url,'%$zabavasvr', v)
--debug_in_file(tt[i].Name .. '  ' .. tt[i].Adress .. '\n')
end

  local __index = math.random(#tt)
  url = tt[__index].Adress
 -- debug_in_file(url .. '\n')

end

  local extopt = (findpattern(url,'%$OPT:(.+)',1,0,0) or '')
  url = string.gsub(url,'%$OPT:(.+)','') 
  m_simpleTV.User.Zabava01.ExtOpt = extopt

  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  m_simpleTV.Http.Close(session)
  if rc~=200 then m_simpleTV.Http.Close(session) return end

 --debug_in_file(answer .. '\n')

  local t={}
  local name,adr
  local i=1
  
  for name,adr in string.gmatch(answer, 'EXT%-X%-STREAM%-INF.-BANDWIDTH=(.-)\n(.-)\n') do 
  
     name = GetQuality(tonumber(name))
     t[i]={}
     t[i].Id= i
     t[i].Name = name
     t[i].Adress = '$zabavastrm=' .. encode64(adr)
     t[i].res = tonumber(name or 360)
     --debug_in_file(t[i].Name .. '  ' .. t[i].Adress .. '\n')

     i=i+1

  end

  m_simpleTV.User.Zabava01.ResolutionTable = t

  local index, retAdr

  if i>1 then
     index = GetMaxResolutionIndex(t) or 1
     retAdr=string.gsub(t[index].Adress,'%$zabavastrm=','')
     retAdr=decode64(retAdr)
  end
  
  if i>2 then
     m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Common.string_toUTF8('Качество'),index-1,t,5000,32+64+128)
  end

  --debug_in_file(retAdr .. '\n')
  m_simpleTV.Control.CurrentAdress = retAdr .. m_simpleTV.User.Zabava01.ExtOpt


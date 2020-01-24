-- плейлист torent-tv http://pomoyka.lib.emergate.net/trash/ttv-list/ (20/04/2018)
-- http://pomoyka.win/trash/ttv-list/

local UpdateID='TTV_TV01'

local session = m_simpleTV.Http.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36 OPR/52.0.2871.40")
if session == nil then return end
-----------------------------------------------
local function CheckAdr(adr, t)
  for i, v in ipairs(t) do 
    if adr == v.Adress then return true end
  end
  return false
end
-----------------------------------------------
local function CheckStr(str)
   str=string.gsub(str,'null','""')
   str=string.gsub(str,'%[%]','""')
   str=string.gsub(str,'\r','')
   return str
end
-----------------------------------------------

m_simpleTV.OSD.ShowMessage("TTV - start updating" ,0xFF00,5)

local ttv_json = m_simpleTV.MainScriptDir .. "user/tvplaylists/ttv/tmp/ttv.json"
local allfon_json = m_simpleTV.MainScriptDir .. "user/tvplaylists/ttv/tmp/allfon.json"
local ace_json = m_simpleTV.MainScriptDir .. "user/tvplaylists/ttv/tmp/ace.json"
local as_json = m_simpleTV.MainScriptDir .. "user/tvplaylists/ttv/tmp/as.json"

local function GetTTVJson()

--local host='http://noblockme.ru/api/anonymize?url=http://pomoyka.lib.emergate.net/trash/ttv-list/'

local host='http://noblockme.ru/api/anonymize?url=http://91.92.66.82/trash/ttv-list/'
 
--[[
local url = host .. 'ttv.json'

  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 1 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')

  url = string.match(answer ,'result":"(.-)"')
  if url == nil then return end

  rc,answer = m_simpleTV.Http.Request(session,{url = url , writeinfile = true , filename = ttv_json})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 2 - " .. rc ,255,5)
 	   return
  end
]]
 local url = host .. 'allfon.json'

  rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 3 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')

  url = string.match(answer ,'result":"(.-)"')
  if url == nil then return end

  rc,answer = m_simpleTV.Http.Request(session,{url = url , writeinfile = true , filename = allfon_json})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 4 - " .. rc ,255,5)
 	   return
  end

 url = host .. 'ace.json'

  rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 5 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')

  url = string.match(answer ,'result":"(.-)"')
  if url == nil then return end

  rc,answer = m_simpleTV.Http.Request(session,{url = url , writeinfile = true , filename = ace_json})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 6 - " .. rc ,255,5)
 	   return
  end

 url = host .. 'as.json'

  rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 7 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')

  url = string.match(answer ,'result":"(.-)"')
  if url == nil then return end

  rc,answer = m_simpleTV.Http.Request(session,{url = url , writeinfile = true , filename = as_json})
  m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("TTV - Connection error 8 - " .. rc ,255,5)
 	   return
  end

end

if m_simpleTV.User.TTV01.Delta==nil then
   m_simpleTV.User.TTV01.Delta=6*60*60
end

local time = os.time()
local delta = m_simpleTV.User.TTV01.Delta
local timestamp = m_simpleTV.Config.GetValue('TTVtimestamp',"tvplaylistsConf.ini")

if timestamp == nil or (tonumber(timestamp)+delta) < time then
   m_simpleTV.Config.SetValue('TTVtimestamp',time,"tvplaylistsConf.ini")
   m_simpleTV.User.TTV01.Timestamp = time
   GetTTVJson()
end
--do return end
--[[
local fhandle = io.open(ttv_json)
if fhandle == nil then return end   

local str = fhandle:read('*a')
fhandle:close()

str=CheckStr(str)
if string.match(str,'%[\n{') and not string.match(str,'%]}$') then
   str = str .. ']}'
end
]]
local m3ustr = '#EXTM3U\n'
local name,adr,grp
local i=1

require('json')
--[[
local t = json.decode(str)
if t==nil then return end

local a={}

while true do
  if t.channels[i]==nil or t.channels[i].name==nil or t.channels[i].cat==nil or t.channels[i].url==nil then break end

  name = t.channels[i].name
  name=string.gsub(name,'[:,]+',';')
  grp = t.channels[i].cat
  grp='TorrentTV - ' .. string.gsub(grp,'[:,]+',';')
  adr = t.channels[i].url 

     a[i]={}
     a[i].Id = i
     a[i].Name = name
     a[i].Grp = grp
     a[i].Adress = adr

  i=i+1
end
--debug_in_file(#a ..'\n' )

str=''
]]
local fhandle = io.open(allfon_json)
if fhandle == nil then return end   

local str = fhandle:read('*a')
fhandle:close()

if not string.match(str,'channels') then
 m_simpleTV.OSD.ShowMessage("TTV update error " ,255,5)
 m_simpleTV.User.TTV01.Delta=0
 return
end

str=CheckStr(str)
if string.match(str,'%[\n{') and not string.match(str,'%]}$') then
   str = str .. ']}'
end

t = json.decode(str)
if t==nil then return end
local a={}
i=1
j=#a+1

while true do
  if t.channels[i]==nil or t.channels[i].name==nil or t.channels[i].cat==nil or t.channels[i].url==nil then break end
  
  name = t.channels[i].name
  name=string.gsub(name,'[:,]+',';')
  grp = t.channels[i].cat
  grp='AllfonTV - ' .. string.gsub(grp,'[:,]+',';')
  adr = t.channels[i].url  

     a[j]={}
     a[j].Id = j
     a[j].Name = name
     a[j].Grp = grp
     a[j].Adress = adr

  i=i+1
  j=j+1
end
--debug_in_file(#a ..'\n' )

str=''

fhandle = io.open(ace_json)
if fhandle == nil then return end   

str = fhandle:read('*a')
fhandle:close()

str=CheckStr(str)
if string.match(str,'%[\n{') and not string.match(str,'%]}$') then
   str = str .. ']}'
end

t = json.decode(str)
if t==nil then return end

i=1
j=#a+1

while true do
  if t.channels[i]==nil or t.channels[i].name==nil or t.channels[i].cat==nil or t.channels[i].url==nil then break end
  
  name = t.channels[i].name
  name=string.gsub(name,'[:,]+',';')
  grp = t.channels[i].cat
  grp='AceStreamTV - ' .. string.gsub(grp,'[:,]+',';')
  adr = t.channels[i].url  

     a[j]={}
     a[j].Id = j
     a[j].Name = name
     a[j].Grp = grp
     a[j].Adress = adr

  i=i+1
  j=j+1
end
--debug_in_file(#a ..'\n' )

str=''

fhandle = io.open(as_json)
if fhandle == nil then return end   

str = fhandle:read('*a')
fhandle:close()

str=CheckStr(str)
if string.match(str,'%[\n{') and not string.match(str,'%]}$') then
   str = str .. ']}'
end

t = json.decode(str)
if t==nil then return end

i=1
j=#a+1

while true do
  if t.channels[i]==nil or t.channels[i].name==nil or t.channels[i].cat==nil or t.channels[i].url==nil then break end
  
  name = t.channels[i].name
  name=string.gsub(name,'[:,]+',';')
  grp = t.channels[i].cat
  grp='AceSearchTV - ' .. string.gsub(grp,'[:,]+',';')
  adr = t.channels[i].url  

  if not CheckAdr(adr, a) then

     a[j]={}
     a[j].Id = j
     a[j].Name = name
     a[j].Grp = grp
     a[j].Adress = adr

   j=j+1
  end
  i=i+1
end
--debug_in_file(#a ..'\n' )

for i=1, #a do 

  name = a[i].Name
  grp =  a[i].Grp
  adr =  a[i].Adress  

  m3ustr =  m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '",' .. name .. '\n' .. adr .. '\n'

end
m_simpleTV.User.TTV01.Delta=6*60*60
--[[
--delete old playlist from db
local sqlstr = 'Select Id from Channels where UpdateID like "TTV_TV%"'
local dTable = m_simpleTV.Database.GetTable(sqlstr)
if dTable ~= nil and dTable[1] ~= nil and dTable[1].Id ~= nil then
   for k, v in ipairs(dTable) do 
       m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Id=' .. v.Id .. ')',true) 
   end
end
]]
function eventFunction(str,err,add,ref,names)
 if err==true then
     local mess = "TTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0xFF00,5)
         m_simpleTV.User.TTV01.updateTimerId =  m_simpleTV.Timer.SetTimer(15000,"TTVAutoupdate()")

  end
end


  --опции  для загрузки плейлиста 
local p={}
p.TypeSourse = 1
p.DeleteBeforeLoad = 0
p.TypeSkip   = 1
p.TypeFind =   0
p.AutoSearch = 1
p.NumberM3U =  1
p.Find_Group = 1
p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'TTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\TTV.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.Data = m3ustr

if m_simpleTV.User.TTV01.isAutoupdate==1 then
p.Asyn = 1
p.EventFunction = "eventFunction"  --optional
p.UserString = ''       --optional
local err = m_simpleTV.PlayList.Load_UTF8 ('',p,0)


elseif m_simpleTV.User.TTV01.isAutoupdate==0 then
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'TTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8 ('',p,0,true,false)

if err==true then
     local mess = "TTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0xFF00,5)
	 
end

end
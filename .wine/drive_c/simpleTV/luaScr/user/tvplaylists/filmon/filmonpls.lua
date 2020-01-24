-- get filmon playlist (23/10/2015)

require('json')

 local session = m_simpleTV.WinInet.New("Opera/9.80 (Windows NT 6.1; U; ru) Presto/2.9.168 Version/11.52")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
-----------------------------------------------
function trim(str)
str = string.match(str,'^%s*(.-)%s*$')
  return str
end
-----------------

 m_simpleTV.OSD.ShowMessage("Filmon: start loading playlist" ,0xFF00,3)

  local url = 'http://www.filmon.com/tv/'

  local rc,answer=m_simpleTV.WinInet.Request(session,{url=url})
  m_simpleTV.WinInet.Close(session)
     if rc~=200 then
    	   m_simpleTV.WinInet.Close(session)
    	   m_simpleTV.OSD.ShowMessage("Connection error - " .. rc ,255,10)
    	   return
     end
--answer=m_simpleTV.Common.string_fromUTF8(answer) 

local tmp = findpattern(answer,'var groups =(.-)];',1,12,1)
     if tmp == nil then 
     	   m_simpleTV.OSD.ShowMessage("Filmon script error - can't find json",255,10)
     	   return
      end

  tmp=trim(tmp)
 -- debug_in_file(tmp .. "\n")

--do return end

local t = json.decode(tmp)
if t == nil  then
   m_simpleTV.OSD.ShowMessage("Error Filmon:  playlist not found"  ,255,10)
   return
end

local m3ustr = '#EXTM3U $BorpasFileFormat="1"\n' 

local i=1,j
local name,adr,grp,img

while true do
  if t[i] == nil then break end
j=1
  while true do
    if t[i].channels[j] == nil then break end


       name = t[i].channels[j].title
       adr = t[i].channels[j].id
 --      grp = t[i].channels[j].group
       grp = 'Filmon - ' .. t[i].original_name
       img = t[i].channels[j].big_logo

    if t[i].channels[j].is_vod == false and t[i].channels[j].is_vox == false then  
       m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. grp .. '" tvg-logo="' .. img .. '",' .. name .. '\n' .. 'filmonlivetv=' .. adr .. '\n'
     end
     j=j+1
  end
  i=i+1
end

--do return end
--[[
local  tmpName = m_simpleTV.Common.GetTmpName()
if tmpName == nil then return end 

 local tfile = io.open(tmpName,'w+')
 if tfile == nil then 
     os.remove(tmpName)
     return
 end

 tfile:write(m3ustr)
 tfile:close() 
]]
  --îïöèè  äëÿ çàãğóçêè ïëåéëèñòà 
local p={}
p.Data = m3ustr
p.TypeSourse = 1
p.DeleteBeforeLoad = 0
p.TypeSkip   = 1
p.TypeFind =   0
p.AutoSearch = 1
p.NumberM3U =  1
p.Find_Group = 1
p.TypeCoding = 0  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'Filmon'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\filmon.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'Filmon playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load ('',p,0,true,false)


  if err==true then
     local mess = "Filmon: playlist updated (New channels: " .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0x37BEDF,3) 
  end
 

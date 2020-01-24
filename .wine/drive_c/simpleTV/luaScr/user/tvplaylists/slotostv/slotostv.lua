
local UpdateID = 'SlotosTV_TV01'
local m3ustr = '#EXTM3U\n'
------------------------------------------------------
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246')
if session == nil then return end
------------------------------------------------------
local function GetContent(num, grp)

    local str=''
  
    local url = 'http://tv.slotos.eu/channel/category/' .. num
    local rc,answer = m_simpleTV.Http.Request(session,{url = url})
    if rc~=200 then return end

--debug_in_file(answer .. '\n')

  
    local tmp = findpattern(answer, '<h2(.-)<script',1,0,0)
    if tmp==nil then return end

--debug_in_file(tmp .. '\n')
--do return end
 
    local name, adr
    local host = 'http://tv.slotos.eu'

    grp = 'SlotosTV - ' .. grp
  
    for w in string.gmatch(tmp, '<a.-<a(.-)/a>') do

       --debug_in_file(w .. '\n\n')

        name = string.match(w, '>(.-)<')
        adr = string.match(w, 'href="(.-)"')
        if name==nil or adr==nil then break end

        adr = '$slotostv=' .. encode64(host .. adr)

       str = str .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '",' .. name .. '\n' .. adr .. '\n'
  
    end
      return str
end  
------------------------------------------------------

  local url = 'http://tv.slotos.eu/'
  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then return end

--debug_in_file(answer .. '\n')

  m_simpleTV.OSD.ShowMessage("SlotosTV: start updating" ,0xFF00,10)

  for num, grp in string.gmatch(answer, 'category.-category/(%d+).->(.-)<') do 
      m_simpleTV.Common.Wait(100)
      m3ustr = m3ustr .. GetContent(num, grp)
--debug_in_file(num .. '  ' .. grp .. '\n')
  end

--debug_in_file(m3ustr .. '\n')

m_simpleTV.Http.Close(session)

  --опции  для загрузки плейлиста 
local p={}
p.Data = m3ustr
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
p.ExtFilter = 'SlotosTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\slotostv.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'SlotosTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "SlotosTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end



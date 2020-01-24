

  local session = m_simpleTV.Http.New()
  if session == nil then return end
  
  local url= decode64('aHR0cDovL3Bhc3RlYmluLmNvbS9yYXcvNGNSYkRFeFA=') 

  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  m_simpleTV.Http.Close(session)
  if rc~=200 then m_simpleTV.Http.Close(session) return end

-- debug_in_file(answer .. '\n')

  answer = answer .. '\n'
  answer = string.gsub(answer, '\r', '')
  answer = m_simpleTV.Common.UTF8ToMultiByte(answer)
  
  local function prepare_m3u(grp,name,adr)
  
      adr=string.gsub(adr, '(hlsstr%d+)', '$zabavasvr')
      adr = '$zabavatv=' .. encode64(adr)
      
      if string.match(grp, 'HD') or string.match(name, 'HD') then
         grp = 'Zabava - HD каналы'
      elseif string.match(grp, 'HD') and string.match(name, '(%(%+%d+%))') then
         grp = 'Zabava - Со сдвигом времени'
      elseif not string.match(grp, 'HD') and string.match(name, '(%(%+%d+%))') then
         grp = 'Zabava - Со сдвигом времени' 
      else grp = 'Zabava - ' .. grp 
      end
  
      return grp, name , adr
  end

 local UpdateID = 'Zabava_TV01'
 local m3ustr = '#EXTM3U\n'

  for grp,name,adr in string.gmatch(answer,'group%-title="(.-)",(.-)\n(.-)\n') do

      grp,name,adr = prepare_m3u(grp,name,adr)

      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '",' .. name .. '\n' .. adr .. '\n'

   end

m3ustr = m_simpleTV.Common.multiByteToUTF8(m3ustr)
--debug_in_file(m3ustr .. '\n')
--do return end

 m_simpleTV.OSD.ShowMessage("Zabava: start loading playlist " ,0xFF00)

--[[
local outm3u, fhandle
local m3u = m_simpleTV.MainScriptDir .. "user/tvplaylists/zabava/zabava.m3u"
fhandle = io.open (m3u , "r")
outm3u = fhandle:read("*all")
fhandle:close()

 local  tmpName = m_simpleTV.Common.GetTmpName()
 if tmpName==nil then 
		return 
 end 
 local tfile = io.open(tmpName,'w+')
 if tfile==nil then 
	os.remove(tmpName)
	return
 end
  
 tfile:write(outm3u)
 tfile:close() 
]]

  --опции  для загрузки плейлиста 
local p={}
p.Data = m3ustr
p.TypeSourse = 1
p.DeleteBeforeLoad = 0
p.TypeSkip   = 1
p.TypeFind =   0
p.AutoSearch = 1
p.NumberM3U =  0
p.Find_Group = 1
p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'Zabava'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\zabava.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'Zabava playlist loading progress'

local err,add,ref,names = m_simpleTV.Common.LoadPlayList_UTF8 (tmpName,p,0,true,false)
--os.remove(tmpName)

if err==true then
     local mess = "Zabava: playlist loaded succesfully"	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0xFF00,10)
end
 
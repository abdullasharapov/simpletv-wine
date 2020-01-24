
m_simpleTV.OSD.ShowMessage("IhaveTV - start loading playlist " ,0xFF00)

local session = m_simpleTV.Http.New()
if session==nil then return end

local url = 'http://ihavesport.com/channel/'

local rc, answer = m_simpleTV.Http.Request(session,{url=url})
m_simpleTV.Http.Close(session)
--debug_in_file(answer ..'\n')

local tmp=findpattern(answer, '<tbody>(.-)</tbody>',1,0,0)
if tmp==nil then return end

local m3ustr = '#EXTM3U\n'
local UpdateID = 'IhaveTV_TV01'
local adr,name,grp

for w in string.gmatch(tmp,'<tr>(.-)</tr>') do 

   w=w:gsub('\n','')

   adr,name,__,grp = string.match(w,'href="(.-)".-alt="(.-)".-<td>(.-)<td>(.-)<')
   if adr==nil or name==nil or grp==nil then break end
   
   adr = '$ihavetv=' .. encode64('http://ihavesport.com' .. adr)

   m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. adr .. '" group-title="IhaveTV - ' .. grp .. '",' .. name .. '\n' .. adr .. '\n'


end
--debug_in_file(m3ustr .. '\n')

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
p.ExtFilter = 'IhaveTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\ihavetv.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'IhaveTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "IhaveTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end

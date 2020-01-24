
 m_simpleTV.OSD.ShowMessage("NTVPlus: start loading playlist " ,0xFF00)

-------------------------------------------------------------------
 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Linux; Android 7.0; SM-G892A Build/NRD90M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/60.0.3112.107 Mobile Safari/537.36")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,8000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,8000,0)
 --INTERNET_FLAG_NO_AUTO_REDIRECT 0x00200000
 --m_simpleTV.WinInet.SetOpenRequestFlags(session,0x00200000)
---------------------------------------------------------------------------
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end
---------------------------------------------------------------------------

local url = decode64('aHR0cDovL21hcGkubnR2cGx1cy50di92MS90di9jaGFubmVscz9hcHBUeXBlPWFuZHJvaWQ=')
   
 local rc,answer = m_simpleTV.WinInet.Request(session,{url=url})
 m_simpleTV.WinInet.Close(session)

 if rc~=200 then
    m_simpleTV.WinInet.Close(session)
    m_simpleTV.OSD.ShowMessage("ntvplus Connection error " .. rc ,255,3)
    return
 end

--debug_in_file(answer.. '\n\n')

 answer=string.gsub(answer,'%[%]','""')

 require('json')
 
 local tab=json.decode(answer)
 if tab==nil then return end

 local UpdateID='NTVPlus_TV01'
 local grp='NTVPlus'
 local m3ustr = '#EXTM3U\n'
 local name,adr
 local i=1
 local t={}

 while true do
       if tab[i] == nil or tab[i].name == nil or tab[i].streamServerId==nil or tab[i].videoUrl==nil then  break end   

          name = trim(tab[i].name)
          adr = '$ntvplus=' .. trim(tab[i].streamServerId)
          m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" group-title="' .. grp .. '",' .. name .. '\n' .. adr .. '\n'
          t[i]={}
          t[i].Id=i
          t[i].name=tab[i].name
          t[i].streamServerId=trim(tab[i].streamServerId)
          t[i].videoUrl=trim(tab[i].videoUrl)
  i=i+1
 end
--debug_in_file(m3ustr)

m_simpleTV.User.NTVPlus.Table = t

  --îïöèè  äëÿ çàãğóçêè ïëåéëèñòà 
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
p.ExtFilter = 'NTVPlus'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\ntv.jpg'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'NTVPlus playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList ('',p,0,true,false)
  if err==true then
     local mess = "NTVPlus: playlist updated (New channels: " .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage(mess,0x37BEDF,3) 
  end
 


 
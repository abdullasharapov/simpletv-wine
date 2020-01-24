 m_simpleTV.OSD.ShowMessage("NTV Plus: start loading playlist " ,0xFF00)

local outm3u, fhandle
local m3u = m_simpleTV.MainScriptDir .. "user/tvplaylists/ntvx/ntvplusx.m3u"
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

  --опции  для загрузки плейлиста 
local p={}
p.TypeSourse = 1
p.DeleteBeforeLoad = 0
p.TypeSkip   = 1
p.TypeFind =   0
p.AutoSearch = 1
p.NumberM3U =  0
p.Find_Group = 1
p.TypeCoding = 0  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'NTV Plus'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\ntv.jpg'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'NTV PlusX playlist loading progress'

local err,add,ref,names = m_simpleTV.Common.LoadPlayList (tmpName,p,0,true,false)
os.remove(tmpName)

if err==true then
     local mess = "NTV Plus: playlist loaded succesfully"	 
	 m_simpleTV.OSD.ShowMessage(mess,0xFF00)
end
 
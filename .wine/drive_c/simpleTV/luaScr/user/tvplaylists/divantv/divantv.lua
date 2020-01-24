
m_simpleTV.OSD.ShowMessage("DivanTV - start loading playlist " ,0xFF00)

local outm3u, fhandle
local m3u_div = m_simpleTV.MainScriptDir .. "user/tvplaylists/divantv/divantv.m3u"
fhandle = io.open (m3u_div , "r")
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

  --îïöèè  äëÿ çàãğóçêè ïëåéëèñòà 
local p={}
p.TypeSourse = 1
p.DeleteBeforeLoad = 0
p.TypeSkip   = 2
p.TypeFind =   0
p.AutoSearch = 1
p.NumberM3U =  0
p.Find_Group = 1
p.TypeCoding = 1  --  -1-auto  0 - plane text  1- UTF8  2- unicode
p.BorpasFileFormat=1
p.AutoNumber = 0
p.ExtFilter = 'DivanTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\divantv1.png'
p.ExtFilterLogoForce = 0
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'DivanTV playlist loading progress'

local err,add,ref,names = m_simpleTV.Common.LoadPlayList_UTF8 (tmpName,p,0,true,false)
os.remove(tmpName)

if err==true then
     local mess = "DivanTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end


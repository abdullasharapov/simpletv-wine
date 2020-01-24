
m_simpleTV.Interface.AddExtMenu('TV Playlists','user\\tvplaylists\\tvinit.lua',string.byte('X'),3)
AddFileToExecute('onconfig',m_simpleTV.MainScriptDir .. "user/tvplaylists/tvinitconfig.lua")

AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/zabava/getaddress.lua")
--AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/faaftv/getaddress.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/peerstv/getaddress.lua")
--AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/firstonetv/getaddress.lua")
--AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/ihavetv/getaddress.lua")
--AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/slotostv/getaddress.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/ustvgo/getaddress.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/ustvnow/getaddress.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/tvtap/getaddress.lua")
AddFileToExecute('getaddress',m_simpleTV.MainScriptDir .. "user/tvplaylists/arconaitv/getaddress.lua")

dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/divantv/divantvinit.lua")
dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/telego/telegoinit.lua")
--dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/ntvx/ntvplusxinit.lua")
dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/ttv/ttvinit.lua")
dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/filmon/filmoninit.lua")
dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/ntv/ntvinit.lua")
dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/yatv/yatvinit.lua")
--dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/spbtv/spbtvinit.lua")
dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/zona/zonainit.lua")
dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/shaluntv/shaluntvinit.lua")

local timestamp = m_simpleTV.Config.GetValue('TTVtimestamp',"tvplaylistsConf.ini")
if timestamp~=nil then
   m_simpleTV.User.TTV01.Timestamp = tonumber(timestamp)
end

local isAutoupdate = m_simpleTV.Config.GetValue('AutoupdatTTVChk',"tvplaylistsConf.ini") or 0
m_simpleTV.User.TTV01.isAutoupdate = tonumber(isAutoupdate)


function TTVAutoupdate()

   local time = os.time()
   local delta = 24*60*60

   if m_simpleTV.User.TTV01.isAutoupdate==1 and m_simpleTV.User.TTV01.Timestamp~=nil then
      if m_simpleTV.User.TTV01.Timestamp+delta < time then
         if m_simpleTV.User.TTV01.updateTimerId~=nil then
            m_simpleTV.Timer.DeleteTimer (m_simpleTV.User.TTV01.updateTimerId)
	    m_simpleTV.User.TTV01.updateTimerId = nil
	 end
         dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/ttv/ttv.lua")
      end
   end
  
end

m_simpleTV.User.TTV01.updateTimerId =  m_simpleTV.Timer.SetTimer(15000,"TTVAutoupdate()")



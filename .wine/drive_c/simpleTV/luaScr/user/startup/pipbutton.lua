
function showInSinglePiP(channelId)
 if channelId==-1 then return end
 m_simpleTV.OSD.PlayInSinglePiP(channelId)
end

local t ={}			
t.Image = m_simpleTV.MainScriptDir_UTF8 .. 'user/pipbutton/image.png' 
t.EventFunction = "showInSinglePiP"
t.IsTooltip = false
t.Mode = 7   --opt default=7 ( bitmask  1 - main playlist  2 - OSD playlist 4 - OSD playlist fullscreen) 
t.DrawOnChannel = true   --opt default =true
t.DrawOnGroup   = false   --opt default =false
t.MediaMode =  0 --opt default -1 (-1 all, 0 - channels, 1 - files, etc)  
t.StaticTooltip = m_simpleTV.Common.string_toUTF8('Открыть в PiP',1251)
--t.ExtFilterID = 0
--t.MaxSize =16   --opt default 0
 m_simpleTV.PlayList.AddItemButton(t)

 --t={}
 --t.utf8 = true
 --t.name = 'Show pip'
 --ONPIP  7
 --t.luastring = 'm_simpleTV.Control.ExecuteAction(7,1)'
 --t.lua_as_scr = true
 --t.key = string.byte('P')
 --t.ctrlkey = 7
 --t.location = 0
 --m_simpleTV.Interface.AddExtMenuT(t)
 
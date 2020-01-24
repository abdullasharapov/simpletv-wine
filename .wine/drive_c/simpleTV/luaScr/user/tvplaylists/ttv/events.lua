 

if m_simpleTV.Control.Reason == 'addressready' then
--[[
   local time = os.time()
   local delta = 24*60*60

   if m_simpleTV.User.TTV01.isAutoupdate==1 and m_simpleTV.User.TTV01.Timestamp~=nil then
      if m_simpleTV.User.TTV01.Timestamp+delta < time then
         dofile (m_simpleTV.MainScriptDir .. "user/tvplaylists/ttv/ttv.lua")
      end
   end
]]


end

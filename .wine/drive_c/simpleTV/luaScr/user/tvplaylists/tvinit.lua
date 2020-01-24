--TV Playlist OSD menu 

local tt={
{"ZonaIPTV (Russian)","user/tvplaylists/zona/zona.lua"},
{"TTV (Torrent TV)","user/tvplaylists/ttv/ttv.lua"},
{"Zabava (Russian)","user/tvplaylists/zabava/loadzabavam3u.lua"},
{"PeersTV (Russian)","user/tvplaylists/peerstv/peerstv.lua"},
{"TVTap (Worldwide)","user/tvplaylists/tvtap/tvtap.lua"},
{"ArconaiTV (USA)","user/tvplaylists/arconaitv/arconaitv.lua"},
{"USTVGO (USA)","user/tvplaylists/ustvgo/ustvgo.lua"},
{"USTVNOW (USA)","user/tvplaylists/ustvnow/ustvnow.lua"},
--{"Firstonetv (Worldwide)","user/tvplaylists/firstonetv/firstonetv.lua"},
--{"SPBTV (Worldwide)","user/tvplaylists/spbtv/spbtv.lua"},
--{"NTV PlusX (Russian)","user/tvplaylists/ntvx/loadntvplusxm3u.lua"},
{"YandexTV (Russian)","user/tvplaylists/yatv/yatv.lua"},
{"Telego (Russian)","user/tvplaylists/telego/telego.lua"},
--{"DivanTV (Ukraine)","user/tvplaylists/divantv/divantv.lua"},
{"Filmon (Worldwide)","user/tvplaylists/filmon/filmonpls.lua"},
--{"FAAF (Animation)","user/tvplaylists/faaftv/faaftvpls.lua"},
{"NTV Plus (Russian)","user/tvplaylists/ntv/ntv.lua"},
--{"IhaveTV (Europe)","user/tvplaylists/ihavetv/ihavetv.lua"},
--{"SlotosTV (Russian)","user/tvplaylists/slotostv/slotostv.lua"},
{"ShalunTV (18+)","user/tvplaylists/shaluntv/shaluntv.lua"},
}

local t ={}
for i=1,#tt do
      t[i] = {}
      t[i].Id   =  i
      t[i].Name =  tt[i][1]
      t[i].Action= tt[i][2]
end

local ret,id = m_simpleTV.OSD.ShowSelect('Select playlist',0,t,10000,1+4+8)
if ret==1 then 
   dofile(m_simpleTV.MainScriptDir .. t[id].Action)
end

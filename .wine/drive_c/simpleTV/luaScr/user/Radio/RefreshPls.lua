
function radiooptions()
  dofile(m_simpleTV.MainScriptDir .. "user/Radio/radiooptions.lua")
end

local tt={
{"101.ru","user/Radio/RadioRefreshPls101.lua"},
{"PCradio","user/Radio/pcradio.lua"},
{"MyRadio","user/Radio/myradio.lua"},
--{"MyRadio Playlists","user/Radio/myradiopls.lua"},
{"PromoDJ","user/Radio/PromoDJ.lua"},
--{"Rambler","user/Radio/RadioRefreshPlsRmb.lua"},
{"Digitally Imported","user/Radio/RadioRefreshPlsDi.lua"},
{"RadioTunes","user/Radio/RadioRefreshPlsRT.lua"},
{"Classicalradio","user/Radio/RadioRefreshPlsCR.lua"},
{"Rockradio","user/Radio/RadioRefreshPlsRR.lua"},
{"Jazzradio","user/Radio/RadioRefreshPlsJZ.lua"},
{"TuneIn","user/Radio/tuneinpls.lua"},
}

local t ={}
for i=1,#tt do
      t[i] = {}
      t[i].Id   =  i
      t[i].Name =  tt[i][1]
      t[i].Adress  = ''
      t[i].Action  = tt[i][2]
  end

      t.ExtButton1 = {}
      t.ExtButton1.ButtonEnable = true
      t.ExtButton1.ButtonName = 'Options'

local ret,id = m_simpleTV.OSD.ShowSelect('Select playlists',0,t,10000,1+4+8)
if id==nil then return end

     if ret==1 then 
	dofile(m_simpleTV.MainScriptDir .. t[id].Action)
     end 

     if ret==3 then
        dofile(m_simpleTV.MainScriptDir .. "user/Radio/radiooptions.lua")
     end


--[[

local t ={}
 t[1] = {} t[2] = {} t[3] = {} t[4] = {} t[5] = {} t[6] = {} t[7] = {} t[8] = {} t[9] = {} 
 t[10] = {} 

  t[1].Id=1
  t[1].Name='101.ru'
  t[1].Adress=''
 
  t[2].Id=2
  t[2].Name='Rockradio'
  t[2].Adress=''
   
  t[3].Id=3
  t[3].Name='Digitally Imported'
  t[3].Adress=''

  t[4].Id=4
  t[4].Name='RadioTunes'
  t[4].Adress=''

  t[5].Id=5
  t[5].Name='JAZZRADIO'
  t[5].Adress=''

  t[6].Id=6
  t[6].Name='Rambler'
  t[6].Adress=''

  t[7].Id=7
  t[7].Name='PCradio'
  t[7].Adress=''
 
  t[8].Id=8
  t[8].Name='PromoDJ'
  t[8].Adress=''

  t[9].Id=9
  t[9].Name='FLAC Radio'
  t[9].Adress=''

  t[10].Id=10
  t[10].Name='MyRadio'
  t[10].Adress=''

 local ret,id = m_simpleTV.OSD.ShowSelect('Update Playlist',0,t,8000,1+4+8)
  
 if id==1 then 
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/RadioRefreshPls101.lua')
  elseif id==2 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/RadioRefreshPlsRR.lua')
  elseif id==3 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/RadioRefreshPlsDi.lua')
  elseif id==4 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/RadioRefreshPlsRT.lua')
  elseif id==5 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/RadioRefreshPlsJZ.lua')
  elseif id==6 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/RadioRefreshPlsRmb.lua')
  elseif id==7 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/pcradio.lua')
  elseif id==8 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/PromoDJ.lua')
  elseif id==9 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/flacru.lua')
  elseif id==10 then
   dofile(m_simpleTV.MainScriptDir .. 'user/Radio/myradio.lua')
end



]]



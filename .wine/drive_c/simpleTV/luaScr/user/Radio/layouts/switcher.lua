--switch layout

 local function setConfigVal(key,val)
   m_simpleTV.Config.SetValue(key,val,"radioConf.ini")
 end

 local layout = m_simpleTV.User.Radio.Layout
 local index = tonumber(layout)

  if layout == '0' then
     index = 0
  elseif layout == '1' then
     index = 1
  elseif layout == '2' then
     index = 2
  elseif layout == '3' then
     index = 3
  elseif layout == '4' then
     index = 4
  elseif layout == '5' then
     index = 5
  elseif layout == '6' then
     index = 6
  end

  local t ={}
  t[1] = {} t[2] = {} t[3] = {} t[4] = {} t[5] = {} t[6] = {} t[7] = {}
 
  t[1].Id=1
  t[1].Name='No layout'
  t[1].Adress=''
 
  t[2].Id=2
  t[2].Name='Layout 1'
  t[2].Adress=''
   
  t[3].Id=3
  t[3].Name='Layout 2'
  t[3].Adress=''

  t[4].Id=4
  t[4].Name='Layout 3'
  t[4].Adress=''

  t[5].Id=5
  t[5].Name='Layout 4'
  t[5].Adress=''

  t[6].Id=6
  t[6].Name='Layout 5'
  t[6].Adress=''

  t[7].Id=7
  t[7].Name='Layout 6'
  t[7].Adress=''


 local ret,id = m_simpleTV.OSD.ShowSelect('Select layout',index or 0,t,0,1+4+8)

 if id==nil then return end

 if id==1 or id==2 or id==3 or id==4 or id==5 or id==6 or id==7 then 
    m_simpleTV.User.Radio.Layout = id-1
    setConfigVal("radioMusicLayout",id-1)
    m_simpleTV.User.Radio.Background = nil
    
end


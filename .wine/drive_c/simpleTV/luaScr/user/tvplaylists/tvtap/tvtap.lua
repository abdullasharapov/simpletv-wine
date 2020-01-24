--script tvtap (06/09/2019)

------------------------------------------------------------------------------
  local userAgent = "USER-AGENT-tvtap-APP-V2"
  local session = m_simpleTV.Http.New(userAgent)
  if session == nil then return end
------------------------------------------------------------------------------

 m_simpleTV.OSD.ShowMessage("TVTap: start updating" ,0xFF00,10)

   local url = 'http://tvtap.net/tvtap1/index_tvtappro.php?case=get_all_channels'
   local body = 'username=603803577'
 
   local t={}  
   t.url = url
   t.method = 'post' 
   t.headers = 'User-Agent: ' .. userAgent .. '\napp-token: 9120163167c05aed85f30bf88495bd89'
   t.body = body
    
   local rc,answer = m_simpleTV.Http.Request(session,t)
   m_simpleTV.Http.Close(session)
   if rc~=200 then m_simpleTV.Http.Close(session) return end
   --debug_in_file(answer .. '\n\n')

   require('json')
   answer = string.gsub(answer, ':%[%]', ':""')
   answer = string.gsub(answer, '%[%]', ' ')
  
   local tab = json.decode(answer)
   if tab == nil or tab.msg==nil or tab.msg.channels==nil then return end

   local m3ustr = '#EXTM3U\n'
   local UpdateID = 'TVTap_TV01'
  
   local t={}
   local name,adr,grp,img,ctry
   local group = 'TVTap - '
   local i=1

   while true do
      if tab.msg.channels[i]==nil then break end

       ctry = tab.msg.channels[i].country or '' 
       name = ctry .. ': ' .. tab.msg.channels[i].channel_name or ''
       adr = '$tvtap=' .. tab.msg.channels[i].pk_id or ''
       grp = group .. tab.msg.channels[i].cat_name or ''
       img = 'http://taptube.net/tvtap1/' .. tab.msg.channels[i].img or ''
       
       t[i]={}
       t[i].Id= i
       t[i].Name = name 
       t[i].Address = adr
       t[i].Grp = grp
       t[i].Img = img
       --debug_in_file (t[i].Name .. ' ' .. t[i].Address .. '\n')

    i=i+1
   end

  table.sort(t, function(a, b) return a.Name < b.Name end)
  for i=1, #t do 
      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. t[i].Grp .. t[i].Name .. '" group-title="' .. t[i].Grp .. '" tvg-logo="' .. t[i].Img .. '",' .. t[i].Name .. '\n' .. t[i].Address .. '\n'
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
p.ExtFilter = 'TVTap'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\tvtap.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'TVTap playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "TVTap - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end



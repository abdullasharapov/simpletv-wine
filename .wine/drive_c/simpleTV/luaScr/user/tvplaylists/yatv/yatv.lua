--script yandex tv playlist (20/10/2019)
------------------------------------------------------
local function GetGrp(str)

local t={
{'inform',m_simpleTV.Common.multiByteToUTF8('Информационные')},
{'sport',m_simpleTV.Common.multiByteToUTF8('Спорт')},
{'films',m_simpleTV.Common.multiByteToUTF8('Фильмы')},
{'entertain',m_simpleTV.Common.multiByteToUTF8('Развлекательные')},
{'business',m_simpleTV.Common.multiByteToUTF8('Деловые')},
{'educate',m_simpleTV.Common.multiByteToUTF8('Образовательные')},
{'foreign',m_simpleTV.Common.multiByteToUTF8('Разное')},
{'music',m_simpleTV.Common.multiByteToUTF8('Музыка')},
{'region',m_simpleTV.Common.multiByteToUTF8('Региональные')},
{'child',m_simpleTV.Common.multiByteToUTF8('Детские')},

}
  for i,v in ipairs(t) do 
    if str==v[1] then str = v[2] end
  end
  return str
end
------------------------------------------------------

  require('json')

  local session = m_simpleTV.Http.New()
  if session == nil then return end

  local url = 'https://yandex.ru/portal/tvstream_json/channels?stream_options=hires&locale=ru&from=morda'
  local rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("Connection error 1 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')

    answer = string.gsub(answer, ':%[%]', ':""')
    answer = string.gsub(answer, '%[%]', ' ')

    local tab = json.decode(answer)
    if tab == nil then return end

local t={}
local i=1
local m3ustr = '#EXTM3U\n'
local UpdateID = 'YandexTV_TV01'
local name,adr,grp,id,ch_type

while true do
   if tab.set[i]==nil then break end

      id = tab.set[i].channel_id
      name = tab.set[i].title
      adr = tab.set[i].content_url

      grp = tab.set[i].channel_category
      if grp~=nil then grp = GetGrp(tab.set[i].channel_category[1]) end
      if grp==nil then grp = m_simpleTV.Common.multiByteToUTF8('Разное') end 
 
     if string.len(id)<5 and not tab.set[i].ya_plus then  
      t[i]={}
      t[i].Id= i
      t[i].channel_id = '$yandextv=' .. id
      t[i].title = name 
      t[i].channel_category = grp or m_simpleTV.Common.multiByteToUTF8('Разное')
      t[i].content_url = adr
      t[i].content_id = tab.set[i].content_id
      --debug_in_file (t[i].channel_id .. ' ' .. t[i].channel_category .. ' ' .. t[i].title .. '\n' .. t[i].content_url  .. '\n\n')
   
      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. t[i].channel_category .. t[i].title .. '" group-title="YandexTV - ' .. t[i].channel_category .. '",' .. t[i].title .. '\n' .. t[i].channel_id.. '\n'
    end
 i=i+1
  
end

  url = 'https://frontend.vh.yandex.ru/channels'
  rc,answer = m_simpleTV.Http.Request(session,{url = url})
  --m_simpleTV.Http.Close(session)
  if rc~=200 then
 	   m_simpleTV.Http.Close(session)
 	   m_simpleTV.OSD.ShowMessage("Connection error 2 - " .. rc ,255,5)
 	   return
  end

--debug_in_file(answer .. '\n')

    answer = string.gsub(answer, ':%[%]', ':""')
    answer = string.gsub(answer, '%[%]', ' ')

    tab = json.decode(answer)
    if tab == nil then return end

    grp = m_simpleTV.Common.multiByteToUTF8('Погода')

i=1
while true do
   if tab.set[i]==nil then break end

      name = tab.set[i].title
      adr = tab.set[i].content_url

     if string.match(name, grp) then  
      t[i]={}
      t[i].Id= i
      t[i].title = name 
      t[i].channel_category = grp
      t[i].content_url = adr:gsub('?.+', '')
   
      m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. t[i].channel_category .. t[i].title .. '" group-title="YandexTV - ' .. t[i].channel_category .. '",' .. t[i].title .. '\n' .. t[i].content_url .. '\n'
    end
 i=i+1
  
end


--debug_in_file(m3ustr .. '\n')
--do return end

m_simpleTV.User.YaTV.Table = nil

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
p.ExtFilter = 'YandexTV'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\yandex.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'YandexTV playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.Load_UTF8('',p,0,true,false)

if err==true then
     local mess = "YandexTV - channels updated (" .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end


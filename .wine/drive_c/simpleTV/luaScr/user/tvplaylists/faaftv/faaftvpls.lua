--script for http://faaf.tv (15/08/2018)
--

local UpdateID='FAAF_TV01'

-----------------------------------------------

 local session = m_simpleTV.WinInet.New("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.168 Safari/537.36 OPR/51.0.2830.40")
 if session == nil then return end

  --INTERNET_OPTION_CONNECT_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,2,5000,0)
  --INTERNET_OPTION_RECEIVE_TIMEOUT
  m_simpleTV.WinInet.SetOptionInt(session,6,5000,0)
-------------------------------------------
function unescape_html(str)
  --str = string.gsub( str, '&raquo;', 'ї' )
  --str = string.gsub( str, '&laquo;', 'Ђ' )
  str = string.gsub( str, '&raquo;', '"' ) 
  str = string.gsub( str, '&laquo;', '"' )
  str = string.gsub( str, '&lt;', '<' )
  str = string.gsub( str, '&gt;', '>' )
  str = string.gsub( str, '&quot;', '"' )
  str = string.gsub( str, '&apos;', "'" )
  str = string.gsub( str, '&#(%d+);', function(n) return string.char(n) end )
  str = string.gsub( str, '&#x(%d+);', function(n) return string.char(tonumber(n,16)) end )
  str = string.gsub( str, '&amp;', '&' ) -- Be sure to do this after all others
  return str
end

-- convert numeric html entities to utf8
-- converts from stdin to stdout
-- example:  &#8364;    ->   И
 local character_entities = {
  ["quot"] = 0x0022,
  ["amp"] = 0x0026,
  ["apos"] = 0x0027,
  ["lt"] = 0x003C,
  ["gt"] = 0x003E,
  ["nbsp"] = 160,
  ["iexcl"] = 0x00A1,
  ["cent"] = 0x00A2,
  ["pound"] = 0x00A3,
  ["curren"] = 0x00A4,
  ["yen"] = 0x00A5,
  ["brvbar"] = 0x00A6,
  ["sect"] = 0x00A7,
  ["uml"] = 0x00A8,
  ["copy"] = 0x00A9,
  ["ordf"] = 0x00AA,
  ["laquo"] = 0x00AB,
  ["not"] = 0x00AC,
  ["shy"] = 173,
  ["reg"] = 0x00AE,
  ["macr"] = 0x00AF,
  ["deg"] = 0x00B0,
  ["plusmn"] = 0x00B1,
  ["sup2"] = 0x00B2,
  ["sup3"] = 0x00B3,
  ["acute"] = 0x00B4,
  ["micro"] = 0x00B5,
  ["para"] = 0x00B6,
  ["middot"] = 0x00B7,
  ["cedil"] = 0x00B8,
  ["sup1"] = 0x00B9,
  ["ordm"] = 0x00BA,
  ["raquo"] = 0x00BB,
  ["frac14"] = 0x00BC,
  ["frac12"] = 0x00BD,
  ["frac34"] = 0x00BE,
  ["iquest"] = 0x00BF,
  ["Agrave"] = 0x00C0,
  ["Aacute"] = 0x00C1,
  ["Acirc"] = 0x00C2,
  ["Atilde"] = 0x00C3,
  ["Auml"] = 0x00C4,
  ["Aring"] = 0x00C5,
  ["AElig"] = 0x00C6,
  ["Ccedil"] = 0x00C7,
  ["Egrave"] = 0x00C8,
  ["Eacute"] = 0x00C9,
  ["Ecirc"] = 0x00CA,
  ["Euml"] = 0x00CB,
  ["Igrave"] = 0x00CC,
  ["Iacute"] = 0x00CD,
  ["Icirc"] = 0x00CE,
  ["Iuml"] = 0x00CF,
  ["ETH"] = 0x00D0,
  ["Ntilde"] = 0x00D1,
  ["Ograve"] = 0x00D2,
  ["Oacute"] = 0x00D3,
  ["Ocirc"] = 0x00D4,
  ["Otilde"] = 0x00D5,
  ["Ouml"] = 0x00D6,
  ["times"] = 0x00D7,
  ["Oslash"] = 0x00D8,
  ["Ugrave"] = 0x00D9,
  ["Uacute"] = 0x00DA,
  ["Ucirc"] = 0x00DB,
  ["Uuml"] = 0x00DC,
  ["Yacute"] = 0x00DD,
  ["THORN"] = 0x00DE,
  ["szlig"] = 0x00DF,
  ["agrave"] = 0x00E0,
  ["aacute"] = 0x00E1,
  ["acirc"] = 0x00E2,
  ["atilde"] = 0x00E3,
  ["auml"] = 0x00E4,
  ["aring"] = 0x00E5,
  ["aelig"] = 0x00E6,
  ["ccedil"] = 0x00E7,
  ["egrave"] = 0x00E8,
  ["eacute"] = 0x00E9,
  ["ecirc"] = 0x00EA,
  ["euml"] = 0x00EB,
  ["igrave"] = 0x00EC,
  ["iacute"] = 0x00ED,
  ["icirc"] = 0x00EE,
  ["iuml"] = 0x00EF,
  ["eth"] = 0x00F0,
  ["ntilde"] = 0x00F1,
  ["ograve"] = 0x00F2,
  ["oacute"] = 0x00F3,
  ["ocirc"] = 0x00F4,
  ["otilde"] = 0x00F5,
  ["ouml"] = 0x00F6,
  ["divide"] = 0x00F7,
  ["oslash"] = 0x00F8,
  ["ugrave"] = 0x00F9,
  ["uacute"] = 0x00FA,
  ["ucirc"] = 0x00FB,
  ["uuml"] = 0x00FC,
  ["yacute"] = 0x00FD,
  ["thorn"] = 0x00FE,
  ["yuml"] = 0x00FF,
  ["OElig"] = 0x0152,
  ["oelig"] = 0x0153,
  ["Scaron"] = 0x0160,
  ["scaron"] = 0x0161,
  ["Yuml"] = 0x0178,
  ["fnof"] = 0x0192,
  ["circ"] = 0x02C6,
  ["tilde"] = 0x02DC,
  ["Alpha"] = 0x0391,
  ["Beta"] = 0x0392,
  ["Gamma"] = 0x0393,
  ["Delta"] = 0x0394,
  ["Epsilon"] = 0x0395,
  ["Zeta"] = 0x0396,
  ["Eta"] = 0x0397,
  ["Theta"] = 0x0398,
  ["Iota"] = 0x0399,
  ["Kappa"] = 0x039A,
  ["Lambda"] = 0x039B,
  ["Mu"] = 0x039C,
  ["Nu"] = 0x039D,
  ["Xi"] = 0x039E,
  ["Omicron"] = 0x039F,
  ["Pi"] = 0x03A0,
  ["Rho"] = 0x03A1,
  ["Sigma"] = 0x03A3,
  ["Tau"] = 0x03A4,
  ["Upsilon"] = 0x03A5,
  ["Phi"] = 0x03A6,
  ["Chi"] = 0x03A7,
  ["Psi"] = 0x03A8,
  ["Omega"] = 0x03A9,
  ["alpha"] = 0x03B1,
  ["beta"] = 0x03B2,
  ["gamma"] = 0x03B3,
  ["delta"] = 0x03B4,
  ["epsilon"] = 0x03B5,
  ["zeta"] = 0x03B6,
  ["eta"] = 0x03B7,
  ["theta"] = 0x03B8,
  ["iota"] = 0x03B9,
  ["kappa"] = 0x03BA,
  ["lambda"] = 0x03BB,
  ["mu"] = 0x03BC,
  ["nu"] = 0x03BD,
  ["xi"] = 0x03BE,
  ["omicron"] = 0x03BF,
  ["pi"] = 0x03C0,
  ["rho"] = 0x03C1,
  ["sigmaf"] = 0x03C2,
  ["sigma"] = 0x03C3,
  ["tau"] = 0x03C4,
  ["upsilon"] = 0x03C5,
  ["phi"] = 0x03C6,
  ["chi"] = 0x03C7,
  ["psi"] = 0x03C8,
  ["omega"] = 0x03C9,
  ["thetasym"] = 0x03D1,
  ["upsih"] = 0x03D2,
  ["piv"] = 0x03D6,
  ["ensp"] = 0x2002,
  ["emsp"] = 0x2003,
  ["thinsp"] = 0x2009,
  ["ndash"] = 0x2013,
  ["mdash"] = 0x2014,
  ["lsquo"] = 0x2018,
  ["rsquo"] = 0x2019,
  ["sbquo"] = 0x201A,
  ["ldquo"] = 0x201C,
  ["rdquo"] = 0x201D,
  ["bdquo"] = 0x201E,
  ["dagger"] = 0x2020,
  ["Dagger"] = 0x2021,
  ["bull"] = 0x2022,
  ["hellip"] = 0x2026,
  ["permil"] = 0x2030,
  ["prime"] = 0x2032,
  ["Prime"] = 0x2033,
  ["lsaquo"] = 0x2039,
  ["rsaquo"] = 0x203A,
  ["oline"] = 0x203E,
  ["frasl"] = 0x2044,
  ["euro"] = 0x20AC,
  ["image"] = 0x2111,
  ["weierp"] = 0x2118,
  ["real"] = 0x211C,
  ["trade"] = 0x2122,
  ["alefsym"] = 0x2135,
  ["larr"] = 0x2190,
  ["uarr"] = 0x2191,
  ["rarr"] = 0x2192,
  ["darr"] = 0x2193,
  ["harr"] = 0x2194,
  ["crarr"] = 0x21B5,
  ["lArr"] = 0x21D0,
  ["uArr"] = 0x21D1,
  ["rArr"] = 0x21D2,
  ["dArr"] = 0x21D3,
  ["hArr"] = 0x21D4,
  ["forall"] = 0x2200,
  ["part"] = 0x2202,
  ["exist"] = 0x2203,
  ["empty"] = 0x2205,
  ["nabla"] = 0x2207,
  ["isin"] = 0x2208,
  ["notin"] = 0x2209,
  ["ni"] = 0x220B,
  ["prod"] = 0x220F,
  ["sum"] = 0x2211,
  ["minus"] = 0x2212,
  ["lowast"] = 0x2217,
  ["radic"] = 0x221A,
  ["prop"] = 0x221D,
  ["infin"] = 0x221E,
  ["ang"] = 0x2220,
  ["and"] = 0x2227,
  ["or"] = 0x2228,
  ["cap"] = 0x2229,
  ["cup"] = 0x222A,
  ["int"] = 0x222B,
  ["there4"] = 0x2234,
  ["sim"] = 0x223C,
  ["cong"] = 0x2245,
  ["asymp"] = 0x2248,
  ["ne"] = 0x2260,
  ["equiv"] = 0x2261,
  ["le"] = 0x2264,
  ["ge"] = 0x2265,
  ["sub"] = 0x2282,
  ["sup"] = 0x2283,
  ["nsub"] = 0x2284,
  ["sube"] = 0x2286,
  ["supe"] = 0x2287,
  ["oplus"] = 0x2295,
  ["otimes"] = 0x2297,
  ["perp"] = 0x22A5,
  ["sdot"] = 0x22C5,
  ["lceil"] = 0x2308,
  ["rceil"] = 0x2309,
  ["lfloor"] = 0x230A,
  ["rfloor"] = 0x230B,
  ["lang"] = 0x27E8,
  ["rang"] = 0x27E9,
  ["loz"] = 0x25CA,
  ["spades"] = 0x2660,
  ["clubs"] = 0x2663,
  ["hearts"] = 0x2665,
  ["diams"] = 0x2666,
}

local char = string.char
 
local function tail(n, k)
  local u, r=''
  for i=1,k do
    n,r = math.floor(n/0x40), n%0x40
    u = char(r+0x80) .. u
  end
  return u, n
end
 
local function to_utf8(a)
  local n, r, u = tonumber(a)
  if n<0x80 then                        -- 1 byte
    return char(n)
  elseif n<0x800 then                   -- 2 byte
    u, n = tail(n, 1)
    return char(n+0xc0) .. u
  elseif n<0x10000 then                 -- 3 byte
    u, n = tail(n, 2)
    return char(n+0xe0) .. u
  elseif n<0x200000 then                -- 4 byte
    u, n = tail(n, 3)
    return char(n+0xf0) .. u
  elseif n<0x4000000 then               -- 5 byte
    u, n = tail(n, 4)
    return char(n+0xf8) .. u
  else                                  -- 6 byte
    u, n = tail(n, 5)
    return char(n+0xfc) .. u
  end
end

local function html2utf8(char)
 for k,v in pairs(character_entities) do
    char = char:gsub('&#39;',"'")
    if k == char:match('&(.-);') or char:match('&#(%d+);') then return to_utf8(v) end
 end
  return char
end

local function Valid(name,grp,desc)
  name = string.gsub(name,',','')
  grp = string.gsub(grp,',','')
  desc = desc:gsub ('&.-;',function(s) return html2utf8(s) end)
  desc = desc:gsub('"','%%22')
  desc = desc:gsub('\r',' ')
  desc = desc:gsub('\n',' ')
 -- desc = desc:gsub('&nbsp;',' ')
  return name,grp,desc
end
-------------------------------------------

local function GetCatalogAdr(adr,grp,host,session)
   m_simpleTV.Common.Wait(100)
  local rc,answer=m_simpleTV.WinInet.Get(session,adr)
  
   if rc~=200 then
  	   m_simpleTV.WinInet.Close(session)
  	   m_simpleTV.OSD.ShowMessage("faaf.tv Connection error 2 - " .. rc ,255,10)
  	   return
   end
  
  --debug_in_file(answer .. "\n\n")

  local m3ustr = ''
  local name,img,desc
  
   for w in string.gmatch(answer,'<div class="view">(.-)<hr />') do

  	adr,name  = string.match (w,'<strong><a href="(.-)">(.-)<')
  	if adr == nil or name == nil then break end

        img = findpattern(w,'<img src="(.-)"',1,10,1)
        desc = findpattern(w,'<div class="text">(.-)<',1,18,1)
        if img == nil then img = '' end
        if desc == nil then desc = '' end
        
        adr = 'faaftv=' .. adr
        name,grp,desc = Valid(name,grp,desc)
        img = host .. img

        m3ustr = m3ustr .. '#EXTINF:-1 update-code="' .. UpdateID .. grp .. name .. '" skipepg="0" skiplogo="0" group-title="FAAF - ' .. grp .. '" tvg-logo="' .. img .. '" video-title="' .. desc .. '" video-desk="' .. desc .. '",' .. name .. '\n' .. adr .. '\n'
      
   end
 
   return m3ustr
end
-------------
local t={} t[1] = {} t[2] = {}

  t[1].Id=1
  t[1].Name='Russian'
  t[1].Adress=''
 
  t[2].Id=2
  t[2].Name='English'
  t[2].Adress=''
   
 local ret,id = m_simpleTV.OSD.ShowSelect('Select language',0,t,10000,1+4+8)
 if id == nil then return end

 local url
  if id==1 then 
    url = 'http://faaf.tv/catalog'
  elseif id==2 then
    url = 'http://faaf.tv/en/catalog'
 end

 m_simpleTV.OSD.ShowMessage("FAAF - start playlist updating" ,0xFF00,30)
--[[
 local body ='login=xps66582%40iaoss.com&password=xps66582%40iaoss.com&vx=%D0%92%D0%A5%D0%9E%D0%94'

 local head = 
'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8\n' ..
'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7\n' ..
'Referer: http://faaf.tv/\n' ..
'Content-Type: application/x-www-form-urlencoded'

  local rc,answer=m_simpleTV.WinInet.Request(session,{url='http://faaf.tv/login',method='post',headers=head,body=body})
   if rc~=200 then
  	   m_simpleTV.WinInet.Close(session)
  	  m_simpleTV.OSD.ShowMessage(" faaf.tv Connection error - " .. rc ,255,10)
  	   return
   end

  debug_in_file(answer .. "\n\n")
]]

 local host = 'http://faaf.tv'

   rc,answer=m_simpleTV.WinInet.Request(session,{url=url})
  
   if rc~=200 then
  	   m_simpleTV.WinInet.Close(session)
  	   m_simpleTV.OSD.ShowMessage("faaf.tv Connection error 1 - " .. rc ,255,10)
  	   return
   end
  
  --debug_in_file(answer .. "\n\n")

  local tmp =  findpattern(answer,'<div class="country">(.-)</div>',1,0,0)

  if tmp == nil then
     m_simpleTV.OSD.ShowMessage("FAAF script error"  ,255,10)
     return
  end

 local m3ustr = '#EXTM3U $TypeMedia="3"\n' --'#EXTM3U\n' --
 local grp,adr
 local j='.'
 for w in string.gmatch(tmp,'<a(.-)/a>') do
	adr  = findpattern (w,'href="(.-)"',1,6,1)
	grp  = findpattern (w,'%b><',1,1,1)
	if adr == nil or grp == nil then break end
        adr = host .. adr
--debug_in_file(grp  .. '  ' .. adr  .. '\n\n')
        m3ustr = m3ustr .. GetCatalogAdr(adr,grp,host,session)

        m_simpleTV.OSD.ShowMessage("FAAF - start playlist updating (" ..j..")" ,0xFF00,3)
        j=j .. '.'
 end

m_simpleTV.WinInet.Close(session)

--debug_in_file(m3ustr .. '\n\n')

local  tmpName = m_simpleTV.Common.GetTmpName()
if tmpName == nil then return end 

 local tfile = io.open(tmpName,'w+')
 if tfile == nil then 
     os.remove(tmpName)
     return
 end

 tfile:write(m3ustr)
 tfile:close() 


  --опции  дл€ загрузки плейлиста 
local p={}
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
p.ExtFilter = 'FAAF'
p.ExtFilterLogo =  '..\\Channel\\logo\\extFiltersLogo\\faaf.png'   -- the logo of extended filter (from ver. 0.4.8 b9)
p.ExtFilterLogoForce = 0
p.UpdateID=UpdateID
p.ShowProgressWindow = 1
p.ProgressWindowHeader = 'FAAF playlist loading progress'

local err,add,ref,names = m_simpleTV.PlayList.LoadPlayList_UTF8 (tmpName,p,0,true,false)
os.remove(tmpName)

if err==true then
     local mess = "FAAF - playlist has been updated ( New video: " .. add .. ")"
	 if add > 0 and add < 25 then 
	    names = string.gsub(names,'%$end','\n')
		mess = mess .. '\n' .. names
	 end
	 
	 m_simpleTV.OSD.ShowMessage_UTF8(mess,0x37BEDF,3) 
  end

for i=1,3 do
  m_simpleTV.Control.ExecuteAction(79)
end



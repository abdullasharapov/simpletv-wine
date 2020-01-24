

function ARGB(A,R,G,B)
  local a = A*256*256*256+R*256*256+G*256+B
  if A<128 then return a end
  return a - 4294967296 
 end

local function COLORREFtoARGB(COLORREF)
 --0x00bbggrr
 if COLORREF==nil then return nil end
 local R =   math.floor(math.fmod(COLORREF,256))
 local G =   math.floor(math.fmod(COLORREF/256,256))
 local B =   math.floor(math.fmod(COLORREF/(256*256),256))
 return ARGB(255,R,G,B)
end

m_simpleTV.OSD.ShowMessage = function(mess,COLORREF,showTime,Append)
m_simpleTV.OSD.ShowMessage_UTF8 (m_simpleTV.Common.string_toUTF8(mess),COLORREF,addTime,Append) 
end

m_simpleTV.OSD.ShowMessage_UTF8 = function(mess,COLORREF,showTimeP,appendP)
if showTimeP~=nil then showTimeP = showTimeP*1000 end
local t = {text=mess,color = COLORREFtoARGB(COLORREF),showTime = showTimeP,append = appendP }
m_simpleTV.OSD.ShowMessageT(t) 
end

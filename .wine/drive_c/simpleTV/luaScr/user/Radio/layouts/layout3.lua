 --layout3

--[[
LEFT_POS=1,
CENTER_POS=2,
RIGHT_POS=3,

NO_CHANGE_V=0,
TOP_POS=0x0100,
CENTER_V_POS=0x0200,
BOTTOM_POS=0x0400,
]]

--m_simpleTV.OSD.SetElementDebugMode(true)

local bg = m_simpleTV.User.Radio.Background
local cover = m_simpleTV.User.Radio.ArtistCover
local title = m_simpleTV.User.Radio.Title
local station = m_simpleTV.User.Radio.StationName

local trackFont = 'arial black'
local trackFontHeight = 40
local trackFontWeight = 0
local trackFontItalic = 0
local trackFontUnderline = 0
local stationFont = 'arial black'
local stationFontHeight = 30
local stationFontWeight = 0
local stationFontItalic = 0
local stationFontUnderline = 0

 local value = m_simpleTV.User.Radio.RadioTrackFontLayout3
 local t={}
 if value ~= nil  then
    for w in string.gmatch(value, '[^,]+') do 
        t[#t+1]=w
    end
    trackFont = t[1]
    trackFontHeight = t[2]
    trackFontWeight = t[5]
    trackFontItalic = t[6]
    trackFontUnderline = t[7]
end

 value = m_simpleTV.User.Radio.RadioStationFontLayout3
 t={}
 if value ~= nil  then
    for w in string.gmatch(value, '[^,]+') do 
        t[#t+1]=w
    end
    stationFont = t[1]
    stationFontHeight = t[2]
    stationFontWeight = t[5]
    stationFontItalic = t[6]
    stationFontUnderline = t[7]
end

local textColor = '0x' ..  m_simpleTV.User.Radio.RadioTextColorLayout3
local borderColor = '0x' ..  m_simpleTV.User.Radio.RadioBorderColorLayout3
local blur = m_simpleTV.User.Radio.RadioBlurBgLayout3
local scroll = m_simpleTV.User.Radio.RadioScrollTextLayout3
local numBreak = m_simpleTV.User.Radio.RadioTrackNumBreakLayout3

 t={}			
 t.BackColor = 0
 t.BackColorEnd = 255
 t.PictFileName = bg
 t.TypeBackColor = 0
 t.UseLogo = 3
 t.Once = 1
 t.Blur = blur
 m_simpleTV.Interface.SetBackground(t)

 local AddElement = m_simpleTV.OSD.AddElement

 t = {}
 t.id = 'DEV_DIV_DEFAULT'
 t.cx=200
 t.cy=200
 t.class="DIV"
 t.minresx=400
 t.minresy=300
 t.align = 0x0403
 t.left=0
 t.once=1
 t.zorder=1
 t.background = -1
 AddElement(t)

 t={}
 t.id = 'DEV_DIV_TEXT_DEFAULT'
 t.cx=0
 t.cy=0
 t.class="TEXT"
 t.minresx=0
 t.minresy=0
 t.align = 0x0403
 t.text = 'radio by wafee'
 t.color = 0x7FFFFFFF
 t.font_addheight = -10
 t.font_weight = 70
 t.font_underline = 0
 t.font_italic = 0
 t.font_name = "Arial"
 t.qt_textparam = 0
 t.left = 5
 t.top  = 5
 t.glow = 4
 t.glowcolor = 0x30000000
 AddElement(t,'DEV_DIV_DEFAULT')

 t = {}
 t.id = 'DIV_UNDER_BACKGROUND'
 t.cx=-100
 t.cy=-100
 t.class="DIV"
 t.once=1
 t.zorder = 0 
 t.background = 0  
 t.backcolor0 = 0x7F000000
 AddElement(t) 

 t = {}
 t.id = 'MAIN_DIV'
 t.cx=-100
 t.cy=-45
 t.class="DIV"
 t.minresx=0
 t.minresy=0
 t.align = 0x0401
 t.left=0
 t.top=45
 t.once=1
 t.zorder=0
 t.background = 0
 t.backcolor0 = 0xe600000 
 AddElement(t)

 t = {}
 t.id = 'ID_LINE1'
 t.cx=-100
 t.cy=1
 t.class="DIV"
 t.minresx=0
 t.minresy=0
 t.align = 0x0101
 t.left=0
 t.top=0
 t.background = 0
 t.backcolor0 = borderColor
 AddElement(t,'MAIN_DIV')
 
 t = {}
 t.id = 'ID_LINE2'
 t.cx=-100
 t.cy=1
 t.class="DIV"
 t.minresx=0
 t.minresy=0
 t.align = 0x0401
 t.left=0
 t.top=0
 t.background = 0
 t.backcolor0 = borderColor --0xffff8c1a 
 AddElement(t,'MAIN_DIV')
  
 t = {}
 t.id = 'COVER_DIV'
 t.cx=700
 t.cy=-95
 t.class="DIV"
 t.minresx=0
 t.minresy=0
 t.align = 0x0101
 t.left=20
 t.top=20
 t.once=1
 t.zorder=0
 t.background = -1
 t.backcolor0 = 0x7fFFFF00
 AddElement(t,'MAIN_DIV')

 t = {}
 t.id = 'COVER_ART'
 t.cx=400
 t.cy=400
 t.class="IMAGE"
 t.imagepath = cover
 t.minresx=-1
 t.minresy=-1
 t.align = 0x0401
 t.left=10
 t.top=0
 --t.transparency = 230
 t.zorder=1
 t.borderwidth = 2
 t.bordercolor = borderColor 
 AddElement(t,'COVER_DIV')

 t={}
 t.id = 'MAIN_DIV_TEXT_TRACK'
 t.cx=0
 t.cy=300
 t.class="TEXT"
 t.align = 0x0401
 t.text = title
 t.color = textColor --0xffff8c1a
 t.font_height = trackFontHeight
 t.font_weight = trackFontWeight
 t.font_name = trackFont --"constantia"
 t.font_italic = trackFontItalic
 t.font_underline = trackFontUnderline
 --t.qt_textparam = 0 --1+4
 t.left = 450
 t.top  = 70
 t.boundWidth = 15

 if tonumber(scroll)==0 then
    t.row_limit=2
    if #title:gsub('[\128-\191]', '') < tonumber(numBreak) then 
     t.cy=0
     t.top  = 180
     t.row_limit=1
    end
 end

 if tonumber(scroll)==1 then
     t.cy=0
     t.top  = 180
     t.row_limit=1
     t.scrollTime = 40
     t.scrollFactor = 2
     --t.scrollWaitStart = 30
     t.scrollWaitEnd   = 100
     --t.text_elidemode = 0  --ElideLeft
     t.text_elidemode = 1  --ElideRight
     --t.text_elidemode = 2  --ElideMiddle
     --t.text_elidemode = 3  --ElideNone
 end
 AddElement(t,'COVER_ART')

 --debug_in_file(string.len(title) .. '\n')

 t={}
 t.id = 'MAIN_DIV_TEXT_STATION'
 t.cx=0
 t.cy=0
 t.class="TEXT"
 t.align = 0x0401
 t.text = station
 t.color = textColor
 t.font_height = stationFontHeight
 t.font_weight = stationFontWeight
 t.font_name = stationFont
 t.font_italic = stationFontItalic
 t.font_underline = stationFontUnderline
 t.left = 450
 t.top  = 70
 AddElement(t,'COVER_ART') 



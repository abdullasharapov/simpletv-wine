 --layout1

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

 m_simpleTV.OSD.RemoveElement('DIV_UNDER_BACKGROUND')
 m_simpleTV.OSD.RemoveElement('MAIN_DIV')

 local t={}			
 t.BackColor = 0
 t.BackColorEnd = 255
 t.PictFileName = m_simpleTV.User.Radio.Background
 t.TypeBackColor = 0
 t.UseLogo = 3
 t.Once = 1
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





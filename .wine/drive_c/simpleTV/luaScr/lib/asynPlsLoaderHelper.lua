local base = _G
module ('asynPlsLoaderHelper')

------------------------------------------------------------------
--static init
------------------------------------------------------------------
local DefaultMessage = 'Playlist loading'
------------------------------------------------------------------
------------------------------------------------------------------
function ARGB(A,R,G,B)
  local a = A*256*256*256+R*256*256+G*256+B
  if A<128 then return a end
  return a - 4294967296 
 end
------------------------------------------------------------------
local function ShowWaitWindow(params)
   
 local q = {}
 q.id = 'ID_APLS_WAIT'
 q.cx=-100
 q.cy=-100
 q.class="DIV"
 q.once=1
 q.zorder=0
 base.m_simpleTV.Interface.AddElementToMainFrame(q)
   
 q={}
 q.id = 'ID_APLS_WAIT_TEXT'
 q.cx=0
 q.cy=0
 q.class="TEXT"
 q.align = 0x0202
 q.top=130
 q.color = (params.MessageColor or ARGB(0xFF,0xD0,0xD0,0xD0))
 q.font_italic =0
 q.font_addheight=8
 q.padding=17
 q.textparam = 1+4 
 q.text = (params.Message or DefaultMessage) .. '  ............\n ' 
 q.background = 0
 q.backcolor0 = ARGB(0x90,0,0,0)
 base.m_simpleTV.Interface.AddElementToMainFrame(q,'ID_APLS_WAIT')
 base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT','SET_SIZE_LOCK')
 
 if params.ProgressEnabled==true then
  q={}
  q.id = 'ID_APLS_WAIT_PROGRESS_BORDER'
  q.cx=-100
  q.cy=10
  q.top=-12
  q.align = 0x0101
  q.class="DIV"
  q.borderwidth=1
  q.bordercolor = (params.ProgressBorderColor or ARGB(0x80,200,200,200))
  q.zorder=1
  base.m_simpleTV.Interface.AddElementToMainFrame(q,'ID_APLS_WAIT_TEXT')
 
  q={}
  q.id = 'ID_APLS_WAIT_PROGRESS'
  q.cx=0
  q.cy=8
  q.align = 0x0201
  q.class="DIV"
  q.background = 0
  q.backcolor0 = (params.ProgressColor or ARGB(0xE0,50,50,240))
  base.m_simpleTV.Interface.AddElementToMainFrame(q,'ID_APLS_WAIT_PROGRESS_BORDER')
 end 
 
 q={}
 q.id = 'ID_APLS_WAIT_TEXT1'
 q.cx=-100
 q.cy=0
 q.top=-4
 q.class="TEXT"
 q.align = 0x0402
 q.color = (params.CancelColor or ARGB(0xFF,0xB8,0xB8,0x28))
 q.font_italic =1
 q.font_addheight=4
 q.textparam = 1+4 
 q.text = 'press any key for cancel' 
 base.m_simpleTV.Interface.AddElementToMainFrame(q,'ID_APLS_WAIT_TEXT')
 
end
--------------------------------------------------------------------
local function HideWaitWindow()
 base.m_simpleTV.Interface.RemoveElementFromMainFrame('ID_APLS_WAIT') 
end
--------------------------------------------------------------------
--------------------------------------------------------------------
function APLS_GetAsynPl(session,rc,answer,userstring)
    
 local ret = base.m_simpleTV.User.APLS.Params.Callback(session,rc,answer,userstring,base.m_simpleTV.User.APLS.Params)
 if ret == nil or ret.Cancel==true then
    base.m_simpleTV.User.APLS.Cancel  = true
	return
  end
    
 if ret.Done==true then     
	 base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT','SET_VALUE_TEXT','Done\n ')
	 if base.m_simpleTV.User.APLS.Params.ProgressEnabled == true then
	   base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_PROGRESS','SET_BCOLOR0',ARGB(0x90,0x20,0xA0,0x20))
	   base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_PROGRESS','SET_SIZE_CX', -100  )
     end	   
	 base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT','REDRAW_ELEMENT')
	 base.m_simpleTV.User.APLS.Cancel  = true
	 base.m_simpleTV.Common.Wait(500)
	return
 end
     
 if ret.request == nil then
    base.m_simpleTV.User.APLS.Cancel  = true
	return
 end
 
 ret.request.callback='_MainPlsAsynCallback'
 if base.m_simpleTV.WinInet.RequestA(session,ret.request) ~= true then
    base.m_simpleTV.User.EP.Cancel  = true
	return
 end
 
 local needRedraw=false
 if ret.Count ~= nil then
   base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT','SET_VALUE_TEXT',(base.m_simpleTV.User.APLS.Params.Message or DefaultMessage) .. ' - ' .. ret.Count ..'\n ')
   needRedraw=true
   --base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT','APPLY')
   
   --local err,cx,cy = base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT','GET_SIZE')
   --local err1,left,top,right,bottom = base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT','GET_RECT')
   --local err2,cx2,cy2 = base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT','GET_VALUE_TEXT_SIZE')
   --if err then  base.debug_in_file('cx=' .. cx .. ' cy=' .. cy .. '\n') end
   --if err1 then  base.debug_in_file('left=' .. left .. ' top=' .. top .. ' right=' .. right  .. ' bottom=' .. bottom .. '\n') end
   --if err2 then  base.debug_in_file('cx2=' .. cx2 .. ' cy2=' .. cy2 .. '\n') end
   
 end
 
 if base.m_simpleTV.User.APLS.Params.ProgressEnabled == true 
    and ret.Progress~=nil and ret.Progress >= 0 and ret.Progress<=1 
    then
    base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_PROGRESS','SET_SIZE_CX', -100 * ret.Progress )
	needRedraw=true
 end   
 
 if needRedraw then
   base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT','REDRAW_ELEMENT')
 end   
 
end
--------------------------------------------------------------------
--------------------------------------------------------------------
function Work(session,request,params)
 
 if params==nil or params.Callback == nil then return end

 if base.m_simpleTV.User==nil then base.m_simpleTV.User={} end
 base.m_simpleTV.User.APLS = {}
 base.m_simpleTV.User.APLS.Cancel  = false
 base.m_simpleTV.User.APLS.Params = params
 
 ShowWaitWindow(params)
 base._MainPlsAsynCallback = APLS_GetAsynPl
 request.callback='_MainPlsAsynCallback'
 if base.m_simpleTV.WinInet.RequestA(session,request) ~=true then return  end

 while true do
	if base.m_simpleTV.User.APLS.Cancel == true then break end
	if base.m_simpleTV.Common.WaitUserInput(500)==1 then 
	  base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT1','SET_VALUE_TEXT','Cancelled')
	  base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT_TEXT1','SET_VALUE_TCOLOR',ARGB(250,255,0,0))
	  base.m_simpleTV.Interface.ControlElement('ID_APLS_WAIT','APPLY')
	  base.m_simpleTV.WinInet.RequestCancel(session)
	  base.m_simpleTV.Common.Wait(1000)
	  break 
    end
 end
  
 HideWaitWindow() 
 return true
end 
--------------------------------------------------------------------
--------------------------------------------------------------------

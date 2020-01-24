local base = _G
module ('jsdecode')

function getVersion()
  return  1.0, "v 1.0"
end 

function DoDecode(scr,nothide,PreScr,addflag,param)
 
 if base.m_simpleTV.jsUnpacker==nil then base.m_simpleTV.jsUnpacker={} end
 base.m_simpleTV.jsUnpacker.DecodeText = nil
 base.m_simpleTV.jsUnpacker.NotHide = false
 base.m_simpleTV.jsUnpacker.PreScr = PreScr
 base.m_simpleTV.jsUnpacker.EncodeText = scr
 base.m_simpleTV.jsUnpacker.Param = param
 
 if addflag==nil then addflag=0 end
 local fl=1 + 64 + addflag
  
 if nothide==true then 
    fl=fl-64+8
	base.m_simpleTV.jsUnpacker.NotHide=true

 end
 
 base.m_simpleTV.Dialog.Show('',base.m_simpleTV.MainScriptDir .. 'lib/jsdecode/jsunpack.html','lib/jsdecode/jsunpackd.lua',480,280,fl)   
 return base.m_simpleTV.jsUnpacker.DecodeText
 
 
end
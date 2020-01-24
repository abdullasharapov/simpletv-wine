local base = _G
module ('SLogger')

-------------------------------------------------------------------
-------------------------------------------------------------------
function Info (Mess)
 Write (Mess,0,nil,3)
end
-------------------------------------------------------------------
function Error (Mess)
 Write (Mess,1,nil,3)
end
-------------------------------------------------------------------
function Warn (Mess)
 Write (Mess,2,nil,3)
end
-------------------------------------------------------------------
function Dbg (Mess)
 Write (Mess,3,nil,3)
end
-------------------------------------------------------------------
-------------------------------------------------------------------
function Write (Mess,Verbose,Module,StackLevel)
 
 if Mess==nil then return end
 if Verbose==nil then Verbose=3 end  -- debug is default
 if StackLevel==nil then StackLevel=2 end
 
 if Module==nil then 
  local info = base.debug.getinfo(StackLevel, "nSl")
  if info then
    Module = 'Lua' 
	if info.short_src then 
		Module = Module .. info.short_src .. ':'
	end
	Module = Module .. (info.currentline or '0')
	
	if info.name then 
		Module = Module .. ':' .. info.name .. '()'
	end
  end
 end
 
 RawWrite(Mess,Verbose,Module)
end
-------------------------------------------------------------------
function RawWrite (Mess,Verbose,Module)
   base.m_simpleTV.Logger.WriteToLog(Mess,Verbose,Module)
end
-------------------------------------------------------------------
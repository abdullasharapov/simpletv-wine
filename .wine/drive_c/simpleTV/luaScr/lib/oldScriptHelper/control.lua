m_simpleTV.Control.SetBackground = m_simpleTV.Interface.SetBackground
m_simpleTV.Control.RestoreBackground = m_simpleTV.Interface.RestoreBackground
setmetatable(m_simpleTV.Control,{
__index = function(t,k)
 if k == 'ChangeAdress' then
   return rawget(t,'ChangeAddress')
 elseif k == 'CurrentAdress' then
   return rawget(t,'CurrentAddress')
 elseif k == 'RealAdress' then
   return rawget(t,'RealAddress')
 else
   return nil
 end
end,
__newindex = function(t,k,v)
 if k == 'ChangeAdress' then
   rawset(t,'ChangeAddress',v)
 elseif k == 'CurrentAdress' then
   rawset(t,'CurrentAddress',v)
 elseif k == 'RealAdress' then
   rawset(t,'RealAddress',v)
 else
   rawset(t,k,v)
 end
end})
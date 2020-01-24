if m_simpleTV.Control.CurrentAdress and not string.match( m_simpleTV.Control.CurrentAdress, '^$ntvplus=%d+' ) then return end

 if m_simpleTV.Control.Reason=='Error' then

   if m_simpleTV.User.NTVPlus.Error==nil then m_simpleTV.User.NTVPlus.Error=0 end

    if m_simpleTV.User.NTVPlus.Error > 3 then 
       m_simpleTV.Control.ExecuteAction(11)
       m_simpleTV.User.NTVPlus.Error=nil
       return
    end

   m_simpleTV.User.NTVPlus.Table=nil
   m_simpleTV.User.NTVPlus.Error = m_simpleTV.User.NTVPlus.Error + 1
   m_simpleTV.Control.ExecuteAction(63) 
end 


if m_simpleTV.Control.Reason=='Playing' then
   m_simpleTV.User.NTVPlus.Error=nil
end




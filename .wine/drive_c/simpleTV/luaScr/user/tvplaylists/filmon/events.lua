
if m_simpleTV.Control.CurrentAdress == nil or not string.match( m_simpleTV.Control.CurrentAdress, '^filmonlivetv=' ) then return end 

if m_simpleTV.Control.Reason == 'Playing' then

  if not m_simpleTV.User.Filmon01.TimerOff then
    if m_simpleTV.User.Filmon01.TimerId==nil then
       m_simpleTV.User.Filmon01.TimerId = m_simpleTV.Timer.SetTimer(12*1000,"GetFilmonStream()")
    end
  end
end

if m_simpleTV.Control.Reason == 'Stopped' or m_simpleTV.Control.Reason =='Error' then
  if m_simpleTV.User.Filmon01.TimerId~= nil then
     m_simpleTV.Timer.DeleteTimer (m_simpleTV.User.Filmon01.TimerId)
     m_simpleTV.User.Filmon01.TimerId=nil
  end
end


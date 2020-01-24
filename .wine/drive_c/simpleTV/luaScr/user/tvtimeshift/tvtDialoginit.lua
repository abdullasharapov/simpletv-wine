--скрипт дополнения Архивы (timeshift) (3/10/19)
if not m_simpleTV.Control.CurrentAdress
or not m_simpleTV.Control.RealAdress
or not (
m_simpleTV.Control.RealAdress:match('rt%.ru/hls/CH_') -- ITV 2.0
or m_simpleTV.Control.RealAdress:match('ngenix%.net/hls/CH_') -- ITV 2.0
or m_simpleTV.Control.RealAdress:match('strm%.yandex%.ru/ka') -- yandextv
or m_simpleTV.Control.RealAdress:match('hls%.peers%.tv.-tshift=true') -- peerstv
or m_simpleTV.Control.RealAdress:match('hls%.peers%.tv.-offset=') -- peerstv
or m_simpleTV.Control.RealAdress:match('ott%.zala%.by') -- zala
or m_simpleTV.Control.RealAdress:match('178%.124%.183%.') -- zala
or m_simpleTV.Control.RealAdress:match('93%.85%.93%.') -- zala
)
then
  m_simpleTV.OSD.ShowMessageT({text='Окно Архива не доступно'})
  return
end
if m_simpleTV.User==nil then m_simpleTV.User={} end
if m_simpleTV.User.TVTimeShift==nil then m_simpleTV.User.TVTimeShift={} end
 m_simpleTV.User.TVTimeShift.Dialog = m_simpleTV.Dialog.Show(
	m_simpleTV.Common.UTF8ToMultiByte('Архивы')
	, m_simpleTV.MainScriptDir ..'user\\tvtimeshift\\tvtDialog.html'
	, 'user\\tvtimeshift\\tvtDialog.lua'
	, 370
	, 160
	, 1+32
	)
require'ex'
require 'json'

if m_simpleTV.Control.ChangeAddress ~= 'No' then return end

if not string.match(package.path,'user/video/core' , 0)  then
	package.path = package.path .. ';' .. m_simpleTV.MainScriptDir .. 'user/video/core/?.lua'
end

local inAdr =  m_simpleTV.Control.CurrentAddress
if inAdr==nill then return end

local pathname = m_simpleTV.MainScriptDir .. "user/video/"

for entry in os.dir(pathname) do
  if string.match(entry.name,'.lua$') and not string.match(entry.name,'^video.lua$') then
	 dofile (m_simpleTV.MainScriptDir .. "user/video/" .. entry.name)
	 if m_simpleTV.Control.ChangeAddress ~= 'No' then break end
  end
end


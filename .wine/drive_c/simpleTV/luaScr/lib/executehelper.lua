
--list of reasons 
-- getaddress   1
-- events       2
-- onconfig     3
-- refreshplst  4

--init
 m_simpleTV.ExecuteFiles={}
 m_simpleTV.ExecuteFiles[1]={}
 m_simpleTV.ExecuteFiles[2]={}
 m_simpleTV.ExecuteFiles[3]={}
 m_simpleTV.ExecuteFiles[4]={}
--end init

function AddFileToExecute(reason,filename)

 filename = m_simpleTV.Common.CleanPath(m_simpleTV.Common.multiByteToUTF8(filename))
 filename = m_simpleTV.Common.UTF8ToMultiByte(filename)
 local index = TestReasonExecute(reason)
 if index == nil then return false end
 
 for i=1,100000,1 do
    if m_simpleTV.ExecuteFiles[index][i] == nil then
	    m_simpleTV.ExecuteFiles[index][i]=filename 
	  return true
	end
 end
return false
end
---------------------------------------
function TestReasonExecute(reason)
 
 if reason=='getaddress' then return 1 end
 if reason=='events' then return 2 end
 if reason=='onconfig' then return 3 end
 if reason=='refreshplst' then return 4 end

 return nil
end
---------------------------------------
function RemoveFileFromExecute(reason,filename)
 local index = TestReasonExecute(reason)
 if index == nil then return false end
 
 for i=1,100000,1 do
    if m_simpleTV.ExecuteFiles[index][i] == nil then break end
	
	if m_simpleTV.ExecuteFiles[index][i]==filename then 
	  m_simpleTV.ExecuteFiles[index].remove(i)
	  break
	end

 end
 
end
---------------------------------------
function ExecuteFilesByReason(reason)
  local index = TestReasonExecute(reason)
  if index == nil then return end
  
  for i,w in ipairs(m_simpleTV.ExecuteFiles[index]) do
    if w ~= nil then 
      --debug_in_file(w .. '\n')
	  dofile (w)
	end
 end
 
end
---------------------------------------

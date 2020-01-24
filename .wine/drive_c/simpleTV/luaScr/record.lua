  
if package.loaded.recordPattern~=nil then   
  local str = recordPattern.getFileNameById(  m_simpleTV.Control.RecordType
                                             ,m_simpleTV.Control.RecordChannelId
											 ,m_simpleTV.Control.RecordChannelName
											 ,m_simpleTV.Control.RecordEpgName
											 ,m_simpleTV.Control.RecordEpgId
											 ,m_simpleTV.Control.RecordTimeshiftOffset
											)
  if str==nil or str=='' then return end
  m_simpleTV.Control.RecordFileName = str
  m_simpleTV.Control.RecordSnapshotFileName  = str 
end 
 
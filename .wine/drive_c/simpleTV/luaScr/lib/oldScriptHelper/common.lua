
m_simpleTV.Common.string_toUTF8 = m_simpleTV.Common.multiByteToUTF8
m_simpleTV.Common.string_fromUTF8 = m_simpleTV.Common.UTF8ToMultiByte
m_simpleTV.Common.string_UnicodeToUTF8 = m_simpleTV.Common.UTF16ToUTF8
m_simpleTV.Common.string_UTF8ToUnicode = m_simpleTV.Common.UTF8ToUTF16
m_simpleTV.Common.string_IsUTF8 = m_simpleTV.Common.isUTF8
m_simpleTV.Common.string_replaceUTF8 = m_simpleTV.Common.replaceUTF8


m_simpleTV.Common.Wait = m_simpleTV.Common.Sleep
---------------------------------------------------------------------------
m_simpleTV.Common.FolderPicker_UTF8 = m_simpleTV.Interface.FolderPicker_UTF8
m_simpleTV.Common.FolderPicker = function(Name,Path)
 local ret = m_simpleTV.Interface.FolderPicker_UTF8(m_simpleTV.Common.string_toUTF8(Name),Path and m_simpleTV.Common.string_toUTF8(Path) or nil)
 if ret == nil then return ret end
 return m_simpleTV.Common.string_fromUTF8(ret)
end
---------------------------------------------------------------------------
m_simpleTV.Common.DownloadFileInTmp = function (URL,inFileName) 
 local session = m_simpleTV.Http.New()
 if session == nil then return nil end
 
 local rc,fileName = m_simpleTV.Http.Request(session,{url = URL,writeinfile =true,filename=inFileName})
 m_simpleTV.Http.Close(session)
 if fileName == nil or fileName=="" then return nil end
 return fileName
end
---------------------------------------------------------------------------
m_simpleTV.Common.RefreshPlayList    = m_simpleTV.PlayList.Refresh
m_simpleTV.Common.LoadPlayList       = m_simpleTV.PlayList.Load
m_simpleTV.Common.LoadPlayList_UTF8  = m_simpleTV.PlayList.Load_UTF8
m_simpleTV.Common.SavePlayList       = m_simpleTV.PlayList.Save

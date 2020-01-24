if TVSources_var then dofile(TVSources_var.TVSdir ..'/events.lua') end
---------------------------
--input
--m_simpleTV.Control.Reason              Error|EndReached|Stopped|Playing|Sleeping|addressready|Timeout|ScrambledOn|ScrambledOff|Exiting
--m_simpleTV.Control.CurrentAddress      Address from database
--m_simpleTV.Control.RealAddress		 Real Address

--output
--m_simpleTV.Control.CurrentAddress      Address from database
--m_simpleTV.Control.Action              dodefault|repeat|stop

--m_simpleTV.Control.Reason=Sleeping - comp going to sleep, all other fields are undefined   
--m_simpleTV.Control.Reason=Exiting  - program is terminated, all other fields are undefined   

--m_simpleTV.OSD.ShowMessage('r - ' .. m_simpleTV.Control.Reason .. ',addr= ' .. m_simpleTV.Control.CurrentAddress .. ',radr=' .. m_simpleTV.Control.RealAddress ,255,1)
--debug_in_file('r - ' .. m_simpleTV.Control.Reason .. ', addr= ' .. m_simpleTV.Control.CurrentAddress .. ', radr=' .. m_simpleTV.Control.RealAddress .. '\n')
--debug_in_file('mode:' .. m_simpleTV.Control.GetMode() ..  ',reason:' .. m_simpleTV.Control.Reason .. ', addr:' .. m_simpleTV.Control.CurrentAddress .. ', radr:' .. m_simpleTV.Control.RealAddress .. '\n')

--m_simpleTV.Control.EventPlayingInterval=1000
--m_simpleTV.Control.EventTimeOutInterval=1000  

ExecuteFilesByReason('events')


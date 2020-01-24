-------------------------- кодировка utf-8 -----------------------
 
--[[    ------------- код для старой версии 0.4.9 ---
		if not package.path:find(TVSources_var.TVSname..'\\core' )  then
			package.path = package.path .. ";" .. TVSources_var.TVSdir .. 'core\\?.lua'
		end
		require("tvs_core")
]]
---------------------------------------------------------------------------------------------------------
local function SetElementHtml(Object, name, value)
	m_simpleTV.Dialog.SetElementHtml_UTF8(Object, name, value)
end

local function SetElementValueString(Object, name, value)
     m_simpleTV.Dialog.SetElementValueString_UTF8(Object, name, value)
end
local function SetCheckBoxValue(Object, name, value)
         m_simpleTV.Dialog.SetCheckBoxValue(Object, name, value)
end

local function GetCheckBoxValue(Object, name)
         return m_simpleTV.Dialog.GetCheckBoxValue(Object, name)
end

local function GetElementValueString(Object, name, value)
     return m_simpleTV.Dialog.GetElementValueString_UTF8(Object, name, value)
end

local function GetComboValue(Object, name)
  if  m_simpleTV.Dialog.GetComboValue_UTF8 then 
      return m_simpleTV.Dialog.GetComboValue_UTF8(Object, name)
  else    
      local value = m_simpleTV.Dialog.GetComboValue(Object, name)
      return  m_simpleTV.Common.string_toUTF8(value,1251)
  end    
end
---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

function GetNewSource(name)
  if name == nil then
    name = SourceNameTest()
  end
  local new_source = {}
  new_source[name] = tvs_core.tvs_NewSource()
  return new_source
end

function SourceNameTest(name)
  if name == nil then
    name = tvs_core.tvs_GetLangStr("src_new")
  end
  if TVSources_var.tmp.srcname[name] == nil then
    return name
  end
  local b = 1
  name = name .. " #1"
  repeat
    b = b + 1
    name = string.gsub(name, "#(.-)$", "#" .. b)
  until TVSources_var.tmp.srcname[name] == nil
  return name
end


function GetSourceParam(Object)
  local CurrentSource = ""
  local value = ""
  local value2 = ""
  CurrentSource = GetElementValueString(Object, "SrcID")
  if CurrentSource ~= nil and CurrentSource ~= "" then
    value = GetElementValueString(Object, "SRCName1")
    value2 = GetElementValueString(Object, "SRCName")

    if value ~= value2 then
      value2 = SourceNameTest(value2)
      TVSources_var.tmp.srcname[value] = nil
      TVSources_var.tmp.srcname[value2] = CurrentSource
      --[[
      SetElementHtml(Object, "BtnSourcesSave", "<input id=\"idBtnSourcesSave\" type=\"image\" onclick=\"changeIcon('idBtnSourcesSave','img/btn_save_click.png','img/btn_save.png')\" src=\"img/btn_save_ns.png\"  onmouseover=\"this.src='img/btn_save_ns_focus.png'\" onmouseout=\"this.src='img/btn_save_ns.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_savesrc") .. "\"/>")
      ]]
    end
    if not type(TVSources_var.tmp.source[CurrentSource])=='table' then TVSources_var.tmp.source[CurrentSource] = {}
    end   
    TVSources_var.tmp.source[CurrentSource].name = value2
    TVSources_var.tmp.source[CurrentSource].sortname = GetElementValueString(Object, "SortName") or ""
    TVSources_var.tmp.source[CurrentSource].scraper = GetElementValueString(Object, "Scraper") or ""
    TVSources_var.tmp.source[CurrentSource].scraper = string.gsub(TVSources_var.tmp.source[CurrentSource].scraper, "[*|<>]", "") or ""
    TVSources_var.tmp.source[CurrentSource].m3u = GetElementValueString(Object, "Path") or ""
    TVSources_var.tmp.source[CurrentSource].m3u = string.gsub(TVSources_var.tmp.source[CurrentSource].m3u, "[*|\"<>]", "") or ""
   
    --TVSources_var.tmp.source[CurrentSource].logo = value3
    
    TVSources_var.tmp.source[CurrentSource].TypeSource = tonumber(GetElementValueString(Object, "SRCType")) or 0
    TVSources_var.tmp.source[CurrentSource].TypeCoding = tonumber(GetElementValueString(Object, "CodePage1")) or 0
    TVSources_var.tmp.source[CurrentSource].LastStart = tonumber(GetElementValueString(Object, "LastDate1")) or 0
    TVSources_var.tmp.source[CurrentSource].RefreshButton = GetCheckBoxValue(Object, "BtnUpdSr") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuild = GetCheckBoxValue(Object, "AutUpdSr") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay = TVSources_var.tmp.source[CurrentSource].AutoBuildDay or {}
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay[1] = GetCheckBoxValue(Object, "SRCDay1") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay[2] = GetCheckBoxValue(Object, "SRCDay2") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay[3] = GetCheckBoxValue(Object, "SRCDay3") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay[4] = GetCheckBoxValue(Object, "SRCDay4") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay[5] = GetCheckBoxValue(Object, "SRCDay5") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay[6] = GetCheckBoxValue(Object, "SRCDay6") or 0
    TVSources_var.tmp.source[CurrentSource].AutoBuildDay[7] = GetCheckBoxValue(Object, "SRCDay7") or 0
    TVSources_var.tmp.source[CurrentSource].DeleteM3U = GetCheckBoxValue(Object, "DeleteM3U") or 0

    TVSources_var.tmp.source[CurrentSource].show_progress = GetCheckBoxValue(Object, "ShowProgress") or 0

    TVSources_var.tmp.source[CurrentSource].TVS = TVSources_var.tmp.source[CurrentSource].TVS  or {}
    TVSources_var.tmp.source[CurrentSource].TVS.add = GetCheckBoxValue(Object, "InTVS") or 0
    TVSources_var.tmp.source[CurrentSource].TVS.FilterCH = GetCheckBoxValue(Object, "TVS_FCH") or 0
    TVSources_var.tmp.source[CurrentSource].TVS.FilterGR = GetCheckBoxValue(Object, "TVS_FGR") or 0
    TVSources_var.tmp.source[CurrentSource].TVS.GetGroup = GetCheckBoxValue(Object, "TVS_GetGR") or 0
    TVSources_var.tmp.source[CurrentSource].TVS.LogoTVG = GetCheckBoxValue(Object, "TVS_GetLogo") or 0
    TVSources_var.tmp.source[CurrentSource].STV = TVSources_var.tmp.source[CurrentSource].STV or {}
    TVSources_var.tmp.source[CurrentSource].STV.add = GetCheckBoxValue(Object, "InBase") or 0
    TVSources_var.tmp.source[CurrentSource].STV.ExtFilter = GetCheckBoxValue(Object, "SRC_M3UexF") or 0
    TVSources_var.tmp.source[CurrentSource].STV.FilterCH = GetCheckBoxValue(Object, "SPL_FCH") or 0
    TVSources_var.tmp.source[CurrentSource].STV.FilterGR = GetCheckBoxValue(Object, "SPL_FGR") or 0
    TVSources_var.tmp.source[CurrentSource].STV.GetGroup = GetCheckBoxValue(Object, "SPL_GetGR") or 0
    TVSources_var.tmp.source[CurrentSource].STV.HDGroup = GetCheckBoxValue(Object, "SPL_HDGR") or 0
    TVSources_var.tmp.source[CurrentSource].STV.AutoSearch = GetCheckBoxValue(Object, "SPL_AutoTVG") or 0
    TVSources_var.tmp.source[CurrentSource].STV.AutoNumber = GetCheckBoxValue(Object, "SPL_AutoNum") or 0
    TVSources_var.tmp.source[CurrentSource].STV.NumberM3U = GetCheckBoxValue(Object, "SPL_M3UNum") or 0
    TVSources_var.tmp.source[CurrentSource].STV.GetSettings = GetCheckBoxValue(Object, "SPL_M3USet") or 0
    TVSources_var.tmp.source[CurrentSource].STV.NotDeleteCH = GetCheckBoxValue(Object, "SPL_NoDel") or 0
    TVSources_var.tmp.source[CurrentSource].STV.TypeSkip   = tonumber(GetElementValueString(Object, "AlrCH1")) or 0
    TVSources_var.tmp.source[CurrentSource].STV.TypeFind   = tonumber(GetElementValueString(Object, "TypeSH1")) or 0
    TVSources_var.tmp.source[CurrentSource].STV.TypeMedia = tonumber(GetElementValueString(Object, "TypeMed1")) or 0
    return CurrentSource
  end
  return nil
end


 
function SourceToHTML(Object, CurrentSource, updlist)
  if updlist then
    updlist = true
  else
    updlis = false
  end
  local name, content
  local source_sort = {}
  local value = ""
  for tvs, _ in pairs(TVSources_var.tmp.source) do
    if TVSources_var.tmp.source[tvs].TypeSource == nil then
      TVSources_var.tmp.source[tvs].TypeSource = 1
    end
    if TVSources_var.tmp.SourceType == 2 or TVSources_var.tmp.SourceType == TVSources_var.tmp.source[tvs].TypeSource then
      table.insert(source_sort, {
        sname = (TVSources_var.tmp.source[tvs].sortname or '') .. (TVSources_var.tmp.source[tvs].name or ''),
        name = TVSources_var.tmp.source[tvs].name or '',
        value = tvs
      })
    end
  end
  if #source_sort == 0 then
    TVSources_var.tmp.SourceType = 2
    updlist = true
    source_sort = nil
    source_sort = {}
    value = "<select autofocus onchange=\"UpdateList('SourceTypePos',this.value)\" id='idSrcType' class='SourcesSelectCombo' ><option value='0'>" .. tvs_core.tvs_GetLangStr("src_type0") .. "</option><option value='1'>" .. tvs_core.tvs_GetLangStr("src_type1") .. "</option><option selected value='2' >" .. tvs_core.tvs_GetLangStr("src_type2") .. "</option></select>"
    SetElementHtml(Object, "SourceTypePos", TVSources_var.tmp.SourceType)
    SetElementHtml(Object, "SourcesType", value)
    for tvs, _ in pairs(TVSources_var.tmp.source) do
      table.insert(source_sort, {
        sname = (TVSources_var.tmp.source[tvs].sortname or '') .. (TVSources_var.tmp.source[tvs].name or ''),
        name = TVSources_var.tmp.source[tvs].name or '',
        value = tvs
      })
    end
  end
  table.sort(source_sort, function(a, b)
    return a.sname < b.sname
  end)
  
  if not source_sort or not source_sort[1] then return end  -- пустой список!!!
  
  if CurrentSource == nil then
    CurrentSource = source_sort[1].value  
  end
  
  if updlist then
    value = ""
    local color = "black"
    for _, t in pairs(source_sort) do
      if TVSources_var.tmp.source[t.value].TypeSource==1 then color = "black" else color = "gray" end
      if t.value == CurrentSource then
        value = value .. '<option class="SelectOption" selected="selected" value="' .. t.value .. '">' .. t.name .. '</option>'
      else
        value = value .. '<option class="SelectOption" style="color: '..color..';" value="' .. t.value .. '">' .. t.name .. '</option>'
      end
    end
    
    value = "<select id='idSrcList' size='1' multiple class='SourcesSelectList' >" .. value .. "</select>"
    SetElementHtml(Object, "idSourcesList", value)
  end
  SetElementValueString(Object, "SrcID", CurrentSource)
  SetElementValueString(Object, "SRCName", TVSources_var.tmp.source[CurrentSource].name)
  SetElementValueString(Object, "SRCName1", TVSources_var.tmp.source[CurrentSource].name)
  if TVSources_var.tmp.source[CurrentSource].sortname ~= nil then
    SetElementValueString(Object, "SortName", TVSources_var.tmp.source[CurrentSource].sortname)
  else
    SetElementValueString(Object, "SortName", "")
  end
  if TVSources_var.tmp.source[CurrentSource].scraper ~= nil then
    SetElementValueString(Object, "Scraper", TVSources_var.tmp.source[CurrentSource].scraper)
  else
    SetElementValueString(Object, "Scraper", "")
  end
  if TVSources_var.tmp.source[CurrentSource].m3u ~= nil then
    SetElementValueString(Object, "Path", TVSources_var.tmp.source[CurrentSource].m3u)
  else
    SetElementValueString(Object, "Path", "")
  end

  value = tvs_core.GetSrcLogo(TVSources_var.tmp.source[CurrentSource]) or ""
  local tmp = (value=="") and  ''   or  '<img width="24px" height="24px" src="'.. value  ..'">' 
  SetElementHtml(Object, "idSrcLogo",  tmp)  

  source_sort = {
    "Plain TEXT",
    "UTF8",
    "UNICODE"
  }
  
  if TVSources_var.tmp.source[CurrentSource].TypeCoding ~= nil then
    SetElementValueString(Object, "CodePage1", TVSources_var.tmp.source[CurrentSource].TypeCoding)
    SetElementValueString(Object, "CodePage", source_sort[TVSources_var.tmp.source[CurrentSource].TypeCoding + 1])
  else
    SetElementValueString(Object, "CodePage1", 0)
    SetElementValueString(Object, "CodePage", source_sort[1])
  end
  if TVSources_var.tmp.source[CurrentSource].TypeSource ~= nil then
    SetElementValueString(Object, "SRCType", TVSources_var.tmp.source[CurrentSource].TypeSource)
  else
    SetElementValueString(Object, "SRCType", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].TVS.add == 1 then
    SetCheckBoxValue(Object, "InTVS", 1)
  else
    SetCheckBoxValue(Object, "InTVS", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.add == 1 then
    SetCheckBoxValue(Object, "InBase", 1)
  else
    SetCheckBoxValue(Object, "InBase", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].RefreshButton == 1 then
    SetCheckBoxValue(Object, "BtnUpdSr", 1)
  else
    SetCheckBoxValue(Object, "BtnUpdSr", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuild == 1 then
    SetCheckBoxValue(Object, "AutUpdSr", 1)
  else
    SetCheckBoxValue(Object, "AutUpdSr", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuildDay[1] == 1 then
    SetCheckBoxValue(Object, "SRCDay1", 1)
  else
    SetCheckBoxValue(Object, "SRCDay1", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuildDay[2] == 1 then
    SetCheckBoxValue(Object, "SRCDay2", 1)
  else
    SetCheckBoxValue(Object, "SRCDay2", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuildDay[3] == 1 then
    SetCheckBoxValue(Object, "SRCDay3", 1)
  else
    SetCheckBoxValue(Object, "SRCDay3", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuildDay[4] == 1 then
    SetCheckBoxValue(Object, "SRCDay4", 1)
  else
    SetCheckBoxValue(Object, "SRCDay4", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuildDay[5] == 1 then
    SetCheckBoxValue(Object, "SRCDay5", 1)
  else
    SetCheckBoxValue(Object, "SRCDay5", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuildDay[6] == 1 then
    SetCheckBoxValue(Object, "SRCDay6", 1)
  else
    SetCheckBoxValue(Object, "SRCDay6", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].AutoBuildDay[7] == 1 then
    SetCheckBoxValue(Object, "SRCDay7", 1)
  else
    SetCheckBoxValue(Object, "SRCDay7", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].DeleteM3U == 1 then
    SetCheckBoxValue(Object, "DeleteM3U", 1)
  else
    SetCheckBoxValue(Object, "DeleteM3U", 0)
  end
  
  SetCheckBoxValue(Object, "ShowProgress", TVSources_var.tmp.source[CurrentSource].show_progress or 0)
  
  if TVSources_var.tmp.source[CurrentSource].TVS.FilterCH == 1 then
    SetCheckBoxValue(Object, "TVS_FCH", 1)
  else
    SetCheckBoxValue(Object, "TVS_FCH", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].TVS.FilterGR == 1 then
    SetCheckBoxValue(Object, "TVS_FGR", 1)
  else
    SetCheckBoxValue(Object, "TVS_FGR", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].TVS.GetGroup == 1 then
    SetCheckBoxValue(Object, "TVS_GetGR", 1)
  else
    SetCheckBoxValue(Object, "TVS_GetGR", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].TVS.LogoTVG == 1 then
    SetCheckBoxValue(Object, "TVS_GetLogo", 1)
  else
    SetCheckBoxValue(Object, "TVS_GetLogo", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.ExtFilter == 1 then
    SetCheckBoxValue(Object, "SRC_M3UexF", 1)
  else
    SetCheckBoxValue(Object, "SRC_M3UexF", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.FilterCH == 1 then
    SetCheckBoxValue(Object, "SPL_FCH", 1)
  else
    SetCheckBoxValue(Object, "SPL_FCH", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.FilterGR == 1 then
    SetCheckBoxValue(Object, "SPL_FGR", 1)
  else
    SetCheckBoxValue(Object, "SPL_FGR", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.GetGroup == 1 then
    SetCheckBoxValue(Object, "SPL_GetGR", 1)
  else
    SetCheckBoxValue(Object, "SPL_GetGR", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.HDGroup == 1 then
    SetCheckBoxValue(Object, "SPL_HDGR", 1)
  else
    SetCheckBoxValue(Object, "SPL_HDGR", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.AutoSearch == 1 then
    SetCheckBoxValue(Object, "SPL_AutoTVG", 1)
  else
    SetCheckBoxValue(Object, "SPL_AutoTVG", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.AutoNumber == 1 then
    SetCheckBoxValue(Object, "SPL_AutoNum", 1)
  else
    SetCheckBoxValue(Object, "SPL_AutoNum", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.NumberM3U == 1 then
    SetCheckBoxValue(Object, "SPL_M3UNum", 1)
  else
    SetCheckBoxValue(Object, "SPL_M3UNum", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.GetSettings == 1 then
    SetCheckBoxValue(Object, "SPL_M3USet", 1)
  else
    SetCheckBoxValue(Object, "SPL_M3USet", 0)
  end
  if TVSources_var.tmp.source[CurrentSource].STV.NotDeleteCH == 1 or TVSources_var.tmp.source[CurrentSource].STV.NotDeleteCH == "nil" then
    SetCheckBoxValue(Object, "SPL_NoDel", 1)
  else
    SetCheckBoxValue(Object, "SPL_NoDel", 0)
  end
  
  if TVSources_var.tmp.source[CurrentSource].STV.TypeSkip ~= nil then
    SetElementValueString(Object, "AlrCH1", TVSources_var.tmp.source[CurrentSource].STV.TypeSkip)
    SetElementValueString(Object, "AlrCH", tvs_core.tvs_GetLangStr("src_m3u_alr" .. TVSources_var.tmp.source[CurrentSource].STV.TypeSkip))
  else
    SetElementValueString(Object, "AlrCH1", 0)
    SetElementValueString(Object, "AlrCH", tvs_core.tvs_GetLangStr("src_m3u_alr0"))
  end
  
  if TVSources_var.tmp.source[CurrentSource].STV.TypeFind ~= nil then
    SetElementValueString(Object, "TypeSH1", TVSources_var.tmp.source[CurrentSource].STV.TypeFind)
    SetElementValueString(Object, "TypeSH", tvs_core.tvs_GetLangStr("src_m3u_type" .. TVSources_var.tmp.source[CurrentSource].STV.TypeFind))
  else
    SetElementValueString(Object, "TypeSH1", 0)
    SetElementValueString(Object, "TypeSH", tvs_core.tvs_GetLangStr("src_m3u_type0"))
  end
  
  value = TVSources_var.tmp.source[CurrentSource].STV.TypeMedia or 0
  SetElementValueString(Object, "TypeMed1", value)
  SetElementValueString(Object, "TypeMed", tvs_core.tvs_GetLangStr("src_m3u_typemedia" .. value))

  
  if TVSources_var.tmp.source[CurrentSource].LastStart ~= nil and 0 < TVSources_var.tmp.source[CurrentSource].LastStart then
    SetElementValueString(Object, "LastDate1", TVSources_var.tmp.source[CurrentSource].LastStart)
    SetElementValueString(Object, "LastDate", os.date("%d.%m.%Y", TVSources_var.tmp.source[CurrentSource].LastStart))
  else
    SetElementValueString(Object, "LastDate1", 0)
    SetElementValueString(Object, "LastDate", "")
  end
end
--------------------------------------------------------------------------------------------------------------------------------

local function dec2bin(num)
	local t = {    ['0'] = '00',    ['1'] = '01',    ['2'] = '10',    ['3'] = '11' }   
   local s = t[tostring(num)] or '00'
   return s:sub(1,1), s:sub(2)
end

-------------------


	
 local function  value_from_filter_file(fname, tab_num)
	   local text =""
	   res = tvs_core.tvs_fcheck(fname)
	   if res == "ok" then
			    local t =  dofile(fname)
			    if type(t)~= "table" then
			     	 tvs_core.tvs_debug("Can't read file : " .. fname)
			    else
	                      local names_t = tvs_core.GetTableFromChannels(tab_num)
	                      
                          local log_t = tvs_core.GetTableFromFiltersLog(tab_num)
			              local ch_name, out, s , f = {} , {}, "", ""
					      for ch_1, ch_2 in pairs(t) do
					        table.insert(ch_name, { name = ch_2[1],   value = ch_2[2]   })
					      end
					      table.sort(ch_name, function(a, b)      return a.name < b.name     end)
					      for ch_1, ch_2 in pairs(ch_name) do
						        if ch_2.name ~= nil and ch_2.name ~= "" and ch_2.value ~= nil and ch_2.value ~= "" then
						              s = log_t[ch_2.name] and log_t[ch_2.name].Source or ''
						              local nohd = ch_2.value:gsub("|.+","")
						              f = names_t[nohd] and ( names_t[nohd].Fav==1 and '2' or '1') or '0'
						              --debug_in_file(ch_2.name .. ">>" .. ch_2.value .. " >> s=".. s .. " f=" .. f)
							          out[#out+1]  =  ch_2.name .. ";" .. ch_2.value .. ";" .. s ..";" .. f..">>"
						        end
					      end
					      text = table.concat(out)
					      text = text:gsub(">>$","")
			    end
	   else
		    tvs_core.tvs_debug("Can't find file : " .. fname)
	   end
	   
	   return text
 end
     
local function FiltersLoad(Object, num)
  --------------------------------------------------------------
  local clock =  os.clock() 
  local value, fname = "", ""
  if num=='1' then
	  fname = TVSources_var.TVSdir .. "core\\channel_filter.lua"
	  value = value_from_filter_file(fname,1)
	  if value == nil or value == "" then
	     value = "Channel before;Channel after"
	  end
	  SetElementValueString(Object, "idCHList", value)
	  SetElementHtml(Object, "idFH1", tvs_core.tvs_GetLangStr("html_channel_bf"))
	  SetElementHtml(Object, "idFH2", tvs_core.tvs_GetLangStr("html_channel_af"))
  elseif num=='2' then
	  fname = TVSources_var.TVSdir .. "core\\groups_filter.lua"
	  value = value_from_filter_file(fname,2)
	  if value == nil or value == "" then
	     value = "Group before;Group after"
	  end
	  SetElementValueString(Object, "idGRList", value)
	  SetElementHtml(Object, "idFG1", tvs_core.tvs_GetLangStr("html_group_bf"))
	  SetElementHtml(Object, "idFG2", tvs_core.tvs_GetLangStr("html_group_af"))
  elseif num=='3' then
	  fname = TVSources_var.TVSdir .. "core\\channel_group.lua"
	  value = value_from_filter_file(fname,3)
	  if value == nil or value == "" then
	    value = "Channel name;Group name"
	  end
	  SetElementValueString(Object, "idGCList", value)
	  SetElementHtml(Object, "idCG1", tvs_core.tvs_GetLangStr("html_channel"))
	  SetElementHtml(Object, "idCG2", tvs_core.tvs_GetLangStr("html_group_af"))
  end 

--debug_in_file ( string.format(fname .." loaded  >> %.4f s. ",   os.clock() - clock )  )
  
end
--------------------------------------------------------------------------------------------------------------------
  function JSCallBack1(Object, param)
  		if type(param)~='string' then return end
  		local value
	   if param=="log" then
		   	value = tvs_core.ReadChangeLog()
		  	value = value:gsub("\n","<br />")
		  	SetElementHtml(Object, "idChangeLog", value)
	   elseif param:find("^tab3") then
	       local n = param:match('tab3_(%d)') or 1
	       --debug_in_file(n)
	       FiltersLoad(Object, n)
	       m_simpleTV.Dialog.ExecScript(Object, 'CreateDynamicTable("'..n..'");' )
	   elseif param:find("^save") then
	      --debug_in_file(param)
	      TVSources_var.ActiveTab = param:match("(%d+)") or 1
	      tvs_core.tvs_SaveConfigInt()  -- сохраняем настройки - последний активный таб
	   end
  end


function OnNavigateComplete(Object)

   local value, i
  TVSources_var.tmp.SourceType = 2
  TVSources_var.tmp.source = tvs_core.tvs_GetSourceParam()
  if TVSources_var.tmp.source == nil then
    TVSources_var.tmp.source = {}
    value = tvs_core.tvs_GetSourceID()
    TVSources_var.tmp.source[value] = tvs_core.tvs_NewSource(1)
    TVSources_var.tmp.source[value].name = tvs_core.tvs_GetLangStr("src_new")
    TVSources_var.tmp.srcname = {}
    TVSources_var.tmp.srcname[TVSources_var.tmp.source[value].name] = value
  else
    TVSources_var.tmp.srcname = nil
    TVSources_var.tmp.srcname = {}
    for value, i in pairs(TVSources_var.tmp.source) do
      TVSources_var.tmp.srcname[TVSources_var.tmp.source[value].name] = value
    end
  end
  local value = "<ul class=\"tabs\">" .. "<li onclick=\"SwitchTab(1)\" id=\"tb_1\" class=\"active\">" .. tvs_core.tvs_GetLangStr("tab_main") .. "</li>" .. "<li onclick=\"SwitchTab(2)\" id=\"tb_2\">" .. tvs_core.tvs_GetLangStr("tab_fset") .. "</li>" .. "<li onclick=\"SwitchTab(3)\" id=\"tb_3\">" .. tvs_core.tvs_GetLangStr("tab_filter") .. "</li>" .. "<li onclick=\"SwitchTab(4)\" id=\"tb_4\">" .. tvs_core.tvs_GetLangStr("tab_auto") .. "</li>" .. "<li onclick=\"SwitchTab(5)\" id=\"tb_5\">" .. tvs_core.tvs_GetLangStr("tab_m3u") .. "</li>" .. "<li onclick=\"SwitchTab(6)\" id=\"tb_6\">" .. tvs_core.tvs_GetLangStr("tab_act") .. "</li>" .."<li onclick=\"SwitchTab(7)\" id=\"tb_7\">" .. tvs_core.tvs_GetLangStr("tab_info") .. "</li>" .. "</ul>"
  SetElementHtml(Object, "idTabs", value)
-------------------------------------------
   value = "<ul class=\"tabs\">" .. "<li onclick=\"SwitchFTab('ftb_1', 'fcontent_1')\" id=\"ftb_1\" class=\"active\">" .. tvs_core.tvs_GetLangStr("tab_channels") .. "</li>" .. "<li onclick=\"SwitchFTab('ftb_2', 'fcontent_2')\" id=\"ftb_2\">" .. tvs_core.tvs_GetLangStr("tab_groups") .. "</li>" .. "<li onclick=\"SwitchFTab('ftb_3', 'fcontent_3')\" id=\"ftb_3\">" .. tvs_core.tvs_GetLangStr("tab_ch_group") .. "</li>" .. "</ul>"
  SetElementHtml(Object, "idTabsFilters", value)
  ----------------------------------
--FillersLoad(Object)
  
  ------------ Search in filters--------------------------------------
 local search_inp =' <input style="float: left; height:12px; margin: 1px 55px 0px 0px; background-color: #ffffff;"  size="16"  type="text" placeholder="filter.."  '
 local tmp =  "\" class=\"iBtnSave\" type=\"image\" src=\"img/btn_save.png\" onmouseover=\"this.src='img/btn_save_focus.png'\" onmouseout=\"this.src='img/btn_save.png' "
 local search_input1 = search_inp..'  id="search_text_CF" onkeyup="tableSearch(document.getElementById(\'dynamic\'), this)" > '
  SetElementHtml(Object, "BtnSaveCF", search_input1.. "<input id=\"idBtnSaveCF\"  title=\"" .. tvs_core.tvs_GetLangStr("html_btn_cf_save") .. tmp .. " onclick=\"changeIcon('idBtnSaveCF','img/btn_save_click.png','img/btn_save.png')\"/>")
   local search_input2 = search_inp .. '  id="search_text_GF" onkeyup="tableSearch(document.getElementById(\'groups\'), this)" > '
  SetElementHtml(Object, "BtnSaveGF", search_input2 .. "<input id=\"idBtnSaveGF\"  title=\"" .. tvs_core.tvs_GetLangStr("html_btn_gf_save") .. tmp .. " onclick=\"changeIcon('idBtnSaveGF','img/btn_save_click.png','img/btn_save.png')\"/>")
   local search_input3 = search_inp .. '  id="search_text_CG" onkeyup="tableSearch(document.getElementById(\'cgroups\') , this)" > '
  SetElementHtml(Object, "BtnSaveCG", search_input3 .."<input id=\"idBtnSaveCG\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_cg_save") .. tmp .. " onclick=\"changeIcon('idBtnSaveCG','img/btn_save_click.png','img/btn_save.png')\"/>")

 -----------------------------------------------------------------      
  
  SetElementHtml(Object, "idSrcInGr", tvs_core.tvs_GetLangStr("src_in_folder"))
  if TVSources_var.SourceInFolder then
    value = 1
  else
    value = 0
  end
  SetCheckBoxValue(Object, "SrcInGr", value)
  SetElementHtml(Object, "idTVSG", tvs_core.tvs_GetLangStr("html_gr_tvs"))
  value = m_simpleTV.Config.GetConfigString(m_simpleTV.Defines.ID_EXT_TVS_GROUP_NEWCH) or ""
  SetElementValueString(Object, "TVSG", value)
  SetElementHtml(Object, "idSaveGR", tvs_core.tvs_GetLangStr("html_gr_get"))
  if TVSources_var.MotherGroup then
    value = 1
  else
    value = 0
  end
  SetCheckBoxValue(Object, "CheckboxSaveGR", value)
  
  SetElementHtml(Object, "idGRign", tvs_core.tvs_GetLangStr("html_gr_ign"))
  value = tvs_core.tvs_fcheck(TVSources_var.TVSdir .. "core\\sources_filter.lua")
  if value == "ok" then
    value = ""
    langs = {}
    ch_name = {}
    langs = dofile(TVSources_var.TVSdir .. "core\\sources_filter.lua")
    if langs == nil then
      tvs_core.tvs_debug("Can't read then sources_filter.lua file.")
    else

      for ch_1, ch_2 in pairs(langs) do
        table.insert(ch_name, {name = ch_1, value = ch_2})
      end

      table.sort(ch_name, function(a, b)
        return a.value < b.value
      end)

      i = 1
      for ch_1, ch_2 in pairs(ch_name) do
        if ch_2.value ~= nil and ch_2.value ~= "" then
          if i == 1 then
            value = ch_2.value
          else
            value = value .. ";" .. ch_2.value
          end
          i = i + 1
        end
      end
      ch_name = nil
      langs = nil
    end
  else
    value = ""
    tvs_core.tvs_debug("Can't find the sources_filter.lua file.")
  end
  SetElementValueString(Object, "GRign", value)

-----------------------------------------------------------------      
--debug_in_file ( string.format(" sources_filter.lua loaded >> %.4f s. ",   os.clock() - clock )  )

   SetElementHtml(Object, "id_EXT_func", tvs_core.tvs_GetLangStr("html_id_EXT_func"))
   SetElementHtml(Object, "idUseExtFunc", tvs_core.tvs_GetLangStr("html_idUseExtFunc"))
  
  
  SetCheckBoxValue(Object, "UseExtFunc", TVSources_var.UseExtFunc or 0)

  SetElementHtml(Object, "idBWDown", tvs_core.tvs_GetLangStr("html_idBWDown"))
  SetCheckBoxValue(Object, "BWDown", TVSources_var.bwDown or 0)
  
  SetElementHtml(Object, "id_CH_with_TimeZone", tvs_core.tvs_GetLangStr("html_CH_with_TimeZone"))
   
  SetElementHtml(Object, "idSetGroupOldCh", tvs_core.tvs_GetLangStr("html_SetGroupOldCh"))
  SetCheckBoxValue(Object, "SetGroupOldCh", TVSources_var.SetGroupOldCh or 1)

  SetElementHtml(Object, "idSetGroupRegional", tvs_core.tvs_GetLangStr("html_SetGroupRegional"))
  SetCheckBoxValue(Object, "SetGroupRegional", TVSources_var.SetGroupRegional or 0)
    
    
    -----------------------
      value = "<input id=\"idBtnClearLog\" type=\"image\" onclick=\"changeIcon('idBtnClearLog','img/btn_clean_click.png','img/btn_clean.png')\" src=\"img/btn_clean.png\" onmouseover=\"this.src='img/btn_clean_focus.png'\" onmouseout=\"this.src='img/btn_clean.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_clrlog") .. "\"/>"
  SetElementHtml(Object, "BtnClearLog", value)
    -------------------
  SetElementHtml(Object, "idNMign", tvs_core.tvs_GetLangStr("html_nm_ign"))
  local fname = TVSources_var.TVSdir .. "core\\patterns_filter.lua"
  value = tvs_core.tvs_fcheck(fname)
  if value == "ok" then
    value = ""
    local patterns = dofile(fname)
    if type(patterns) ~= 'table' then
      tvs_core.tvs_debug("Can't read then patterns_filter.lua file.")
    else
      for k,v in pairs(patterns) do
        if v and v ~= "" then
            value = value .. (value=="" and "" or ";" ) .. v
        end
      end
    end
  else
    value = ""
    tvs_core.tvs_debug("Can't find the patterns_filter.lua file.")
  end
  SetElementValueString(Object, "NMign", value)  
  -------------------
  value =  tvs_core.tvs_GetLangStr("tvs_settings") 
  local ver, build = tvs_core.GetVersion()
  if build < 10 then
    build = "0" .. build
  end
  local VersionStr = "v"..ver .. "." .. build
  
  local sitelink = "http://iptv.gen12.net/bugtracker/view.php?id=1379"
  local repolink = "http://www.mediafire.com/folder/y4aqacseb5zee/TVSources3"
 
  value = value .. '<a style="background-color: inherit; text-decoration: none;" target="_blank" href="'..sitelink..'"> TVSources '..VersionStr..'</a> '

  SetElementHtml(Object, "idHead", value)
  SetElementHtml(Object, "idDFSource", tvs_core.tvs_GetLangStr("html_source_df"))
  value = TVSources_var.Default
  if value ~= nil then
    SetElementValueString(Object, "DFSource", value)
  end
  SetElementHtml(Object, "idFilteSmb", tvs_core.tvs_GetLangStr("html_filter_sm"))
  i = 1
  value = ""
  if TVSources_var.FilterName ~= nil then
    local str = TVSources_var.FilterName
    local i = 1
    while i <= str:len() do   
      if str:byte(i) ~= 37 then
        value = value .. string.char(str:byte(i))
      elseif str:byte(i) == 37 and str:byte(i + 1) == 37 then
        value = value .. string.char(str:byte(i))
        i = i + 1
      end
      i = i + 1
    end
  else
    value = ""
  end
  SetElementValueString(Object, "FilteSmb", value)
  value = "<select onchange=\"UpdateList('SourceTypePos',this.value)\" id=\"idSrcType\" size=\"1\" style=\"position: absolute; left: 1px; top: 2px; font-size: 12px;\" class=\"SourcesSelect\"><option value=\"0\">" .. tvs_core.tvs_GetLangStr("src_type0") .. "</option><option value=\"1\" >" .. tvs_core.tvs_GetLangStr("src_type1") .. "</option><option selected value=\"2\">" .. tvs_core.tvs_GetLangStr("src_type2") .. "</option></select>"
  SetElementHtml(Object, "SourcesType", value)
  SetElementHtml(Object, "SourceTypePos", TVSources_var.tmp.SourceType)
  SetElementHtml(Object, "idSRCName", tvs_core.tvs_GetLangStr("tvsource"))
  SetElementHtml(Object, "idSortName", tvs_core.tvs_GetLangStr("html_src_srtname"))
  SetElementHtml(Object, "idScraper", tvs_core.tvs_GetLangStr("html_src_scrap"))
  SetElementHtml(Object, "idPath", tvs_core.tvs_GetLangStr("html_src_path"))
    
  SetElementHtml(Object, "idLastDate", tvs_core.tvs_GetLangStr("html_src_date"))
  SetElementHtml(Object, "idCodePage", tvs_core.tvs_GetLangStr("html_src_cp"))
  SetElementHtml(Object, "idInTVS", tvs_core.tvs_GetLangStr("html_src_intvs"))
  SetElementHtml(Object, "idInBase", tvs_core.tvs_GetLangStr("html_src_inbase"))
  SetElementHtml(Object, "idDaysLegend", tvs_core.tvs_GetLangStr("auto_days"))
  SetElementHtml(Object, "idDeleteM3U", tvs_core.tvs_GetLangStr("src_m3u_delete"))
  SetElementHtml(Object, "idShowProgress", tvs_core.tvs_GetLangStr("html_ShowProgress"))

  SetElementHtml(Object, "idBtnUpdSr", tvs_core.tvs_GetLangStr("src_m3u_refbutton"))
  SetElementHtml(Object, "idAutUpdSr", tvs_core.tvs_GetLangStr("src_m3u_refstart"))
  SetElementHtml(Object, "idSRCDay1", tvs_core.tvs_GetLangStr("mon"))
  SetElementHtml(Object, "idSRCDay2", tvs_core.tvs_GetLangStr("tue"))
  SetElementHtml(Object, "idSRCDay3", tvs_core.tvs_GetLangStr("wed"))
  SetElementHtml(Object, "idSRCDay4", tvs_core.tvs_GetLangStr("thu"))
  SetElementHtml(Object, "idSRCDay5", tvs_core.tvs_GetLangStr("fri"))
  SetElementHtml(Object, "idSRCDay6", tvs_core.tvs_GetLangStr("sat"))
  SetElementHtml(Object, "idSRCDay7", tvs_core.tvs_GetLangStr("sun"))
  SetElementHtml(Object, "idTVS_FCH", tvs_core.tvs_GetLangStr("src_m3u_filchan"))
  SetElementHtml(Object, "idTVS_FGR", tvs_core.tvs_GetLangStr("src_m3u_filgroup"))
  SetElementHtml(Object, "idTVS_GetGR", tvs_core.tvs_GetLangStr("src_tvs_groups"))
  SetElementHtml(Object, "idTVS_GetLogo", tvs_core.tvs_GetLangStr("src_tvs_tvglogo"))
  SetElementHtml(Object, "idCGReadyLegend", tvs_core.tvs_GetLangStr("src_m3u_already"))
  SetElementHtml(Object, "idTypeMediaLegend", tvs_core.tvs_GetLangStr("src_m3u_typemedia"))
  SetElementHtml(Object, "idSPL_FCH", tvs_core.tvs_GetLangStr("src_m3u_filchan"))
  SetElementHtml(Object, "idSPL_FGR", tvs_core.tvs_GetLangStr("src_m3u_filgroup"))
  SetElementHtml(Object, "idSPL_GetGR", tvs_core.tvs_GetLangStr("src_m3u_groups"))
  SetElementHtml(Object, "idSPL_HDGR", tvs_core.tvs_GetLangStr("src_m3u_hd"))
  SetElementHtml(Object, "idSPL_AutoTVG", tvs_core.tvs_GetLangStr("src_m3u_tvglogo"))
  SetElementHtml(Object, "idSPL_AutoNum", tvs_core.tvs_GetLangStr("src_m3u_autonum"))
  SetElementHtml(Object, "idSPL_M3UNum", tvs_core.tvs_GetLangStr("src_m3u_numbers"))
  SetElementHtml(Object, "idSPL_M3USet", tvs_core.tvs_GetLangStr("src_m3u_settings"))
  SetElementHtml(Object, "idSPL_NoDel", tvs_core.tvs_GetLangStr("src_m3u_nodelCH"))
  SetElementHtml(Object, "idSRC_M3UexF", tvs_core.tvs_GetLangStr("src_m3u_extfilter"))
  
  value = "<ul class=\"select\" id=\"slAlrCH\" style=\"display: none;\">" .. "  <li onclick=\"ChangeList('AlrCH','slAlrCH','" .. tvs_core.tvs_GetLangStr("src_m3u_alr0") .. "',0)\" style=\"top: 0px; width: 200px;\">" .. tvs_core.tvs_GetLangStr("src_m3u_alr0") .. "</li>" .. "  <li onclick=\"ChangeList('AlrCH','slAlrCH','" .. tvs_core.tvs_GetLangStr("src_m3u_alr1") .. "',1)\" style=\"top: 20px; width: 200px;\">" .. tvs_core.tvs_GetLangStr("src_m3u_alr1") .. "</li>" .. "  <li onclick=\"ChangeList('AlrCH','slAlrCH','" .. tvs_core.tvs_GetLangStr("src_m3u_alr2") .. "',2)\" style=\"top: 40px; width: 200px;\">" .. tvs_core.tvs_GetLangStr("src_m3u_alr2") .. "</li>" .. "</ul>"
  SetElementHtml(Object, "idAlrCH", value)
  
  value = "<ul class=\"select\" id=\"slTypeSH\" style=\"display: none;\">" .. "  <li onclick=\"ChangeList('TypeSH','slTypeSH','" .. tvs_core.tvs_GetLangStr("src_m3u_type0") .. "',0)\" style=\"top: 0px; width: 150px;\">" .. tvs_core.tvs_GetLangStr("src_m3u_type0") .. "</li>" .. "  <li onclick=\"ChangeList('TypeSH','slTypeSH','" .. tvs_core.tvs_GetLangStr("src_m3u_type1") .. "',1)\" style=\"top: 20px; width: 150px;\">" .. tvs_core.tvs_GetLangStr("src_m3u_type1") .. "</li>" .. "</ul>"
  SetElementHtml(Object, "idTypeSH", value)
  
  value = "<ul class=\"select\" id=\"slTypeMed\" style=\"display: none;\">" .. 
  "  <li onclick=\"ChangeList('TypeMed','slTypeMed','" ..   tvs_core.tvs_GetLangStr("src_m3u_typemedia0") .. "',0)\" style=\"top: 0px; width: 150px;\">" .. 
  tvs_core.tvs_GetLangStr("src_m3u_typemedia0") .. "</li>" .. 
  "  <li onclick=\"ChangeList('TypeMed','slTypeMed','" ..   tvs_core.tvs_GetLangStr("src_m3u_typemedia1") .. "',1)\" style=\"top: 20px; width: 150px;\">" .. 
  tvs_core.tvs_GetLangStr("src_m3u_typemedia1") .. "</li>" .. 
  "  <li onclick=\"ChangeList('TypeMed','slTypeMed','" ..   tvs_core.tvs_GetLangStr("src_m3u_typemedia2") .. "',2)\" style=\"top: 40px; width: 150px;\">" .. 
  tvs_core.tvs_GetLangStr("src_m3u_typemedia2") .. "</li>" .. 
  "  <li onclick=\"ChangeList('TypeMed','slTypeMed','" ..   tvs_core.tvs_GetLangStr("src_m3u_typemedia3") .. "',3)\" style=\"top: 60px; width: 150px;\">" .. 
  tvs_core.tvs_GetLangStr("src_m3u_typemedia3") .. "</li>" ..   "</ul>"
  SetElementHtml(Object, "idTypeMed", value)
  
  value = "<input id=\"idBtnSourcesSave\" type=\"image\" onclick=\"changeIcon('idBtnSourcesSave','img/btn_save_click.png','img/btn_save.png')\" src=\"img/btn_save.png\" onmouseover=\"this.src='img/btn_save_focus.png'\" onmouseout=\"this.src='img/btn_save.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_savesrc") .. "\"/>"
  SetElementHtml(Object, "BtnSourcesSave", value)
  value = "<input id=\"idBtnSourcesAdd\" type=\"image\" onclick=\"changeIcon('idBtnSourcesAdd','img/btn_add2_click.png','img/btn_add2.png')\" src=\"img/btn_add2.png\" onmouseover=\"this.src='img/btn_add2_focus.png'\" onmouseout=\"this.src='img/btn_add2.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_addsrc") .. "\"/>"
  SetElementHtml(Object, "BtnSourcesAdd", value)
  value = "<input id=\"idBtnSourcesDel\" type=\"image\" onclick=\"changeIcon('idBtnSourcesDel','img/btn_delete2_click.png','img/btn_delete2.png')\" src=\"img/btn_delete2.png\" onmouseover=\"this.src='img/btn_delete2_focus.png'\" onmouseout=\"this.src='img/btn_delete2.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_delsrc") .. "\"/>"
  SetElementHtml(Object, "BtnSourcesDel", value)
  value = "<input id=\"idBtnSourcesRef\" type=\"image\" onclick=\"changeIcon('idBtnSourcesRef','img/btn_refresh_click.png','img/btn_refresh.png')\" src=\"img/btn_refresh.png\" onmouseover=\"this.src='img/btn_refresh_focus.png'\" onmouseout=\"this.src='img/btn_refresh.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_refrsrc") .. "\"/>"
  SetElementHtml(Object, "BtnSourcesRef", value)
  value = "<input id=\"idBtnSourcesClean\" type=\"image\" onclick=\"changeIcon('idBtnSourcesClean','img/btn_clean_click.png','img/btn_clean.png')\" src=\"img/btn_clean.png\" onmouseover=\"this.src='img/btn_clean_focus.png'\" onmouseout=\"this.src='img/btn_clean.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_clnsrc") .. "\"/>"
  SetElementHtml(Object, "BtnSourcesClean", value)
  SourceToHTML(Object, nil, "yes")

 --------основные -------------------------------------------- 
  value = tvs_core.tvs_GetLangStr("html_info_button") .. '  <img width="12px" height="12px" src="../settings/img/TVSourcesButton.png" >'
  SetElementHtml(Object, "idInfoButton", value)  
  SetCheckBoxValue(Object, "CheckboxInfoButton", TVSources_var.InfoButton or 0)


  SetElementValueString(Object, "LangForm", TVSources_var.OSDLang or "Default")
  local value = tvs_core.tvs_fcheck(TVSources_var.TVSdir .. "lang\\tvs_lang.lst")
  if value == "ok" then
    value = "<option value=\"Default\">" .. "Default" .. "</option>"
    local langs = {}
    local langs_ns = {}
    langs_ns = dofile(TVSources_var.TVSdir .. "lang\\tvs_lang.lst")
    if langs_ns == nil then
      tvs_core.tvs_debug("Can't read then tvs_lang.lst file.")
    else
      local nameL, fileL
      local lang_sel = false
      local nameL, fileL
      for nameL, fileL in pairs(langs_ns) do
        table.insert(langs, {
          name = fileL[1],
          value = nameL
        })
      end
      table.sort(langs, function(a, b)
        return a.name < b.name
      end)
      for fileL, nameL in pairs(langs) do
        if nameL.value == TVSources_var.OSDLang and nameL.value ~= "Default" then
          value = value .. "<option selected=\"selected\" value=\"" .. nameL.value .. "\">" .. nameL.name .. "</option>"
        elseif nameL.name ~= "Default" then
          value = value .. "<option value=\"" .. nameL.value .. "\">" .. nameL.name .. "</option>"
        end
      end
    end
  else
    tvs_core.tvs_debug("Can't find the tvs_lang.lst file.")
    value = "<option value=\"Default\">" .. "Default" .. "</option>"
  end
  if value == nil or value == "" then
    value = "<option value=\"Default\">" .. "Default" .. "</option>"
  end
  value = "<select onchange=\"UpdateLang(this.value)\" id=\"idLangs\" size=\"1\" form=\"DFSource\" style=\"cursor:pointer; width: 140px; border: 1px solid #39c;\">" .. value .. "</select>"
  SetElementHtml(Object, "LangList", value)
  SetElementHtml(Object, "idNoSignal", tvs_core.tvs_GetLangStr("html_no_signal"))
  if TVSources_var.NoSignal then
    value = 1
  else
    value = 0
  end
  SetCheckBoxValue(Object, "CheckboxNoSignal", value)
  
   SetElementHtml(Object, "idLegendAutoCh", tvs_core.tvs_GetLangStr("html_legend_auto_ch") )

  SetElementHtml(Object, "idNextSr", tvs_core.tvs_GetLangStr("html_next_sr"))
  if TVSources_var.NextSr then
    value = 1
  else
    value = 0
  end
  SetCheckBoxValue(Object, "CheckboxNextSr", value)
  SetElementHtml(Object, "idLastPlay", tvs_core.tvs_GetLangStr("html_last_play"))
  if TVSources_var.LastPlay then
    value = 1
  else
    value = 0
  end
   SetCheckBoxValue(Object, "CheckboxLastPlay", value)
  --------- hotkey heap
      SetElementHtml(Object, "idLegendHotKeys", tvs_core.tvs_GetLangStr("legend_hot_keys")) 
	  SetElementHtml(Object, "idSymbol", tvs_core.tvs_GetLangStr("menu_hotkey_let"))
  --------- 1 hotkey
	 SetElementHtml(Object, "idHotKeys", tvs_core.tvs_GetLangStr("menu_hotkey_set"))
     local  s1, s2 = dec2bin(TVSources_var.HotKey[2] or 2)
	 SetCheckBoxValue(Object, "CheckboxHK1", s1)
	 SetCheckBoxValue(Object, "CheckboxHK2", s2)
     SetElementValueString(Object, "HKKey", string.char(TVSources_var.HotKey[1]  or string.byte('T') ))
  --------- 2 hotkey
     SetElementHtml(Object, "idHotKeysUpd", tvs_core.tvs_GetLangStr("menu_hotkey_set_upd"))
     s1, s2 = dec2bin(TVSources_var.HotKeyUpd[2] or 3)
	 SetCheckBoxValue(Object, "CheckboxHKUpd1", s1)
	 SetCheckBoxValue(Object, "CheckboxHKUpd2", s2)
     SetElementValueString(Object, "HKKeyUpd", string.char(TVSources_var.HotKeyUpd[1]  or string.byte('N') ))
  --------- 3 hotkey
     SetElementHtml(Object, "idHotKeysServ", tvs_core.tvs_GetLangStr("menu_hotkey_set_serv"))
     s1, s2 = dec2bin(TVSources_var.HotKeyServ[2] or 1)
	 SetCheckBoxValue(Object, "CheckboxHKServ1", s1)
	 SetCheckBoxValue(Object, "CheckboxHKServ2", s2)
	 if TVSources_var.HotKeyServ[1]==nil  then value  = "9"
	 else value  = (TVSources_var.HotKeyServ[1] == 0 )  and "" or string.char( TVSources_var.HotKeyServ[1]  )
	 end
     SetElementValueString(Object, "HKKeyServ", value)  --       0 - disable init hotkey 
     m_simpleTV.Dialog.ExecScript(Object,"HKKeyServ.onchange();"  )

----------
  SetElementHtml(Object, "idCHNameFilter", tvs_core.tvs_GetLangStr("html_ch_filter"))
  if TVSources_var.CHNameFilter then
    value = 1
  else
    value = 0
  end
  SetCheckBoxValue(Object, "CheckboxCHNameFilter", value)
  
  SetElementHtml(Object, "idLogging", tvs_core.tvs_GetLangStr("html_logging"))
  if TVSources_var.Logging then
    value = 1
  else
    value = 0
  end
  SetCheckBoxValue(Object, "CheckboxLogging", value)
 
  SetElementHtml(Object, "idErrRep", tvs_core.tvs_GetLangStr("html_errrep"))
  SetElementValueString(Object, "ErrRep", TVSources_var.ErrRepeatCount or 1)
 
 -----------------------------------------------------------------------------------
   SetElementHtml(Object, "idLegendOSDMes", tvs_core.tvs_GetLangStr("html_OSDMes"))
   SetElementHtml(Object, "idOSDMes1", tvs_core.tvs_GetLangStr("html_OSDMes1"))
   SetElementHtml(Object, "idOSDMes2", tvs_core.tvs_GetLangStr("html_OSDMes2"))
   SetElementHtml(Object, "idOSDMes3", tvs_core.tvs_GetLangStr("html_OSDMes3"))
	SetCheckBoxValue(Object, "CheckboxOSDMes1", TVSources_var.OSDMes[1] or 1) 
	SetCheckBoxValue(Object, "CheckboxOSDMes2", TVSources_var.OSDMes[2] or 1) 
	SetCheckBoxValue(Object, "CheckboxOSDMes3", TVSources_var.OSDMes[3] or 1) 
  -----------------------------------------------------------------------------------
  
  value = tvs_core.tvs_GetLangStr("html_del_base")
  SetElementHtml(Object, "idDelBase", value)  
  SetCheckBoxValue(Object, "CheckboxDelBase", TVSources_var.DelBase or 0)
  
  SetElementHtml(Object, "idLegendGrPls", tvs_core.tvs_GetLangStr("html_legend_gr_pls") )
  SetCheckBoxValue(Object, "CheckboxAutoST", TVSources_var.AutoBuild and 1 or 0)
   
  SetCheckBoxValue(Object, "CheckboxKeyPls", TVSources_var.KeyPlsMake and  1 or 0)
  
  SetCheckBoxValue(Object, "CheckboxAutoFL", TVSources_var.AutoBuildFL and 1 or 0)
  
  for i = 1, 7 do
    SetCheckBoxValue(Object, "CheckboxDay" .. i, TVSources_var.AutoBuildDay[i])
  end
  SetElementHtml(Object, "idKeyPls", tvs_core.tvs_GetLangStr("src_m3u_refbutton"))
  SetElementHtml(Object, "idAutoST", tvs_core.tvs_GetLangStr("auto_start"))
  SetElementHtml(Object, "idAutoFL", tvs_core.tvs_GetLangStr("auto_flag"))
  SetElementHtml(Object, "idDay2", tvs_core.tvs_GetLangStr("mon"))
  SetElementHtml(Object, "idDay3", tvs_core.tvs_GetLangStr("tue"))
  SetElementHtml(Object, "idDay4", tvs_core.tvs_GetLangStr("wed"))
  SetElementHtml(Object, "idDay5", tvs_core.tvs_GetLangStr("thu"))
  SetElementHtml(Object, "idDay6", tvs_core.tvs_GetLangStr("fri"))
  SetElementHtml(Object, "idDay7", tvs_core.tvs_GetLangStr("sat"))
  SetElementHtml(Object, "idDay1", tvs_core.tvs_GetLangStr("sun"))
  SetElementHtml(Object, "idDays", tvs_core.tvs_GetLangStr("auto_days"))

  SetElementHtml(Object, "idDMode", tvs_core.tvs_GetLangStr("html_dmode"))
  SetCheckBoxValue(Object, "CheckboxDMode", TVSources_var.DMode or 0)
  
  SetElementHtml(Object, "idTDTweak", tvs_core.tvs_GetLangStr("html_tdtweak") .. ' (10..100 ms)')
  SetElementValueString(Object, "TDTweak", TVSources_var.TimeDelayTweak)
  
  SetElementHtml(Object, "idChWait", tvs_core.tvs_GetLangStr("html_chwait"))
  SetElementValueString(Object, "ChWait", TVSources_var.ChannelWaiting)


 ---------------------------------------------------------------------------------- 
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSaveCF", "OnClickButtonSave")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSaveGF", "OnClickGroupSave")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSaveCG", "OnClickAutogroupSave")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idSrcList", "OnClickChangeSource")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "SourceTypePos", "OnClickChangeSrcType")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSourcesSave", "OnClickSourcesSave")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSourcesRef", "OnClickSourceRefresh")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSourcesClean", "OnClickSourceClean")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSourcesAdd", "OnClickSourcesAdd")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnSourcesDel", "OnClickSourcesDel")
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idBtnClearLog", "OnClickClearLog")
------------------------------------------------------------------------------------
  ---------------  Действия --------------------------------------------------------
  value = "<button  id=\"idButtonRefresh\" class=\"button\" style=\"width: 150px;\">" .. tvs_core.tvs_GetLangStr("html_button_1") .. "</button>"
  SetElementHtml(Object, "idButton1", value)
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idButtonRefresh", "OnClickButtonRefresh")  -- Сгруппировать источники
  
  value = "<button  id=\"idButtonClear\" class=\"button\" style=\"width: 150px;\">" .. tvs_core.tvs_GetLangStr("html_button_2") .. "</button>"
  SetElementHtml(Object, "idButton2", value)
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idButtonClear", "OnClickButtonClear")  -- очистить каталог
    
  value = "<button  id='idButtonGetFavor' class='button' style='display: block; width: 150px; font-style: italic;'>" .. tvs_core.tvs_GetLangStr("html_button_3") .. "</button>"
  SetElementHtml(Object, "idButton3", value)  
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idButtonGetFavor", "OnClickButtonGetFavor")

  value = "<button  id='idButtonSetFavor' class='button' style='display: block; width: 150px; font-style: italic;'>" .. tvs_core.tvs_GetLangStr("html_button_4") .. "</button>"
  SetElementHtml(Object, "idButton4", value)  
  m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idButtonSetFavor", "OnClickButtonSetFavor")

    m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idButtonImportFavor", "OnClickButtonImportFavor")
    m_simpleTV.Config.AddEventHandler(Object, "OnClick", "idButtonExportFavor", "OnClickButtonExportFavor")



  --value  = ' <a id="toggler"  href="#">&#9733</a>'
  value  = ' <font style="color: gold;">&#9733</font>'
  SetElementHtml(Object, "idFavAct", tvs_core.tvs_GetLangStr("html_favaction") .. value)
  

  local err = 'Number of favorite names: ' .. tvs_core.FavTableRecCount() 

  SetElementHtml(Object, "idMsgFav", err) 

  SetElementHtml(Object, "idRestoreFav", tvs_core.tvs_GetLangStr("html_restore_fav") )  
  SetCheckBoxValue(Object, "RestoreFav", TVSources_var.RestoreFav or 0)

  SetElementHtml(Object, "idExpandFav", tvs_core.tvs_GetLangStr("html_ExpandFav"))
  SetCheckBoxValue(Object, "CheckboxExpandFav", TVSources_var.ExpandFav or 0)
    
  SetElementHtml(Object, "idAutoClearBase",  tvs_core.tvs_GetLangStr("html_auto_clear_base"))  
  SetCheckBoxValue(Object, "AutoClearBase", TVSources_var.AutoClearBase or 0)
  
  SetElementHtml(Object, "idAutoGroupBase", tvs_core.tvs_GetLangStr("html_auto_group_base"))  

  if TVSources_var.LastStart > 0 then
    value = tvs_core.tvs_GetLangStr("last_start") .. " " .. os.date("%d.%m.%Y %H:%M", TVSources_var.LastStart)
  else
    value = tvs_core.tvs_GetLangStr("last_start") .. " " .. tvs_core.tvs_GetLangStr("html_not_start")
  end
  SetElementHtml(Object, "idLastStart", value)
  
--------Информация ---------------------------------------------------------------------------------
  value = tvs_core.tvs_GetLangStr("author") .. "  v1.102 by Dmitry R.  /  "
  value = value .. tvs_core.tvs_GetLangStr("tvs_ver") .." " ..VersionStr  .. " by BM<br>"   
  value = value .. tvs_core.tvs_GetLangStr("tr_trans") .. " " .. tvs_core.tvs_GetLangStr("translator") .. "<br>"
  value = value .. 'Bugtracker: <a target="_blank" href="'..sitelink.. '">'..sitelink..'</a><br>'
  value = value .. 'Repository: <a target="_blank" href="'..repolink.. '">'..repolink..'</a><br>'
  --value = value  .. tvs_core.tvs_GetLangStr("tvs_trn") .. " " .. tvs_core.tvs_GetLangStr("tr_ver") 
  
  SetElementHtml(Object, "idInfo", value)
  
  value = '<div style="font-size: 10px; font-family: sans-sherif,Helvetica;">Examples of shortcuts for LAN media-server: <br>'..
  "<span style='font-size: 9px; color: blue;'>tv.exe -nooneinstance -execute \"loadfile(m_simpleTV.MainScriptDir..'user/TVSources/core/tvs_server.lua')('192.168.xxx.xxx','9090')\"  </span><br>" ..
  "<span style='font-size: 9px; color: darkgreen;'>tv.exe -nooneinstance -execute \"loadfile(m_simpleTV.MainScriptDir..'user/TVSources/core/tvs_server.lua')()\"  </span><br>" ..
"<span style='font-size: 9px; color: navy;'>PS: for x64 system add it to path: <i> ..core/х64/.. <i>  </span>  </div>"

  SetElementHtml(Object, "idMediaServer", value)
  
  value  = tonumber(TVSources_var.ActiveTab) or 1
  if (value<1 or value>7) and value~=31 and value~=32 and value~=33 then value=1 end
  m_simpleTV.Dialog.ExecScript(Object, 'SwitchTab(' ..value ..'); ' )
  
end

  -------------------------------------------
function OnClickSourceClean(Object)
		local delsource = GetElementValueString(Object, "SrcID")
		GetSourceParam(Object)
		local lang_str = tvs_core.tvs_GetLangStr("tvs_cleaning")
		if delsource  then
		           local delsource_name  = TVSources_var.tmp.source[delsource].name
       		      tvs_core.tvs_ShowError(delsource_name .. ". " .. lang_str , 16580352,3)
                   if tvs_core.tvs_SourceClean(delsource, delsource_name) then 
	                   tvs_core.tvs_ShowError(lang_str .. " " .. tvs_core.tvs_GetLangStr("tvs_cleaned"), 4783872, 3)
		           end
		 else 
    				tvs_core.tvs_ShowError("Error SrcID")
		end

	  		
end  
function OnClickSourceClean_Old(Object)

  local delsource = GetElementValueString(Object, "SrcID")
  GetSourceParam(Object)
  local error = tvs_core.tvs_fcheck(TVSources_var.TVSdirLst .. "\\tvsources_ch_list.lst", "yes")
  if error == "ok" then
    local lang_str = tvs_core.tvs_GetLangStr("tvs_cleaning")
    local file_name
    file_name = dofile( TVSources_var.TVSdirLst .. "\\tvsources_ch_list.lst")
    if file_name ~= nil then
      local i, a, fname
      i, d, e = 1, 0, 0
      for a, fname in pairs(file_name) do
        tvs_core.tvs_SourceClean(fname[2], delsource)
        d, e = math.modf(a / #file_name * 100)
        tvs_core.tvs_ShowError(TVSources_var.tmp.source[delsource].name .. ". " .. lang_str .. " " .. d .. "%", 16580352)
        i = i + 1
      end
      TVSources_var.tmp.source[delsource].LastStart = 0
      SetElementValueString(Object, "LastDate1", 0)
      SetElementValueString(Object, "LastDate", "")
      tvs_core.tvs_SaveSources()
    end
  end
  
  if TVSources_var.tmp.source[delsource].TypeSource == 1 then
    fname = TVSources_var.TVSdir .. "m3u\\TVSCleaner.m3u"
    local fhandle = io.open(fname, "w+")
    if fhandle ~= nil then
      tvs_core.tvs_debug("Creating the TVSCleaner.m3u file for " .. delsource .. ": ok.")
      fhandle:seek("set", 0)
      fhandle:write([[
#EXTM3U
#EXTINF:-1,Cleaner]])
      fhandle:close()
      local settings = {}
      settings.TypeSourse = 1
      settings.DeleteBeforeLoad = 0
      settings.TypeCoding = -1
      settings.UpdateID = delsource
      settings.NotDeleteWhenRefresh = 0
      local err = m_simpleTV.Common.LoadPlayList(fname, settings, 0, true, false)
      os.remove(fname)
    else
      tvs_core.tvs_debug("Can't create the TVSCleaner.m3u file.")
    end
  end
  tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("tvs_cleaned"), 4783872, 3)
  
end

function OnClickSourceRefresh(Object)
  local refsource = GetElementValueString(Object, "SrcID")
  local result
  GetSourceParam(Object)
  result = tvs_core.UpdateSource(refsource, false)
  if result then
    SetElementValueString(Object, "LastDate1", TVSources_var.tmp.source[refsource].LastStart)
    SetElementValueString(Object, "LastDate", os.date("%d.%m.%Y", TVSources_var.tmp.source[refsource].LastStart))
  end
end

function OnClickSourcesDel(Object)
  local delsource, scraper
  -- old?
	  delsource = GetElementValueString(Object, "SRCName1")
	  if TVSources_var.tmp.source[delsource] then
	    scraper = TVSources_var.tmp.source[delsource].scraper 
	  end
	  TVSources_var.tmp.srcname[delsource] = nil
  -----------
  delsource = GetElementValueString(Object, "SrcID")
  if TVSources_var.tmp.source[delsource] then
    scraper = scraper or TVSources_var.tmp.source[delsource].scraper or ""
  end
  TVSources_var.tmp.source[delsource] = nil
  
  local ret = 0
  if scraper and scraper:find("%.lua$") then
	    local mess = tvs_core.tvs_GetLangStr("tvs_remove_src_mess") 
		ret = m_simpleTV.Interface.MessageBox(mess.."\n"..scraper, 'TVSources', 4+0x20) --MB_YESNO | MB_ICONQUESTION			
		if ret == 6  then  -- IDYES=6
		  os.remove(TVSources_var.TVSdir .. "scrapers\\"..scraper)
		  
	    end 
  end
  
  local i = 0
  local name, content
  for name, content in pairs(TVSources_var.tmp.source) do
    i = i + 1
    if i > 1 then
      break
    end
  end
  if i == 0 then
    delsource = tvs_core.tvs_GetSourceID()
    TVSources_var.tmp.source[delsource] = tvs_core.tvs_NewSource(1)
    TVSources_var.tmp.srcname[""] = delsource
  end
  if ret == 6  then 
	  if tvs_core.tvs_SaveSources() == "ok" then
	    tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("sources_save_ok"), 4783872, 3)
	  end
  end
  --[[
  SetElementHtml(Object, "BtnSourcesSave", "<input id=\"idBtnSourcesSave\" type=\"image\" onclick=\"changeIcon('idBtnSourcesSave','img/btn_save_click.png','img/btn_save.png')\" src=\"img/btn_save_ns.png\"  onmouseover=\"this.src='img/btn_save_ns_focus.png'\" onmouseout=\"this.src='img/btn_save_ns.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_savesrc") .. "\"/>")
  ]]
  SourceToHTML(Object, nil, "yes")
 
end

function OnClickSourcesAdd(Object)
--[[
  SetElementHtml(Object, "BtnSourcesSave", "<input id=\"idBtnSourcesSave\" type=\"image\" onclick=\"changeIcon('idBtnSourcesSave','img/btn_save_click.png','img/btn_save.png')\" src=\"img/btn_save_ns.png\"  onmouseover=\"this.src='img/btn_save_ns_focus.png'\" onmouseout=\"this.src='img/btn_save_ns.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_savesrc") .. "\"/>")
  ]]
  local poslist = SourceNameTest()
  tvs_core.tvs_debug(poslist)
  local sourceID = tvs_core.tvs_GetSourceID(TVSources_var.tmp.source)
  GetSourceParam(Object)
  TVSources_var.tmp.source[sourceID] = tvs_core.tvs_NewSource(1)
  TVSources_var.tmp.source[sourceID].name = poslist
  TVSources_var.tmp.srcname[poslist] = sourceID
  SourceToHTML(Object, sourceID, "yes")
end

function OnClickSourcesSave(Object)

		
  local poslist = GetElementValueString(Object, "SrcID")
  GetSourceParam(Object)
  SourceToHTML(Object, poslist,"yes")
  local value = tvs_core.tvs_SaveSources()
  if value == "ok" then
    tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("sources_save_ok"), 4783872, 3)
    --SetElementHtml(Object, "idLastDate", tvs_core.tvs_GetLangStr("html_src_date"))
  end
  --[[
  SetElementHtml(Object, "BtnSourcesSave", "<input id=\"idBtnSourcesSave\" type=\"image\" onclick=\"changeIcon('idBtnSourcesSave','img/btn_save_click.png','img/btn_save.png')\" src=\"img/btn_save.png\"  onmouseover=\"this.src='img/btn_save_focus.png'\" onmouseout=\"this.src='img/btn_save.png'\" title=\"" .. tvs_core.tvs_GetLangStr("html_btn_savesrc") .. "\"/>")
]]  

end

function OnClickChangeSource(Object)
  local value = GetComboValue(Object, "idSrcList")
  local name = GetElementValueString(Object, "SRCName1")
  local curpos = GetSourceParam(Object)

  if value ~= name then
    curpos = TVSources_var.tmp.srcname[value]
    SourceToHTML(Object, curpos, "yes")
  else
    SourceToHTML(Object, curpos)
  end
end

function OnClickChangeSrcType(Object)
  GetSourceParam(Object)
  local pos = tonumber(GetElementValueString(Object, "SourceTypePos"))
  if TVSources_var.tmp.SourceType ~= pos then
    TVSources_var.tmp.SourceType = pos
    SourceToHTML(Object, nil, "yes")
  end
end

function OnOk(Object)
  local value = GetElementValueString(Object, "DFSource")
  if not value then return end
  TVSources_var.Default = value or ""
  local value = GetElementValueString(Object, "FilteSmb") or ""
  if value ~= "" then
    value = string.gsub(value, "\'\"\*|\\/:<>?nNoO", "")
    local i = 1
    local b
    local strtmp = value 
    value = ""
    repeat
      b = string.byte(strtmp, i)   -- 12 magic symbols is  ( ) . % + - * ? [ ] ^ $

      if  b == 36 or b == 37 or b == 40 or b == 41 or b == 42 or b == 43 or b == 45 or b == 46 or b == 63 or b == 91 or b == 93 or b == 94 then
        value = value .. "%" .. string.char(b)
      else
        value = value .. string.char(b)
      end
      i = i + 1
    until i > string.len(strtmp)
    --value = value:gsub("%%+","%")
    TVSources_var.FilterName = value
  else
    TVSources_var.FilterName = ""
  end
  value = GetElementValueString(Object, "LangForm")
  if value == nil or value == "" then
    TVSources_var.OSDLang = "Default"
  else
    TVSources_var.OSDLang = value
  end
------------------------------------------	
  TVSources_var.InfoButton = GetCheckBoxValue(Object, "CheckboxInfoButton") or 0
--- HotKeys 
	TVSources_var.HotKey[2] = tonumber(GetCheckBoxValue(Object, "CheckboxHK2") or 0)
	if GetCheckBoxValue(Object, "CheckboxHK1") == 1 then
	TVSources_var.HotKey[2] = TVSources_var.HotKey[2] + 2
	end
	value = GetElementValueString(Object, "HKKey")  or ""
	TVSources_var.HotKey[1] = string.byte( value=="" and  "T" or value )
--- HotKeys Upd
	TVSources_var.HotKeyUpd[2] = tonumber(GetCheckBoxValue(Object, "CheckboxHKUpd2") or 0)
	if GetCheckBoxValue(Object, "CheckboxHKUpd1") == 1 then
	TVSources_var.HotKeyUpd[2] = TVSources_var.HotKeyUpd[2] + 2
	end
	value = GetElementValueString(Object, "HKKeyUpd")  or ""
	TVSources_var.HotKeyUpd[1] = string.byte( value=="" and  "N" or value )
--- HotKeys Serv
	TVSources_var.HotKeyServ[2] = tonumber(GetCheckBoxValue(Object, "CheckboxHKServ2") or 0)
	if GetCheckBoxValue(Object, "CheckboxHKServ1") == 1 then
	TVSources_var.HotKeyServ[2] = TVSources_var.HotKeyServ[2] + 2
	end
	value = GetElementValueString(Object, "HKKeyServ")  or ""
	TVSources_var.HotKeyServ[1] = string.byte(value ) or 0
  ---
  value = GetCheckBoxValue(Object, "CheckboxNoSignal") or 0
  if value == 1 then
    TVSources_var.NoSignal = true
  else
    TVSources_var.NoSignal = false
  end
  value = GetCheckBoxValue(Object, "CheckboxNextSr") or 0
  if value == 1 then
    TVSources_var.NextSr = true
  else
    TVSources_var.NextSr = false
  end
  value = GetCheckBoxValue(Object, "CheckboxLastPlay") or 0
  if value == 1 then
    TVSources_var.LastPlay = true
  else
    TVSources_var.LastPlay = false
  end
  
  value = tonumber(GetElementValueString(Object, "ChWait")) or 20 -- в секундах 
  if value < 5 or value > 60 then value = 20 end
  TVSources_var.ChannelWaiting = value
  
  value = GetCheckBoxValue(Object, "CheckboxCHNameFilter") or 0
  if value == 1 then
    TVSources_var.CHNameFilter = true
  else
    TVSources_var.CHNameFilter = false
  end

  value = tonumber(GetElementValueString(Object, "ErrRep")) or 1 -- кол-во 
  if value < 1 or value > 50 then value = 1 end
  TVSources_var.ErrRepeatCount = value
    
  value = GetCheckBoxValue(Object, "CheckboxLogging") or 0
  if value == 1 then
    TVSources_var.Logging = true
  else
    TVSources_var.Logging = false
  end
  
  value = GetCheckBoxValue(Object, "CheckboxOSDMes1") or 1
  TVSources_var.OSDMes[1] = tonumber(value)
  value = GetCheckBoxValue(Object, "CheckboxOSDMes2") or 1
  TVSources_var.OSDMes[2] = tonumber(value)
  value = GetCheckBoxValue(Object, "CheckboxOSDMes3") or 1
  TVSources_var.OSDMes[3] = tonumber(value)
 ----------------------------------------------------------------------------
  value = GetCheckBoxValue(Object, "CheckboxAutoST") or 0
  if value == 1 then
    TVSources_var.AutoBuild = true
  else
    TVSources_var.AutoBuild = false
  end
  value = GetCheckBoxValue(Object, "CheckboxKeyPls") or 0
  if value == 1 then
    TVSources_var.KeyPlsMake = true
  else
    TVSources_var.KeyPlsMake = false
  end
  value = GetCheckBoxValue(Object, "CheckboxAutoFL") or 0
  if value == 1 then
    TVSources_var.AutoBuildFL = true
  else
    TVSources_var.AutoBuildFL = false
  end
  
  value = tonumber(GetElementValueString(Object, "TDTweak")) or 50
  if value < 10 or value > 100 then value = 50 end
  TVSources_var.TimeDelayTweak =  value

  TVSources_var.DelBase = GetCheckBoxValue(Object, "CheckboxDelBase") or 0

  TVSources_var.DMode = GetCheckBoxValue(Object, "CheckboxDMode") or 0

  
  value = GetCheckBoxValue(Object, "SrcInGr") or 0
  if value == 1 then
    TVSources_var.SourceInFolder = true
  else
    TVSources_var.SourceInFolder = false
  end
  value = GetCheckBoxValue(Object, "CheckboxSaveGR") or 0
  if value == 1 then
    TVSources_var.MotherGroup = true
  else
    TVSources_var.MotherGroup = false
  end
  TVSources_var.RestoreFav = GetCheckBoxValue(Object, "RestoreFav") or 0
  TVSources_var.ExpandFav =  GetCheckBoxValue(Object, "CheckboxExpandFav") or 0 
  TVSources_var.AutoClearBase = GetCheckBoxValue(Object, "AutoClearBase") or 0
  TVSources_var.bwDown = GetCheckBoxValue(Object, "BWDown") or 0
  TVSources_var.SetGroupOldCh = GetCheckBoxValue(Object, "SetGroupOldCh") or 1
  TVSources_var.SetGroupRegional = GetCheckBoxValue(Object, "SetGroupRegional") or 0


  TVSources_var.UseExtFunc = GetCheckBoxValue(Object, "UseExtFunc") or 1



  value = GetElementValueString(Object, "TVSG") or ""
  m_simpleTV.Config.SetConfigString(m_simpleTV.Defines.ID_EXT_TVS_GROUP_NEWCH, value)
--------------------------  

  value = GetElementValueString(Object, "GRign") 

  if value and value ~= "" then
    local Sources_Ign = {}
    Sources_Ign = split(value, ";")
    if Sources_Ign ~= nil then
      local fhandle = io.open(TVSources_var.TVSdir .. "core\\sources_filter.lua", "w+")
      if fhandle == nil then
        tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("filter_src_er"), 255, 3)
        tvs_core.tvs_debug("Create the sources filter file.. error.")
      else
        fhandle:seek("set", 0)
        fhandle:write("local src_filter = {\n")
        i = 1
        value = ""
        repeat
          value = tvs_core.tvs_clear_double_space(Sources_Ign[i])
          if value ~= "" then
            fhandle:write("['" .. tvs_core.tvs_lowcase(value) .. "'] = '" .. value .. "',\n")
          end
          i = i + 1
        until i > #Sources_Ign
        fhandle:write([[
}
return src_filter]])
        fhandle:close()
        tvs_core.tvs_debug("Create the sources filter file.. ok.")
      end
    end
  else
    local fhandle = io.open(TVSources_var.TVSdir .. "core\\sources_filter.lua", "w+")
    if fhandle == nil then
      tvs_core.tvs_debug("Create the sources filter file.. error.")
    else
      fhandle:seek("set", 0)
      fhandle:write([[
local src_filter = {}
return src_filter]])
      fhandle:close()
    end
  end
----------------------
--------------------------  
  value = GetElementValueString(Object, "NMign") or ""
  if value ~= "" then
    local Names_Ign = split(value, ";")
    if type(Names_Ign) == 'table' then
      local fhandle = io.open(TVSources_var.TVSdir .. "core\\patterns_filter.lua", "w+")
      if fhandle == nil then
        tvs_core.tvs_ShowError("Create the patterns filter file.. error.", 255, 3)
        tvs_core.tvs_debug("Create the patterns filter file.. error.")
      else
        str = "return {\n"
        for i=1, #Names_Ign do
          	value = Names_Ign[i]
          	value = value:gsub('"',''):gsub("'",'')
			--value = value:gsub("[%'%.%-%+%*]", "")            
			--value = value:gsub('[%[%]%^%$%\\%/%"%\n]',"")
			if value ~= "" then
				str= str .. "'" .. value .. "',\n"
			end
        end
        str= str .. "}"
        fhandle:write(str)
        fhandle:close()
        tvs_core.tvs_debug("Create the patterns filter file.. ok.")
      end
    end
  else
    local fhandle = io.open(TVSources_var.TVSdir .. "core\\patterns_filter.lua", "w+")
    if fhandle == nil then
      tvs_core.tvs_debug("Create the patterns filter file.. error.")
    else
      fhandle:write("return {}")
      fhandle:close()
    end
  end
----------------------  
  TVSources_var.AutoBuildDay[1] = GetCheckBoxValue(Object, "CheckboxDay1") or 0
  TVSources_var.AutoBuildDay[2] = GetCheckBoxValue(Object, "CheckboxDay2") or 0
  TVSources_var.AutoBuildDay[3] = GetCheckBoxValue(Object, "CheckboxDay3") or 0
  TVSources_var.AutoBuildDay[4] = GetCheckBoxValue(Object, "CheckboxDay4") or 0
  TVSources_var.AutoBuildDay[5] = GetCheckBoxValue(Object, "CheckboxDay5") or 0
  TVSources_var.AutoBuildDay[6] = GetCheckBoxValue(Object, "CheckboxDay6") or 0
  TVSources_var.AutoBuildDay[7] = GetCheckBoxValue(Object, "CheckboxDay7") or 0
  
  tvs_core.tvs_LangInitialization()
    
  value = tvs_core.tvs_SaveConfigInt()
  if value == "ok" then
    tvs_core.tvs_debug("Writing the config file... ok")
  else
    tvs_core.tvs_debug("Writing the config file... error")
  end
  
--------------добавляем или удаляем инфо-кнопку в плейлист ----------------
dofile(TVSources_var.TVSdir .. 'core\\tvs_info_button.lua') 

 
end

function OnClickButtonClear()
    tvs_core.ClearBase(true)
end
--------------------------------------------------------------------------
function OnClickButtonSave(Object)

  local ch_count, i, ch_bf, ch_af
  ch_count = GetElementValueString(Object, "idCHCount")
  if ch_count ~= nil and ch_count ~= "" then
    ch_count = tonumber(ch_count)
    if ch_count > 0 then
             SetElementHtml(Object, "idSaveBoxText", '&#9432; ' ..tvs_core.tvs_GetLangStr("filter_saving"))
		     m_simpleTV.Dialog.ExecScript(Object,"document.getElementById('idSaveBox').style.display = 'flex'; "  )
		
		      i = 1
		      local ch_name = {}
		      repeat
		        ch_bf = GetElementValueString(Object, "ch_name" .. i .. "_1") or ""
		        ch_af = GetElementValueString(Object, "ch_name" .. i .. "_2") or ""
		        ch_bf = tvs_core.tvs_clear_double_space(ch_bf)
		        ch_af = tvs_core.tvs_clear_double_space(ch_af)
		        ch_bf = string.gsub(ch_bf, ";", "")
		        ch_bf = string.gsub(ch_bf, "Channel before", "")
		        ch_af = string.gsub(ch_af, ";", "")
		        if ch_bf ~= "" and ch_af ~= "" then
		          table.insert(ch_name, {name = ch_bf, value = ch_af})
		        end
		        i = i + 1
		      until ch_count < i
		      table.sort(ch_name, function(a, b)        return a.name < b.name      end)
		
		          local tmp_t =  {}
			      tmp_t[1] =  "local ch_filter = {\n"
			      for ch_bf, ch_af in pairs(ch_name) do
			          tmp_t[#tmp_t+1] =   "['" .. tvs_core.tvs_lowcase(ch_af.name) .. "']={'" .. ch_af.name .. "','" .. ch_af.value .. "'},\n"
			      end
			      tmp_t[#tmp_t+1]  = "} \n return ch_filter\n"
		
			      local fhandle = io.open(TVSources_var.TVSdir .. "core\\channel_filter.lua", "w+")
			      if fhandle == nil then
			        tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("filter_gr_er"), 0, 3)
			        tvs_core.tvs_debug("Create the groups filter file.. error.")
			        return nil
			      end
			      fhandle:write(table.concat(tmp_t))
			      fhandle:close()
		
			  m_simpleTV.Dialog.ExecScript(Object,"document.getElementById('idSaveBox').style.display = 'none'; "  )
		      tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("filter_cr_ok"), 4783872, 3)
		      tvs_core.tvs_debug("Create the channel filter file.. ok.")
		      return "ok"
    end
  end


end

function OnClickGroupSave(Object)
  local ch_count, i, ch_bf, ch_af
  ch_count = GetElementValueString(Object, "idGRCount")
  if ch_count ~= nil and ch_count ~= "" then
    ch_count = tonumber(ch_count)
    if ch_count > 0 then
             SetElementHtml(Object, "idSaveBoxText", '&#9432; ' .. tvs_core.tvs_GetLangStr("filter_saving"))    
		     m_simpleTV.Dialog.ExecScript(Object,"document.getElementById('idSaveBox').style.display = 'flex';"  )
		      i = 1
		      local ch_name = {}
		      repeat
		        ch_bf = GetElementValueString(Object, "gr_name" .. i .. "_1") or ""
		        ch_af = GetElementValueString(Object, "gr_name" .. i .. "_2") or ""
		        ch_bf = tvs_core.tvs_clear_double_space(ch_bf)
		        ch_af = tvs_core.tvs_clear_double_space(ch_af)
		        ch_bf = string.gsub(ch_bf, ";", "")
		        ch_bf = string.gsub(ch_bf, "Group before", "")
		        ch_af = string.gsub(ch_af, ";", "")
		        if ch_bf ~= "" and ch_af ~= "" then
		          table.insert(ch_name, {name = ch_bf, value = ch_af})
		        end
		        i = i + 1
		      until ch_count < i
		      table.sort(ch_name, function(a, b)       return a.name < b.name       end)
		      
		      	  local tmp_t =  {}
			      tmp_t[1] =  "local gr_filter = {\n"
			      for ch_bf, ch_af in pairs(ch_name) do
			          tmp_t[#tmp_t+1] =   "['" .. tvs_core.tvs_lowcase(ch_af.name) .. "']={'" .. ch_af.name .. "','" .. ch_af.value .. "'},\n"
			      end
			      tmp_t[#tmp_t+1]  = "} \n return gr_filter\n"
		
			      local fhandle = io.open(TVSources_var.TVSdir .. "core\\groups_filter.lua", "w+")
			      if fhandle == nil then
			        tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("filter_gr_er"), 0, 3)
			        tvs_core.tvs_debug("Create the groups filter file.. error.")
			        return nil
			      end
			      fhandle:write(table.concat(tmp_t))
			      fhandle:close()
			      
			  m_simpleTV.Dialog.ExecScript(Object,"document.getElementById('idSaveBox').style.display = 'none'; "  )
		      tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("filter_gr_ok"), 4783872, 3)
		      tvs_core.tvs_debug("Create the groups filter file.. ok.")
		      return "ok"
    end
  end
end

function OnClickAutogroupSave(Object)
  local ch_count, i, ch_bf, ch_af
  ch_count = GetElementValueString(Object, "idCGCount")
  if ch_count ~= nil and ch_count ~= "" then
    ch_count = tonumber(ch_count)
    if ch_count > 0 then
             SetElementHtml(Object, "idSaveBoxText", '&#9432; ' .. tvs_core.tvs_GetLangStr("filter_saving"))        
		     m_simpleTV.Dialog.ExecScript(Object,"document.getElementById('idSaveBox').style.display = 'flex';"  )
		      i = 1
		      local ch_name = {}
		      repeat
		        ch_bf = GetElementValueString(Object, "cg_name" .. i .. "_1") or ""
		        ch_bf = tvs_core.tvs_clear_double_space(ch_bf)
		        ch_bf = string.gsub(ch_bf, ";", "")
		        ch_bf = string.gsub(ch_bf, "Channel name", "")
		        ch_af = GetElementValueString(Object, "cg_name" .. i .. "_2") or ""
		        ch_af = tvs_core.tvs_clear_double_space(ch_af)
		        ch_af = string.gsub(ch_af, ";", "")
		        if ch_bf ~= "" and ch_af ~= "" then
		          table.insert(ch_name, {name = ch_bf, value = ch_af})
		        end
		        i = i + 1
		      until ch_count < i
		      table.sort(ch_name, function(a, b)     return a.name < b.name   end)
		      
			      local tmp_t =  {}
			      tmp_t[1] =  "local gr_filter = {\n"
			      for ch_bf, ch_af in pairs(ch_name) do
			          tmp_t[#tmp_t+1] =   "['" .. tvs_core.tvs_lowcase(ch_af.name) .. "']={'" .. ch_af.name .. "','" .. ch_af.value .. "'},\n"
			      end
			      tmp_t[#tmp_t+1]  = "} \n return gr_filter\n"
			      
			      local fhandle = io.open(TVSources_var.TVSdir .. "core\\channel_group.lua", "w+")
			      if fhandle == nil then
			        tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("filter_cg_er"), 0, 3)
			        tvs_core.tvs_debug("Create the autogroup filter file.. error.")
			        return nil
			      end
			      fhandle:write(table.concat(tmp_t))
			      fhandle:close()
	      
			  m_simpleTV.Dialog.ExecScript(Object,"document.getElementById('idSaveBox').style.display = 'none'; "  )
		      tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("filter_cg_ok"), 4783872, 3)
		      tvs_core.tvs_debug("Create the autogroup filter file.. ok.")
		      return "ok"
    end
  end
end
-----------------------------------------------------------------------------------------------
function OnClickButtonRefresh(Object)
  TVSources_var.LastStart = os.time()
  OnOk(Object)
  tvs_core.tvs_BuildList(nil, nil)
  tvs_core.tvs_ShowError(tvs_core.tvs_GetLangStr("m3u_load") .. " Completed.",0xffffff,3)
  local value = tvs_core.tvs_GetLangStr("last_start") .. " " .. os.date("%d.%m.%Y %H:%M", TVSources_var.LastStart)
  SetElementHtml(Object, "idLastStart", value)
end
-----------------------------------------------------------------------------------------------

function OnClickButtonGetFavor(Object)

  local err = tvs_core.RememberFavor() or ""
  SetElementHtml(Object, "idMsgFav", err) 

end 
-----------------------------------------------------------------------------------------------
function OnClickClearLog(Object)
       tvs_core.tvs_ShowError("Clear log",255, 3)
       tvs_core.tvs_debug("Log cleared", nil, true)
end
----------------------------------------------------------------------------------------------
function OnClickButtonSetFavor(Object)

		  local err = tvs_core.RestoreFavor() or ""
		  SetElementHtml(Object, "idMsgFav", err) 
		  
end 

function OnClickButtonImportFavor(Object)

		  local err = tvs_core.ImportFavor() or ""
		  SetElementHtml(Object, "idMsgFav", err) 
		  m_simpleTV.Common.Wait(1500)
		  local err = tvs_core.RestoreFavor() or ""
		  SetElementHtml(Object, "idMsgFav", err) 
  
end 


function OnClickButtonExportFavor(Object)

		  local err = tvs_core.ExportFavor() or ""
		  SetElementHtml(Object, "idMsgFav", err) 
  
end 


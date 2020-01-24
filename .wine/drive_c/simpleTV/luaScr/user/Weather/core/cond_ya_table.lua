local t = {            -- night, day
	["clear"] = {1,0,   "31", "32"},
	["partly-cloudy"] = {2,0, "33","34"}, 
	["mostly-clear"] = {2,0, "33","34"}, 
	["cloudy"] = {3,0, "26","26"}, 
	["overcast"] = {4,0, "26","26"}, 
	["fog"] = {50,0, "21","22"},
	-- малооблачно, прерывистые облака
	["partly-cloudy-and-light-rain"] = {2,500, "45","39"}, 
	["partly-cloudy-and-rain"] = {2,501, "45","39"}, 
	["partly-cloudy-and-light-snow"] = {2,600, "46","41"}, 
	["partly-cloudy-and-snow"] = {2,600, "46","41"}, 
	-- облачно,
	["cloudy-and-light-rain"] = {3,500, "11","11"}, 
	["cloudy-and-light-snow"] = {3,600, "13","13"}, 
	["cloudy-and-rain"] = {3,501, "12","12"}, 
	["cloudy-and-snow"] = {3,601, "14","14"}, 
	-- пасмурно, 
	["overcast-and-light-rain"] = {4,500, "11","11"}, 
	["overcast-and-rain"] = {4,503, "12","12"}, 
	["overcast-and-light-snow"] = {4,600, "13","13"}, 
	["overcast-and-snow"] = {4,602 ,"14","14"}, 
	["overcast-and-wet-snow"] = {4,615, "05","05"},                          -- дождь со снегом
	["overcast-thunderstorms-with-rain"]= {4,232, "03","03"}, 

}
return t

--[[
	{"bkn_-ra_n","partly-cloudy-and-light-rain","переменная облачность, небольшой дождь"}, 
	{"bkn_-sn_n","cloudy-and-light-snow","облачно с прояснениями, небольшой снег"}, 
	{"bkn_n","partly-cloudy","малооблачно"}, 
	{"bkn_n","mostly-clear","малооблачно"}, 
	{"bkn_n","cloudy","облачно с прояснениями"}
	{"bkn_ra_n","partly-cloudy-and-rain","дождь"}, 
	{"ovc","overcast","пасмурно"}, 
	{"ovc_+ra","overcast-and-rain","сильный дождь"}, 
	{"ovc_-ra","overcast-and-light-rain","пасмурно, небольшой дождь"}, 
	{"ovc_-ra.png","overcast-and-wet-snow","облачно, дождь со снегом"}, 
	{"ovc_-sn","overcast-and-light-snow","пасмурно, небольшой снег"}, 
	{"ovc_ra","cloudy-and-rain","дождь"}, 
	{"ovc_sn","cloudy-and-snow","снег"}, 
	{"ovc_ts_ra","overcast-thunderstorms-with-rain","сильный дождь, гроза"}, 
	{"skc_d","clear","ясно"}, 
	{"skc_n","clear","ясно"}, 
    {"ovc_ra_sn.png","overcast-and-wet-snow","облачно, дождь со снегом"}, 
]]
	
--[[
1	{"clear","ясно"},
2	{"partly-cloudy","малооблачно"}, 
2	{"mostly-clear","малооблачно"}, 
3	{"cloudy","облачно с прояснениями"}, 
4	{"overcast","пасмурно"}, 
50	{"fog","туман"},

2 500	{"partly-cloudy-and-light-rain","переменная облачность, небольшой дождь"}, 
2 501	{"partly-cloudy-and-rain","дождь"}, 
2 600	{"partly-cloudy-and-light-snow","переменная облачность, небольшой снег"}, 
2 601	{"partly-cloudy-and-snow","снег"}, 

3 500	{"cloudy-and-light-rain","облачно с прояснениями, небольшой дождь"}, 
3 600	{"cloudy-and-light-snow","облачно с прояснениями, небольшой снег"}, 
3 501	{"cloudy-and-rain","дождь"}, 
3 601	{"cloudy-and-snow","снег"}, 

4 500	{"overcast-and-light-rain","пасмурно, небольшой дождь"}, 
4 600	{"overcast-and-light-snow","пасмурно, небольшой снег"}, 
4 602	{"overcast-and-snow","сильный снег"}, 
4 503	{"overcast-and-rain","сильный дождь"}, 
4 232	{"overcast-thunderstorms-with-rain","сильный дождь, гроза"}, 
4 615  {"overcast-and-wet-snow","облачно, дождь со снегом"}, 

]]

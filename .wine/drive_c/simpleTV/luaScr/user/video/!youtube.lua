-- видеоскрипт для сайта https://www.youtube.com (12/11/19)
-- открывает подобные ссылки из плейлиста: https://pastebin.com/raw/MWAe9hK1
----------------------------------------------------------------------------------------------------
-- показать плейлист на OSD - Ctrl+M
----------------------------------------------------------------------------------------------------
-- искать видео через команду меню "Открыть URL (Ctrl+N)"
-- использовать префикс:
-- "-" для видео
-- "--" плейлистов
-- "---" каналов
-- "-+" прямых трансляций
-- открывает подобные запросы: -Маша и Медведь; --мосфильм; --- Ariana Grande; -+ вселенная
-- авторизация ------------------------------------------------------------------------------------
-- 1 вариант: файл cookies.txt формата "Netscape HTTP Cookie File" поместить в папку 'work'
-- получить файл: в дополнении https://addons.mozilla.org/en-US/firefox/addon/cookies-txt
-- 2 вариант: в 'Password Manager' для id - youtube, в качестве пароля использовать "cookies" сайта
-- получить "cookies": в дополнении https://addons.mozilla.org/ru/firefox/addon/xcookie
-- или из Firefox скопировать заголовки запроса, из Chrome запрос cURLE
----------------------------------------------------------------------------------------------------
-- предпочитаемый язык субтитров (https://pastebin.com/raw/N8XraJpT ) устанавить в настройках
----------------------------------------------------------------------------------------------------
local debug = false -- true | false
----------------------------------------------------------------------------------------------------
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
		if not inAdr then return end
		if not inAdr:match('^[%p%a%s]*https?://[%a%.]*youtu[%.combe]')
			and not inAdr:match('^https?://[w%.]*hooktube%.com')
			and not inAdr:match('^https?://[%a%.]*invidio[%a]*%.')
			and not inAdr:match('^[%p%a%s]*https?://y2u%.be')
			and not inAdr:match('^%s*%-')
		then
		 return
		end
	if debug then
		debug = os.clock()
		function YT_Log(str, verbose)
			m_simpleTV.Logger.WriteToLog(str, (verbose or 3), 'YouTube')
		end
		YT_Log('inAdr: ' .. inAdr, 0)
	end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 5, id = 'channelName'})
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
		if inAdr:match('isRelated=true') then
			m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 0})
			inAdr = inAdr:gsub('&isRelated=.+', '')
			m_simpleTV.Control.PlayAddress(inAdr)
		 return
		end
	if inAdr:match('https?://')
		and not (inAdr:match('isChPlst=true')
			or inAdr:match('isPlst=true')
			or inAdr:match('browse_ajax')
			or inAdr:match('isLogo=false')
			or inAdr:match('&restart'))
	then
		if not m_simpleTV.Common.isUTF8(inAdr) then
			inAdr = m_simpleTV.Common.multiByteToUTF8(inAdr)
		end
		inAdr = inAdr:gsub('^.-https?://', 'https://')
		inAdr = inAdr:gsub('[\'"%[%]%(%)]+.-$', '')
		inAdr = m_simpleTV.Common.fromPersentEncoding(inAdr)
		inAdr = inAdr:gsub('[\'"]+.-$', '')
		inAdr = inAdr:gsub('amp;', '')
		inAdr = inAdr:gsub('\\', '/')
		inAdr = inAdr:gsub('%$OPT:.-$', '')
		inAdr = inAdr:gsub('disable_polymer=%w+', '')
		inAdr = inAdr:gsub('flow=list', '')
		inAdr = inAdr:gsub('no_autoplay=%w+', '')
		inAdr = inAdr:gsub('start_radio=%d+', '')
		inAdr = inAdr:gsub('time_continue=', 't=')
		inAdr = inAdr:gsub('/videoseries', '/playlist')
		inAdr = inAdr:gsub('list_id=', 'list=')
		inAdr = inAdr:gsub('/feed%?', '?')
		inAdr = inAdr:gsub('//music%.', '//')
		inAdr = inAdr:gsub('//gaming%.', '//')
		inAdr = inAdr:gsub('/featured%?', '')
		inAdr = inAdr:gsub('&nohtml5=%w+', '')
		inAdr = inAdr:gsub('/tv%#/.-%?', '/watch?')
		inAdr = inAdr:gsub('&resume', '')
		inAdr = inAdr:gsub('&spf=%w+', '')
		inAdr = inAdr:gsub('/live%?.-$', '/live')
		inAdr = inAdr:gsub('%#t=', '&t=')
		inAdr = inAdr:gsub('&t=0s', '')
		inAdr = inAdr:gsub('&+', '&')
		inAdr = inAdr:gsub('%?+', '?')
		inAdr = inAdr:gsub('[&%?/]+$', '')
		inAdr = inAdr:gsub('%s+', '')
		inAdr = inAdr:gsub('/([%?=&])', '%1' .. '')
	end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.YT then
		m_simpleTV.User.YT = {}
	end
	if not m_simpleTV.User.YT.logoDisk then
		require 'lfs'
		local path = m_simpleTV.Common.GetMainPath(1) .. m_simpleTV.Common.UTF8ToMultiByte('Channel/')
		local f = path .. 'logo/Icons/YT_logo.png'
		local size = lfs.attributes(f, 'size')
		if not size then
			lfs.mkdir(path)
			local pathL = path .. 'logo/'
			lfs.mkdir(pathL)
			local pathI = pathL .. 'Icons/'
			lfs.mkdir(pathI)
			local fhandle = io.open(f, 'w+b')
			if fhandle then
				local logo = 'data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAyAAAAJYCAMAAACtqHJCAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAEAAgECAAICAgEBBAQAAAUAAgUCAAUCAwUCBAUFBQkAAQkAAggCAQ0AAAwAAg4CAQwCAgkJCQ4ODhIBAREBAhICARACAxABBBUAARUAAhcCARkAAR4BAR4AAhERERQUFBkZGR0dHSABACEAAiUAACQBAikBAi8CAzEBATIAAjQBATQBAjsBAj4BAj4CACEhISUlJSoqKi0tLTIyMjU1NTk5OT09PUAAAUAAA0QAAEUAAkUCAksBAk8BAU0BBFIBAVICBFYAAFQBAlUCAFkAAFgBA1wAAV4BBGABAGAAAmICAmUBAWoBAW0BAW8BAnEAAXEAAnQAAXcBAnUCA3gBAH0BAUBAQEVFRUpKSk1NTVFRUVZWVllZWV5eXmJiYmVlZWlpaW1tbXFxcXV1dXl5eX19fYIBA4MCAoUBAoQBBIkAAYgAAosBBI0BAYwCBpEBApYBAZUBBJ0BAqABAqUBAaQAAqkBAakBBK8BAbEBA7QBAboAALoBA7oCAbsCArkBBL4BAbwBAr0CA8YBAckBAs0AAtEAANABAtECA9YBAdcBAtkAAdwAAeEAAOUAAeUCBukAAO0AAO0BAuwCAe8CA+8BBPABAfYAAPUBAvQCAfoAAPoBAvoCAfoCAvsBBP0AAP0AAvwCAPwCAv0CBPwEA/wFBfwKCv0OEP0QEf4VFfwWGfsYGfwaGv0eHv4fIP0gH/slJf4gIPwlJPwoKv0vMPwxMfw0Ofw+PvxOUPxRU/xYVf5bXfxcXf1qavt7e/15fPx/fIGBgYWFhYiIiI2NjZGRkZWVlZmZmZycnKGhoaampqmpqa2trbKysrS0tLm5ub29vfuDgf2RkfyVk/yWlvyYl/2jo/2kpPyqqfu7u/66uv7Bv8HBwcbGxsnJyc3NzdDQ0NXV1dnZ2d3d3fzDwfzFw/zJxvvPzvzR0P7d2/zc3OHh4eXl5enp6e3t7f3k4f3m5v3s7P3w7fHx8fX19fzz8fz29f349vn5+fr++/v+/P75+f39+/7+/gAAAKO0mi0AAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAPo0lEQVR4Xu3de5yc1V0H4BkG0rog6K54wcomMQWpbQ2BEIVWsYqX2lZayzXcCVEsYpG2WLHW1gZQCzGgQgy32SDWG2rVipdWJUBKEm7eqyYhWbyWJIrZ0pF0Pr6X3/vOzO5mMrvZjWnmeT5c5py5vPnjfPOe877nnLcCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACHvmr2T/Zv8t9E9mKCqM7eHv+R6oQaOGSkocgc85ULTnjNN37T6ad/53ef9ea3v/3ss9/xQ+961zWFc85OfN9ZZ33X6Wd8y0mvffWC4449IvtWmhkJ4VB15PGv+Y63XXP9T9182+rVd6+5Z8399ftDvV6+TI1ExUjy75r716y5+67Vd/z8h9577Tu/53ULvqIWvwaHjGp1znHf+4GVd2XNf7+s+cUV7zy+WktPJwebwaEwEBXQo+orz111/wPRxvdTfe2vvOdra7XD46cPHo/sDqdGBfRowYr62rS/NCPq9bUr39CRj9pwoa3/NRBVw0NR0bvB+OYkupwd1jXD4qiAXlSrJ/5CxxBjBqz+tvax+uBoIzd2StQkrmiM5ZVPREXvnsi/OJkL4yOTeDTyISBMyZyv+rmRu2fs/JEbuePE+PXMxmiazUuiIvF0VDW7tOm92BDfnISAMNNqP1Kvj6yNlj1D1t6z4si2c8hF0TSbn46K5KyyM6p2z42a3gkIB9AJd89wOnLfXmsFZG4j2uZzUVGpnFxWTf26sIBwAF0dLXqGfaR6WBwgOUltibbZGIyaytKoaT4SFVMgIBw4R/zsAzM9RM/cd3wrIK0rSOdFRau5TuOiq4BwoFQrx62JFj3D1p4Vh0gtibbZvCoqKsU5ZUd5TumdgHDgvDEa9Iy7tv1C71g0ziejYqgYghQVU7F0edgWP9J8IiqWnxwfmYSAMA3Vc6M9z7SRD7bPNnkyGudo3MlbHOXmZXl5ejbFj7R6bl0ICNNQvSEa9Iz76BFxiNRl0Tgbw3n58ig35+Xl6REQZt3N0Z5nWn11e0AWFV2qC/JyMYzYtl+TfwWEWVY9ZmU06JlWH/m6OEZqYEe0znV5eTSKj+XFaRIQZttxd0aD7uaee+PFVIy8Pg6R+XS0zmez0nCUmudnxekSEGbbgmjO3TzwYGvtVM/qI+3XeSsXRut8Ibuse0GUxtqn8tYGBqbY4dqvgOztaLVEvKTvVb8h2nM3v/MvD099Nkq9fk4cIzNvd946G/PTUnHj8NmiKQ6ev+6pLaOjW59+9Pz2GyPDc0P+ucHhvKKYIj8uIIPZm4l4ezg+ns/26gjI0CWbnhvdsuGCcdPja4uv3Lh5y5YtTz12UVxNoM+9oYdzw0N79vzD761JMjKl80j92jhEpvZcNM+L0kJxm/DK/M2hZcXUxcTOK8vTynBx+yQudl0VpeLuybiALI9Sc2NWbH07a+xtARm4pDje1oWV1uli4KLtUZ1oPL5fF9g4RJwVzbmbj+/53+bn/uJj90ytn1V/TxwiV7TedELvULTPRn5fb1ExZA/bsrNMYj8DUlw5a2aJawVkoBgQJZ5vTSYeKmfg53YsijfoY2/todX/7p60vfznn/zq1M4g749D5E7NGl0+oXdRvH4+6+EsbDt95EajfzM0OwF5LF5kNpa9vGejprSjCCr965xozt3kAWk2//EP6/dF1b7VRz4ch8gVC0B2J43/kvxlc0P6xkDR32rzZD42mJ2AlB/LjC1M30xSUk6obHkqfYu+dk20526KgDQ//9e/HVW9uCUOEWK2SSMZIz+Rv8zvGpY31ds08hY/OwEpfzT3aPbh1gKVdqfl79G/fixaczdlQJrNFz/1az33s26OQ4RL4ycur9RizLE7bbhDL+SFpMO1/old8bK5OfvK7AQkyd/2Z8sjNbfnfayy37V52bLigkJz6uvlOcS8L1pzN20BaTb/4+G19/V20ffWo+IYuYXxAxsqc+OS75a0aZ6fv04GHslw+ZSi3Tayjs8sBWTXebXK/OejEGt+a8Wt/qeS3t3g1ijkgyT62I09D9ILez7z+71t8XDrl8YxQlxD3VaO17PFhEV3K7v+22rFV6Sl2QlI3n8rlzTmS7ZOi0J+b//iKDTntS4C05dujNbcTWdAms2X/vLXe7knctuRcYxQdGIGis5WeseunKS1K7tyVU6DzyIwOwHJLg1UhuM01mxemhaL7zayz5YDkqVpiT72kWjN3YwPyBea//WnD3Zu1zuZVUfHMULRmVr8eP7/HWn/ZWHRFEezv6sHWsWkPDsByT9cKVdbZaP04h7Ijuy98gbM8qxI/7olWnM34wOS+tdP7HOroPEBmRut7tLo4W9KK8uuTT4srxRD9kaantkJSMzFKjfrSs8oA8U99G3Ze7Xi9GKU3u96WQ4yWUCae/52X5d8xwekWIf+eLS+rGtT3BLJ41KplBeQ0pvssxqQ8r7H00mhuLdfbExUDtnzIn3rpmjN3UwakObL//Nn8f5eTAjIsvyLo3nDzaYt1so2nzfqyjNRzAbLsxqQ+NPk565y/n2alkRxQonzGn1r+gF56e9+s/tIfUJATolv5rZndeXth8ezYisg6UWtWQ1Icakg+4OcHK/HByT/Q9K/ptvFevmfPzHVMUirH5PJ72Cvj9KEgFyeFGY1IMUy+eZoUihmhwkInaY5SP/sJ++9f8oBKfc2ySzprDrgASlHP2lAymsFAkKHD0dr7mZCQF78q14mnKycEJDy/ltiZ9Zq9x6QdIu5WQ1IscYxC8h58VpA6FCd+p305p7PPBRvdHdr+wbvmXllk202n8mr9hqQ9Db7/0NANi9adMopi8oVKgLS56o/Ea25m86A/PvDa6c1FysxUN6ci7kkB19AxhGQfnd9tOZu2gPy35/q4R567qNz4hgtZSONtekCwkFuatPdP/c3H4u6Hoyb7p5qtcPtMU9WQDio9bI1bwTkC41/+oOpbJC1Ig7RptzEunzWlIBwMKu+o/dB+mf/+J4pPMqwPvKBOEa7ct138bRCAeGg9pYeAvLxJCAvv/jnva8lzNTfG4doV24ckq3+SBxsAdl6QbsL8x+mf31rNOdukoC89Pe/tXaK2yvWr4tDtOs9IFfM2nT3CEi5YqojIHEfBDLV10Vz7uahz//bH91bT/IxlYTU7//BOEa7CQEpJ52PD8is30kv52KlASmniQkI7aon9jCs+I1PPhivpqA+8rY4RrsJAYnFUxMDkk6GPzABSZeAjJ+LBblX3RUNuov6SHL+mLoz4xDtJgSkXJURl7XKgKRPG5zVgHRMd58Xr4uADA5P49mJHHqqx66K5tzVPfH/KaiPnBTHaDchIFdEuVgwVewnkjXjWQ1IWU5/bKhYQrg1f/OysbHdo9ue2XhxXqRvzbk1GvSMG5kwVzExISAXRbn4q7vcpjfdw2G6AcnDto+AlJcH1ieFwWKpb6woLHazi44f/auXXRumZdUr4gjtJgSk3MYkWmbxN/nOdA+HVkDyXa5n8gxSKzesS7eYrxVnrheyN8uen4D0uznXRXuecTe1P6OwMCEgxU4O8cD0Yne5fK1ruXdCLB7pNSD5TOHuAZlfhi/7crFwK9ssolJ5Kor794g4vvhV3xLtecbdMG6ue2ZCQGrFDoeN7GED5aWlfL1huQRxWVoaKJrtXgJS7vL7QnL6qbXuBI4LSLZZROtIY1n3rbwrkm3HO1Ts8JhebKaPVSsnRXueafUfiEN0mBCQVrtNd9gZLOfD502+HLJvS84vg63HFkwekDIRjeSEU1vcWuDbGZCxpbVKrfXMhXx70fJ0syHt25Uru7JdF+lf1cqRd07nEu6+rT0jDtFhYkDKQUjjsVOXlKeInXlPp/Wkm6cvXta2mGTygJQ3M5o7r7xkU9nBGh+QZnPr+o2tzavzjRZbf7L1S05bXnTtsr3t6G+9rCmchl8+6rA4QLuJAWlfRNUSOxqW17hC0R+bPCCdm0I0m7uKYcb4gHTIhzflc0U7GKNTedPsBOS6Wm8BqZzX9ld94YV4xFTx6M+wa0l8dvKAtMq5q4q5wx0BaXT+5nNxkpjsOT67Ws9no28ddWs6cWqmrT5xsjH6ZAGplbNNSo3y8enlVK3MpcWO03sJyOKOrG0eKAYtHQHZXN6bzJTbUy/qDE6i0fpD0r9qb8wmIs6okbVXHzZ+x4bMJAGpDGyIusLYpelAOTO/rdfUuKpSiT7WXgJSK5+lkBidX16p6gjII7VyL65EsXArcUFrXJIZK9as0NdqX3L13fUprITqRf2nxz0bpDBZQCq1y8ubdqktcas7c2r51s40NnH7ey8BqQyWNY1NSS+t2O2qIyDJr19ZPqdnffsofOHTbWegxtOnRDV9rjrnR++e4TPIz3z1pB2sSuWSdaGz9Q0u3fT8rrFGY/fObesXl6ePzPC60V1jY7u2P5INS87Pvx1TpC7OS+vWZc+jStWWbt45NrZ7x6bT0l8Zireze5Dx1eVpYe7y53bu3r3jySWdx6otemzbzt1jyTtb1p3c+Rb97JVv/qWZG4eM1Ndc++WT9q+6Ghiev3DhvOzv+nEG5i5cONx7cx2av3Devqfi1obmzp30U4Nz58+b/B361+EL3r1q7cwkpH7nj7+2NvV8wMGreli18opvPueGFbfeviba+XTcftst77/mzKOraTwkhEPQEUcfe8Lrz3zruddc/74bf3LFTR+9beXKVatW3X5nZvVdidX56zuS6lUrV952000fuvGG69/9w9//pjNOPO7LjqpWDtN151BVzWWv0n8OT17OOeboo499VebrX51YkL/+mqMT2QeT7lTy0eQUlHz4CCcO6CARAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADwxadS+T+1mwqMp9zWOgAAAABJRU5ErkJggg=='
				logo = logo:gsub('.+,', '')
				logo = decode64(logo)
				fhandle:write(logo)
				fhandle:close()
			else
				f = ''
			end
		end
		m_simpleTV.User.YT.logoDisk = f
	end
	if not m_simpleTV.User.YT.logoPlstDisk then
		require 'lfs'
		local path = m_simpleTV.Common.GetMainPath(1) .. m_simpleTV.Common.UTF8ToMultiByte('Channel/')
		local f = path .. 'logo/Icons/YT_logo_plst.png'
		local size = lfs.attributes(f, 'size')
		if not size then
			lfs.mkdir(path)
			local pathL = path .. 'logo/'
			lfs.mkdir(pathL)
			local pathI = pathL .. 'Icons/'
			lfs.mkdir(pathI)
			local fhandle = io.open(f, 'w+b')
			if fhandle then
				local logo = 'data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAR4AAADoBAMAAADLW5ZVAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAPUExURUxpcWZmZszMzP///5mZmXVupX4AAAABdFJOUwBA5thmAAABt0lEQVR42u3a0U3EMBBF0TihAaMUsCINRKKDZPuvCVhg+SMzK+bxpNxbwZHAju3ZYSAiIiIiIiJya3r9h37xjF3fMx48ePDgwYMHDx48ePDgwYMHDx48ePDgwXNyj9u8gIiIiIiI6K8ar/o27qd48ODBgwcPHjx48ODBgwcPHjx48ODBg+fknulF38JYhIiIPr5BZp4nsw9Um1cvT/cCtfcjzurl6dvq5em7macvZh4f0Jdnvnh5bFZ9u19s8qCx4GdGd0/f8p6Ca96PJw8q9qS3oWpPdtWXe+bFy5Nc9fWe3KoXeFIghSdz+JB4Eqte44mvepEnDFJ5oocPlSe6Dck8wVWv88S+9UJPaBtSeiLbkNQTWPVaz/HhQ+s5XvViz+G/kNizef29jvdEqSewRSs9s9d+GPrECz2L1/dr9zpv7F7nsegVQ+QJX8E0nvidWeJJvCkoPJknDoUn8+Ii8KSeyOo9uSfEck9ysFLtyT5BF3vST/S1nvwIYyr4mVF79LG3en5hMpNrXpxvj80ItT06bKr0GI3gm9Ow8tMzO/2EozkNu2+efbDybFacYVwHIiIiIiI6RW/aZw+8Nfy26AAAAABJRU5ErkJggg=='
				logo = logo:gsub('.+,', '')
				logo = decode64(logo)
				fhandle:write(logo)
				fhandle:close()
			else
				f = ''
			end
		end
		m_simpleTV.User.YT.logoPlstDisk = f
	end
	if not (inAdr:match('/c/')
			or inAdr:match('/watch_videos')
			or inAdr:match('/shared%?')
			or inAdr:match('/channel/')
			or inAdr:match('/user/')
			or inAdr:match('isChPlst=true')
			or inAdr:match('isPlst=true')
			or inAdr:match('isLogo=false')
			or inAdr:match('browse_ajax')
			or inAdr:match('&restart'))
		or
			(inAdr:match('/videos') and not inAdr:match('&restart'))
		or
			(inAdr:match('/channel/') and inAdr:match('/live$'))
	then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = m_simpleTV.User.YT.logoDisk, TypeBackColor = 0, UseLogo = 3, Once = 1})
	elseif inAdr:match('isPlst=true') or inAdr:match('isLogo=false') then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = '', TypeBackColor = 0, UseLogo = 3, Once = 1})
		if not inAdr:match('list=RD') then
			inAdr = inAdr:gsub('&isLogo=false', '')
		end
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36', nil, true)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 16000)
	local debug_0
	local plstId
	local plstIndex
	local selectPos
	local isVideo = true
	local isPlst = false
	local isChPlst = false
	local isChVideos = false
	local isPanel = true
	local isWin_epgInfo = false
	local i_panel = m_simpleTV.Config.GetValue('mainOsd/showTimeInfoPanel', 'simpleTVConfig')
	if i_panel and tostring(i_panel) == '0' then
		isPanel = false
	end
	local win_epgInfo = m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig')
	if win_epgInfo and tostring(win_epgInfo) == 'true' then
		isWin_epgInfo = true
	end
	local videoId = inAdr:match('[%?&/]v[=/](.+)')
				or inAdr:match('/embed/(.+)')
				or inAdr:match('/watch/(.+)')
				or inAdr:match('y[2out]*u%.be/(.+)')
				or ''
	videoId = videoId:sub(1, 11)
	if not m_simpleTV.User.YT.Lng then
		m_simpleTV.User.YT.Lng = {}
		if m_simpleTV.Interface.GetLanguage() == 'ru' then
			m_simpleTV.User.YT.Lng.desc = 'описание'
			m_simpleTV.User.YT.Lng.qlty = 'качество'
			m_simpleTV.User.YT.Lng.savePlstFolder = 'сохраненые плейлисты'
			m_simpleTV.User.YT.Lng.savePlst_1 = 'плейлист сохранен в файл'
			m_simpleTV.User.YT.Lng.savePlst_2 = 'в папку'
			m_simpleTV.User.YT.Lng.savePlst_3 = 'невозможно сохранить плейлист'
			m_simpleTV.User.YT.Lng.sub = 'субтитры'
			m_simpleTV.User.YT.Lng.subTr = 'перевод'
			m_simpleTV.User.YT.Lng.preview = 'предосмотр'
			m_simpleTV.User.YT.Lng.audio = 'аудио'
			m_simpleTV.User.YT.Lng.noAudio = 'нет аудио'
			m_simpleTV.User.YT.Lng.plst = 'плейлист'
			m_simpleTV.User.YT.Lng.error = 'ошибка'
			m_simpleTV.User.YT.Lng.live = 'прямая трансляция'
			m_simpleTV.User.YT.Lng.upLoadOnCh = 'загружено на канал'
			m_simpleTV.User.YT.Lng.loading = 'загрузка'
			m_simpleTV.User.YT.Lng.videoNotAvail = 'видео не доступно'
			m_simpleTV.User.YT.Lng.videoNotExst = 'видео не существует'
			m_simpleTV.User.YT.Lng.adaptive = 'адаптивное'
			m_simpleTV.User.YT.Lng.page = 'стр.'
			m_simpleTV.User.YT.Lng.hl = 'ru_RU'
			m_simpleTV.User.YT.Lng.hl_sub = 'ru'
			m_simpleTV.User.YT.Lng.camera = 'вид с видеокамеры'
			m_simpleTV.User.YT.Lng.camera_plst_title = 'список видеокамер'
			m_simpleTV.User.YT.Lng.channel = 'канал'
			m_simpleTV.User.YT.Lng.video = 'видео'
			m_simpleTV.User.YT.Lng.search = 'поиск'
			m_simpleTV.User.YT.Lng.notFound = 'не найдено'
			m_simpleTV.User.YT.Lng.started = 'начало в'
			m_simpleTV.User.YT.Lng.published = 'опубликовано'
			m_simpleTV.User.YT.Lng.duration = 'продолжительность'
			m_simpleTV.User.YT.Lng.relatedVideos = 'похожие видео'
		elseif m_simpleTV.Interface.GetLanguage() == 'pt' then
			m_simpleTV.User.YT.Lng.desc = 'descrição'
			m_simpleTV.User.YT.Lng.qlty = 'qualidade'
			m_simpleTV.User.YT.Lng.savePlstFolder = 'playlists salvas'
			m_simpleTV.User.YT.Lng.savePlst_1 = 'lista de reprodução salva em arquivo'
			m_simpleTV.User.YT.Lng.savePlst_2 = 'para pasta'
			m_simpleTV.User.YT.Lng.savePlst_3 = 'não é possível salvar a playlist'
			m_simpleTV.User.YT.Lng.sub = 'legendas'
			m_simpleTV.User.YT.Lng.subTr = 'traduzido'
			m_simpleTV.User.YT.Lng.preview = 'preview'
			m_simpleTV.User.YT.Lng.audio = 'áudio'
			m_simpleTV.User.YT.Lng.noAudio = 'sem áudio'
			m_simpleTV.User.YT.Lng.plst = 'lista de reprodução'
			m_simpleTV.User.YT.Lng.error = 'erro'
			m_simpleTV.User.YT.Lng.live = 'em direto'
			m_simpleTV.User.YT.Lng.upLoadOnCh = 'uploads do canal'
			m_simpleTV.User.YT.Lng.loading = 'a carregar'
			m_simpleTV.User.YT.Lng.videoNotAvail = 'vídeo não disponível'
			m_simpleTV.User.YT.Lng.videoNotExst = 'vídeo não existe'
			m_simpleTV.User.YT.Lng.adaptive = 'ádaptativo'
			m_simpleTV.User.YT.Lng.page = 'página'
			m_simpleTV.User.YT.Lng.hl = 'pt_PT'
			m_simpleTV.User.YT.Lng.hl_sub = 'pt'
			m_simpleTV.User.YT.Lng.camera = 'visão da câmera'
			m_simpleTV.User.YT.Lng.camera_plst_title = 'álternar câmera'
			m_simpleTV.User.YT.Lng.channel = 'chanel'
			m_simpleTV.User.YT.Lng.video = 'vídeo'
			m_simpleTV.User.YT.Lng.search = 'procurar'
			m_simpleTV.User.YT.Lng.notFound = 'não encontrado'
			m_simpleTV.User.YT.Lng.started = 'started'
			m_simpleTV.User.YT.Lng.published = 'published'
			m_simpleTV.User.YT.Lng.duration = 'duration'
			m_simpleTV.User.YT.Lng.relatedVideos = 'vídeos relacionados'
		elseif m_simpleTV.Interface.GetLanguage() == 'vi' then
			m_simpleTV.User.YT.Lng.desc = 'Sự miêu tả'
			m_simpleTV.User.YT.Lng.qlty = 'Chất lượng'
			m_simpleTV.User.YT.Lng.savePlstFolder = 'Đã lưu danh sách phát'
			m_simpleTV.User.YT.Lng.savePlst_1 = 'Danh sách phát được lưu thành file'
			m_simpleTV.User.YT.Lng.savePlst_2 = 'vào thư mục'
			m_simpleTV.User.YT.Lng.savePlst_3 = 'Không thể lưu'
			m_simpleTV.User.YT.Lng.sub = 'Phụ đề'
			m_simpleTV.User.YT.Lng.subTr = 'Google dịch'
			m_simpleTV.User.YT.Lng.preview = 'Xem lại'
			m_simpleTV.User.YT.Lng.audio = 'Âm thanh'
			m_simpleTV.User.YT.Lng.noAudio = 'Không có âm thanh'
			m_simpleTV.User.YT.Lng.plst = 'Danh sách phát'
			m_simpleTV.User.YT.Lng.error = 'Lỗi'
			m_simpleTV.User.YT.Lng.live = 'Trực tiếp'
			m_simpleTV.User.YT.Lng.upLoadOnCh = 'Kênh'
			m_simpleTV.User.YT.Lng.loading = 'Đang tải'
			m_simpleTV.User.YT.Lng.videoNotAvail = 'Video không có sẵn'
			m_simpleTV.User.YT.Lng.videoNotExst = 'Video không tồn tại'
			m_simpleTV.User.YT.Lng.adaptive = 'Tự động'
			m_simpleTV.User.YT.Lng.page = 'Trang.'
			m_simpleTV.User.YT.Lng.hl = 'vi'
			m_simpleTV.User.YT.Lng.hl_sub = 'vi'
			m_simpleTV.User.YT.Lng.camera = 'Xem camera'
			m_simpleTV.User.YT.Lng.camera_plst_title = 'Đổi camera'
			m_simpleTV.User.YT.Lng.channel = 'Kênh'
			m_simpleTV.User.YT.Lng.video = 'Video'
			m_simpleTV.User.YT.Lng.search = 'Tìm kiếm'
			m_simpleTV.User.YT.Lng.notFound = 'Không tìm thấy'
			m_simpleTV.User.YT.Lng.started = 'Bắt đầu'
			m_simpleTV.User.YT.Lng.published = 'Xuất bản'
			m_simpleTV.User.YT.Lng.duration = 'Thời lượng'
			m_simpleTV.User.YT.Lng.relatedVideos = 'Video liên quan'
		else
			m_simpleTV.User.YT.Lng.desc = 'description'
			m_simpleTV.User.YT.Lng.qlty = 'quality'
			m_simpleTV.User.YT.Lng.savePlstFolder = 'saved playlists'
			m_simpleTV.User.YT.Lng.savePlst_1 = 'playlist saved to file'
			m_simpleTV.User.YT.Lng.savePlst_2 = 'to folder'
			m_simpleTV.User.YT.Lng.savePlst_3 = 'unable to save playlist'
			m_simpleTV.User.YT.Lng.sub = 'subtitles'
			m_simpleTV.User.YT.Lng.subTr = 'translated'
			m_simpleTV.User.YT.Lng.preview = 'preview'
			m_simpleTV.User.YT.Lng.audio = 'audio'
			m_simpleTV.User.YT.Lng.noAudio = 'no audio'
			m_simpleTV.User.YT.Lng.plst = 'playlist'
			m_simpleTV.User.YT.Lng.error = 'error'
			m_simpleTV.User.YT.Lng.live = 'live'
			m_simpleTV.User.YT.Lng.upLoadOnCh = 'uploads from channel'
			m_simpleTV.User.YT.Lng.loading = 'loading'
			m_simpleTV.User.YT.Lng.videoNotAvail = 'video not available'
			m_simpleTV.User.YT.Lng.videoNotExst = 'video does not exist'
			m_simpleTV.User.YT.Lng.adaptive = 'adaptive'
			m_simpleTV.User.YT.Lng.page = 'page'
			m_simpleTV.User.YT.Lng.hl = 'en_US'
			m_simpleTV.User.YT.Lng.hl_sub = 'en'
			m_simpleTV.User.YT.Lng.camera = 'camera view'
			m_simpleTV.User.YT.Lng.camera_plst_title = 'switch camera'
			m_simpleTV.User.YT.Lng.channel = 'channel'
			m_simpleTV.User.YT.Lng.video = 'video'
			m_simpleTV.User.YT.Lng.search = 'search'
			m_simpleTV.User.YT.Lng.notFound = 'not found'
			m_simpleTV.User.YT.Lng.started = 'started'
			m_simpleTV.User.YT.Lng.published = 'published'
			m_simpleTV.User.YT.Lng.duration = 'duration'
			m_simpleTV.User.YT.Lng.relatedVideos = 'related videos'
		end
	end
	if not m_simpleTV.User.YT.cookies then
			local function GetNetscapeFileFormat()
				local f = m_simpleTV.Common.GetMainPath(1) .. '/cookies.txt'
				local fhandle = io.open(f, 'r')
					if not fhandle then return end
				local t, i = {}, 1
				local yt_cooki_name, yt_cooki_val
					for line in fhandle:lines() do
						_, _, _, yt_cooki_name, yt_cooki_val = line:match('^[%#%a_]*%.youtube%.com%s+(%a+)%s+/%s+(%a+)%s+(%d+)%s+(.-)%s+(.-)$')
						if yt_cooki_name and yt_cooki_val then
							t[i] = {}
							t[i] = yt_cooki_name .. '=' .. yt_cooki_val
							i = i + 1
						end
					end
				fhandle:close()
					if i == 1 then return end
			 return table.concat(t, ';')
			end
			local function GetPmCookies()
				local error_text, pm = pcall(require, 'pm')
				if package.loaded.pm then
					local ret, login, pass = pm.GetTestPassword('youtube', 'YouTube', true)
					if pass and pass ~= '' then
					 return pass
					end
				end
			 return nil
			end
		local cookies = GetNetscapeFileFormat() or GetPmCookies()
		if cookies then
			local p = cookies:gsub('[\'"%s]+', ';') .. ';'
			local VISITOR_INFO1_LIVE = p:match('VISITOR_INFO1_LIVE=.-;') or ''
			local SID = p:match('SID=.-;') or ''
			local HSID = p:match('HSID=.-;') or ''
			local SSID = p:match('SSID=.-;') or ''
			local APISID = p:match('APISID=.-;') or ''
			local LOGIN_INFO = p:match('LOGIN_INFO=.-;') or ''
			local YSC = p:match('YSC=.-;') or ''
			cookies = VISITOR_INFO1_LIVE .. SID .. HSID .. SSID .. APISID .. LOGIN_INFO .. YSC
		else
			cookies = ''
		end
		m_simpleTV.User.YT.cookies = cookies .. 'PREF=hl=' .. m_simpleTV.User.YT.Lng.hl .. ';'
	end
	if not m_simpleTV.User.YT.ChPlst then
		m_simpleTV.User.YT.ChPlst = {}
	end
	if not m_simpleTV.User.YT.ChPlst.Urls then
		m_simpleTV.User.YT.ChPlst.Urls = {}
	end
	if not m_simpleTV.User.YT.Plst then
		m_simpleTV.User.YT.Plst = {}
	end
	if not m_simpleTV.User.YT.qlty then
		m_simpleTV.User.YT.qlty = tonumber(m_simpleTV.Config.GetValue('YT_qlty') or '360')
	end
	if not m_simpleTV.User.YT.qlty_live then
		m_simpleTV.User.YT.qlty_live = tonumber(m_simpleTV.Config.GetValue('YT_qlty_live') or '360')
	end
	if m_simpleTV.User.YT.isChPlst then
		m_simpleTV.User.YT.isChPlst = nil
	end
	local function GetApiKey()
		local sessionGetApiKey = m_simpleTV.Http.New('Mozilla/5.0 (SmartHub; SMART-TV; U; Linux/SmartTV) AppleWebKit/531.2+ (KHTML, like Gecko) WebBrowser/1.0 SmartTV Safari/531.2+')
			if not sessionGetApiKey then return end
		m_simpleTV.Http.SetTimeout(sessionGetApiKey, 16000)
			local function CheckApiKey(key, header)
					if not key or not header then return end
				local url = 'https://www.googleapis.com/youtube/v3/i18nLanguages?part=snippet&fields=kind&key=' .. key
				local rc, answer = m_simpleTV.Http.Request(sessionGetApiKey, {url = url, headers = header})
					if rc ~= 200 then return end
			 return true
			end
			local function ApiKey()
				local apiKeyHeader = 'Referer: https://www.youtube.com/tv/'
				local url = 'https://www.youtube.com/s/tv/html5/loader/live.js'
				m_simpleTV.Http.SetCookies(sessionGetApiKey, url, m_simpleTV.User.YT.cookies, '')
				local rc, answer = m_simpleTV.Http.Request(sessionGetApiKey, {url = url, headers = apiKeyHeader})
					if rc ~= 200 then return end
				local labels = answer:match('labels={\'default\':\'(.-)\'')
					if not labels then return end
				url = 'https://www.youtube.com/s/tv/html5/' .. labels .. '/app-prod.js'
				m_simpleTV.Http.SetCookies(sessionGetApiKey, url, m_simpleTV.User.YT.cookies, '')
				rc, answer = m_simpleTV.Http.Request(sessionGetApiKey, {url = url, headers = apiKeyHeader})
					if rc ~= 200 then return end
				local apiKey = answer:match('%?.%.getApiKey%(%):.-"(.-)"')
					if not apiKey then return end
		 return apiKey, apiKeyHeader
		end
		local apiKey, apiKeyHeader = ApiKey()
		local check = CheckApiKey(apiKey, apiKeyHeader)
		if not check then
			apiKey = decode64('QUl6YVN5Q05DZVgwbUpYWHZDSVNuaHBCS3pkc1hKSWVVc19KQmxJ')
			apiKeyHeader = 'Referer: ' .. decode64('aHR0cHM6Ly9uZXh0ZXJyLmZvci55b3V0dWJlLnNpbXBsZXR2')
			check = CheckApiKey(apiKey, apiKeyHeader)
				if not check then
					m_simpleTV.OSD.ShowMessageT({text = 'YouTube - API Key not valid', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
					m_simpleTV.Common.Sleep(2000)
				end
		end
		m_simpleTV.Http.Close(sessionGetApiKey)
		m_simpleTV.User.YT.apiKey = apiKey
		m_simpleTV.User.YT.apiKeyHeader = apiKeyHeader
	end
	local function split_str(source, delimiters)
		local elements = {}
		local pattern
		if not delimiters or delimiters == '' then
			pattern = '.'
		else
			pattern = '([^' .. delimiters .. ']+)'
		end
		source:gsub(pattern, function(value) elements[#elements + 1] = value end)
	 return elements
	end
	local function table_reversa(t)
		local tbl = {}
		local p = #tbl
			for i = #t, 1, -1 do
				p = p + 1
				tbl[p] = t[i]
			end
	 return tbl
	end
	local function timeStamp(isodt)
		local pattern = '(%d+)%-(%d+)%-(%d+)T(%d+):(%d+)'
		local xyear, xmonth, xday, xhour, xminute = isodt:match(pattern)
			if not (xyear or xmonth or xday or xhour or xminute) then
				 return ''
				end
		local currenttime = os.time()
		local datetime = os.date('!*t', currenttime)
		datetime.isdst = true
		local offset = currenttime - os.time(datetime)
		local convertedTimestamp = os.time({year = xyear, month = xmonth, day = xday, hour = xhour, min = xminute})
	 return (convertedTimestamp + offset)
	end
	local function secondsToClock(sec)
		sec = tonumber(sec)
			if sec < 2 then
			 return ''
			end
		sec = string.format('%01d:%02d:%02d',
									math.floor(sec / 3600),
									math.floor(sec / 60) % 60,
									math.floor(sec % 60))
	 return sec:gsub('^0[0:]+(.+:)', '%1' .. '')
	end
	local function unescape_html(str)
		str = str:gsub('u0026', '&')
		str = str:gsub('&#39;', '\'')
		str = str:gsub('&ndash;', "-")
		str = str:gsub('&#8217;', '\'')
		str = str:gsub('&raquo;', '"')
		str = str:gsub('&laquo;', '"')
		str = str:gsub('&lt;', '<')
		str = str:gsub('&gt;', '>')
		str = str:gsub('&quot;', '"')
		str = str:gsub('&apos;', "'")
		str = str:gsub('&#(%d+);', function(n) return string.char(n) end)
		str = str:gsub('&#x(%d+);', function(n) return string.char(tonumber(n, 16)) end)
		str = str:gsub('&amp;', '&') -- Be sure to do this after all others
	 return str
	end
	local function CleanDesc(d)
			if not d then return end
			if #d < 150 then return end
			if isWin_epgInfo == true then
				d = m_simpleTV.Common.fromPersentEncoding(d)
				d = d:gsub('\\n', '\n')
				d = d:gsub('\\r', '')
				d = d:gsub('%\n+', '\n')
			 return d
			end
		d = m_simpleTV.Common.fromPersentEncoding(d)
		d = d:gsub(string.char(194, 160), '')
		d = d:gsub('%.%s', '&nexterr\n', 2)
		d = d:gsub('\\n', '\n')
		d = d:gsub('\\r', '\n')
		d = d:gsub('%\n+', '\n')
		d = split_str(d, '\n')
			if #d < 3 then return end
		local desc, j = {}, 1
		local s
			for i = 1, #d do
				s = d[i]:match('https?://')
					or d[i]:match('^%s*%#%D')
					or d[i]:match('^%s*Follow%s')
					or d[i]:match('^%s*FOLLOW%s')
					or d[i]:match('^[%p%s]*$')
					or d[i]:match('[tT]witter')
					or d[i]:match('[fF]acebook')
					or d[i]:match('TWITTER')
					or d[i]:match('FACEBOOK')
					or d[i]:match('INSTAGRAM')
					or d[i]:match('[sS]potify')
					or d[i]:match('[iI]nstagram')
					or d[i]:match('[sS]oundcloud')
					or d[i]:match('@')
					or d[i]:match('©')
					or d[i]:match('www%.[%-%w]+%.')
					or d[i]:match('iTunes')
					or d[i]:match('%([cC]%) %d+')
				if not s then
					desc[j] = d[i]
					j = j + 1
						if j == 30 then break end
				end
			end
			if j < 3 then return end
		desc = table.concat(desc, '\n')
		desc = desc:gsub('&nexterr%\n', '. ')
		desc = desc:gsub('&nexterr', '')
		desc = desc:gsub('^[%s%c]*(.-)[%s%c]*$', '%1')
	 return desc
	end
	local function CleanTitle(s)
		s = m_simpleTV.Common.fromPersentEncoding(s)
		s = unescape_html(s)
		s = s:gsub('\\', '')
		if m_simpleTV.Interface.GetLanguage() == 'ru' then
			s = s:gsub('^Watch later$', 'Посмотреть позже')
			s = s:gsub('^Untitled List$', 'Список без названия')
			s = s:gsub('ОСТРОСЮЖЕТНЫЙ БОЕВИК!', '')
			s = s:gsub('ФИЛЬМ ПОРАЗИЛ ВСЕХ!', '')
			s = s:gsub('КРУТОЙ ФИЛЬМ!', '')
			s = s:gsub('ОТЛИЧНЫЙ ФИЛЬМ!', '')
			s = s:gsub('ОЧЕНЬ КРУТОЙ ДЕТЕКТИВ!', '')
			s = s:gsub('ФИЛЬМ ЗАСЛУЖИВАЕТ ВНИМАНИЯ!', '')
			s = s:gsub('ФИЛЬМ ПОКОРИЛ СЕРДЦА!', '')
			s = s:gsub('ОБАЛДЕННЫЙ ФИЛЬМ!', '')
			s = s:gsub('ПРЕКРАСНЫЙ ФИЛЬМ!', '')
			s = s:gsub('ОЧЕНЬ КЛАССНЫЙ ФИЛЬМ!', '')
			s = s:gsub('ПОТРЯСАЮЩИЙ ФИЛЬМ!', '')
			s = s:gsub('КЛАССНЫЙ СЕРИАЛ!', '')
			s = s:gsub('КЛАССНЫЙ ДЕТЕКТИВ!', '')
			s = s:gsub('КРУТОЙ БОЕВИК!', '')
			s = s:gsub('ЗАМЕЧАТЕЛЬНЫЙ ФИЛЬМ!', '')
			s = s:gsub('НЕРЕАЛЬНО КРУТОЙ ФИЛЬМ!', '')
			s = s:gsub('ПРЕМЬЕРА ПОКОРИЛА ИНТЕРНЕТ!', '')
			s = s:gsub('ЭТОТ ФИЛЬМ ЖДАЛИ ВСЕ!', '')
		elseif m_simpleTV.Interface.GetLanguage() == 'pt' then
			s = s:gsub('^Watch later$', 'Assistir depois')
			s = s:gsub('^Untitled List$', 'Lista sem título')
		elseif m_simpleTV.Interface.GetLanguage() == 'vi' then
			s = s:gsub('^Watch later$', 'Xem sau')
			s = s:gsub('^Untitled List$', 'Danh sách không tên')
		end
	 return s
	end
	local function ShowMessage(m)
			if isPanel == true then return end
		m_simpleTV.OSD.ShowMessageT({text = m, color = ARGB(255, 155, 155, 255), showTime = 1000 * 5, id = 'channelName'})
	end
	local function ShowInfo(info, bcolor, txtparm, color)
			local function datScr()
				local f = m_simpleTV.MainScriptDir .. 'user/video/!youtube.lua'
				local fhandle = io.open(f, 'r')
					if not fhandle then
					 return ''
					end
				local dat = fhandle:read(85)
				fhandle:close()
				dat = dat:match('%(.+%)') or ''
			 return dat
			end
		m_simpleTV.Control.ExecuteAction(37)
		if not info then
				local function dumpInfo(o)
					if type(o) == 'table' then
						local s = '{ '
						for k, v in pairs(o) do
							if type(k) ~= 'number' then
								k = '"' .. k .. '"'
							end
							s = s .. '[' .. k .. '] = ' .. dumpInfo(v) .. ',' .. '\n'
						end
					 return s .. '} '
					else
					 return tostring(o)
					end
				end
				local function truncateUtf8(str, n)
						if m_simpleTV.Common.midUTF8 then
						 return m_simpleTV.Common.midUTF8(str, 0, n)
						end
					str = m_simpleTV.Common.UTF8ToUTF16(str)
					str = str:sub(1, n)
					str = m_simpleTV.Common.UTF16ToUTF8(str)
				 return str
				end
			color = ARGB(0xFF, 0x80, 0x80, 0xFF)
			bcolor = ARGB(0x90, 0, 0, 0)
			txtparm = 1 + 4
			local codec = ''
			local title
			if #m_simpleTV.User.YT.title > 70 then
				title = truncateUtf8(m_simpleTV.User.YT.title, 65) .. '...'
			else
				title = m_simpleTV.User.YT.title
			end
			local ti = m_simpleTV.Control.GetCodecInfo()
			if ti then
				local codecD, typeD, resD
				local t, i = {}, 1
					for w in dumpInfo(ti):gmatch('%[%d+%] =.-}') do
						t[i] = {}
						codecD = w:match('%["Codec"%] = (.-),\n')
						typeD = w:match('%["Type"%] = (.-),\n')
						if codecD and typeD then
							typeD = typeD:gsub('Video', m_simpleTV.User.YT.Lng.video .. ': ')
							typeD = typeD:gsub('Audio', m_simpleTV.User.YT.Lng.audio .. ': ')
							typeD = typeD:gsub('Subtitle', m_simpleTV.User.YT.Lng.sub .. ': ')
							codecD = typeD .. codecD
							codecD = '\n' .. codecD
						end
						resD = w:match('%["Video resolution"%] = (.-),\n') or w:match('%["Resolution"%] = (.-),\n')
						if resD then
							resD = m_simpleTV.User.YT.Lng.qlty .. ': ' .. resD
							resD = '\n' .. resD
						end
						t[i] = (codecD or '') .. (resD or '')
						i = i + 1
					end
				codec = table.concat(t)
			end
			local dur, publishedAt, author
			if m_simpleTV.User.YT.isLive == true then
				dur = ''
				author = m_simpleTV.User.YT.Lng.live .. ' | '
						.. m_simpleTV.User.YT.Lng.channel .. ': '
						.. m_simpleTV.User.YT.author
				local timeSt = timeStamp(m_simpleTV.User.YT.actualStartTime)
				timeSt = os.date('%y %d %m %H %M', tonumber(timeSt))
				local year, day, month, hour, min = timeSt:match('(%d+) (%d+) (%d+) (%d+) (%d+)')
				publishedAt = m_simpleTV.User.YT.Lng.started .. ': '
						.. string.format('%d:%02d (%d/%d/%02d)', hour, min, day, month, year)
			else
				dur = m_simpleTV.User.YT.Lng.duration .. ': ' .. m_simpleTV.User.YT.duration
				author = m_simpleTV.User.YT.Lng.upLoadOnCh .. ': ' .. m_simpleTV.User.YT.author
				local timeSt = timeStamp(m_simpleTV.User.YT.publishedAt)
				timeSt = os.date('%y %d %m', tonumber(timeSt))
				local year, day, month = timeSt:match('(%d+) (%d+) (%d+)')
				publishedAt = m_simpleTV.User.YT.Lng.published .. ': '
						.. string.format('%d/%d/%02d', day, month, year)
			end
			info = title .. '\n'
					.. author .. '\n'
					.. publishedAt .. '\n'
					.. dur .. '\n'
					.. codec
			info = info:gsub('[%\n]+', '\n')
			info = info:gsub('%\n$', '')
		end
		local addElement = m_simpleTV.OSD.AddElement
		local removeElement = m_simpleTV.OSD.RemoveElement
		local q = {}
		q.once = 1
		q.zorder = 0
		q.cx = 0
		q.cy = 0
		q.id = 'YT_TEXT_INFO'
		q.class = 'TEXT'
		q.align = 0x0202
		q.top = 0
		q.color = color or ARGB(0xFF, 0xFF, 0xFF, 0xFF)
		q.font_italic = 0
		q.font_addheight = 6
		q.padding = 20
		q.textparam = txtparm or (1 + 4)
		q.text = info
		q.background = 0
		q.backcolor0 = bcolor or ARGB(0x90, 100, 0, 0)
		addElement(q)
		q = {}
		q.id = 'YT_DIV_CR'
		q.cx = 200
		q.cy = 200
		q.class = 'DIV'
		q.minresx = 800
		q.minresy = 600
		q.align = 0x0103
		q.left = 0
		q.once = 1
		q.zorder = 1
		q.background = -1
		addElement(q)
		q = {}
		q.id = 'YT_DIV_CR_TEXT'
		q.cx = 0
		q.cy = 0
		q.class = 'TEXT'
		q.minresx = 0
		q.minresy = 0
		q.align = 0x0103
		q.text = 'YouTube by nexterr ' .. datScr()
		q.color = ARGB(0x40, 211, 211, 211)
		q.font_height = -15
		q.font_weight = 700
		q.font_underline = 0
		q.font_italic = 0
		q.font_name = 'Arial'
		q.textparam = 0
		q.left = 5
		q.top = 5
		q.glow = 1
		q.glowcolor = ARGB(0x90, 0x00, 0x00, 0x00)
		addElement(q,'YT_DIV_CR')
			if m_simpleTV.Common.WaitUserInput(5000) == 1 then
				removeElement('YT_TEXT_INFO')
				removeElement('YT_DIV_CR')
			 return
			end
			if m_simpleTV.Common.WaitUserInput(5000) == 1 then
				removeElement('YT_TEXT_INFO')
				removeElement('YT_DIV_CR')
			 return
			end
			if m_simpleTV.Common.WaitUserInput(5000) == 1 then
				removeElement('YT_TEXT_INFO')
				removeElement('YT_DIV_CR')
			 return
			end
		removeElement('YT_TEXT_INFO')
		removeElement('YT_DIV_CR')
	end
	local function StopOnErr(e, t)
		if m_simpleTV.User.YT.logoDisk ~= '' then
			m_simpleTV.Control.CurrentAddress = m_simpleTV.User.YT.logoDisk .. '$OPT:video-filter=adjust$OPT:saturation=0$OPT:video-filter=gaussianblur$OPT:image-duration=5'
		else
			m_simpleTV.Control.CurrentAddress = 'vlc://pause:5'
		end
		if session then
			m_simpleTV.Http.Close(session)
		end
		if sessionGetVideo then
			m_simpleTV.Http.Close(sessionGetVideo)
		end
		local err = '❗️ YouTube ' .. m_simpleTV.User.YT.Lng.error .. ' [' .. e .. ']\n' .. (t or '')
		m_simpleTV.Control.SetTitle(err)
		isPanel = false
		ShowMessage(err)
	end
	local function Search(sAdr)
		local types, yt, header, stopSearch, url
		local eventType = ''
		if sAdr:match('^%s*%-%s*%-%s*%-') then
			types = 'channel'
			header = m_simpleTV.User.YT.Lng.channel
			yt = 'channel/'
			stopSearch = 90
		elseif sAdr:match('^%s*%-%s*%-') then
			types = 'playlist'
			header = m_simpleTV.User.YT.Lng.plst
			yt = 'playlist?list='
			stopSearch = 120
		elseif sAdr:match('^%s*%-%s*%+') then
			eventType = '&eventType=live'
			types = 'video'
			header = m_simpleTV.User.YT.Lng.live
			yt = 'watch?v='
			stopSearch = 60
		elseif sAdr:match('^%-related=') then
			sAdr = sAdr:gsub('%-related=', '')
			types = 'related'
			header = m_simpleTV.User.YT.Lng.relatedVideos
			yt = 'watch?v='
			stopSearch = 90
		else
			types = 'video&videoDimension=2d'
			header = m_simpleTV.User.YT.Lng.video
			yt = 'watch?v='
			stopSearch = 50
		end
		require 'json'
			if types == 'video&videoDimension=2d' then
				sAdr = sAdr:gsub('^[%-%+%s]+(.-)%s*$', '%1')
				sAdr = m_simpleTV.Common.multiByteToUTF8(sAdr)
				sAdr = m_simpleTV.Common.toPersentEncoding(sAdr)
				local k, i = 1, 1
				local tab, name, dur, desc, length_seconds
				local t = {}
					for j = 1, 10 do
							if k > stopSearch then break end
						url = 'https://youtube.com/search_ajax?style=json&search_query=' .. sAdr .. '&page=' .. j .. '&hl=' .. m_simpleTV.User.YT.Lng.hl
						local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
							if rc ~= 200 then break end
						answer = answer:gsub('(%[%])', '"nil"')
						tab = json.decode(answer)
							if not tab then return end
						i = 1
							while true do
									if not tab.video[i] then break end
								length_seconds = tonumber(tab.video[i].length_seconds or '0')
								if length_seconds > 0 then
									name = CleanTitle(tab.video[i].title)
									dur = tab.video[i].duration
									t[k] = {}
									t[k].Id = k
									t[k].Adress = 'https://www.youtube.com/' .. yt .. tab.video[i].encrypted_id
									t[k].Name = name .. ' (' .. dur .. ')'
									if isPanel == true then
										t[k].InfoPanelLogo = 'https://i.ytimg.com/vi/' .. tab.video[i].encrypted_id .. '/default.jpg'
										t[k].InfoPanelName = name
										t[k].InfoPanelShowTime = 10000
										desc = tab.video[i].description
										if desc and desc ~= '' then
											t[k].InfoPanelDesc = unescape_html(desc)
											t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.desc .. ' | ' .. m_simpleTV.User.YT.Lng.channel .. ': ' .. tab.video[i].author.. ' | ' .. dur
										else
											t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.channel .. ': ' .. tab.video[i].author .. ' | ' .. dur
										end
									end
									k = k + 1
								end
								i = i + 1
							end
						j = j + 1
					end
					if k == 1 then return end
			 return t, types, header
			end
		if not m_simpleTV.User.YT.apiKey then
			GetApiKey()
		end
			if not m_simpleTV.User.YT.apiKey then return end
		if types == 'related' then
			url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&fields=nextPageToken,items/snippet/title,items/id/videoId,items/snippet/thumbnails/default/url,items/snippet/description,items/snippet/liveBroadcastContent,items/snippet/channelTitle&type=video&relatedToVideoId=' .. sAdr .. '&key=' .. m_simpleTV.User.YT.apiKey .. '&relevanceLanguage=' .. m_simpleTV.User.YT.Lng.hl
		else
			sAdr = sAdr:gsub('^[%-%+%s]+(.-)%s*$', '%1')
			sAdr = m_simpleTV.Common.multiByteToUTF8(sAdr)
			sAdr = m_simpleTV.Common.toPersentEncoding(sAdr)
			url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=' .. sAdr .. '&type=' .. types .. '&fields=nextPageToken,items/id,items/snippet/title,items/snippet/thumbnails/default/url,items/snippet/description,items/snippet/liveBroadcastContent,items/snippet/channelTitle&maxResults=50' .. eventType .. '&key=' .. m_simpleTV.User.YT.apiKey .. '&relevanceLanguage=' .. m_simpleTV.User.YT.Lng.hl
		end
		local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
			if rc ~= 200 then return end
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
			if not tab then return end
		local t = {}
		local k, i = 1, 1
		local name
			while true do
					if not tab.items[i] or k > stopSearch then break end
				if eventType == '&eventType=live'
					or (eventType == '' and tab.items[i].snippet.liveBroadcastContent ~= 'live')
				then
					name = CleanTitle(tab.items[i].snippet.title)
					t[k] = {}
					t[k].Id = k
					t[k].Name = name
					t[k].Adress = 'https://www.youtube.com/' .. yt .. (tab.items[i].id.videoId or tab.items[i].id.playlistId or tab.items[i].id.channelId)
					if isPanel == true then
						if tab.items[i].snippet
							and tab.items[i].snippet.thumbnails
							and tab.items[i].snippet.thumbnails.default
							and tab.items[i].snippet.thumbnails.default.url
						then
							t[k].InfoPanelLogo = tab.items[i].snippet.thumbnails.default.url
						else
							t[k].InfoPanelLogo = m_simpleTV.User.YT.logoDisk
						end
						t[k].InfoPanelName = name
						t[k].InfoPanelShowTime = 10000
						if types == 'related' then
							t[k].InfoPanelDesc = CleanDesc(tab.items[i].snippet.description)
						else
							t[k].InfoPanelDesc = tab.items[i].snippet.description
						end
						if types ~= 'playlist' then
							if t[k].InfoPanelDesc and t[k].InfoPanelDesc ~= '' then
								t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.desc .. ' | ' .. m_simpleTV.User.YT.Lng.channel .. ': ' .. tab.items[i].snippet.channelTitle
							else
								t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.channel .. ': ' .. tab.items[i].snippet.channelTitle
							end
						else
							if t[k].InfoPanelDesc and t[k].InfoPanelDesc ~= '' then
								t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.desc
							end
						end
					end
					k = k + 1
				end
				i = i + 1
			end
			if k == 1 then return end
		local j, adrUrl, nextPageToken
			while true do
					if k > stopSearch then break end
				nextPageToken = answer:match('"nextPageToken": "(.-)"')
					if not nextPageToken then break end
				adrUrl = url .. '&pageToken=' .. nextPageToken
				rc, answer = m_simpleTV.Http.Request(session, {url = adrUrl, headers = m_simpleTV.User.YT.apiKeyHeader})
					if rc ~= 200 then break end
					if not answer:match('"id"') then break end
				answer = answer:gsub('%[%]', '"nil"')
				tab = json.decode(answer)
					if not tab then break end
				j = 1
					while true do
							if not tab.items[j] or k > stopSearch then break end
						if eventType == '&eventType=live'
							or (eventType == '' and tab.items[j].snippet.liveBroadcastContent ~= 'live')
						then
							name = CleanTitle(tab.items[j].snippet.title)
							t[k] = {}
							t[k].Id = k
							t[k].Name = name
							t[k].Adress = 'https://www.youtube.com/' .. yt .. (tab.items[j].id.videoId or tab.items[j].id.playlistId or tab.items[j].id.channelId)
							if isPanel == true then
								if tab.items[j].snippet
									and tab.items[j].snippet.thumbnails
									and tab.items[j].snippet.thumbnails.default
									and tab.items[j].snippet.thumbnails.default.url
								then
									t[k].InfoPanelLogo = tab.items[j].snippet.thumbnails.default.url
								else
									t[k].InfoPanelLogo = m_simpleTV.User.YT.logoDisk
								end
								t[k].InfoPanelName = name
								t[k].InfoPanelShowTime = 10000
								if types == 'related' then
									t[k].InfoPanelDesc = CleanDesc(tab.items[j].snippet.description)
								else
									t[k].InfoPanelDesc = tab.items[j].snippet.description
								end
								if types ~= 'playlist' then
									if t[k].InfoPanelDesc and t[k].InfoPanelDesc ~= '' then
										t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.desc .. ' | ' .. m_simpleTV.User.YT.Lng.channel .. ': ' .. tab.items[j].snippet.channelTitle
									else
										t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.channel .. ': ' .. tab.items[j].snippet.channelTitle
									end
								else
									if t[k].InfoPanelDesc and t[k].InfoPanelDesc ~= '' then
										t[k].InfoPanelTitle = m_simpleTV.User.YT.Lng.desc
									end
								end
							end
							k = k + 1
						end
						j = j + 1
					end
			end
	 return t, types, header
	end
	local function GetUrlWatchVideos(url)
		m_simpleTV.Http.SetRedirectAllow(session, false)
		m_simpleTV.Http.SetCookies(session, url, m_simpleTV.User.YT.cookies, '')
		local rc = m_simpleTV.Http.Request(session, {url = url})
		local raw = m_simpleTV.Http.GetRawHeader(session)
			if not raw then return end
	 return raw:match('Location: (.-)\n')
	end
	local function GetInfo(v)
		local sessionGetInfo = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36')
			if not sessionGetInfo then return end
		m_simpleTV.Http.SetTimeout(sessionGetInfo, 16000)
		if not m_simpleTV.User.YT.apiKey then
			GetApiKey()
		end
			if not m_simpleTV.User.YT.apiKey then return end
		local url = 'https://www.googleapis.com/youtube/v3/videos?part=snippet,contentDetails,liveStreamingDetails&fields=items/snippet/thumbnails,items/contentDetails/regionRestriction,items/contentDetails/duration,items/snippet/publishedAt,items/liveStreamingDetails/actualStartTime&id=' .. v .. '&key=' .. m_simpleTV.User.YT.apiKey
		local rc, answer = m_simpleTV.Http.Request(sessionGetInfo, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
		m_simpleTV.Http.Close(sessionGetInfo)
			if rc ~= 200 then return end
		answer = answer:gsub('%[%]', '"nil"')
		require 'json'
		local t = json.decode(answer)
			if not t
				or not t.items
				or not t.items[1]
			then
			 return
			end
			if t.items[1].liveStreamingDetails
				and t.items[1].liveStreamingDetails.actualStartTime
				and m_simpleTV.User.YT.isLive == true
			then
				m_simpleTV.User.YT.actualStartTime = t.items[1].liveStreamingDetails.actualStartTime
				m_simpleTV.User.YT.getinfo = true
			 return
			end
		if t.items[1].snippet then
			if m_simpleTV.User.YT.duration == ''
				and t.items[1].contentDetails
				and t.items[1].contentDetails.duration
			then
				local duration = t.items[1].contentDetails.duration
				local h = duration:match('(%d+)H') or 0
				local m = duration:match('(%d+)M') or 0
				local s = duration:match('(%d+)S') or 0
				local d = duration:match('(%d+)D') or 0
				duration = d * 24 * 3600 + h * 3600 + m * 60 + s
				m_simpleTV.User.YT.duration = secondsToClock(duration)
			end
			if t.items[1].snippet.publishedAt then
				m_simpleTV.User.YT.publishedAt = t.items[1].snippet.publishedAt
			end
			if t.items[1].snippet.thumbnails then
				if t.items[1].snippet.thumbnails.maxres
					and t.items[1].snippet.thumbnails.maxres.url
				then
					m_simpleTV.User.YT.pic = t.items[1].snippet.thumbnails.maxres.url
				elseif t.items[1].snippet.thumbnails.high
					and t.items[1].snippet.thumbnails.high.url
				then
					m_simpleTV.User.YT.pic = t.items[1].snippet.thumbnails.high.url
				elseif t.items[1].snippet.thumbnails.default
					and t.items[1].snippet.thumbnails.default.url
				then
					m_simpleTV.User.YT.pic = t.items[1].snippet.thumbnails.default.url
				end
			end
		end
		m_simpleTV.User.YT.getinfo = true
	end
	local function SetBackground(b)
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = (b or ''), TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	local function BuildParamArray(str)
		str = m_simpleTV.Common.fromPersentEncoding(str)
		str = m_simpleTV.Common.fromPersentEncoding(str)
		str = str:gsub('&html5_.+', '')
		str = str:gsub('%?', '&')
		str = str:gsub('xtags=%w+&', '')
		str = str:gsub('^["%s]*(.-)[%s,]*$', '%1')
	 return split_str(str, '&')
	end
	local function GetParamFromArray(t, name)
		for i = 1, #t do
			local s = t[i]:match('^' .. name .. '=(.+)')
				if s then
				 return s
				end
		end
	 return nil
	end
	local function GetAdr(array, isCipher)
		local url = GetParamFromArray(array, 'url')
		local sparams = GetParamFromArray(array, 'sparams')
		local mime = GetParamFromArray(array, 'type') or GetParamFromArray(array, 'mime')
			if not mime or not url or not sparams then return end
		local quality = GetParamFromArray(array, 'quality')
		local clen = GetParamFromArray(array, 'clen') or '0'
		if isCipher == true then
			quality = true
		end
			if clen == '0' and not quality then return end
		local signature
		local sig = GetParamFromArray(array, 'signature')
		local s = GetParamFromArray(array, 's') or GetParamFromArray(array, 'sig')
		local sp = GetParamFromArray(array, 'sp') or 'signature'
		if sig then
			signature = 'signature=' .. sig
		end
		if s and sp == 'sig' then
			signature = 'llsig=' .. s
		end
		if s and sp == 'signature' then
			signature = 's=' .. s
		end
			if not signature then return end
		local fparams = '&'
			for param in sparams:gmatch('%w+') do
				local str = GetParamFromArray(array, param)
				if str then
					fparams = fparams .. param .. '=' .. str .. '&'
				end
			end
		local lsig = GetParamFromArray(array, 'lsig')
		if lsig then
			local lsparams = GetParamFromArray(array, 'lsparams')
				if not lsparams then return end
			local lfparams = '&'
				for lparam in lsparams:gmatch('%w+') do
					local lstr = GetParamFromArray(array, lparam)
					if lstr then
						lfparams = lfparams .. lparam .. '=' .. lstr .. '&'
					end
				end
			lsig = '&lsparams=' .. lsparams .. lfparams .. 'lsig=' .. lsig
			if sp == 'sig' then
				signature = 'llsig=' .. s
			else
				signature = 'sig=' .. s
			end
		else
			lsig = ''
		end
		local key = GetParamFromArray(array, 'key')
		if key then
			key = '&key=' .. key
		else
			key = ''
		end
		local adr = url .. '?sparams=' .. sparams .. fparams .. signature .. lsig .. key
	 return adr, quality
	end
	local function DeCipherSign(adr)
			local function table_swap(t, a)
					if a >= #t then return end
				local c = t[1]
				local p = (a % #t) + 1
				t[1] = t[p]
				t[p] = c
			 return t
			end
			local function table_slica(tbl, first, last, step)
				local sliced = {}
				local p = #sliced
					for i = first or 1, last or #tbl, step or 1 do
						p = p + 1
						sliced[p] = tbl[i]
					end
			 return sliced
			end
			local function sign_decode(s, signScr)
				local t = split_str(s)
					if #t == 0 then
					 return s
					end
				local math_abs = math.abs
					for i = 1, #signScr do
						local a = signScr[i]
						if a == 0 then
							t = table_reversa(t)
						else
							if a > 0 then
								t = table_swap(t, a)
							else
								t = table_slica(t, math_abs(a) + 1)
							end
						end
					end
			 return table.concat(t)
			end
		local ciperSign, signature
		for s in adr:gmatch('[&/]s[=/][^&/]*') do
				if not m_simpleTV.User.YT.signScr then
					isPanel = false
					ShowMessage('⚠️ YouTube - DeCipher Signature Error 1')
					adr = 'vlc://pause:3'
				 break
				end
			ciperSign = s:gsub('[&/]s[=/]', '')
			signature = sign_decode(ciperSign, m_simpleTV.User.YT.signScr)
			if s:match('s=') then
				adr = adr:gsub('&s=[^&]*', '&signature=' .. signature, 1)
			else
				adr = adr:gsub('/s/[^/]*', '/signature/' .. signature, 1)
			end
		end
		for ls in adr:gmatch('[&/]llsig[=/][^&/]*') do
				if not m_simpleTV.User.YT.signScr then
					isPanel = false
					ShowMessage('⚠️ YouTube - DeCipher Signature Error 2')
					adr = 'vlc://pause:3'
				 break
				end
			ciperSign = ls:gsub('[&/]llsig[=/]', '')
			signature = sign_decode(ciperSign, m_simpleTV.User.YT.signScr)
			if ls:match('llsig=') then
				adr = adr:gsub('&llsig=[^&]*', '&sig=' .. signature, 1)
			else
				adr = adr:gsub('/llsig/[^/]*', '/sig/' .. signature, 1)
			end
		end
	 return adr
	end
	local function GetQltyIndex(t)
		if (m_simpleTV.User.YT.qlty < 300
			and m_simpleTV.User.YT.qlty > 100)
		then
			m_simpleTV.User.YT.qlty = m_simpleTV.User.YT.qlty0
			or tonumber(m_simpleTV.Config.GetValue('YT_qlty') or '360')
		end
		local index
			for u = 1, #t do
					if t[u].qltyLive
						and m_simpleTV.User.YT.qlty_live < t[u].qltyLive
					then
					 return index or 1
					end
					if t[u].qlty
						and m_simpleTV.User.YT.qlty < t[u].qlty
					then
					 break
					end
				index = u
			end
		if index == 1
			and m_simpleTV.User.YT.qlty > 100
		then
			if #t > 1 then
				index = 2
			end
		end
	 return index or 1
	end
	local function GetStreamsTab(vId)
		m_simpleTV.User.YT.vId = vId
		m_simpleTV.User.YT.chId = ''
		m_simpleTV.User.YT.title = ''
		m_simpleTV.User.YT.publishedAt = ''
		m_simpleTV.User.YT.actualStartTime = ''
		m_simpleTV.User.YT.duration = ''
		m_simpleTV.User.YT.pic = nil
		m_simpleTV.User.YT.getinfo = false
		m_simpleTV.User.YT.isLive = false
		m_simpleTV.User.YT.isLiveContent = false
		m_simpleTV.User.YT.isTrailer = false
		m_simpleTV.User.YT.isMusic = false
		m_simpleTV.User.YT.desc = nil
		local sTime = inAdr:match('[%?&]t=[^&]*')
		if sTime and videoId == m_simpleTV.User.YT.vId then
			local h = sTime:match('(%d+)h') or 0
			local m = sTime:match('(%d+)m') or 0
			local s = sTime:match('(%d+)s') or 0
			local d = sTime:match('(%d+)') or 0
			local st = (h * 3600) + (m * 60) + s
			if st ~= 0 then
				sTime = st
			else
				sTime = d
			end
			sTime = '$OPT:start-time=' .. sTime
		end
		local sessionGetVideo = m_simpleTV.Http.New('Mozilla/5.0 (SmartHub; SMART-TV; U; Linux/SmartTV) AppleWebKit/531.2+ (KHTML, like Gecko) WebBrowser/1.0 SmartTV Safari/531.2+')
			if not sessionGetVideo then
			 return nil, 'session GetVideo Error'
			end
		m_simpleTV.Http.SetTimeout(sessionGetVideo, 16000)
		if not m_simpleTV.User.YT.signScr then
				local function GetPlayerJs()
					local url = 'https://www.youtube.com/tv#/watch/video/control?v=' .. m_simpleTV.User.YT.vId
					m_simpleTV.Http.SetCookies(sessionGetVideo, url, m_simpleTV.User.YT.cookies, '')
					local rc, answer = m_simpleTV.Http.Request(sessionGetVideo, {url = url})
						if rc ~= 200 then return end
					url = answer:match('"player_url":"(.-)"')
						if not url then return end
					url = url:gsub('\\/', '/')
					url = 'https://www.youtube.com' .. url
					rc, answer = m_simpleTV.Http.Request(sessionGetVideo, {url = url, headers = 'Referer: https://www.youtube.com/tv'})
						if rc ~= 200 then return end
					local l, obj = answer:match('%(a%){a=a%.split%(""%)((;..).-)return a%.join%(""%)}')
						if not l or not obj then return end
					local func, p
					local signScr, i = {}, 1
						for param in l:gmatch(obj .. '%.(.-)%)') do
							func, p = param:match('^(..)%(a,(%d+)')
							func = answer:match('[%p%s]' .. func .. ':function(.-)}')
							if func:match('a%.reverse') then
								p = 0
							end
							if func:match('a%.splice') then
								p = '-' .. p
							end
							signScr[i] = tonumber(p)
							i = i + 1
						end
					local sts = answer:match('[,%.]sts[:="](%d+)')
				 return signScr, sts
				end
			m_simpleTV.User.YT.signScr, m_simpleTV.User.YT.signSts = GetPlayerJs()
			m_simpleTV.User.YT.signSts = m_simpleTV.User.YT.signSts or ''
		end
		local url = 'https://www.youtube.com/get_video_info?eurl=https://www.youtube.com&video_id=' .. m_simpleTV.User.YT.vId .. '&hl=' .. m_simpleTV.User.YT.Lng.hl .. '&sts=' .. m_simpleTV.User.YT.signSts
		m_simpleTV.Http.SetCookies(sessionGetVideo, url, m_simpleTV.User.YT.cookies, '')
		if debug then
			debug_0 = os.clock()
		end
		local rc, answer = m_simpleTV.Http.Request(sessionGetVideo, {url = url})
		if debug then
			debug_0 = string.format('%.3f', (os.clock() - debug_0))
		end
			if rc ~= 200 then
				answer = ''
			end
		local trailer = answer:match('trailerVideoId%%22%%3A%%22(.-)%%22')
		if trailer then
			m_simpleTV.User.YT.vId = trailer
			m_simpleTV.User.YT.isTrailer = true
			answer = answer:match('playerVars.+') or ''
			answer = m_simpleTV.Common.fromPersentEncoding(answer)
			answer = answer:gsub('\\u0026', '&')
		end
		if not answer:match('status%%22%%3A%%22OK') then
			url = 'https://www.youtube.com/get_video_info?el=detailpage&eurl=https://www.youtube.com&cco=1&video_id=' .. m_simpleTV.User.YT.vId .. '&hl=' .. m_simpleTV.User.YT.Lng.hl .. '&sts=' .. m_simpleTV.User.YT.signSts
			m_simpleTV.Http.SetCookies(sessionGetVideo, url, m_simpleTV.User.YT.cookies, '')
			rc, answer = m_simpleTV.Http.Request(sessionGetVideo, {url = url})
				if rc ~= 200 then
				 return nil, 'GetVideo Error 1'
				end
		end
		local answerJS = answer:match('player_response=([^&]+)')
			if not answerJS then
			 return nil, m_simpleTV.User.YT.Lng.videoNotExst
			end
		answerJS = answerJS:gsub('%+', ' ')
		answerJS = m_simpleTV.Common.fromPersentEncoding(answerJS)
		answerJS = answerJS:gsub('\\u0026', '&')
		answerJS = answerJS:gsub('%[%]', '"nil"')
		require 'json'
		local tab0 = json.decode(answerJS)
			if not tab0 then
			 return nil, 'GetStreams Tab Error 1'
			end
			if tab0.multicamera
				and tab0.multicamera.playerLegacyMulticameraRenderer
				and tab0.multicamera.playerLegacyMulticameraRenderer.metadataList
				and not inAdr:match('&restart')
				and not inAdr:match('&isPlst=true')
				and not inAdr:match('list=')
			then
				local t, i = {}, 1
				local metadataList = tab0.multicamera.playerLegacyMulticameraRenderer.metadataList
				metadataList = m_simpleTV.Common.fromPersentEncoding(metadataList)
					for vId in metadataList:gmatch('/vi/(.-)/') do
						t[i] = {}
						t[i] = vId
						i = i + 1
					end
					if i == 1 then
					 return nil, 'no list multicamers'
					end
				t = table.concat(t, ',')
				inAdr = 'https://www.youtube.com/watch_videos?video_ids=' .. t .. '&title=' .. m_simpleTV.User.YT.Lng.camera_plst_title:gsub('%s', '%+')
				inAdr = GetUrlWatchVideos(inAdr)
					if not inAdr then
					 return nil, 'not get adrs multicamers'
					end
				m_simpleTV.Http.Close(sessionGetVideo)
				m_simpleTV.Http.Close(session)
				inAdr = inAdr .. '&isLogo=false'
			 return inAdr
			end
		m_simpleTV.Http.Close(session)
		if tab0.videoDetails then
			if tab0.videoDetails.author then
				m_simpleTV.User.YT.author = tab0.videoDetails.author
			end
			if tab0.videoDetails.channelId then
				m_simpleTV.User.YT.chId = tab0.videoDetails.channelId
			end
			if tab0.videoDetails.title then
				m_simpleTV.User.YT.title = tab0.videoDetails.title
			end
			if tab0.videoDetails.isLive == true then
				m_simpleTV.User.YT.isLive = true
			end
			if tab0.videoDetails.isLiveContent == true then
				m_simpleTV.User.YT.isLiveContent = true
			end
			if isVideo and tab0.videoDetails.lengthSeconds then
				m_simpleTV.User.YT.duration = secondsToClock(tab0.videoDetails.lengthSeconds)
			end
			if tab0.videoDetails.shortDescription then
				local desc = tab0.videoDetails.shortDescription
				desc = CleanDesc(desc)
				m_simpleTV.User.YT.desc = desc
			end
		end
		local title = CleanTitle(m_simpleTV.User.YT.title)
		if tab0.multicamera then
			title = title .. '\n☑ ' .. m_simpleTV.User.YT.Lng.camera
		end
			if tab0.streamingData and tab0.streamingData.hlsManifestUrl
				and (tab0.videoDetails.isLiveContent == true or tab0.videoDetails.isLive == true)
			then
				local opt
				if m_simpleTV.Common.GetVlcVersion() > 3000 then
					opt = '$OPT:no-gnutls-system-trust$OPT:adaptive-use-access'
					optA = '$OPT:no-gnutls-system-trust$OPT:adaptive-logic=fixedrate'
				else
					opt = '$OPT:no-ts-trust-pcr'
				end
				url = tab0.streamingData.hlsManifestUrl:gsub('keepalive/yes/', '')
				rc, answer = m_simpleTV.Http.Request(sessionGetVideo, {url = url})
					if rc ~= 200 then
					 return nil, 'GetStreams live Error 1'
					end
				local t, i = {}, 1
					for name, fps, adr in answer:gmatch('RESOLUTION=(.-),.-RATE=(%d+).-\n(.-)\n') do
						name = tonumber(name:match('x(%d+)') or '0')
						if name > 240 then
							if tonumber(fps) > 30 then
								qlty = name + 6
								fps = ' ' .. fps .. ' FPS'
							else
								qlty = name
								fps = ''
							end
							t[i] = {}
							t[i].Id = i
							t[i].Name = name .. 'p' .. fps
							t[i].Adress = adr .. opt
							t[i].qltyLive = qlty
							i = i + 1
						end
					end
					if i == 1 then
					 return nil, 'GetStreams live Error 2'
					end
				if m_simpleTV.Common.GetVlcVersion() > 3000 then
					t[i] = {Id = i, Name = m_simpleTV.User.YT.Lng.adaptive, qltyLive = 3000, Adress = url .. optA}
				end
				if tab0.videoDetails.isLive == true then
					title = title .. '\n☑ ' .. m_simpleTV.User.YT.Lng.live
				end
				m_simpleTV.Http.Close(sessionGetVideo)
				m_simpleTV.Http.Close(session)
			 return t, title
			end
		local tab, i = {}, 1
		local audio_itags, video_itags, opt_2xx, opt_3xx
		if m_simpleTV.Common.GetVlcVersion() > 3000 then
				video_itags = {
							394, 17, 160, 278, -- 144
							395, 36, 133, 242, -- 240
							43, 18, 134, 243, -- 360
							135, 244, -- 480
							-- 22, -- 720 mp4
							136, 247, -- 720
							298, -- 720 (60 fps)
							-- 302, 334, -- 720 (60 fps, HDR)
							137, 248,-- 1080
							-- 303, 299, 335,-- 1080 (60 fps, HDR)
							-- 264, 271, 308, 336, -- 1440 (60 fps, HDR)
							-- 266, 313, 315, 337, -- 2160 (60 fps, HDR)
							-- 272, -- 4320 (60 fps)
							}
				audio_itags = {
							258, -- aac
							251, -- opus
							140, -- aac
							171, -- vorbis
							}
				opt_3xx = '$OPT:no-gnutls-system-trust'
			elseif m_simpleTV.Common.GetVlcVersion() == 2280 then
				video_itags = {
							17, 278, -- 144
							36, 242, -- 240
							43, 18, 243, -- 360
							244, -- 480
							-- 22, -- 720 mp4
							247, -- 720
							-- 302, 334, -- 720 (60 fps, HDR)
							248, -- 1080
							-- 303, 335, -- 1080 (60 fps, HDR)
							-- 271, 308, 336, -- 1440 (60 fps, HDR)
							-- 313, 315, 337, -- 2160 (60 fps, HDR)
							-- 272, -- 4320 (60 fps)
							}
				audio_itags = {171} -- vorbis
				opt_2xx = '$OPT:demux=avcodec'
			else
				video_itags = {
							17, -- 144
							36, -- 240
							43, 18, -- 360
							-- 22, -- 720 mp4
							-- 136, -- 720 (dash)
							-- 137, -- 1080 (dash)
							}
				audio_itags = {171} -- vorbis
				opt_2xx = '$OPT:demux=avcodec'
		end
		if tab0.streamingData and tab0.streamingData.formats then
			local k = 1
			while true do
					if not tab0.streamingData.formats[k] then break end
				tab[i] = {}
				tab[i].itag = tab0.streamingData.formats[k].itag
				tab[i].fps = tab0.streamingData.formats[k].fps
				tab[i].qlty = tab0.streamingData.formats[k].height
				tab[i].width = tab0.streamingData.formats[k].width
				tab[i].Adress = tab0.streamingData.formats[k].cipher or tab0.streamingData.formats[k].url
				tab[i].adaptive = false
				if tab0.streamingData.formats[k].cipher then
					tab[i].isCipher = true
				end
				i = i + 1
				k = k + 1
			end
		end
		if tab0.streamingData and tab0.streamingData.adaptiveFormats then
			local k = 1
			local adr
			while true do
					if not tab0.streamingData.adaptiveFormats[k] then break end
				adr = tab0.streamingData.adaptiveFormats[k].cipher or tab0.streamingData.adaptiveFormats[k].url
				if not adr:match('dur=0%.00')
					and not adr:match('dur%%3D0.00')
					and not adr:match('clen=0')
					and not adr:match('clen%%3D0')
				then
					tab[i] = {}
					tab[i].itag = tab0.streamingData.adaptiveFormats[k].itag
					tab[i].qlty = tab0.streamingData.adaptiveFormats[k].height
					tab[i].width = tab0.streamingData.adaptiveFormats[k].width
					tab[i].fps = tab0.streamingData.adaptiveFormats[k].fps
					tab[i].Adress = adr
					tab[i].adaptive = true
					if tab0.streamingData.adaptiveFormats[k].cipher then
						tab[i].isCipher = true
					end
					i = i + 1
				end
				k = k + 1
			end
		end
		if #tab == 0 then
				local function tables_concat(t1, t2)
					local t3 = {unpack(t1)}
					local p = #t3
						for i = 1, #t2 do
							p = p + 1
							t3[p] = t2[i]
						end
				 return t3
				end
			local fmt_stream_map = answer:match('url_encoded_fmt_stream_map=([^&]*)') or ''
			local adaptive_fmts = answer:match('adaptive_fmts=([^&]*)') or ''
			local streams = fmt_stream_map .. ',' .. adaptive_fmts
			streams = m_simpleTV.Common.fromPersentEncoding(streams)
			streams = split_str(streams, ',')
			local all_itags = tables_concat(video_itags, audio_itags)
			local array, itag, adr, quality, size, height, width, adaptive
				for b = 1, #streams do
					itag = streams[b]:match('itag=(%d+)')
					if itag then
						for z = 1, #all_itags do
							if tonumber(itag) == all_itags[z] then
								array = BuildParamArray(streams[b])
								adr, quality = GetAdr(array)
								if adr then
									if quality then
										if quality == 'small' then
											height = '240'
										elseif quality == 'medium' then
											height = '360'
										else
											height = '720'
										end
										adaptive = false
									else
										size = GetParamFromArray(array, 'size') or ''
										width, height = size:match('(%d+)x(%d+)')
										adaptive = true
									end
									if not adr:match('itag=') then
										adr = adr .. '&itag=' .. itag
									end
									if not adr:match('ratebypass=') then
										adr = adr .. '&ratebypass=yes'
									end
									tab[i] = {}
									tab[i].Adress = adr
									tab[i].itag = itag
									tab[i].fps = GetParamFromArray(array, 'fps')
									tab[i].qlty = height
									tab[i].width = width
									tab[i].adaptive = adaptive
									i = i + 1
								end
							 break
							end
						end
					end
				end
		end
		if tab0.streamingData and tab0.streamingData.dashManifestUrl then
			rc, answer = m_simpleTV.Http.Request(sessionGetVideo, {url = tab0.streamingData.dashManifestUrl})
			if rc == 200 then
				local dur = answer:match('mediaPresentationDuration="PT(%d+)')
				for width, height, fps, adr in answer:gmatch('width="(.-)".-height="(.-)".-frameRate="(.-)"><BaseURL>(.-)</BaseURL>') do
					if adr:match('/dur/') then
						tab[i] = {}
						tab[i].itag = adr:match('/itag/(%d+)/')
						tab[i].qlty = height
						tab[i].width = width
						tab[i].fps = fps
						tab[i].Adress = adr
						tab[i].adaptive = true
						i = i + 1
					elseif not sTime
						and not adr:match('/dur/')
						and m_simpleTV.Common.GetVlcVersion() > 3000
						and dur
						and tonumber(dur) < 300
					then
						tab[i] = {}
						tab[i].itag = adr:match('/itag/(%d+)/')
						tab[i].qlty = height or '8000'
						tab[i].width = width
						tab[i].fps = fps
						tab[i].Adress = tab0.streamingData.dashManifestUrl
									.. '$OPT:adaptive-use-access'
									.. '$OPT:adaptive-logic=highest'
									.. '$OPT:adaptive-maxheight=' .. height
						tab[i].adaptive = true
						tab[i].dashMpd = height
						i = i + 1
					end
				end
				for adr in answer:gmatch('AudioChannelConfiguration.-<BaseURL>(.-)</BaseURL>') do
					tab[i] = {}
					tab[i].itag = adr:match('/itag/(%d+)/')
					tab[i].Adress = adr
					i = i + 1
				end
			end
		end
			if #tab == 0 then
				local title_err = 'GetStreams Tab Error 2'
				local stream_tab_err
				if tab0.playabilityStatus then
					if tab0.playabilityStatus.status
						and tab0.playabilityStatus.status == 'LOGIN_REQUIRED'
					then
						if m_simpleTV.Interface.GetLanguage() == 'ru' then
							title_err = 'ТРЕБУЕТСЯ ВХОД: используйте "cookies" для авторизации'
						elseif m_simpleTV.Interface.GetLanguage() == 'pt' then
							title_err = 'LOGIN NECESSÁRIO: usar "cookies" para autorização'
						elseif m_simpleTV.Interface.GetLanguage() == 'vi' then
							title_err = 'YÊU CẦU ĐĂNG NHẬP: sử dụng "cookies" để ủy quyền'
						else
							title_err = 'LOGIN REQUIRED: use "cookies" for authorization'
						end
					elseif tab0.playabilityStatus.errorScreen
						and tab0.playabilityStatus.errorScreen.playerErrorMessageRenderer
						and tab0.playabilityStatus.errorScreen.playerErrorMessageRenderer.subreason
						and tab0.playabilityStatus.errorScreen.playerErrorMessageRenderer.subreason.simpleText
						then
							title_err = tab0.playabilityStatus.errorScreen.playerErrorMessageRenderer.subreason.simpleText
					elseif tab0.playabilityStatus.liveStreamability
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer.mainText
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer.mainText.runs[1]
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer.mainText.runs[1].text
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer.mainText.runs[2]
						and tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer.mainText.runs[2].text
						then
							title_err = tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer.mainText.runs[1].text .. tab0.playabilityStatus.liveStreamability.liveStreamabilityRenderer.offlineSlate.liveStreamOfflineSlateRenderer.mainText.runs[2].text
					elseif tab0.playabilityStatus.reason then
						title_err = tab0.playabilityStatus.reason
					else
						title_err = m_simpleTV.User.YT.Lng.videoNotAvail
					end
					title_err = title .. '\n⚠️ ' .. title_err:gsub('%..+', '')
					if m_simpleTV.User.YT.getinfo == false then
						GetInfo(m_simpleTV.User.YT.vId)
					end
					if m_simpleTV.User.YT.pic then
						stream_tab_err = {{Name = '', Adress = m_simpleTV.User.YT.pic .. '$OPT:NO-STIMESHIFT$OPT:image-duration=6'}}
						m_simpleTV.Http.Close(sessionGetVideo)
						m_simpleTV.Http.Close(session)
					end
				end
				isPanel = false
			 return stream_tab_err, title_err
			end
		local captions, captions_title
		if tab0.captions
			and tab0.captions.playerCaptionsTracklistRenderer
			and tab0.captions.playerCaptionsTracklistRenderer.captionTracks
		then
				local function Subtitle()
					local subt = {}
					local subtList = tostring(m_simpleTV.Config.GetValue('subtitle/lang', 'simpleTVConfig'))
					if subtList == 'nil'
								or subtList == 'none'
								or subtList == ''
					then
						subt[1] = m_simpleTV.User.YT.Lng.hl_sub
					else
						subtList = subtList:gsub('%s', ',')
						subtList = subtList:gsub('[^%d%a,%-_]', '')
						subtList = subtList:gsub('_', '-')
						subtList = subtList:gsub(',+', ',')
						subt = split_str(subtList, ',')
						if #subt == 0 then
							subt[1] = m_simpleTV.User.YT.Lng.hl_sub
						end
					end
					local r = 1
					local languageCode, kind, q, subtAdr
					while true do
							if not subt[r] or subtAdr then break end
						q = 1
						while true do
								if not tab0.captions.playerCaptionsTracklistRenderer.captionTracks[q] then break end
							languageCode = tab0.captions.playerCaptionsTracklistRenderer.captionTracks[q].languageCode
							kind = tab0.captions.playerCaptionsTracklistRenderer.captionTracks[q].kind
								if languageCode
									and (not kind or kind ~= 'asr')
									and languageCode == subt[r]
								then
									subtAdr = '#' .. tab0.captions.playerCaptionsTracklistRenderer.captionTracks[q].baseUrl .. '&fmt=vtt'
								 break
								end
							q = q + 1
						end
						r = r + 1
					end
						if subtAdr then
						 return subtAdr, ''
						end
						if not tab0.captions.playerCaptionsTracklistRenderer.translationLanguages
							or not tab0.captions.playerCaptionsTracklistRenderer.translationLanguages[1]
						then
						 return
						end
					r = 1
					local lngCodeTr
					while true do
							if not subt[r] or lngCodeTr then break end
						q = 1
						while true do
								if not tab0.captions.playerCaptionsTracklistRenderer.translationLanguages[q] then break end
							languageCode = tab0.captions.playerCaptionsTracklistRenderer.translationLanguages[q].languageCode
								if languageCode
									and languageCode == subt[r]
								then
									lngCodeTr = languageCode
								 break
								end
							q = q + 1
						end
						r = r + 1
					end
						if not lngCodeTr then return end
					r = 1
					while true do
							if not tab0.captions.playerCaptionsTracklistRenderer.captionTracks[r] then break end
						languageCode = tab0.captions.playerCaptionsTracklistRenderer.captionTracks[r].languageCode
						kind = tab0.captions.playerCaptionsTracklistRenderer.captionTracks[r].kind
							if languageCode
								and (not kind or kind ~= 'asr')
								and languageCode ~= 'na'
							then
								subtAdr = '#' .. tab0.captions.playerCaptionsTracklistRenderer.captionTracks[r].baseUrl .. '&tlang=' .. lngCodeTr .. '&fmt=vtt'
							 break
							end
						r = r + 1
					end
						if not subtAdr then return end
				 return subtAdr, ' (' .. m_simpleTV.User.YT.Lng.subTr .. ')'
				end
			captions, captions_title = Subtitle()
			if captions and m_simpleTV.Common.GetVlcVersion() < 3000 then
				captions = captions:gsub('://', '/subtitle://')
			end
		end
			for _, v in pairs(tab) do
				v.qlty = tonumber(v.qlty or '0')
				v.width = tonumber(v.width or '0')
				v.fps = tonumber(v.fps or '0')
				v.itag = tonumber(v.itag or '0')
				if (v.qlty > 340 and v.qlty < 500) and v.width > 640 then
					v.qlty = 480
				end
				if (v.qlty > 250 and v.qlty < 300) and v.width > 600 then
					v.qlty = 360
				end
				if (v.qlty > 760 and v.qlty < 1200) and v.width > 1600 then
					v.qlty = 1080
				end
				if v.qlty > 0 and v.qlty <= 180 then
					v.qlty = 144
				elseif v.qlty > 180 and v.qlty <= 300 then
					v.qlty = 240
				elseif v.qlty > 300 and v.qlty <= 400 then
					v.qlty = 360
				elseif v.qlty > 400 and v.qlty <= 500 then
					v.qlty = 480
				elseif v.qlty > 500 and v.qlty <= 780 then
					v.qlty = 720
				elseif v.qlty > 780 and v.qlty <= 1200 then
					v.qlty = 1080
				elseif v.qlty > 1200 and v.qlty <= 1500 then
					v.qlty = 1440
				elseif v.qlty > 1500 and v.qlty <= 2800 then
					v.qlty = 2160
				elseif v.qlty > 2800 and v.qlty <= 4500 then
					v.qlty = 4320
				end
				v.Name = v.qlty .. 'p'
				if v.fps > 30 then
					v.Name = v.Name .. ' ' .. v.fps .. ' FPS'
					if v.itag == 334
						or v.itag == 335
						or v.itag == 336
						or v.itag == 337
					then
						v.qlty = v.qlty + 7
						v.Name = v.Name .. ' HDR'
					else
						v.qlty = v.qlty + 6
					end
				end
			end
			local function GetAdr_isCipher(adr, itag, isCipher)
				if isCipher == true then
					local url = BuildParamArray(adr)
					url = GetAdr(url, isCipher)
						if not url then
						 return adr
						end
					if not url:match('itag=') then
						url = url .. '&itag=' .. itag
					end
					if not url:match('ratebypass=') then
						url = url .. '&ratebypass=yes'
					end
				 return url
				end
			 return adr
			end
		local audioAdr, audioAdr_isCipher
			for i = 1, #audio_itags do
				for z = 1, #tab do
					if audio_itags[i] == tab[z].itag then
						audioAdr = tab[z].Adress
						audioAdr_isCipher = tab[z].isCipher
					 break
					end
				end
				if audioAdr then
				 break
				end
			end
		if audioAdr_isCipher == true and audioAdr then
			local array = BuildParamArray(audioAdr)
			audioAdr = GetAdr(array, audioAdr_isCipher)
		end
		local sort_video_itags = {}
		local u = 1
			for i = 1, #video_itags do
				for z = 1, #tab do
					if video_itags[i] == tab[z].itag then
						sort_video_itags[u] = tab[z]
						u = u + 1
					 break
					end
				end
			end
		if #sort_video_itags == 0 then
			sort_video_itags = tab
		end
		tab, u = {}, 1
		local opt = '$OPT:sub-track=0$OPT:NO-STIMESHIFT$OPT:input-slave='
			for _, v in pairs(sort_video_itags) do
				if v.qlty > 300 then
					if v.adaptive == true and audioAdr then
						tab[u] = v
						if v.dashMpd then
							tab[u].Adress = v.Adress .. (opt_3xx or '') .. opt .. (captions or '')
						else
							if m_simpleTV.Common.GetVlcVersion() == 2150 then
								tab[u].Name = v.Name .. ' (dash)'
								tab[u].qlty = v.qlty + 2
								tab[u].Adress = GetAdr_isCipher(v.Adress, v.itag, v.isCipher) .. '$OPT:POSITIONTOCONTINUE=0' .. opt .. audioAdr .. (captions or '')
							else
								tab[u].Adress = GetAdr_isCipher(v.Adress, v.itag, v.isCipher) .. (sTime or '') .. (opt_3xx or '') .. opt .. audioAdr .. (captions or '')
							end
						end
						u = u + 1
					end
					if v.adaptive == false then
						tab[u] = v
						tab[u].Adress = GetAdr_isCipher(v.Adress, v.itag, v.isCipher) .. (sTime or '') .. (opt_3xx or '') .. (opt_2xx or '') .. opt .. (captions or '')
						u = u + 1
					end
				end
			end
		if #tab == 0 then
			for _, v in pairs(sort_video_itags) do
				if v.adaptive == true and audioAdr then
					tab[u] = v
					if v.dashMpd then
						tab[u].Adress = GetAdr_isCipher(v.Adress, v.itag) .. (opt_3xx or '') .. opt .. (captions or '')
					else
						if m_simpleTV.Common.GetVlcVersion() == 2150 then
							tab[u].Name = v.Name .. ' (dash)'
							tab[u].qlty = v.qlty + 2
							tab[u].Adress = GetAdr_isCipher(v.Adress, v.itag, v.isCipher) .. '$OPT:POSITIONTOCONTINUE=0' .. opt .. audioAdr .. (captions or '')
						else
							tab[u].Adress = GetAdr_isCipher(v.Adress, v.itag, v.isCipher) .. (sTime or '') .. (opt_3xx or '') .. opt .. audioAdr .. (captions or '')
						end
					end
					u = u + 1
				end
				if v.adaptive == false then
					tab[u] = v
					tab[u].Adress = GetAdr_isCipher(v.Adress, v.itag, v.isCipher) .. (sTime or '') .. (opt_3xx or '') .. (opt_2xx or '') .. opt .. (captions or '')
					u = u + 1
				end
			end
		end
			if #tab == 0 then
			 return nil, 'GetStreams Tab Error 3'
			end
		if not m_simpleTV.User.YT.cookies:match('^PREF')
			and m_simpleTV.User.YT.isLive == false
			and m_simpleTV.User.YT.isLiveContent == false
			and m_simpleTV.User.YT.isTrailer == false
			and tab0.playbackTracking
			and tab0.playbackTracking.videostatsPlaybackUrl
			and tab0.playbackTracking.videostatsPlaybackUrl.baseUrl
		then
				function callback_MarkWatch(sessionGetVideo)
					m_simpleTV.Http.Close(sessionGetVideo)
				end
			local cpn_alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_'
			local cpn_alphabet_len = #cpn_alphabet
			local t = {}
			local random_d
			local mathRandom = math.random
				for i = 1, 16 do
					random_d = mathRandom(1, cpn_alphabet_len)
					t[i] = {}
					t[i] = cpn_alphabet:sub(random_d, random_d)
				end
			t = table.concat(t)
			url = m_simpleTV.Common.fromPersentEncoding(tab0.playbackTracking.videostatsPlaybackUrl.baseUrl) .. '&ver=2&fs=0&volume=100&muted=0&cpn=' .. t
			m_simpleTV.Http.SetCookies(sessionGetVideo, url, m_simpleTV.User.YT.cookies, '')
			m_simpleTV.Http.RequestA(sessionGetVideo, {callback = 'callback_MarkWatch', url = url})
		else
			m_simpleTV.Http.Close(sessionGetVideo)
		end
		local audioAdrName, audioId
		if audioAdr then
			audioAdr = audioAdr .. (sTime or '') .. (opt_2xx or '') .. (opt_3xx or '') .. '$OPT:NO-STIMESHIFT'
			audioAdrName = '🔉 ' .. m_simpleTV.User.YT.Lng.audio
			audioId = 99
		else
			audioAdr = 'vlc://pause:5'
			audioAdrName = '🔇 ' .. m_simpleTV.User.YT.Lng.noAudio
			audioId = 10
		end
		tab[u] = {Name = audioAdrName, qlty = audioId, Adress = audioAdr}
		local hash, streams_tab = {}, {}
			for i = 1, #tab do
				if not hash[tab[i].Name] then
					u = #streams_tab + 1
					streams_tab[u] = tab[i]
					hash[tab[i].Name] = true
				end
			end
		table.sort(streams_tab, function(a, b) return a.qlty < b.qlty end)
			for i = 1, #streams_tab do
				streams_tab[i].Id = i
			end
		if m_simpleTV.User.YT.qlty < 100 then
			if audioId == 99 then
				title = title .. '\n☑ ' .. m_simpleTV.User.YT.Lng.audio
			else
				title = title .. '\n☐ ' .. m_simpleTV.User.YT.Lng.noAudio
			end
			local visual = tostring(m_simpleTV.Config.GetValue('vlc/audio/visual/module', 'simpleTVConfig'))
			if visual == 'nil'
				or visual == 'none'
				or visual == ''
			then
				if m_simpleTV.User.YT.getinfo == false then
					GetInfo(m_simpleTV.User.YT.vId)
				end
				SetBackground(m_simpleTV.User.YT.pic or m_simpleTV.User.YT.logoDisk)
			else
				SetBackground()
			end
		elseif captions_title then
			if tostring(m_simpleTV.Config.GetValue('subtitle/disableAtStart', 'simpleTVConfig')) == 'true' then
				title = title .. '\n☐ ' .. m_simpleTV.User.YT.Lng.sub .. captions_title
			else
				title = title .. '\n☑ ' .. m_simpleTV.User.YT.Lng.sub .. captions_title
			end
		end
		if isVideo and (answerJS:match('music%.youtube%.com') or answerJS:match('"category":"Music"')) then
			m_simpleTV.User.YT.isMusic = true
		end
		if m_simpleTV.User.YT.isTrailer == true then
			title = title .. '\n☑ ' .. m_simpleTV.User.YT.Lng.preview
		end
	 return streams_tab, title
	end
	local function AddInPl_Videos_YT(str, tab)
		local i = #tab + 1
		local ret = false
		str = str:gsub('\\"', '%%22')
			for adr, name, times in str:gmatch('gridVideoRenderer.-"videoId":"(.-)".-"simpleText":"(.-)".-"accessibilityData".-"simpleText":"(.-)"') do
				name = CleanTitle(name)
				tab[i] = {}
				tab[i].Id = i
				tab[i].Adress = 'https://www.youtube.com/watch?v=' .. adr .. '&isPlst=true'
				if isPanel == false then
					tab[i].Name = name .. ' (' .. times .. ')'
				else
					tab[i].Name = name
					tab[i].InfoPanelLogo = 'https://i.ytimg.com/vi/' .. adr .. '/default.jpg'
					tab[i].InfoPanelName = name
					tab[i].InfoPanelTitle = times
					tab[i].InfoPanelShowTime = 10000
				end
				i = i + 1
				ret = true
			end
	 return ret
	end
	local function AddInPl_Plst_YT(str, tab)
		local i = #tab + 1
		local ret = false
		str = str:gsub('\\"', '%%22')
			for name, desc, adr in str:gmatch('"title": "(.-)".-"description": "(.-)".-"videoId": "(.-)"') do
				if name ~= 'Deleted video' and name ~= 'Private video' then
					name = CleanTitle(name)
					tab[i] = {}
					tab[i].Id = i
					if adr == videoId and not selectPos then
						selectPos = i
					end
					tab[i].Adress = 'https://www.youtube.com/watch?v=' .. adr .. '&isPlst=true'
					tab[i].Name = name
					if isPanel == true then
						tab[i].InfoPanelLogo = 'https://i.ytimg.com/vi/' .. adr .. '/default.jpg'
						tab[i].InfoPanelName = name
						tab[i].InfoPanelDesc = CleanDesc(desc)
						if tab[i].InfoPanelDesc then
							tab[i].InfoPanelTitle = m_simpleTV.User.YT.Lng.desc
						end
						tab[i].InfoPanelShowTime = 10000
					end
					i = i + 1
					ret = true
				end
			end
	 return ret
	end
	function AsynPlsCallb_Videos_YT(session, rc, answer, userstring, params)
		answer = answer:gsub('\\"', '%%22')
		local ret = {}
			if rc ~= 200 then
				ret.Cancel = true
			 return ret
			end
		if params.User.First == true then
			params.User.First = false
			params.User.Title = answer:match('channelMetadataRenderer.-"title":"(.-)"') or '???'
			params.User.Title = CleanTitle(params.User.Title)
			m_simpleTV.Control.SetTitle(params.User.Title)
		end
			if not AddInPl_Videos_YT(answer, params.User.tab) then
				ret.Done = true
			 return ret
			end
		local nextContinuationData = answer:match('"nextContinuationData"(.-)$')
			if not nextContinuationData then
				ret.Done = true
			 return ret
			end
		local continuation, itct = nextContinuationData:match('"continuation":"(.-)".-"clickTrackingParams":"(.-)"')
			if not continuation or not itct then
				ret.Done = true
			 return ret
			end
		ret.request = {}
		ret.request.url = 'https://www.youtube.com/browse_ajax?ctoken=' .. continuation .. '&continuation=' .. continuation .. '&itct=' .. itct
		ret.request.headers = 'X-YouTube-Client-Name: 1\nX-YouTube-Client-Version: 2.20181220\nReferer: https://www.youtube.com/'
		ret.Count = #params.User.tab
		if params.User.plstTotalResults > params.User.Progress then
			ret.Progress = ret.Count / params.User.plstTotalResults
		end
	 return ret
	end
	function AsynPlsCallb_Plst_YT(session, rc, answer, userstring, params)
		local ret = {}
			if rc ~= 200 then
				params.User.rc = rc
				ret.Cancel = true
			 return ret
			end
			if not AddInPl_Plst_YT(answer, params.User.tab) then
				ret.Done = true
			 return ret
			end
		local nextPageToken = answer:match('"nextPageToken": "(.-)"')
			if not nextPageToken then
				ret.Done = true
			 return ret
			end
		ret.request = {}
		ret.request.url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&fields=nextPageToken,items(snippet/title,snippet/resourceId/videoId,snippet/description)&playlistId=' .. plstId .. '&key=' .. m_simpleTV.User.YT.apiKey .. '&pageToken=' .. nextPageToken .. '&hl=' .. m_simpleTV.User.YT.Lng.hl
		ret.request.headers = m_simpleTV.User.YT.apiKeyHeader
		ret.Count = #params.User.tab
		if params.User.plstTotalResults > params.User.Progress then
			ret.Progress = ret.Count / params.User.plstTotalResults
		end
	 return ret
	end
	function SavePlst_YT()
		if m_simpleTV.User.YT.Plst and m_simpleTV.User.YT.plstHeader then
			require 'lfs'
			local t = m_simpleTV.User.YT.Plst
			local header = m_simpleTV.User.YT.plstHeader
			local adr, name
			local m3ustr = '#EXTM3U $ExtFilter="YouTube" $BorpasFileFormat="1"\n'
				for i = 1, #t do
					name = t[i].Name
					adr = t[i].Adress:gsub('&isPlst=true', '')
					m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. header .. '",' .. name .. '\n' .. adr .. '\n'
				end
			if m_simpleTV.User.YT.ChTitleForSave then
				header = header .. ' [' .. m_simpleTV.User.YT.Lng.channel
						.. ' - ' .. m_simpleTV.User.YT.ChTitleForSave .. '] '
			end
			header = m_simpleTV.Common.UTF8ToMultiByte(header)
			header = header:gsub('%c', '')
			header = header:gsub('[\\/"%*:<>%|%?]+', ' ')
			header = header:gsub('%s+', ' ')
			header = header:gsub('^%s*(.-)%s*$', '%1')
			local fileEnd = ' (YouTube ' .. os.date('%d.%m.%y') .. ').m3u8'
			local folder = m_simpleTV.Common.GetMainPath(2) .. m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.User.YT.Lng.savePlstFolder) .. '/'
			lfs.mkdir(folder)
			local folderYT = folder .. 'YouTube/'
			lfs.mkdir(folderYT)
			local filePath = folderYT .. header .. fileEnd
			local fhandle = io.open(filePath, 'w+')
			if fhandle then
				fhandle:write(m3ustr)
				fhandle:close()
				ShowInfo(
							m_simpleTV.User.YT.Lng.savePlst_1 .. '\n'
							.. m_simpleTV.Common.multiByteToUTF8(header) .. '\n'
							.. m_simpleTV.User.YT.Lng.savePlst_2 .. '\n'
							.. m_simpleTV.Common.multiByteToUTF8(folderYT)
						)
			else
				ShowInfo(m_simpleTV.User.YT.Lng.savePlst_3)
			end
		end
	end
	function Qlty_YT()
		m_simpleTV.Control.ExecuteAction(37)
		local t = m_simpleTV.User.YT.QltyTab
			if not t then return end
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '❕'}
		t.ExtParams = {FilterType = 2}
		if not m_simpleTV.User.YT.isVideo then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '💾'}
		else
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '🔎'}
		end
		local index = m_simpleTV.User.YT.QltyIndex
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ ' .. m_simpleTV.User.YT.Lng.qlty, index - 1, t, 5000, 1 + 4)
		if not id then
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
			if t[id].qltyLive then
				m_simpleTV.Config.SetValue('YT_qlty_live', t[id].qltyLive)
				m_simpleTV.User.YT.qlty_live = t[id].qltyLive
			else
				if t[id].qlty > 300 then
					m_simpleTV.Config.SetValue('YT_qlty', t[id].qlty)
					m_simpleTV.User.YT.qlty0 = t[id].qlty
				end
				if t[id].qlty < 100 then
					local visual = tostring(m_simpleTV.Config.GetValue('vlc/audio/visual/module', 'simpleTVConfig'))
					if visual == 'nil'
						or visual == 'none'
						or visual == ''
					then
						if m_simpleTV.User.YT.getinfo == false then
							GetInfo(m_simpleTV.User.YT.vId)
						end
						SetBackground(m_simpleTV.User.YT.pic or m_simpleTV.User.YT.logoDisk)
					else
						SetBackground()
					end
				end
				m_simpleTV.User.YT.qlty = t[id].qlty
			end
			if (t[id].qlty and t[id].qlty > 100) or t[id].qltyLive then
				SetBackground()
			end
			m_simpleTV.User.YT.QltyIndex = id
			m_simpleTV.Control.SetTitle(' ')
			ShowMessage(t[id].Name)
			local adr = DeCipherSign(t[id].Adress)
			adr = adr:gsub('%$OPT:start%-time=%d+', '')
			m_simpleTV.Control.SetNewAddress(adr, m_simpleTV.Control.GetPosition())
		end
		if ret == 2
			and not m_simpleTV.User.YT.isVideo
		then
			SavePlst_YT()
		elseif ret == 2 and m_simpleTV.User.YT.isVideo and id then
			m_simpleTV.Control.ExecuteAction(105)
			local info_text = '🔎 ' .. m_simpleTV.User.YT.Lng.search .. ' YouTube:\n'
							.. '- ' .. m_simpleTV.User.YT.Lng.video .. '\n'
							.. '-- ' .. m_simpleTV.User.YT.Lng.plst .. '\n'
							.. '--- ' .. m_simpleTV.User.YT.Lng.channel .. '\n'
							.. '-+ ' .. m_simpleTV.User.YT.Lng.live
			ShowInfo(info_text, ARGB(0x80, 0, 0, 0), 4)
		end
		if ret == 3
		then
			if m_simpleTV.User.YT.getinfo == false then
				GetInfo(m_simpleTV.User.YT.vId)
			end
			ShowInfo()
		end
	end
	function ChPlst_YT()
		local tab = m_simpleTV.User.YT.ChPlstTab
			if not tab then return end
		local num = m_simpleTV.User.YT.ChPlst.Num
		local index = 0
			for k, v in ipairs(tab) do
				if tonumber(num) == tonumber(v.Name:match('^(%d+)')) then
					index = k
				end
			end
		tab.ExtParams = {FilterType = 2}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('📋 ' .. m_simpleTV.User.YT.ChTitle, index - 1, tab, 30000, 1 + 4 + 2 + 128)
		if not id then
			m_simpleTV.Control.ExecuteAction(37)
		end
			if ret == 1 then
				m_simpleTV.User.YT.ChPlst.Refresh = true
				m_simpleTV.User.YT.ChPlst.Num = tab[id].Name:match('^(%d+)') or tab[1].Name
				m_simpleTV.User.YT.ChPlst.Header = tab[id].Name:match('^%d+%. (.+)') or tab[1].Name
				m_simpleTV.Control.SetNewAddress(tab[id].Adress)
			 return
			end
			if ret == 2 then
				PrevChPlst_YT()
			 return
			end
			if ret == 3 then
				NextChPlst_YT()
			 return
			end
	end
	function NextChPlst_YT()
		m_simpleTV.User.YT.ChPlst.Refresh = true
		local tab = table_reversa(m_simpleTV.User.YT.ChPlst.Urls)
		if #tab == 0 then
			tab[1] = m_simpleTV.User.YT.ChPlst.FirstUrl
		end
		m_simpleTV.Control.ChangeAddress = 'No'
		m_simpleTV.Control.CurrentAddress = tab[1] .. '&restart'
		dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
	end
	function PrevChPlst_YT()
		m_simpleTV.User.YT.ChPlst.Refresh = false
		local tab = m_simpleTV.User.YT.ChPlst.Urls
		if #tab > 1 then
			tab[#tab] = nil
			tab[#tab] = nil
		end
		if #tab == 0 then
			m_simpleTV.Control.CurrentAddress = m_simpleTV.User.YT.ChPlst.MainUrl
		else
			m_simpleTV.Control.CurrentAddress = tab[#tab]
		end
		m_simpleTV.User.YT.ChPlst.Urls = tab
		m_simpleTV.Control.ChangeAddress = 'No'
		dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
	end
		if inAdr:match('&restart&restart&restart') then
			StopOnErr(1000)
		 return
		end
		if inAdr:match('/watch_videos')
			or inAdr:match('/shared%?ci=')
		then
			inAdr = GetUrlWatchVideos(inAdr)
				if not inAdr then
					StopOnErr(0)
				 return
				end
			m_simpleTV.Http.Close(session)
			m_simpleTV.Control.PlayAddress(inAdr)
		 return
		end
	if inAdr:match('^%s*%-') then
		local t, types, header = Search(inAdr)
		m_simpleTV.Http.Close(session)
			if not t or #t == 0 then
				StopOnErr(5.1, m_simpleTV.User.YT.Lng.notFound)
			 return
			end
		local title, SortOrder
		if types == 'related' then
			local sessionRelated = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3809.87 Safari/537.36')
				if not sessionRelated then return end
			m_simpleTV.Http.SetTimeout(sessionRelated, 16000)
			if not m_simpleTV.User.YT.apiKey then
				GetApiKey()
			end
			local vId = inAdr:match('=(.-)$')
			local url = 'https://www.googleapis.com/youtube/v3/videos?id=' .. vId .. '&part=snippet&fields=items/snippet/localized/title' .. '&hl=' .. m_simpleTV.User.YT.Lng.hl .. '&key=' .. m_simpleTV.User.YT.apiKey
			local rc, answer = m_simpleTV.Http.Request(sessionRelated, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
			m_simpleTV.Http.Close(sessionRelated)
			answer = answer or ''
			answer = answer:gsub('\\"', '%%22')
			title = answer:match('"title": "(.-)"') or m_simpleTV.User.YT.Lng.video
			title = CleanTitle(title)
			title = m_simpleTV.User.YT.Lng.search .. ': ' .. header .. ' — ' .. title
		else
			title = inAdr:gsub('^[%-%+%s]+(.-)%s*$', '%1')
			title = m_simpleTV.Common.multiByteToUTF8(title)
			title = title .. ' - ' .. m_simpleTV.User.YT.Lng.search .. ' (' .. header .. ')'
		end
		local FilterType, AutoNumberFormat
		if #t > 1 then
			FilterType = 1
			AutoNumberFormat = '%1. %2'
		else
			FilterType = 2
			AutoNumberFormat = ''
		end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 ' .. title, 0, t, 30000, 1 + 4 + 8 + 2 + 128)
		m_simpleTV.Control.ExecuteAction(37)
			if not id or ret == 3 then
				m_simpleTV.Control.ExecuteAction(11)
			 return
			end
		t = t[id].Adress .. '&isLogo=false'
		m_simpleTV.Control.ChangeAddress = 'No'
		m_simpleTV.Control.CurrentAddress = t
		dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
	 return
	end
	if inAdr:match('isPlst=true') then
		isVideo = false
	end
	if inAdr:match('/user/.-/videos')
		or inAdr:match('/channel/.-/videos')
		or inAdr:match('/feeds/videos%.xml%?channel_id=')
		or inAdr:match('/c/.-/videos')
			then
				isChPlst = false
				isChVideos = true
				plstIndex = 1
	elseif inAdr:match('/user/.-$')
		or inAdr:match('/channel/.-$')
		or inAdr:match('/c/.-$')
		or inAdr:match('&numVideo=')
		or inAdr:match('youtube%.com/%w+/?$')
		or inAdr:match('/live$')
		or inAdr:match('/embed/live_stream%?')
			then
				isChPlst = true
				isChVideos = false
				plstIndex = 1
	elseif inAdr:match('youtube%.com/%w+/videos')
			then
				isChPlst = false
				isChVideos = true
				plstIndex = 1
	end
	if inAdr:match('list=') then
		plstId = inAdr:match('list=([^&]*)')
		if plstId ~= '' then
			isPlst = true
			plstIndex = 1
		end
	end
	if inAdr:match('isChPlst=true') then
		m_simpleTV.User.YT.isChPlst = true
	end
	if ((inAdr:match('list=RD') or inAdr:match('list=TL'))
			and not inAdr:match('/embed'))
		or ((inAdr:match('list=WL') or inAdr:match('list=OL'))
			and not inAdr:match('index='))
	then
		inAdr = inAdr .. '&index=1'
	end
	if inAdr:match('index=') then
		plstIndex = inAdr:match('index=(%d+)') or '1'
		plstIndex = tonumber(plstIndex)
	end
	if isChVideos then
		m_simpleTV.Control.ExecuteAction(37)
		if not m_simpleTV.User.YT.isChPlst then
			m_simpleTV.User.YT.ChTitleForSave = nil
		end
		m_simpleTV.User.YT.isVideo = false
		local url = inAdr:gsub('&restart', '')
		url = url:gsub('(.+)/feeds/videos%.xml%?channel_id=([%w_%-]+)', '%1' .. '/channel/' .. '%2' .. '/videos')
		local tab = {}
		local plstTotalResults = 0
		local Url0
		local user = url:match('user/([_%w%-%.]+)') or url:match('/c/([_%w%-%.]+)')
		local channel = url:match('channel/([_%w%-%.]+)')
		if not (user or channel) then
			user = url:match('youtu[%.combe]/([_%w%-%.]+)')
		end
		if user then
			Url0 = '&forUsername=' .. user
		end
		if channel then
			Url0 = '&id=' .. channel
		end
		if Url0 then
			if not m_simpleTV.User.YT.apiKey then
				GetApiKey()
			end
			if m_simpleTV.User.YT.apiKey then
					local function PlstTotalResults()
						local url = 'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&fields=items(contentDetails/relatedPlaylists)' .. Url0 .. '&key=' .. m_simpleTV.User.YT.apiKey
						local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
							if rc ~= 200 then return end
						plstId = answer:match('"uploads".-"(.-)"')
							if not plstId then return end
						url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&fields=pageInfo&playlistId=' .. plstId .. '&key=' .. m_simpleTV.User.YT.apiKey
						rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
							if rc ~= 200 then return end
					 return tonumber(answer:match('"totalResults": (%d+)'))
					end
				plstTotalResults = PlstTotalResults() or 0
			end
		end
		if not url:match('sort=') and not url:match('/c/') then
			if user then
				url = 'https://www.youtube.com/user/' .. user .. '/videos?shelf_id=0&view=0&sort=dd'
			end
			if channel then
				url = 'https://www.youtube.com/channel/' .. channel .. '/videos?view=0&sort=dd&shelf_id=0'
			end
		end
		local t0 = {}
		t0.url = url
		t0.method = 'get'
		local params = {}
		params.Message = '⇩ ' .. m_simpleTV.User.YT.Lng.loading
		params.Callback = AsynPlsCallb_Videos_YT
		params.ProgressColor = ARGB(0x80, 255, 0, 0)
		params.User = {}
		params.User.tab = {}
		params.User.plstTotalResults = plstTotalResults
		params.User.Progress = 50
		if params.User.plstTotalResults > params.User.Progress then
			params.ProgressEnabled = true
		end
		params.User.Title = ''
		params.User.First = true
		require 'asynPlsLoaderHelper'
		asynPlsLoaderHelper.Work(session, t0, params)
		local header = params.User.Title
		tab = params.User.tab
			if #tab == 0 then
				StopOnErr(1)
			 return
			end
		m_simpleTV.User.YT.Plst = tab
		m_simpleTV.User.YT.plstHeader = header
		ShowMessage(header)
		tab.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_YT()'}
		local pl = 0
		if #tab == 1 then
			pl = 32
		end
		local FilterType, AutoNumberFormat
		if #tab > 1 then
			FilterType = 1
			AutoNumberFormat = '%1. %2'
		else
			FilterType = 2
			AutoNumberFormat = ''
		end
		tab.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		tab.ExtButton1 = {ButtonEnable = true, ButtonName = '📋', ButtonScript = [[
					m_simpleTV.Control.ExecuteAction(37)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = 'https://www.youtube.com/channel/' .. m_simpleTV.User.YT.chId .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				]]}
		local vId = tab[1].Adress:match('v=(.-)&')
		m_simpleTV.User.YT.AddToBaseUrlinAdr = inAdr
		m_simpleTV.User.YT.AddToBaseVideoIdPlst = vId
		m_simpleTV.OSD.ShowSelect_UTF8(header, 0, tab, 10000, pl)
		m_simpleTV.Control.CurrentTitle_UTF8 = header
		local t, title = GetStreamsTab(vId)
			if not t then
				StopOnErr(2, title)
			 return
			end
			if type(t) == 'string' then
				m_simpleTV.Control.PlayAddress(t)
			 return
			end
		m_simpleTV.User.YT.QltyTab = t
		local index = GetQltyIndex(t)
		local retAdr = t[index].Adress
		m_simpleTV.User.YT.QltyIndex = index
		local fps = t[index].Name:match('%d+ FPS')
		if fps then
			title = title .. '\n☑ ' .. fps
		end
		ShowMessage(title)
		retAdr = DeCipherSign(retAdr)
		m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.YT.logoPlstDisk, m_simpleTV.Control.ChannelID)
		m_simpleTV.Control.CurrentAddress = retAdr
	 return
	end
	if isChPlst then
		local url = inAdr
		if url:match('/live$') or url:match('/embed/live_stream%?') then
			local rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then StopOnErr(3) return end
			local liveId = answer:match('"liveStreamabilityRenderer\\":{\\"videoId\\":\\"(.-)\\"') or answer:match('"watchEndpoint\\":{\\"videoId\\":\\"(.-)\\"')
				if liveId then
					m_simpleTV.Http.Close(session)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = 'https://www.youtube.com/watch?v=' .. liveId .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				 return
				end
			url = url:gsub('/live$', '')
			url = url:gsub('embed/live_stream%?channel=', 'channel/')
		end
		if not url:match('/playlists') then
			url = url:gsub('/$', '') .. '/playlists'
		end
		if not url:match('sort=') and not url:match('browse_ajax') then
			url = url:gsub('(^.-/playlists)', '%1') .. '?view=1&sort=lad&shelf_id=0&restart'
		end
		url = url:gsub('&restart', '') .. '&restart'
		if not m_simpleTV.User.YT.ChPlst.countErr then
			m_simpleTV.User.YT.ChPlst.countErr = 0
		end
		if not m_simpleTV.User.YT.ChPlst.MainUrl then
			m_simpleTV.User.YT.ChPlst.MainUrl = url
		end
		if #m_simpleTV.User.YT.ChPlst.Urls > 0 then
			if m_simpleTV.User.YT.ChPlst.MainUrl == url then
				m_simpleTV.User.YT.ChPlst.Urls = nil
				m_simpleTV.User.YT.ChPlst.FirstUrl = nil
				m_simpleTV.User.YT.ChPlst.Num = nil
			end
		end
		if m_simpleTV.User.YT.ChPlst.MainUrl ~= url then
			if not url:match('browse_ajax') then
				m_simpleTV.User.YT.ChPlst.MainUrl = url
				m_simpleTV.User.YT.ChPlst.Urls = nil
				m_simpleTV.User.YT.ChPlst.FirstUrl = nil
				m_simpleTV.User.YT.ChPlst.Num = nil
			end
		end
		if not m_simpleTV.User.YT.ChPlst.Urls then
			m_simpleTV.User.YT.ChPlst.Urls = {}
		end
		local num = 0
		if url:match('browse_ajax') then
			url, num = url:match('^(.-)&numVideo=(%d+)')
				if not url or not num then
					StopOnErr(3.1)
				 return
				end
		end
		m_simpleTV.Http.SetCookies(session, url, 'PREF=hl=' .. m_simpleTV.User.YT.Lng.hl .. ';', '')
		local rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('&restart', ''), headers = 'X-YouTube-Client-Name: 1\nX-YouTube-Client-Version: 2.20190620\nReferer: https://www.youtube.com/'})
			if rc ~= 200 then
				StopOnErr(4, 'cant load channal page')
			 return
			end
		answer = answer:gsub('\\"', '%%22')
		answer = answer:gsub('\\/', '/')
		local chTitle = answer:match('channelMetadataRenderer.-"title":"(.-)"') or 'playlists'
		if chTitle == 'playlists' and not url:match('browse_ajax') then
			m_simpleTV.Http.SetCookies(session, url, 'PREF=hl=' .. m_simpleTV.User.YT.Lng.hl .. ';', '')
			rc, answer = m_simpleTV.Http.Request(session, {url = url:gsub('&restart', ''), headers = 'X-YouTube-Client-Name: 1\nX-YouTube-Client-Version: 2.20190620\nReferer: https://www.youtube.com/'})
				if rc ~= 200 then
					StopOnErr(4.11, 'cant load channal page')
				 return
				end
			answer = answer:gsub('\\"', '%%22')
			answer = answer:gsub('\\/', '/')
			chTitle = answer:match('channelMetadataRenderer.-"title":"(.-)"') or 'playlists'
		end
		chTitle = CleanTitle(chTitle)
		m_simpleTV.User.YT.ChTitle = chTitle
		local channel_banner = answer:match('"mobileBanner":{"thumbnails":%[{"url":"(.-)%-fcrop') or m_simpleTV.User.YT.logoDisk
		channel_banner = channel_banner:gsub('^//', 'https://')
		if not url:match('browse_ajax') and not inAdr:match('&restart') then
			SetBackground(channel_banner)
			m_simpleTV.Control.SetTitle(chTitle)
		end
		local buttonNext = false
		local nextContinuationData = answer:match('"nextContinuationData"(.-)$')
		if nextContinuationData then
			buttonNext = true
			local continuation, itct = nextContinuationData:match('"continuation":"(.-)".-"clickTrackingParams":"(.-)"')
			if continuation and itct then
				url = 'https://www.youtube.com/browse_ajax?ctoken=' .. continuation .. '&continuation=' .. continuation .. '&itct=' .. itct
			end
		end
		answer = answer:gsub('"title":{"simpleText"', '"text"')
		answer = answer:gsub('{', '')
		answer = answer:gsub('}', '')
		local chId = answer:match('/channel/([%w_%-%.]+)') or ''
		local tab, i = {}, 1
		local j = 1 + tonumber(num)
		local shelf = inAdr:match('shelf_id=(%d+)') or '0'
		if j == 1 and chId and shelf == '0' then
			if not m_simpleTV.User.YT.apiKey then
				GetApiKey()
			end
			if m_simpleTV.User.YT.apiKey then
					local function PlstTotalResults()
						local plstId
						local plstTotalResults
						local url = 'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&fields=items(contentDetails/relatedPlaylists)&id=' .. chId .. '&key=' .. m_simpleTV.User.YT.apiKey
						local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
							if rc ~= 200 then return end
						plstId = answer:match('"uploads".-"(.-)"')
							if not plstId then return end
						url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&fields=pageInfo&playlistId=' .. plstId .. '&key=' .. m_simpleTV.User.YT.apiKey
						rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
							if rc ~= 200 then return end
						plstTotalResults = tonumber(answer:match('"totalResults": (%d+)') or '0')
							if plstTotalResults > 0 then
								local t
								if isPanel == false then
									t =
										{
											Id = 1,
											Name = '🔺 '
												.. m_simpleTV.User.YT.Lng.upLoadOnCh
												.. ' (' .. plstTotalResults .. ')',
											count = plstTotalResults,
											Adress = 'https://www.youtube.com/playlist?list=' .. plstId .. '&isChPlst=true',
										}
								else
									t =
										{
											Id = 1,
											Name = '🔺 '
												.. m_simpleTV.User.YT.Lng.upLoadOnCh
												.. ' (' .. plstTotalResults .. ')',
											count = plstTotalResults,
											Adress = 'https://www.youtube.com/playlist?list=' .. plstId .. '&isChPlst=true',
											InfoPanelLogo = channel_banner,
											InfoPanelShowTime = 10000,
											InfoPanelName = m_simpleTV.User.YT.Lng.channel .. ': ' .. chTitle,
											InfoPanelTitle = m_simpleTV.User.YT.Lng.upLoadOnCh .. ' ('
														.. plstTotalResults .. ' '
														.. m_simpleTV.User.YT.Lng.video .. ')'
										}
								end
							 return t
							end
					 return
					end
				local plstTotalResults = PlstTotalResults()
				if plstTotalResults then
					tab[1] = plstTotalResults
					i = 2
				end
			end
		end
			for adr, logo, name, count in answer:gmatch('PlaylistRenderer":"playlistId":"(.-)".-"thumbnails":%["url":"(.-)".-"text":"(.-)".-"videoCountShortText":"simpleText":"(.-)"') do
				tab[i] = {}
				tab[i].Id = i
				tab[i].count = count or '0'
				name = CleanTitle(name)
				tab[i].Name = j .. '. ' .. name .. ' (' .. count .. ')'
				if isPanel == true then
					tab[i].InfoPanelTitle = m_simpleTV.User.YT.Lng.plst .. ': ' .. name .. ' (' .. count .. ' ' .. m_simpleTV.User.YT.Lng.video .. ')'
					logo = logo:gsub('hqdefault', 'default')
					logo = logo:gsub('^//', 'https://')
					logo = logo:gsub('/vi_webp/', '/vi/')
					logo = logo:gsub('movieposter%.webp', 'default.jpg')
					tab[i].InfoPanelLogo = logo
					tab[i].InfoPanelShowTime = 10000
					tab[i].InfoPanelName = m_simpleTV.User.YT.Lng.channel .. ': ' .. chTitle
				end
				tab[i].Adress = 'https://www.youtube.com/playlist?list=' .. adr .. '&isChPlst=true'
				j = j + 1
				i = i + 1
			end
				if i == 1 then
					m_simpleTV.Http.Close(session)
					m_simpleTV.User.YT.ChPlst.countErr = m_simpleTV.User.YT.ChPlst.countErr + 1
						if m_simpleTV.User.YT.ChPlst.countErr == 3 then
							m_simpleTV.User.YT.ChPlst.countErr = nil
							StopOnErr(4.1, 'cant parce channal page')
						 return
						end
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = 'https://www.youtube.com/channel/' .. chId .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				 return
				end
		m_simpleTV.User.YT.ChPlstTab = tab
		m_simpleTV.User.YT.isChPlst = true
		local buttonPrev = false
		if #m_simpleTV.User.YT.ChPlst.Urls >= 1 then
			buttonPrev = true
		end
		tab.ExtButton0 = {ButtonEnable = buttonPrev, ButtonName = '🢀'}
		tab.ExtButton1 = {ButtonEnable = buttonNext, ButtonName = '🢂'}
		num = #tab + tonumber(num)
		local nom1ChPlstTab = tonumber(tab[1].Name:match('^(%d+)') or '1')
		if nom1ChPlstTab == 1 then
			m_simpleTV.User.YT.Nom1ChPlstTab = 1
			m_simpleTV.User.YT.pageChPlst = 1
		end
		if nom1ChPlstTab > m_simpleTV.User.YT.Nom1ChPlstTab then
			m_simpleTV.User.YT.pageChPlst = m_simpleTV.User.YT.pageChPlst + 1
		end
		if nom1ChPlstTab < m_simpleTV.User.YT.Nom1ChPlstTab then
			m_simpleTV.User.YT.pageChPlst = m_simpleTV.User.YT.pageChPlst - 1
		end
		m_simpleTV.User.YT.Nom1ChPlstTab = nom1ChPlstTab
		if m_simpleTV.User.YT.pageChPlst > 1 then
			m_simpleTV.User.YT.ChTitle = m_simpleTV.User.YT.ChTitle .. ' (' .. m_simpleTV.User.YT.Lng.page .. ' ' .. m_simpleTV.User.YT.pageChPlst .. ')'
		end
		url = url .. '&numVideo=' .. num
		table.insert(m_simpleTV.User.YT.ChPlst.Urls, url)
		if not m_simpleTV.User.YT.ChPlst.FirstUrl then
			m_simpleTV.User.YT.ChPlst.FirstUrl = url
		end
		if not m_simpleTV.User.YT.ChPlst.Num then
			m_simpleTV.User.YT.ChPlst.Num = 0
		end
		local index = 0
		if m_simpleTV.User.YT.ChPlst.Refresh then
			index = 0
		end
		num = m_simpleTV.User.YT.ChPlst.Num
			for k, v in ipairs(tab) do
				if tonumber(num) == tonumber(v.Name:match('^(%d+)')) then
					index = k
				end
			end
		tab.ExtParams = {FilterType = 2}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('📋 ' .. m_simpleTV.User.YT.ChTitle, index - 1, tab, 30000, 1 + 4 + 8 + 2 + 128)
		m_simpleTV.Control.CurrentTitle_UTF8 = chTitle
			if not id then
				m_simpleTV.Control.ExecuteAction(37)
				m_simpleTV.Http.Close(session)
			 return
			end
		if ret == 1 then
			plstId = tab[id].Adress:gsub('^.-list=(.+)', '%1')
			m_simpleTV.User.YT.ChPlst.Num = tab[id].Name:match('^(%d+)') or tab[1].Name
			m_simpleTV.User.YT.ChPlst.Header = tab[id].Name:match('^%d+%. (.+)') or tab[1].Name
			m_simpleTV.User.YT.ChPlst.Refresh = false
			isPlst = true
			m_simpleTV.User.YT.ChTitleForSave = chTitle
			local con = tonumber(tab[id].count)
			if con and con < 300 then
				SetBackground()
			end
		end
			if ret == 2 then
				PrevChPlst_YT()
			 return
			end
			if ret == 3 then
				NextChPlst_YT()
			 return
			end
	end
	if isPlst then
		m_simpleTV.User.YT.isVideo = false
		if not m_simpleTV.User.YT.isChPlst then
			m_simpleTV.User.YT.ChTitleForSave = nil
		end
		if inAdr:match('index=') then
			m_simpleTV.Http.SetCookies(session, inAdr, m_simpleTV.User.YT.cookies, '')
			local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('&restart', '')})
				if rc ~= 200 then
					StopOnErr(5)
				 return
				end
			answer = answer:gsub('\\"', '%%22')
			local tab, i = {}, 1
			local name, selected, timer, adr
				for gg in answer:gmatch('{"playlistPanelVideoRenderer":{"title".-%]}}') do
					name = gg:match('"title".-"simpleText":"(.-)"')
					selected = gg:match('"selected":(%a+)')
					timer = gg:match('"label".-"simpleText":"(%d+:.-)"') or ''
					adr = gg:match('"videoId":"(.-)"')
					if name and adr then
						tab[i] = {}
						tab[i].Id = i
						name = CleanTitle(name)
						if isPanel == false then
							if timer ~= '' then
								timer = ' (' .. timer .. ')'
							end
							tab[i].Name = name .. timer
						else
							if timer ~= '' then
								tab[i].InfoPanelTitle = timer
							end
							tab[i].Name = name
							tab[i].InfoPanelName = name
							tab[i].InfoPanelLogo = 'https://i.ytimg.com/vi/' .. adr .. '/default.jpg'
							tab[i].InfoPanelShowTime = 10000
						end
						tab[i].Adress = 'https://www.youtube.com/watch?v=' .. adr .. '&isPlst=true'
						if selected and selected == 'true' then
							selectPos = i
						end
						i = i + 1
					end
				end
				if i == 1 then
					for gg in answer:gmatch('{"playlistVideoRenderer":{"videoId".-%]}}') do
						name = gg:match('"title".-"simpleText":"(.-)"')
						timer = gg:match('"lengthText".-"simpleText":"(%d+:.-)"') or ''
						adr = gg:match('"videoId":"(.-)"')
						if name and adr then
							name = CleanTitle(name)
							tab[i] = {}
							tab[i].Id = i
							if isPanel == false then
								if timer ~= '' then
									timer = ' (' .. timer .. ')'
								end
								tab[i].Name = name .. timer
							else
								if timer ~= '' then
									tab[i].InfoPanelTitle = timer
								end
								tab[i].Name = name
								tab[i].InfoPanelName = name
								tab[i].InfoPanelLogo = 'https://i.ytimg.com/vi/' .. adr .. '/default.jpg'
								tab[i].InfoPanelShowTime = 10000
							end
							tab[i].Adress = 'https://www.youtube.com/watch?v=' .. adr .. '&isPlst=true'
							i = i + 1
						end
					end
				end
				if i == 1 and not inAdr:match('&restart') then
					m_simpleTV.Http.Close(session)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = inAdr .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				 return
				end
				if i == 1 then
					m_simpleTV.Http.Close(session)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = inAdr:gsub('[%?&]list=[%a%d_%-]+', '') .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				 return
				end
			local header = answer:match('"playlist":{"title":"(.-)"')
						or answer:match('"microformat".-"title":"(.-)"')
						or 'title - not found'
			header = CleanTitle(header)
			ShowMessage(header)
			m_simpleTV.User.YT.Plst = tab
			m_simpleTV.User.YT.plstHeader = header
			local pl = 0
			if selectPos and selectPos ~= plstIndex and selectPos ~= 1 then
				pl = 32
			end
			plstIndex = selectPos or 1
			if inAdr:match('isLogo=false') and #tab > 1 then
				plstIndex = 2
			end
			if plstIndex > 1 or inAdr:match('[%?&]t=') or #tab == 1 or inAdr:match('list=RD') then
				pl = 32
			end
			local vId = tab[plstIndex].Adress:match('watch%?v=(.-)&')
			m_simpleTV.User.YT.AddToBaseUrlinAdr = inAdr
			m_simpleTV.User.YT.AddToBaseVideoIdPlst = tab[1].Adress:match('watch%?v=(.-)&')
			tab.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_YT()'}
			tab.ExtButton1 = {ButtonEnable = true, ButtonName = '📋', ButtonScript = [[
					m_simpleTV.Control.ExecuteAction(37)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = 'https://www.youtube.com/channel/' .. m_simpleTV.User.YT.chId .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				]]}
			local FilterType, AutoNumberFormat
			if #tab > 1 then
				FilterType = 1
				AutoNumberFormat = '%1. %2'
			else
				FilterType = 2
				AutoNumberFormat = ''
			end
			tab.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
			m_simpleTV.OSD.ShowSelect_UTF8(header, plstIndex - 1, tab, 10000, pl)
			local t, title = GetStreamsTab(vId)
				if not t then
					StopOnErr(6, title)
				 return
				end
				if type(t) == 'string' then
					m_simpleTV.Control.PlayAddress(t)
				 return
				end
			m_simpleTV.User.YT.QltyTab = t
			local index = GetQltyIndex(t)
			local retAdr = t[index].Adress
			m_simpleTV.User.YT.QltyIndex = index
			local fps = t[index].Name:match('%d+ FPS')
			if fps then
				title = title .. '\n☑ ' .. fps
			end
			ShowMessage('◽️ ' .. header .. '\n' .. title .. '\n☑ ' .. m_simpleTV.User.YT.Lng.plst)
			m_simpleTV.Control.CurrentTitle_UTF8 = header
			retAdr = DeCipherSign(retAdr)
			m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.YT.logoPlstDisk, m_simpleTV.Control.ChannelID)
			m_simpleTV.Control.CurrentAddress = retAdr
		 return
		end
		if not inAdr:match('index=') then
			m_simpleTV.Control.ExecuteAction(37)
			if not m_simpleTV.User.YT.apiKey then
				GetApiKey()
			end
				if not m_simpleTV.User.YT.apiKey then return end
			local url = 'https://www.googleapis.com/youtube/v3/playlists?part=snippet&fields=items/snippet/localized/title&id=' .. plstId .. '&hl=' .. m_simpleTV.User.YT.Lng.hl .. '&key=' .. m_simpleTV.User.YT.apiKey
			local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
			if rc ~= 200 then
				answer = ''
			end
			answer = answer:gsub('\\"', '%%22')
			local header = answer:match('"title": "(.-)"') or m_simpleTV.User.YT.Lng.plst
			header = CleanTitle(header)
			m_simpleTV.User.YT.plstHeader = header
			local tab, i = {}, 1
			url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&fields=pageInfo&playlistId=' .. plstId .. '&hl=' .. m_simpleTV.User.YT.Lng.hl .. '&key=' .. m_simpleTV.User.YT.apiKey
			rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = m_simpleTV.User.YT.apiKeyHeader})
			if rc ~= 200 then
				answer = ''
			end
			local plstTotalResults = tonumber(answer:match('"totalResults": (%d+)') or '1')
			local t0 = {}
			t0.url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&fields=nextPageToken,items(snippet/title,snippet/resourceId/videoId,snippet/description)&playlistId=' .. plstId .. '&hl=' .. m_simpleTV.User.YT.Lng.hl .. '&key=' .. m_simpleTV.User.YT.apiKey
			t0.method = 'get'
			t0.headers = m_simpleTV.User.YT.apiKeyHeader
			local params = {}
			params.Message = '⇩ ' .. m_simpleTV.User.YT.Lng.loading
			params.Callback = AsynPlsCallb_Plst_YT
			params.ProgressColor = ARGB(0x80, 255, 0, 0)
			params.User = {}
			params.User.tab = {}
			params.User.rc = nil
			params.User.Progress = 199
			params.User.plstTotalResults = plstTotalResults
			if params.User.plstTotalResults > params.User.Progress then
				params.ProgressEnabled = true
			end
			require 'asynPlsLoaderHelper'
			asynPlsLoaderHelper.Work(session, t0, params)
			tab = params.User.tab
			rc = params.User.rc
				if rc == 400 or rc == - 1 then
					StopOnErr(8)
				 return
				end
				if #tab == 0 and rc then
					if rc == 404 and not inAdr:match('&restart') then
						inAdr = inAdr .. '&index=1'
					elseif (rc == 404 or rc == 403) and inAdr:match('&restart') then
						inAdr = inAdr:gsub('[%?&]list=[%w_%-]+', '')
					end
					m_simpleTV.Http.Close(session)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = inAdr .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				 return
				end
				if #tab == 0 and not rc then
					StopOnErr(9, m_simpleTV.User.YT.Lng.videoNotAvail)
					if m_simpleTV.User.YT.isChPlst == true then
						m_simpleTV.Common.Sleep(2000)
						m_simpleTV.Control.ChangeAddress = 'No'
						m_simpleTV.Control.CurrentAddress = m_simpleTV.User.YT.ChPlst.MainUrl .. '&restart'
						dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
					end
				 return
				end
				if not selectPos and videoId and inAdr:match('[%?&]t=') then
					inAdr = inAdr:gsub('[%?&]list=[%w_%-]+', '')
					m_simpleTV.Http.Close(session)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = inAdr .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				 return
				end
			m_simpleTV.User.YT.Plst = tab
			local pl = 0
			if selectPos and selectPos ~= plstIndex and selectPos ~= 1 then
				pl = 32
			end
			plstIndex = selectPos or 1
			if plstIndex > 1 or inAdr:match('[%?&]t=') or #tab == 1 then
				pl = 32
			end
			local vId = tab[plstIndex].Adress:match('watch%?v=(.-)&') or ''
			tab.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_YT()'}
			if m_simpleTV.User.YT.isChPlst then
				tab.ExtButton1 = {ButtonEnable = true, ButtonName = '📋', ButtonScript = 'ChPlst_YT()'}
			else
				tab.ExtButton1 = {ButtonEnable = true, ButtonName = '📋', ButtonScript = [[
					m_simpleTV.Control.ExecuteAction(37)
					m_simpleTV.Control.ChangeAddress = 'No'
					m_simpleTV.Control.CurrentAddress = 'https://www.youtube.com/channel/' .. m_simpleTV.User.YT.chId .. '&restart'
					dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
				]]}
			end
			local FilterType, AutoNumberFormat
			if #tab > 1 then
				FilterType = 1
				AutoNumberFormat = '%1. %2'
			else
				FilterType = 2
				AutoNumberFormat = ''
			end
			tab.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
			m_simpleTV.OSD.ShowSelect_UTF8(header, plstIndex - 1, tab, 10000, pl)
			local t, title = GetStreamsTab(vId)
				if not t then
					StopOnErr(10, title)
				 return
				end
				if type(t) == 'string' then
					m_simpleTV.Control.PlayAddress(t)
				 return
				end
			m_simpleTV.User.YT.QltyTab = t
			local index = GetQltyIndex(t)
			local retAdr = t[index].Adress
			m_simpleTV.User.YT.QltyIndex = index
			local fps = t[index].Name:match('%d+ FPS')
			if fps then
				title = title .. '\n☑ ' .. fps
			end
			ShowMessage('◽️ ' .. header .. '\n' .. title .. '\n☑ ' .. m_simpleTV.User.YT.Lng.plst)
			if not m_simpleTV.User.YT.isChPlst then
				m_simpleTV.Control.CurrentTitle_UTF8 = header
			else
				m_simpleTV.Control.CurrentTitle_UTF8 = ''
			end
			retAdr = DeCipherSign(retAdr)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.YT.logoPlstDisk, m_simpleTV.Control.ChannelID)
			m_simpleTV.User.YT.AddToBaseVideoIdPlst = tab[1].Adress:match('watch%?v=(.-)&')
			m_simpleTV.User.YT.AddToBaseUrlinAdr = 'https://www.youtube.com/playlist?list=' .. plstId
			if m_simpleTV.User.YT.isChPlst then
				m_simpleTV.Control.SetNewAddress(m_simpleTV.Control.CurrentAddress)
			end
		 return
		end
	end
	if not isPlst then
		local t, title = GetStreamsTab(videoId)
			if not t then
				StopOnErr(12, title)
			 return
			end
			if type(t) == 'string' then
				m_simpleTV.Control.PlayAddress(t)
			 return
			end
		m_simpleTV.User.YT.QltyTab = t
		local index = GetQltyIndex(t)
		local retAdr = t[index].Adress
		m_simpleTV.User.YT.QltyIndex = index
		if isVideo then
			m_simpleTV.Control.ChangeChannelLogo('https://i.ytimg.com/vi/' .. videoId .. '/default.jpg', m_simpleTV.Control.ChannelID)
			local name = title:gsub('%c.-$', '')
			m_simpleTV.Control.SetTitle(name)
			m_simpleTV.Control.CurrentTitle_UTF8 = name
			m_simpleTV.User.YT.isVideo = true
			local header, name_header, ap_header
			local publishedAt = ''
			if m_simpleTV.User.YT.author
				and m_simpleTV.User.YT.isTrailer == false
			then
				name_header = m_simpleTV.User.YT.Lng.upLoadOnCh
						.. ': '
						.. m_simpleTV.User.YT.author
			elseif m_simpleTV.User.YT.isTrailer == true then
				name_header = m_simpleTV.User.YT.Lng.preview
			else
				name_header = ''
			end
			if m_simpleTV.User.YT.isLive == true then
				if isPanel == false then
					ap_header = ' (' .. m_simpleTV.User.YT.Lng.live .. ')'
				else
					GetInfo(videoId)
					if m_simpleTV.User.YT.actualStartTime then
						local timeSt = timeStamp(m_simpleTV.User.YT.actualStartTime)
						timeSt = os.date('%y %d %m %H %M', tonumber(timeSt))
						local year, day, month, hour, min = timeSt:match('(%d+) (%d+) (%d+) (%d+) (%d+)')
						publishedAt = ' | ' .. m_simpleTV.User.YT.Lng.started .. ': '
								.. string.format('%d:%02d (%d/%d/%02d)', hour, min, day, month, year)
					end
				end
			else
				if isPanel == false then
					if m_simpleTV.User.YT.duration ~= '' then
						ap_header = ' (' .. m_simpleTV.User.YT.duration .. ')'
					end
				end
			end
			local t1 = {}
			t1[1] = {}
			t1[1].Id = 1
			t1[1].Adress = retAdr
			t1[1].Name = name
			if isPanel == false then
				header = name_header .. (ap_header or '')
			else
				if m_simpleTV.User.YT.isTrailer == true then
					ap_header = m_simpleTV.User.YT.Lng.preview
				elseif m_simpleTV.User.YT.isLive == true then
					ap_header = m_simpleTV.User.YT.Lng.live
				else
					ap_header = m_simpleTV.User.YT.Lng.video
				end
				if m_simpleTV.User.YT.isLive == false then
					if m_simpleTV.User.YT.duration ~= '' then
						publishedAt = ' | ' .. m_simpleTV.User.YT.duration
					end
				end
				header = 'YouTube - ' .. ap_header
				t1[1].InfoPanelLogo = 'https://i.ytimg.com/vi/' .. videoId .. '/default.jpg'
				t1[1].InfoPanelName = name
				t1[1].InfoPanelShowTime = 8000
				t1[1].InfoPanelDesc = m_simpleTV.User.YT.desc
				if t1[1].InfoPanelDesc then
					t1[1].InfoPanelTitle = m_simpleTV.User.YT.Lng.desc .. ' | ' .. m_simpleTV.User.YT.Lng.channel .. ': ' .. m_simpleTV.User.YT.author .. publishedAt
				else
					t1[1].InfoPanelTitle = m_simpleTV.User.YT.Lng.channel .. ': ' .. m_simpleTV.User.YT.author .. publishedAt
				end
			end
			if m_simpleTV.User.YT.isLiveContent == false
				and m_simpleTV.User.YT.isTrailer == false
			then
				t1[2] = {}
				t1[2].Id = 2
				if m_simpleTV.User.YT.isMusic == true then
					t1[2].Name = '🎵 music mix ' .. m_simpleTV.User.YT.Lng.plst
					t1[2].Adress = 'https://www.youtube.com/watch?v=' .. m_simpleTV.User.YT.vId .. '&list=RD' .. m_simpleTV.User.YT.vId .. '&isLogo=false'
					m_simpleTV.User.YT.ChTitleForSave = nil
					t1[2].InfoPanelLogo = m_simpleTV.User.YT.logoPlstDisk
				else
					t1[2].Name = '🔎 ' .. m_simpleTV.User.YT.Lng.search .. ': ' .. m_simpleTV.User.YT.Lng.relatedVideos
					t1[2].Adress = '-related=' .. m_simpleTV.User.YT.vId .. '&isLogo=false&isRelated=true'
				end
			end
			t1.ExtParams = {FilterType = 2}
			t1.ExtButton0 = {ButtonEnable = true, ButtonName = '⚙', ButtonScript = 'Qlty_YT()'}
			t1.ExtButton1 = {ButtonEnable = true, ButtonName = '📋', ButtonScript = [[
						m_simpleTV.Control.ExecuteAction(37)
						m_simpleTV.Control.ChangeAddress = 'No'
						m_simpleTV.Control.CurrentAddress = 'https://www.youtube.com/channel/' .. m_simpleTV.User.YT.chId .. '&restart'
						dofile(m_simpleTV.MainScriptDir .. 'user\\video\\!youtube.lua')
					]]}
			m_simpleTV.OSD.ShowSelect_UTF8(header, 0, t1, 8000, 32 + 64 + 128)
		else
			m_simpleTV.Control.CurrentTitle_UTF8 = ''
		end
		local fps = t[index].Name:match('%d+ FPS')
		if fps then
			title = title .. '\n☑ ' .. fps
		end
		ShowMessage(title)
		retAdr = DeCipherSign(retAdr)
		m_simpleTV.Control.CurrentAddress = retAdr
		if debug then
			local scr_time = string.format('%.3f', (os.clock() - debug))
			local calc = scr_time - debug_0
			YT_Log('title: ' .. title, 0)
			debug_in_file(
							title .. '\n\n'
							.. 'https://www.youtube.com/watch?v=' .. videoId .. '\n\n'
							.. 'time ' .. scr_time .. ' s.'
							.. ' | request ' .. debug_0 .. ' s.'
							.. ' | calc ' .. calc .. ' s.\n'
							.. '-----------------------------------------------------------------------\n\n'
							.. m_simpleTV.Common.fromPersentEncoding(retAdr):gsub('%$', '\n\n$'):gsub('slave=', 'slave=\n\n'):gsub('%#', '\n\n#\n\n')
							, m_simpleTV.Common.GetMainPath(2) .. 'YouTube_log_debug.txt', true
						)
		end
	 return
	end
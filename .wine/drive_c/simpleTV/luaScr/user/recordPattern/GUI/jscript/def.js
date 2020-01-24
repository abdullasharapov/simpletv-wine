var m_globalTranslateMap = new Map();

//--------------------------------------------------------------
//getters/setters
//--------------------------------------------------------------
function setRecordPattern(str)
{
 document.getElementById('inputRecordPattern').value = str;
}
//--------------------------------------------------------------
function getRecordPattern()
{
 return document.getElementById('inputRecordPattern').value;
}
//--------------------------------------------------------------
function setSnapshotPattern(str)
{
 document.getElementById('inputSnapshotPattern').value = str;
}
//--------------------------------------------------------------
function getSnapshotPattern()
{
 return document.getElementById('inputSnapshotPattern').value;
}
//--------------------------------------------------------------
//--------------------------------------------------------------
function setTimePattern(str)
{
 document.getElementById('inputTimePattern').value = str;
}
//--------------------------------------------------------------
function getTimePattern()
{
 return document.getElementById('inputTimePattern').value;
}
//--------------------------------------------------------------
function setEnabled(val)
{
 document.getElementById('enabledId').checked = !!val;
}
//--------------------------------------------------------------
function getEnabled()
{
 return document.getElementById('enabledId').checked;
}
//--------------------------------------------------------------
//--------------------------------------------------------------
function setPreviewRec(str)
{
 document.getElementById('preViewRec').textContent = str;
}
//--------------------------------------------------------------
function setPreviewSnap(str)
{
 document.getElementById('preViewSnap').textContent = str;
}
//--------------------------------------------------------------
function setPreviewTime(str)
{
 document.getElementById('preViewTime').textContent = str;
}
//--------------------------------------------------------------
//--------------------------------------------------------------
//
//--------------------------------------------------------------
function reloadRecPreview()
{
 window.CHtmlDialog.callLua2('updateRecordPreview', getRecordPattern(),getTimePattern() );
}
//--------------------------------------------------------------
function reloadSnapPreview()
{
 window.CHtmlDialog.callLua2('updateSnapshotPreview', getSnapshotPattern(),getTimePattern() );
}
//--------------------------------------------------------------
function reloadTimePreview()
{
 window.CHtmlDialog.callLua1('updateTimePreview', getTimePattern() );
}
//--------------------------------------------------------------
function resetToDefaults()
{
 window.CHtmlDialog.callLua('resetToDefaults');
}
//--------------------------------------------------------------
function startUp()
{
 updateEnabled();
 document.getElementById('inputRecordPattern').focus();  
}
//--------------------------------------------------------------
function updateEnabled()
{
 var color; 
 if (getEnabled())
	color = 'black';
 else color = 'grey';
  
 document.getElementById('inputRecordPattern').style.color = color;
 document.getElementById('preViewRec').style.color = color;
 
 document.getElementById('inputSnapshotPattern').style.color = color;
 document.getElementById('preViewSnap').style.color = color;
 
 document.getElementById('inputTimePattern').style.color = color;
 document.getElementById('preViewTime').style.color = color;

}
//--------------------------------------------------------------
function addVar(str)
{
 let input = undefined;
 let rec  = document.getElementById('inputRecordPattern');
 let snap = document.getElementById('inputSnapshotPattern');

 if (rec === document.activeElement) 
     input = rec;
 else if (snap === document.activeElement)
     input = snap;
 
 if (input === undefined) return;
 var scrollPos = input.scrollTop;
 var pos = 0;
 var browser = ((input.selectionStart || input.selectionStart == "0") ? 
    "ff" : (document.selection ? "ie" : false ) );
  if (browser == "ie") { 
    input.focus();
    var range = document.selection.createRange();
    range.moveStart ("character", -input.value.length);
    pos = range.str.length;
  }
  else if (browser == "ff") { pos = input.selectionStart };

  var front = (input.value).substring(0, pos);  
  var back = (input.value).substring(pos, input.value.length); 
  input.value = front+str+back;
  pos = pos + str.length;
  if (browser == "ie") { 
    input.focus();
    var range = document.selection.createRange();
    range.moveStart ("character", -input.value.length);
    range.moveStart ("character", pos);
    range.moveEnd ("character", 0);
    range.select();
  }
  else if (browser == "ff") {
    input.selectionStart = pos;
    input.selectionEnd = pos;
    input.focus();
  }
  input.scrollTop = scrollPos; 
}
//--------------------------------------------------------------
//translate
//--------------------------------------------------------------
function tr(str)
{
 if (m_globalTranslateMap.has(str))
    return m_globalTranslateMap.get(str);
 return str;
}
//--------------------------------------------------------------
function doTranslate()  
{
 //Caption
 document.getElementById('mainCaptionText').textContent  = tr('Record Pattern');
 
 //ToolBar
 document.getElementById('toollBarButtonCnannelName').textContent  = tr('Channel');
 document.getElementById('toollBarButtonGroupName').textContent  = tr('Group');
 document.getElementById('toollBarButtonExtFilterName').textContent  = tr('ExtFilter');
 document.getElementById('toollBarButtonTime').textContent  = tr('Time');
 document.getElementById('toollBarButtonTimeshift').textContent  = tr('Timeshift');
 document.getElementById('toollBarButtonReset').textContent  = tr('Reset');
 
 document.getElementById('toollBarButtonEpgTitle').textContent  = tr('EPG'); 
 document.getElementById('toollBarButtonEpgCat').textContent  = tr('EPG category');
 document.getElementById('toollBarButtonEpgStart').textContent  = tr('EPG start');
 document.getElementById('toollBarButtonEpgEnd').textContent  = tr('EPG end');
  
 //Inputs
 var v = document.getElementById('labelRecordPatern');
 v.innerHTML = tr('Format for record') + v.innerHTML;
  
 v = document.getElementById('labelSnapshotPatern');
 v.innerHTML = tr('Format for snapshot') + v.innerHTML;
 
 v = document.getElementById('labelTimePatern');
 v.innerHTML = tr('Format for time') + v.innerHTML;
}
//--------------------------------------------------------------

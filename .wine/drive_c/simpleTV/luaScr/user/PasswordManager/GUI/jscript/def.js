var m_globalLogins = new Map();
var m_globalTranslateMap = new Map();
var m_showPassword = false;
var m_showDialogPassword = false;

//--------------------------------------------------------------
function doImport()
{
 window.CHtmlDialog.callLua( 'requestImport' );
}
//--------------------------------------------------------------
function doExport()
{
  window.CHtmlDialog.callLua( 'requestExport' );
}
//--------------------------------------------------------------
function getLogins()  
{ 
 var retA = []; 
  m_globalLogins.forEach(function (value, key, map) {
	  retA.push({'id': key,'name':value.name,'login':value.login,'password':value.password});
	});
 return retA;
}
//--------------------------------------------------------------
function clearLogins()  
{
 m_globalLogins.clear();
 var table = getLoginTable();
 if (table!=null)
     table.innerHTML = "";
}
//--------------------------------------------------------------
function getLoginTable()
{
 return document.getElementById("loginTable");
}
//--------------------------------------------------------------
function getRowById(id)
{
 var table = getLoginTable();
 if (table==null) return null;
 var r = table.rows;
 if (r==null) return null;
 return r.namedItem(id);
}
//--------------------------------------------------------------
function showRowPassword(id)  
{
 var item = m_globalLogins.get(id);
 if (undefined == item) return;
 var row = getRowById(id);
 if (row!=null)
    {
	  if (row.cells[3].textContent.startsWith('\u25CF'))
				row.cells[3].textContent = item.password;
	  else row.cells[3].textContent = item.password.replace(/(.)/g, '\u25CF');
	}
}
//--------------------------------------------------------------
function deleteEntry(id)  
{
 m_globalLogins.delete(id);
 var row = getRowById(id);
 if (row!=null)
	getLoginTable().deleteRow(row.rowIndex);
}
//-------------------------------------------------------------- 
function reloadLoginTable()
{
 var m = getLogins();
 clearLogins();
 m.forEach(function (item, index, array) {
	  addEntry(item.id,item.name,item.login,item.password);
	});
}
//-------------------------------------------------------------- 
function updateLoginRow(oldId,newId)
{
 var item = m_globalLogins.get(newId);
 if (undefined == item) return;
 
 if (oldId!=newId)
     {
	  var row = getRowById(newId);
	  if (row!=null)
	      getLoginTable().deleteRow(row.rowIndex);
	 }
	 
  var row = getRowById(oldId);
 if (row!=null)
  {
   row.innerHTML = ''
   fillRow(newId,row);
  } 
} 
//-------------------------------------------------------------- 
function addEntry(id,name,login,password) 
 {
  var table = getLoginTable();
  if (table==null) return;
  m_globalLogins.set(id,{'name' : name,'login' : login,'password' : password})
  
  var row = table.insertRow(-1);
  fillRow(id,row)
}
//-------------------------------------------------------------- 
function fillRow(id,row)
{  
  var item = m_globalLogins.get(id);
  if (undefined == item) return;
  
  row.id = id;
  var cellId = row.insertCell(0);
  var cellName = row.insertCell(1);
  var cellLogin = row.insertCell(2);
  var cellPassword = row.insertCell(3);
  var cellAction = row.insertCell(4);
  
  row.addEventListener("dblclick", function(){ editItem(id,false);}, false);
  
  cellId.textContent       = id;
  cellName.textContent     = item.name;
  cellLogin.textContent    = item.login;
  cellPassword.textContent = m_showPassword ? item.password : item.password.replace(/(.)/g, '\u25CF');
  
  cellAction.innerHTML   = "<img class='cell-button' src='Img/edit.png' title=\"" + tr("edit") + "\" onclick=\"editItem('" + id + "',true);return false;\">"
+  (m_showPassword ? '' : "<img class='cell-button' src='Img/eye.png' title=\"" + tr("show password") + "\" onclick=\"showRowPassword('" + id + "');return false;\">")
+ "<img class='cell-button' style=\"margin-left:16px;\" src='Img/btn_delete.png' title=\"" + tr("delete") + "\" onclick=\"deleteEntry('" + id + "');return false;\">";  
  cellAction.style.userSelect = 'none';
  cellAction.addEventListener("dblclick", function(e){e.stopPropagation();}, false);

 } 
//--------------------------------------------------------------
function closeEditor()
{
 document.getElementById('editorForm').reset();
 document.getElementById('origLoginId').value = '';
 document.getElementById('editorAllArea').style.display = 'none';
}
//--------------------------------------------------------------
function isEditorOpen()
{
 return document.getElementById('editorAllArea').style.display != 'none';
}
//--------------------------------------------------------------
function onSubmitEditor()  
{
 var id     = document.getElementById('loginId').value.trim().toLowerCase();
 var origId = document.getElementById('origLoginId').value;
 var name = document.getElementById('loginName').value.trim();
 var login = document.getElementById('loginLogin').value.trim();
 var password = document.getElementById('loginPassword').value.trim();

 if ( 	 id==='' 
      || name==='')
   {
    //TODO: show error message
    return;
   }
 
 if (origId==='')  
    {
	 if (m_globalLogins.has(id))
		 origId = id;
	 else 
	  { 
	   addEntry(id,name,login,password) 
	   closeEditor();
	   return;
	  }
	}
  
 m_globalLogins.delete(origId);
 m_globalLogins.set(id,{'name' : name,'login' : login,'password' : password});
 updateLoginRow(origId,id);
 
 closeEditor();
}
//--------------------------------------------------------------
function newItem()  
{
 document.getElementById('editorContent').style.animationName = 'animatetop';
 document.getElementById('editorForm').reset();
 document.getElementById('origLoginId').value = '';
 document.getElementById('editorAllArea').style.display = 'block';
}
//--------------------------------------------------------------
function editItem(id,animDir)  
{
 var item = m_globalLogins.get(id);
 if (undefined == item) return;
 
 document.getElementById('editorForm').reset();
 
 document.getElementById('loginId').value = id;
 document.getElementById('origLoginId').value =  id;
 document.getElementById('loginName').value = item.name;
 document.getElementById('loginLogin').value = item.login;
 document.getElementById('loginPassword').value = item.password;
    
 document.getElementById('editorContent').style.animationName = animDir ? 'animateright' : 'animateopacity';
 document.getElementById('editorAllArea').style.display = 'block';
}
//--------------------------------------------------------------
function updateEditorShowPasswordButton()
{
 var b  = document.getElementById('editorShowPasswordButton');
 var ct = document.getElementById('loginPassword');
 if (m_showPassword)
      {
	   b.style.display = 'none';
	   ct.type = 'text';
	  }
  else {
        b.style.display = 'inline-block'; 
		ct.type = 'password';
	   }
}
//--------------------------------------------------------------
function editorShowPassword()
{
 var ct = document.getElementById('loginPassword');
 if (ct.type == 'password')
			ct.type = 'text';
 else  			
	ct.type = 'password';
}
//--------------------------------------------------------------
//Preference
//--------------------------------------------------------------
function openPreference()
{
 document.getElementById('prefShowPassCheckbox').checked = m_showPassword;
 document.getElementById('prefShowDialogPassCheckbox').checked = m_showDialogPassword;
 
 document.getElementById('prefAllArea').style.display = 'block';
}
//--------------------------------------------------------------
function isPreferenceOpen()
{
 return document.getElementById('prefAllArea').style.display != 'none';
}
//--------------------------------------------------------------
function closePreference()
{
 document.getElementById('prefAllArea').style.display = 'none';
}
//--------------------------------------------------------------
function onSubmitPref() 
{ 
 closePreference();
 
 m_showDialogPassword = document.getElementById('prefShowDialogPassCheckbox').checked;
 var v = document.getElementById('prefShowPassCheckbox').checked;
 if (v != m_showPassword)
    {
	 m_showPassword = v;
	 updateEditorShowPasswordButton();
	 reloadLoginTable();
	}
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
 document.getElementById('mainCaptionText').textContent  = tr('Password Manager');
 
 //Header table
 document.getElementById('headerId').textContent  = tr('Id');
 document.getElementById('headerName').textContent  = tr('Name');
 document.getElementById('headerLogin').textContent  = tr('Login');
 document.getElementById('headerPass').textContent  = tr('Password');
 document.getElementById('headerAct').textContent  = tr('Actions');
  
 //Toolbar
 document.getElementById('toollBarButtonNew').textContent  = tr('New');
 document.getElementById('toollBarButtonImport').textContent  = tr('Import');
 document.getElementById('toollBarButtonExport').textContent  = tr('Export');
 document.getElementById('toollBarButtonPref').textContent  = tr('Preference');
  
 //Editor
 document.getElementById('editorHeader').textContent  = tr('Editor');
 document.getElementById('editorLabelId').textContent  = tr('Id');
 document.getElementById('editorLabelName').textContent  = tr('Name');
 document.getElementById('editorLabelLogin').textContent  = tr('Login');
 document.getElementById('editorLabelPass').textContent  = tr('Password');
 document.getElementById('editorSubmit').value = tr('Save');
 
 //Pref dialog
 document.getElementById('prefHeader').textContent  = tr('Preference');
 document.getElementById('prefSubmit').value = tr('Save');
  
 var v = document.getElementById('prefShowPassText');
 v.innerHTML = tr('Show passwords') + v.innerHTML;
 v = document.getElementById('prefShowDialogPassText');
 v.innerHTML = tr('Show dialog of enter password') + v.innerHTML;
}
//--------------------------------------------------------------
//not functions
//--------------------------------------------------------------
window.onclick = function(event) {
 if (event.target == document.getElementById('editorAllArea')) 
		{
		 closeEditor();  
		 return false;
		}
 if (event.target == document.getElementById('prefAllArea')) 
		{
		 closePreference();
		 return false;  		
		}
}
//--------------------------------------------------------------
window.onkeydown = function(event) {
 if (event.keyCode == 27) 
    {
	 if (isEditorOpen())
		{
 		 closeEditor();
		 return false;
		}
     if (isPreferenceOpen())
		{
 		 closePreference();
		 return false;
		}	
	}
 return true;	
}
//--------------------------------------------------------------

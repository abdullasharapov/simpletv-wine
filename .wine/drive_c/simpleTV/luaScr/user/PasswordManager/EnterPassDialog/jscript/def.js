var m_globalTranslateMap = new Map();

//--------------------------------------------------------------
function setInitialVal(id,name,showPassword)
{
 document.getElementById('loginId').value   = id;
 document.getElementById('loginName').value = name;
 updateEditorShowPasswordButton(showPassword)
}
//--------------------------------------------------------------
function doClose()
{
 window.CHtmlDialog.callLua('requestCancel')
}
//--------------------------------------------------------------
function onSubmitEditor()
{ 
 var login    = document.getElementById('loginLogin').value.trim();
 var password = document.getElementById('loginPassword').value.trim();
  
 if (login === '' || password === '' ) return;
  
 window.CHtmlDialog.callLua3( 'formSubmit'
							  , document.getElementById('loginId').value
						      , login
							  , password);
}
//--------------------------------------------------------------
function updateEditorShowPasswordButton(showPassword)
{
 var b  = document.getElementById('editorShowPasswordButton');
 var ct = document.getElementById('loginPassword');
 if (showPassword)
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
 document.getElementById('editorHeader').textContent  = tr('MainHeader');
 document.getElementById('editorLabelId').textContent  = tr('Id');
 document.getElementById('editorLabelName').textContent  = tr('Name');
 document.getElementById('editorLabelLogin').textContent  = tr('Login');
 document.getElementById('editorLabelPass').textContent  = tr('Password');
 document.getElementById('editorSubmit').value = tr('Ok'); 
}
//--------------------------------------------------------------
//not functions
//--------------------------------------------------------------
window.onkeydown = function(event) {
 if (event.keyCode == 27) 
    {
	 doClose();
	}
 return true;	
}
//--------------------------------------------------------------

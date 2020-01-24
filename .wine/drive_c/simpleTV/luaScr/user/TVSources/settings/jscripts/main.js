	var ch_refresh = false;
	var gr_refresh = false;
	var cg_refresh = false;
	var carret_pos;
			
function getCaret(el) {
  if (el.selectionStart) {
    return el.selectionStart;
  } else if (document.selection) {
    el.focus();
 
    var r = document.selection.createRange();
    if (r == null) {
      return 0;
    }
 
    var re = el.createTextRange(),
        rc = re.duplicate();
    re.moveToBookmark(r.getBookmark());
    rc.setEndPoint('EndToStart', re);
 
    return rc.text.length;
  } 
  return 0;
}

function setSelectionRange(input, selectionStart, selectionEnd) {
  if (input.setSelectionRange) {
    input.focus();
    input.setSelectionRange(selectionStart, selectionEnd);
  }
  else if (input.createTextRange) {
    var range = input.createTextRange();
    range.collapse(true);
    range.moveEnd('character', selectionEnd);
    range.moveStart('character', selectionStart);
    range.select();
  }
}
 
function setCaretToPos (input, pos) {
  setSelectionRange(input, pos, pos);
}

function UpdateLang(param){
    document.getElementById("LangForm").value = param;
}

function UpdateList(id,param){
    document.getElementById(id).value = param;
	document.getElementById(id).click();
}

function changeIcon(id,icon1,icon2){
    document.getElementById(id).setAttribute("src",icon1);
	setTimeout(function() {document.getElementById(id).setAttribute("src",icon2);},250);
}

function select_file(id,icon1,icon2) {
	document.getElementById(id).setAttribute("src",icon1);
	document.getElementById(id).click();
	setTimeout(function() {document.getElementById(id).setAttribute("src",icon2);},250);
}

function change_file_path(path,id) {
	if (path) {
	 	document.getElementById(id).value = path ;
	 	}
}

function SelectList(id) {
	if (document.getElementById('sl'+id).style.display == 'none') {
		document.getElementById('sl'+id).style.display = 'block';
		document.getElementById('btn'+id).setAttribute("src","img/btn_select_click.png");
	}
	else {
		document.getElementById('sl'+id).style.display = 'none';
		document.getElementById('btn'+id).setAttribute("src","img/btn_select.png");
	}
}
function ChangeList(id,list,contetnt,type) {
	document.getElementById('btn'+id).setAttribute("src","img/btn_select.png");
	document.getElementById(id).value = contetnt;
	document.getElementById(id+'1').value = type;
	document.getElementById(list).style.display = 'none';
}

function CreateDynamicTable(f_tab)
{
     switch (f_tab) {
         case  '1' :
         case  "ftb_1" :
    	            if (ch_refresh == false) { 	
        	            ch_refresh = true;
        	            document.getElementById('idFilterLoading1').style.display = 'block';
						new DynamicTable( window, document.getElementById("dynamic"), 'idCHList', 'ch_name','idCHCount',  document.getElementById('search_text_CF'));
        	            document.getElementById('idFilterLoading1').style.display = 'none';
						
                    }
                    break;
         case  '2' :
         case  "ftb_2" :
    	            if (gr_refresh == false) { 	
        	            gr_refresh = true;
        	            document.getElementById('idFilterLoading2').style.display = 'block';
						new DynamicTable( window, document.getElementById("groups"), 'idGRList', 'gr_name','idGRCount', document.getElementById('search_text_GF'));
        	            document.getElementById('idFilterLoading2').style.display = 'none';
                    }
                    break;                            
         case  '3' :
         case  "ftb_3" :
    	            if (cg_refresh == false) { 	
        	            cg_refresh = true;
        	            document.getElementById('idFilterLoading3').style.display = 'block';
						new DynamicTable( window, document.getElementById("cgroups"), 'idGCList', 'cg_name','idCGCount', document.getElementById('search_text_CG'));
        	            document.getElementById('idFilterLoading3').style.display = 'none';
                    }
                    break;                            
       } 
}


function SwitchTab(num) {
    //num = toString(num);
    var tab = +/\d/.exec(num)
	document.getElementById('content_1').style.display = 'none';
	document.getElementById('content_2').style.display = 'none';
	document.getElementById('content_3').style.display = 'none';
	document.getElementById('content_4').style.display = 'none';
	document.getElementById('content_5').style.display = 'none';
	document.getElementById('content_6').style.display = 'none';
	document.getElementById('content_7').style.display = 'none';
	document.getElementById('content_'+tab).style.display = 'block'; 
	document.getElementById('tb_1').className = '';
	document.getElementById('tb_2').className = '';
	document.getElementById('tb_3').className = '';
	document.getElementById('tb_4').className = '';
	document.getElementById('tb_5').className = '';
	document.getElementById('tb_6').className = '';
	document.getElementById('tb_7').className = '';
	document.getElementById('tb_'+tab).className = 'active';
	// табы фильтров
	if (num == 31 || num == 32 || num == 33) {
	        var n = num-30;
	        SwitchFTab('ftb_'+n, 'fcontent_'+n);
	        return;	
	}
	// оставлено для совместимости
	if (num == 3) SwitchFTab('ftb_1', 'fcontent_1');
    // подгрузка changelog
	if (num == 7) window.external.CallLua1("log"); 
		
	window.external.CallLua1("save"+num); 
}
function SwitchFTab(new_tab, new_content) {   
    // SwitchFTab('ftb_1', 'fcontent_1')
	document.getElementById('fcontent_1').style.display = 'none';
	document.getElementById('fcontent_2').style.display = 'none';
	document.getElementById('fcontent_3').style.display = 'none';
	document.getElementById(new_content).style.display = 'block'; 
	var n = +/\d$/.exec(new_tab)
	window.external.CallLua1("tab3_" + n);  
	window.external.CallLua1("save3" + n); 
	//CreateDynamicTable(new_tab) - перенесено в CallLua1
	document.getElementById('ftb_1').className = '';
	document.getElementById('ftb_2').className = '';
	document.getElementById('ftb_3').className = '';
	document.getElementById(new_tab).className = 'active';
}

<!---------- Работаем с таблицей фильтров -------------------->

if(typeof window.DynamicTable !== 'function') {
 
    function DynamicTable(GLOB, htmlTable, id_string, nameinput, count, search) {   
        // Так как эта функция является конструктором,
        // подразумевается, что ключевое слово this - будет
        // указывать на экземпляр созданного объекта. Т.е.
        // вызывать её нужно с оператором "new".
        // Проверка ниже является страховкой:
        // если эта функция была вызвана без оператора "new",
        // то здесь эта досадная ситуация исправляется:
        if ( !(this instanceof DynamicTable) ) {
            return new DynamicTable(GLOB, htmlTable, id_string, nameinput, count, search);  
        }
		//
		var FilterCH; 
		FilterCH = new Array();
		
        // Зависимость:
        var DOC       = GLOB.document,
			FilterCH  = new Array(),
            // Ссылка на массив строк таблицы:
            tableRows = htmlTable.rows,
			// Количество каналов:
            CH_count  = tableRows.length,
            // Кол-во строк таблицы:
            RLength   = tableRows.length,
            // Кол-во ячеек в таблице:
            CLength   = tableRows[0].cells.length,
            // Контейнер для работы в циклах ниже:
            inElement = null,
            // Контейнер кнопки
            button    = null,
            // Контейнер текстового узла кнопки
            //butText   = null,
            // В одном из методов ниже, потребуется
            // сохранить контекст:
            self      = this,
            // Счётчики итераций:
            i,j;   
		
		this.massCH = function() {
			ch_string = document.getElementById(id_string).value
			var z = ch_string.split('>>');
			for(var i = 0; i < z.length; i++) z[i] = z[i].split(';');
			return z;	
		} 
        // --------------------------------------------------------------------------------------
 
        // Метод "Вставить кнопки".
        // Создаёт/добавляет две кнопки "удалить" и "добавить", завёрнутые в элемент "p".  
        // Кнопка img заменена  на span с описанием свойств в css.
        this.insertButtons = function() {
            // Создаём первую кнопку:
            inElement = DOC.createElement("p");
            inElement.className = "d-butts";            
            button = DOC.createElement("span");       
            button.onclick = this.delRow;
            button.className = "d-butts-span-1";
            inElement.appendChild(button);
            // Создаём вторую кнопку:
            button = DOC.createElement("span");                  
            button.onclick = this.addRow;
            button.className = "d-butts-span-2";
            inElement.appendChild(button);
            return inElement;
        };
        // --------------------------------------------------------------------------------------
        
        // Метод "Добавить строку"
        this.addRow = function(ev) {
            // Кросс бр. получаем событие и цель (кнопку)
            var e         = ev||GLOB.event,
                target    = e.target||e.srcElement,
                // Получаем ссылку на строку, в которой была кнопка:
                row       = target.parentNode.parentNode.parentNode,
                // Получаем кол-во ячеек в строке:
                cellCount = row.cells.length,
                // Получаем индекс строки в которой была кнопка + 1,
                // что бы добавить строку сразу после той, в которой
                // была нажата кнопка:
                index     = row.rowIndex + 1,
                i;

            // Вставляем строку:
            var row = htmlTable.insertRow(index);      
            row.display = "inline-block"  ;   
           
            // Сообщаем, что ячеек стало больше
			CH_count = CH_count + 1;
			// Помещаем в поле счетчик последнего канала для обработки в скрипте
			document.getElementById(count).value = CH_count;
			
			// В этом цикле, вставляем ячейки.
            for(i=0; i < cellCount; i += 1) {   
                         
                htmlTable.rows[index].insertCell(i);               
                // Если ячейка последняя...
                if(i == cellCount-1) {
                    // Получаем в переменную кнопки, используя метод, описанный выше:
                    inElement = self.insertButtons();              
                } else {           
                    // Иначе получаем в переменную текстовое поле:     
                    inElement = DOC.createElement("INPUT");
					inElement.setAttribute("size","32");
					inElement.style.border = '0px';
                    // ... и задаём ему имя, типа name[] - которое
                    // впоследствии станет массивом.
                    //inElement.name  = config[i+1]+"[]"; 
					inElement.id = nameinput+[CH_count]+"_"+[i+1];			
                }                  
                // Добавляем в DOM, то что получили в переменную:
                htmlTable.rows[index].cells[i].appendChild(inElement);                     
            }
            // Обнуляем переменную, т.к.
            // она используется и в других методах.
            inElement = null;
            // Во избежании ненужных действий, при нажатии на кнопку
            // возвращаем false:
           tableSearch(htmlTable, search);
            return false;
        };
		
		// Метод "Добавить последнюю строку"
        this.addRowLast = function() {

            var tableRows = htmlTable.rows,
				// Получаем кол-во ячеек в строке:
                cellCount = tableRows[0].cells.length,
                // Получаем индекс строки в которой была кнопка + 1,
                // что бы добавить строку сразу после той, в которой
                // была нажата кнопка:
                index     = tableRows.length,
                i;

            // Вставляем строку:
            var row = htmlTable.insertRow(index);      
            row.display = "inline-block"  ;   

            // Сообщаем, что ячеек стало больше
			CH_count = CH_count + 1;
			// Помещаем в поле счетчик последнего канала для обработки в скрипте
			document.getElementById(count).value = CH_count;
			// В этом цикле, вставляем ячейки.
            for(i=0; i < cellCount; i += 1) {   
                         
                htmlTable.rows[index].insertCell(i);               
                // Если ячейка последняя...
                if(i == cellCount-1) {
                    // Получаем в переменную кнопки, используя метод, описанный выше:
                    inElement = self.insertButtons();              
                } else {           
                    // Иначе получаем в переменную текстовое поле:     
                    inElement = DOC.createElement("INPUT");
					inElement.setAttribute("size","32");
					inElement.style.border = '0px';

                    // ... и задаём ему имя, типа name[] - которое
                    // впоследствии станет массивом.
                    //inElement.name  = config[i+1]+"[]"; 
					inElement.id = nameinput+[CH_count]+"_"+[i+1];			
                }                  
                // Добавляем в DOM, то что получили в переменную:
                htmlTable.rows[index].cells[i].appendChild(inElement);                     
            }
            // Обнуляем переменную, т.к.
            // она используется и в других методах.
            inElement = null;
            // Во избежании ненужных действий, при нажатии на кнопку
            // возвращаем false:
            return false;
        };
         
        // Метод "Удалить строку"
        // Удаляем строку, на  кнопку, которой нажали:
        this.delRow = function(ev) {
            // Страховка: не даёт удалить строку, если она осталась
            // последней. Цифра 1 здесь потому, что мы не считаем
            // строку с заголовками TH, которой нет в нашей таблице.
            if(tableRows.length > 1) {
                htmlTable.deleteRow( this.parentNode.parentNode.parentNode.rowIndex );
            } else {
                return false;  
            }          
        };         
         
        // Фактически, ниже это инициализация таблицы:
        // Содержимое ячеек помещается внутрь текстовых
        // полей, а в последнюю ячейку кажой строки, помещаются
        // нопки "удалить" и "добавить" Функция является
        // "вызываемой немедленно"
        return (function() {
			// Обновляем данные о количестве каналов для последующей обработки в скрипте
			document.getElementById(count).value = CH_count;
			
			// Преобразуем в массив данные, полученные из lua
			FilterCH  = self.massCH();
            var ch_mass = FilterCH.length;
			// Мы имеем дело с двумерным массивом:
            // table.rows[...].cells[...]
            // Поэетому сдесь вложенный цикл.
            // Внешний цикл "шагает" по массиву...
				
            for( i = 0; i < ch_mass; i += 1 ) { 
                var src = FilterCH[i][2]; 
                if (typeof(src) !== "string") { src =""; }
                              
                var dest = FilterCH[i][3];
                if (typeof(dest) !== "string") { dest = '0'; }
                
               
				// если строки нет, то добавляем ее
				if ( i > RLength - 1) {
					self.addRowLast();
					//присваиваем input'ам значения из массива
					var inp1 = document.getElementById(nameinput+[i+1]+"_1"), 
					    inp2 = document.getElementById(nameinput+[i+1]+"_2")
					inp1.value = FilterCH[i][0]; 
					inp2.value = FilterCH[i][1]; 
					
					if (src !== "") { inp1.className = "filter_used"; inp1.title = src ; }
					else { inp1.className = "filter_unused"; };
				    switch (dest)
				    {
				     case "1":  inp2.className = "filter_exist";  break;
				     case "2":  inp2.className = "filter_favor";  break;
				     default:   inp2.className = "filter_unused"; break;
				    }	
				    					
				}
				else {
					// Строка в таблице есть, значит меняем ее
					// Внутренний цикл "шагает" по ячейкам:
					for( j = 0; j < CLength; j += 1 ) {
		                // Если ячейка последняя...
							if( j + 1 == CLength ) {
								// Помещаем в переменную кнопки:
								inElement = self.insertButtons(); 				
							} else {                   
								// Иначе создаем текстовый элемент,
								inElement = DOC.createElement("INPUT");
								inElement.setAttribute("size","32");
								inElement.style.border = '0px';
		
								// Помещаем в него данные ячейки,
								inElement.value = FilterCH[i][j];
								if (j==0) 
								   if (src !== "") { inElement.className = "filter_used";  inElement.title = src ; }
								   else {inElement.className = "filter_unused";}
								if (j==1) 

								   switch (dest)
								   {
								     case "1":  inElement.className = "filter_exist";  break;
								     case "2":  inElement.className = "filter_favor";  break;
								     default:   inElement.className = "filter_unused"; break;
								   }				
                                 
								// Присваиваем имя - массив,
								//inElement.name  = config[j+1]+"[]";
								// Присаваиваем id
								inElement.id = nameinput+[i+1]+"_"+[j+1];
								// Удаляем, уже не нужный экземпляр данных непосредственно
								// из самой ячейки, потому что теперь данные у нас внутри
								// текстового поля:
								tableRows[i].cells[j].firstChild.data = "";
							} 

		                // Вставляем в ячейку содержимое переменной - это
		                // либо текстовое поле, либо кнопки:
		                tableRows[i].cells[j].appendChild(inElement);
		                // Обнуляем переменную, т.к.
		                // она используется и в других методах.
		                inElement = null;
					} 
				}
            }
            
			//обнуляем массив, чтобы память не занимал
			FilterCH = null;
        }());
     
    }// end function DynamicTable
   
}

window.onload_ = function() {
	document.getElementById('toggler').onclick = function() {
		openbox('box', this);
		return false;
	};
};
function openbox(id, toggler) {
	var div = document.getElementById(id);
	if(div.style.display == 'block') {
		div.style.display = 'none';
		toggler.innerHTML = '&#9733';
	}
	else {
		div.style.display = 'block';
		toggler.innerHTML = '&#9734';
	}
}
// search on dynamic table
function tableSearch(htmlTable, htmlSearch) {
    var phrase = htmlSearch ;
    var table = htmlTable; // document.getElementById('dynamic');
    var regexp = new RegExp(phrase.value, 'i');
    var flag = false;
    for (var i = 0; i < table.rows.length; i++) {
        flag = false;
        table.rows[i].style.display = "none";
        for (var j = 1; j >= 0; j--) {
            var str = table.rows[i].cells[j].firstChild.value; // firstchild >> INPUT
            if  (str!="undefined") {
	            flag = regexp.test(str);
		        if (flag || str=="") {  table.rows[i].style.display = "inline-block";   break;    }
	        }
        }
    }
}

uses Crt,SysUtils;

type
  Pinteger = ^integer;
  Pstring = ^string;
  PAnsiString = ^ansistring;
  Pchar = ^char;
  Ptree = ^treeitem;
  
  treeitem=record
    index, dataint: Pinteger;
    datastr: Pstring;
    left, right: Ptree;
    end;
    
//меню
procedure menu(messege: PAnsiString; var menu_item: Pinteger);
var
  key: Pchar; // введенный символ

begin
  menu_item^ := 1;
  repeat
    //очистка экрана
    ClrScr;
    
    // отображение элементов меню
    if menu_item^ = 1 then write('-> ') else write('   ');
    writeln('1.Create structure');
    
    if menu_item^ = 2 then write('-> ') else write('   ');
    writeln('2.Delete structure');
    
    if menu_item^ = 3 then write('-> ') else write('   ');
    writeln('3.Entry element');
    
    if menu_item^ = 4 then write('-> ') else write('   ');
    writeln('4.Search element');
    
    if menu_item^ = 5 then write('-> ') else write('   ');
    writeln('5.Is empty?');

    if menu_item^ = 6 then write('-> ') else write('   ');
    writeln('6.Number of elements');
    
    if menu_item^ = 7 then write('-> ') else write('   ');
    writeln('7.Exit');
        
    writeln(messege^);
    messege^:='';
    // Считывание нажатой клавиши
    new(key);
    key^ := ReadKey;
    
    // Обработка клавиш
    if key^ = #72 then // стрелка вверх
      if menu_item^ > 1 then
        menu_item^ := menu_item^ - 1
      else menu_item^ := 7;
    if key^ = #80 then // Стрелка вниз
      if menu_item^ < 7 then
        menu_item^ := menu_item^ + 1
      else menu_item^:= 1;
  until key^ = #10; // Enter
  dispose(key);
end;

// Количество элементов
procedure countelement(item: Ptree; var counter: integer);
begin
  if item^.left<>nil then
    begin
    counter+=1;
    countelement(item^.left, counter)
    end;
  if item^.right<>nil then 
    begin
    counter+=1;
    countelement(item^.right, counter)
    end;
end;

// Количество, для вывода значения
function outputcounter(item: Ptree): integer;
begin
  if item=nil then outputcounter:=0 
  else 
    begin
    outputcounter:=1;
    countelement(item, outputcounter)
    end;
end;
 
// Созданиме структуры
procedure createstruct(var item: Ptree);
  begin
  item:= nil;
  end;
  
// Добавление элемента
procedure addelement(var item: Ptree; index, dataint: Pinteger; datastr: Pstring; messege: PAnsiString);
  begin
  if item=nil then 
    begin
    new(item);
    item^.index:=index;
    item^.right:=nil;
    item^.left:=nil;
    item^.dataint:=dataint;
    item^.datastr:=datastr;
    messege^:='Element added';
    end
  else if index^ < item^.index^ then addelement(item^.left, index, dataint, datastr, messege)
  else if index^ > item^.index^ then addelement(item^.right, index, dataint, datastr, messege)
  else begin 
    messege^:='Element already exist';
    dispose(index);
    dispose(datastr);
    dispose(dataint);
    end;
  end;
  
// Ввод данных и добавление 
procedure inputadd(var item: Ptree; messege: PAnsiString);
var
  lindex,ldataint: integer;
  ldatastr: string;
  dataint, index: Pinteger;
  datastr: Pstring;
begin
  writeln('Write number and data(age, name) of the new element:');
  new(index);
  new(datastr);
  new(dataint);
  readln(lindex, ldataint, ldatastr);
  index^:= lindex;
  dataint^:= ldataint;
  datastr^:= ldatastr;
  addelement(item, index, dataint, datastr, messege);
end;

// Поиск элемента 
procedure findelement(var find: Ptree; item: Ptree; index: Pinteger);
begin
  if item^.index^=index^ then find:=item 
  else if index^ < item^.index^ then 
    if item^.left=nil then exit 
    else findelement(find, item^.left, index)
  else if index^ > item^.index^ then
    if item^.right=nil then exit 
    else findelement(find, item^.right, index);
end;

// Ввод и поиск 
procedure inputfind(var item: Ptree; messege: PAnsiString);
var 
  find: Ptree;
  index: Pinteger;
begin
  writeln('Write number of the element:');
  new(find);
  new(index);
  readln(index^);
  find^.datastr:=nil;
  find^.dataint:=nil;
  findelement(find, item, index);
  if find^.datastr=nil then messege^:='The element does not exist'
  else messege^:= 'Age = '+IntToStr(find^.dataint^)+', name = '+find^.datastr^
end;
  
// Пустой?
procedure emptiness(item: Ptree; messege: PAnsiString);
begin
  if item=nil then messege^:='Tree is empty'
  else messege^:='Tree is not empty'
end;

// Удаление дерева
procedure deletetree(var item: Ptree);
begin
  if item<>nil then
    begin
    if item^.left<>nil then deletetree(item^.left);
    if item^.right<>nil then deletetree(item^.right);
    dispose(item^.index);
    dispose(item^.datastr);
    dispose(item^.dataint);
    item:=nil
    end
end;

// Обработка команд
var 
menu_item: Pinteger;
messege: PAnsiString;
exit, exist_str,exist_elem: Pstring;
item: Ptree;

begin
new(menu_item);
new(exit);
new(exist_str);
new(messege);
new(exist_elem);
menu_item^:=1;
exit^:='no';
messege^:='';
exist_str^:='no';
exist_elem^:='no';

while exit^='no' do
begin
menu(messege, menu_item);
case menu_item^ of
  1: begin 
  if exist_str^ ='no' then begin
  createstruct(item);
  exist_str^:='yes';
  messege^:='Tree created' end
  else messege^:='Tree already created';
  end;
  
  2: begin 
  if exist_str^='yes' then begin
  deletetree(item);
  exist_elem^:='no';
  messege^:='Tree deleted'
  end
  else messege^:='Tree not created'
  end;
  
  3: begin 
  if exist_str^ ='yes' then begin
  inputadd(item, messege);
  exist_elem^:='yes' end
  else messege^:='Tree not created'
  end;
  
  4: begin 
  if exist_elem^='yes' then inputfind(item, messege)
  else messege^:= 'Tree is empty or net created' 
  end;
  
  5: begin 
  if exist_str^='yes' then emptiness(item, messege)
  else messege^:='Tree not created'
  end;
  
  6: begin
  if exist_str^='yes' then messege^:=IntToStr(outputcounter(item))+' elements in tree'
  else messege^:='Tree not created'
  end;
  
  7: exit^:='yes';
  end;
end;
end.
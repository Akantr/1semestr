uses Crt,Math,SysUtils;

type Tmiss = record
  absol,otn: double;
  end;
//ввод границ интегрирования
procedure abinput(var a,b:double);
var temp: double;
    begin
    write('Введите границы интегрирования: ');
    readln(a,b);
    if a>b then 
        begin
        temp:=a;
        a:=b;
        b:=temp;
        end;
    end;

//меню
procedure menu(messege: string; var menu_item: integer);
var
  key: char; // введенный символ

begin
  menu_item := 1;
  repeat
    //очистка экрана
    ClrScr;
    
    // отображение элементов меню
    if menu_item = 1 then write('-> ') else write('   ');
    writeln('1.Ввод границ интеграла');
    
    if menu_item = 2 then write('-> ') else write('   ');
    writeln('2.Ввод точности интегрирования');
    
    if menu_item = 3 then write('-> ') else write('   ');
    writeln('3.Расчет интеграла');
    
    if menu_item = 4 then write('-> ') else write('   ');
    writeln('4.Расчет и вывод погрешности');
    
    if menu_item = 5 then write('-> ') else write('   ');
    writeln('5.Вывод интеграла');

    if menu_item = 6 then write('-> ') else write('   ');
    writeln('6.Выход');
        
    writeln(messege);
    messege:='';
    // Считывание нажатой клавиши
    key := ReadKey;
    
    // Обработка клавиш
    if key = #72 then // стрелка вверх
      if menu_item > 1 then
        menu_item := menu_item - 1
      else menu_item := 6;
    if key = #80 then // Стрелка вниз
      if menu_item < 6 then
        menu_item := menu_item + 1
      else menu_item:= 1;
  until key = #10; // Enter
end;

// ввод точности
procedure ninput(var n:double);
    begin
    write('Введите точность интегрирования: ');
    readln(n)
    end;
    
// Расчет интеграла
function  integral(a,b,n: double): double; 
begin // 2*x^3+(-2)*x^2+(-4)*x+18
  if a<-2.069 then a:=-2.069; //крайнее левое значение графика, положительное по x 
  integral:=0;
  n:=(b-a)/n;
  while b>a do 
   begin
   integral+=n * (2*power(b,3)+(-2)*power(b,2)+(-4)*b+18);
   b:=b-n
   end;
end;

// Погрешность
function uncertainty(a,b,integ: double): Tmiss;
var F1,F2,absol:double;

begin //(1/2)x⁴ - (2/3)x³ - 2x² + 18x
  if a<-2.069 then a:=-2.069; //крайнее левое значение графика, положительное по x 
  F1:=0.5*power(a,4)-(2/3)*power(a,3)-2*power(a,2)+18*a;
  F2:=0.5*power(b,4)-(2/3)*power(b,3)-2*power(b,2)+18*b ;
  uncertainty.absol:=integ-F2-F1; //абсолютная погрешность
  uncertainty.otn:=(uncertainty.absol/(F2-F1))*100; //относительная погрешность
end;

// Обработка команд
var a,b,n,integ: double;
unecrt: Tmiss;
menu_item: integer;
exist_ab,exist_n,exist_integ,messege,exit: string;

begin
menu_item:=1;
exist_ab:='no';
exist_n:='no';
exist_integ:='no';
exit:='no';
messege:='';

while exit='no' do
begin
menu(messege, menu_item);
case menu_item of
  1: begin abinput(a,b); 
    exist_ab:='yes';
    messege:='';
    end;
  2: begin ninput(n);
    exist_n:='yes';
    messege:='';
    end;
  3: begin 
    if (exist_n='yes') and (exist_ab='yes') then 
      begin integ:=integral(a,b,n);
      exist_integ:='yes'
      end
    else messege:='Нет точности или предела интегрирования';
    end;
  4: begin 
    if exist_integ='yes' then 
      begin 
      unecrt:=uncertainty(a,b,integ);
      messege:='Абсолютная погрешность равна ' + FloatToStr(unecrt.absol) + ', относительная погрешность равна '+ FloatToStr(unecrt.otn)+'%'
      end
    else messege:='Интеграл еще не найден';
    end;
  5: begin 
    if exist_integ='yes' then messege:='Интеграл равен ' + FloatToStr(integ)
    else messege:='Интеграл еще не найден';
    end;
  6: exit:='yes';
  end;
end;
end.

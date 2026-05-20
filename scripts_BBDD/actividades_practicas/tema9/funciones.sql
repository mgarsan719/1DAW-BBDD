drop database if exists pl_sql;
create database pl_sql;

use pl_sql;

-- saludar con nombre
delimiter $$
create function saluda(nombre varchar(250)) 
returns varchar(250) 
deterministic 
begin
	return concat('Hola ', nombre);
end$$

-- Suma con parametros
create function suma(num1 int, num2 int) 
returns int 
deterministic 
begin
	return num1 + num2;
end$$

-- dado un precio sin iva(21%) y un descuento calcule el precio final
create function precio_final(precio decimal, descuento int) 
returns decimal(16, 2)
deterministic 
begin
	declare precio_IVA decimal(16, 2);
    set precio_IVA = precio* 1.21;
    
    return precio_IVA - ((descuento / 100) * precio_IVA);
end$$

-- funcion edad
create function mayoriaEdad(edad int) 
returns varchar(250)
deterministic 
begin
	declare mensaje varchar(250);

    if(edad>18) then
		set mensaje = 'Eres mayor';
	else
		set mensaje = 'Eres menor';
    end if;
	
    return mensaje;
end$$

create function factorial(num int) 
returns int
deterministic 
begin
    declare result int default 1;
	while (num > 1) do
        set result = result * num;
        set num = num - 1;
    end while;
    
    return result;
end$$

delimiter ;

select saluda('Mario');

select suma(10, 7);

select precio_final(100, 20);

select mayoriaEdad(2);

select factorial(5);
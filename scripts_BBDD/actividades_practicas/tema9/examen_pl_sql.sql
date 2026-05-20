-- Cabecera
drop database if exists practica_pl_sql;
create database practica_pl_sql;
use practica_pl_sql;

create table alumno(
	id bigint auto_increment primary key,
    nombre_alumno varchar(255),
    fecha_nacimiento date,
    edad int
);

create table alumnos_eliminados(
	id_alumno bigint,
    nombre_alumno varchar(255),
    fecha_nacimiento date,
    edad int
);

-- a. Crea una función que dado dos números enteros devuelva la media de
-- ambos numeros. Comprueba el resultado
delimiter $$
create function media(num1 double, num2 double) 
returns double
deterministic 
begin
	return (num1+num2)/2;
end$$

select media(8, 9);

-- b. Crea una función que dado una base y un exponente devuelva el resultado
-- de la operación de potencia. Comprueba el resultado
delimiter $$
create function potencia(num1 int, num2 int) 
returns int
deterministic 
begin
    declare cont int default 0;
	declare result int default 1;
	while (cont < num2) do
        set result = result * num1;
        set cont = cont + 1;
    end while;
	return result;
end$$

select potencia(2, 4);

-- a. Realiza un procedimiento almacenado que solicite al usuario una cadena de
-- caracteres con su nombre. El procedimiento debe saludar al usuario
-- indicando el número de veces que ha sido invocado dicho procedimiento. Por
-- ejemplo: “Hola Pedrito, has llamado al procedimiento 6 vece(s)”. Si la cadena
-- está vacía debes mostrar un mensaje del tipo “El valor no puede estar vacío”
-- y resetea el valor del contador a 0.
delimiter $$
create procedure nombre_veces(in nombre varchar(250), inout contador int) begin
	select concat_ws(' ', 'Hola', nombre, 'has llamado a este procedimiento', contador, 'veces') as saludo;
	set contador = contador + 1;
end$$
delimiter ;

set @contador=1;
call nombre_veces('Mario', @contador);

-- a. Crea un trigger que salte al insertar un registro en la tabla Alumno. Este triger
-- debe introducir en el campo edad de la tabla alumno la edad calculada dada
-- la fecha de nacimiento.
/*
delimiter $$
Create trigger actualizarEdad before insert on alumno for each row begin
	set new.edad = datediff(now(), fecha_nacimiento)/365;
end$$
delimiter ;
*/

insert into alumno (nombre_alumno, fecha_nacimiento, edad) values ('Paco', '2005-03-08', 18);
insert into alumno (nombre_alumno, fecha_nacimiento, edad) values ('Juan', '2005-03-08', 17);
insert into alumno (nombre_alumno, fecha_nacimiento, edad) values ('Pepe', '2005-03-08', 24);

select * from alumno;

-- b. Crea un trigger que cuando se elimine un alumno se introduzca en una tabla
-- espejo llamada “alumnos_eliminados”
delimiter $$
Create trigger historialBorrado before delete on alumno for each row begin
	insert into alumnos_eliminados values (old.id, old.nombre_alumno, old.fecha_nacimiento, old.edad);
end$$
delimiter ;

select * from alumno;
delete from alumno;
select * from alumnos_eliminados;

-- a. Recorre la tabla alumno mostrando un mensaje del tipo “Tu nombre es:
-- nombre_del_alumno_en_mayusculas y tienes edad años”, solo para aquellos
-- alumnos mayores de edad.
delimiter $$
create procedure nombre_alumnos_edad() begin
		-- Variables
    declare fin boolean default false;
    declare nombre varchar(255);
    
    -- Cursor
    declare cursor_alumnos cursor for (select nombre_alumno from alumno);
    
    -- Handler
    declare continue handler for not found set fin = true;
    
    -- Abrir cursor
    open cursor_alumnos;
    
    -- Recorrer cursor
    bucle: loop
		fetch cursor_alumnos into nombre;
        if fin = true then
			leave bucle;
		end if;
        
        if edad >= 18 then
			select concat_ws(' ', 'Tu nombre es:', nombre_alumno, 'y tienes', edad) as saludo;
        end if;
        
    end loop;
  
	-- Cerrar cursor
    close cursor_alumnos;
end$$
delimiter ;

call nombre_alumnos_edad();

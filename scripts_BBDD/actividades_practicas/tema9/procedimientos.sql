drop database if exists pl_sql;
create database pl_sql;
use pl_sql;

create table alumno(
	id bigint auto_increment primary key,
    nombre_alumno varchar(255)
);

-- Haz un procedimiento que dado tu nombre diga
-- "Hola tu_nombre tiene x letras"
delimiter $$
create procedure letras_nombre(in nombre varchar(250)) begin
		Select concat_ws(' ', 'Hola', nombre, 'tu nombre tiene', length(nombre), 'letras');
end$$
delimiter ;

set @nombre = 'Mario';
call letras_nombre(@nombre);

-- Un procedimiento que inserte nombres en la tabla alumno
delimiter $$
create procedure insert_data(in nombre varchar(255)) begin
    insert into alumno (nombre_alumno) values
        (nombre);
end$$
delimiter ;

call insert_data('Juan');
call insert_data('Carlos');
call insert_data('Ana');
call insert_data('Maria');
call insert_data('Jose Maria');
call insert_data('Juliana');


-- Un procedimiento que salude a todos los usuarios
delimiter $$
create procedure saluda_alumnos() begin 
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
        
	select concat_ws(' ', 'Hola', nombre) as saludo;
    end loop;
    
    -- Cerrar cursor
    close cursor_alumnos;
    
end $$
delimiter ;

call saluda_alumnos();

-- Crea un procedimiento que por cada nombre de la tabla
-- alumnos muestre un mensaje del tipo Hola nombre_alumno
-- tu nombre tiene x letras para aquellos que terminan por a
-- muestra ademas un mensaje al final diciendo las veces que
-- se ha ejecutado el procedimiento

delimiter $$
create procedure nombre_alumnos_letras(inout contador bigint) begin
		-- Variables
    declare fin boolean default false;
    declare nombre varchar(255);
    declare veces bigint default 0;
    
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
        
        if nombre like '%a' then
			select concat_ws(' ', 'Hola', nombre, 'tu nombre tiene', length(nombre), 'letras. Has llamado a este procedimiento', contador, 'veces') as saludo;
        end if;
        
    end loop;
  
	-- Cerrar cursor
    close cursor_alumnos;
    
    set contador = contador + 1;
    
end$$
delimiter ;

set @contador=0;
call nombre_alumnos_letras(@contador);

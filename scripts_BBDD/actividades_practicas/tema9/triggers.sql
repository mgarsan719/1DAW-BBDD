-- Cabecera
drop database if exists pl_sql;
create database pl_sql;
use pl_sql;

create table alumno(
	id bigint auto_increment primary key,
    nombre_alumno varchar(255),
    usuario varchar (255),
    fechaCreacion date,
    fechaModificacion date
);

create table historial_cambios_alumno(
	id bigint auto_increment primary key,
    id_alumno bigint,
    nombre_antiguo varchar(255),
    nombre_actual varchar(255),
    fecha_modificacion date
);

-- Ejemplo estructura trigger
-- que antes de insertar datos se cambien a mayuscula
delimiter $$
Create trigger ejemplo_1 before insert on alumno for each row begin
	set new.nombre_alumno = upper(new.nombre_alumno);
    
end$$
delimiter ;

-- que inserte el nombre del usuario que crea al alumno y la fecha en la que se crea
delimiter $$
Create trigger auditoria before insert on alumno for each row begin
	set new.usuario = current_user();
	set new.fechaCreacion = current_date();
    
end$$
delimiter ;

insert into alumno (nombre_alumno) values ('Juan Palmilla');
select * from alumno;

-- al modificar un dato del usuario, se modifica la fecha
delimiter $$
Create trigger fechaMod before update on alumno for each row begin
	set new.fechaModificacion = current_date();
    
end$$
delimiter ;

update alumno a set a.nombre_alumno='Juan de la Palmilla'
where id=1;
select * from alumno;

-- en la tabla historial_cambios_alumno que se actualice con los datos de modificacion al modificar alumno
delimiter $$
Create trigger historial_cambios after update on alumno for each row begin
    insert into historial_cambios_alumno values (old.id, old.nombre_antiguo, new.nombre_actual, now());
end$$
delimiter ;

update alumno a set a.nombre_alumno='Juan de la Palmilla el mejor'
where id=1;
select * from historial_cambios_alumno;
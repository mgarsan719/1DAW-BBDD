-- Cabecera
drop database if exists pl_sql;
create database pl_sql;
use pl_sql;

-- Tablas
create table empleado(
	DNI char(9) primary key,
    Nombre VARCHAR(20) not null,
    Apellido1 varchar(20),
    Apellido2 varchar(20),
    Direccion varchar(20),
    Ciudad varchar(20),
    Municipio varchar(20),
    Cod_postal char(5),
    Sexo char(1),
    Fecha_nac date,
    
    constraint check_sexo check(upper(Sexo) in ('H', 'M'))
);

create table historial_salarial(
	DNI_empleado char(9),
    Salario decimal(6,2),
    Fecha_inicio date,
    Fecha_fin date,
    
	constraint pk_historialSalarial primary key (DNI_empleado, Salario, Fecha_inicio),
    constraint fk_historialSalarial_empleado foreign key (DNI_empleado) references empleado(DNI)
);

create table departamento(
	cod_dpto bigint primary key auto_increment,
    Nombre varchar(30) not null unique,
    DNI_jefe char(9),
    Presupuesto decimal(6,2) not null,
    
    constraint fk_departamento_empleado foreign key (DNI_jefe) references empleado(DNI)
);

create table universidad(
	Cod_univ bigint primary key auto_increment,
    Nombre varchar(30) not null,
    Ciudad varchar(20),
    Cod_postal char(5)
);

create table estudio(
	DNI_empl char(9),
    Cod_univ bigint,
    Fecha_fin date,
    Titulo varchar(30) not null,
    Especialidad varchar(30),
    
    constraint pk_estudio primary key(DNI_empl, cod_univ),
	constraint fk_estudio_empleado foreign key(DNI_empl) references empleado(DNI),
    constraint fk_estudio_universidad foreign key(Cod_univ) references universidad(cod_univ)
);

create table trabajo(
	Cod_trabajo bigint primary key auto_increment,
    Nombre varchar(20) not null,
    Salario_max decimal(6,2) not null,
    Salario_min decimal(6,2) not null
);

create table historial_laboral(
	DNI_empleado char(9),
    Cod_trabajo bigint,
    Cod_dpto bigint,
    Fecha_inicio date not null,
    Fecha_fin date,
    DNI_super char(9),
    
    constraint pk_historialLaboral primary key(DNI_empleado, Cod_trabajo, Cod_dpto),
    constraint fk_historialLaboral_empleado foreign key(DNI_empleado) references empleado(DNI),
    constraint fk_historialLaboral_trabajo foreign key(Cod_trabajo) references trabajo(Cod_trabajo),
	constraint fk_historialLaboral_dpto foreign key(Cod_dpto) references departamento(Cod_dpto),
	constraint fk_historialLaboral_empleadoSuper foreign key(DNI_super) references empleado(DNI)
);

-- Insercion de datos
describe empleado;
insert into empleado values
	('48563218J', 'Enrique', 'Huertas', 'Roldan', 'C/Huerta Daza Nº10', 'Sevilla', 'El Viso del Alcor', '41520', 'H', '2005-05-25'),
	('12045786A', 'Francisco' , 'Santos', 'de los Santos', 'C/Negrilla Nº45', 'Sevilla', 'Alcala', '41500', 'H', '2000-07-20'),
	('57864158P', 'Juan' , 'Gomez', 'Garcia', 'C/La Polilla Nº20', 'Malaga', 'La palmilla', '57820', 'H', '1980-03-15'),
-- 	('111222', 'Sergio' , 'Palma', 'Entrena', null, null, null, 'P', null), NO DEJA
-- 	('222333', 'Lucia' , 'Ortega', 'Plus', null, null, null, null, null), NO DEJA
	('11122233I', 'Sergio' , 'Palma', 'Entrena', null, null, null, null, 'H', null), -- SI DEJA
 	('22233344D', 'Lucia' , 'Ortega', 'Plus', null, null, null, null, null, null); -- SI DEJA

select * from empleado;

describe historial_salarial;
insert into historial_salarial values
	('48563218J', 1958.85, '2018-09-18', '2020-04-20'),
    ('48563218J', 2299.90, '2020-06-3', null),
    ('57864158P', 3000, '2023-01-12', null);
    
select * from historial_salarial;


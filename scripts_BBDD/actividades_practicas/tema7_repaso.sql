use banco;

-- Crea una tabla llamada reintegros con aquellos movimientos de tipo “Retirada cajero”
describe movimiento;

drop table reintegros;
create table reintegros as
select m.* from movimiento m
	join tipo_movimiento tm using (cod_tipo_mov)
where tm.descripcion = 'Retiro Cajero';

select * from reintegros;

-- Crea la tabla cuentas_clientes y almacena el nombre del cliente, el código de la cuenta y el saldo de la misma.
describe cuenta;
describe cliente;

create table cuenta_clientes
select concat_ws(' ', cl.nombre, cl.apellidos) nombre_cliente, c.cod_cuenta, c.saldo from cuenta c
join cliente cl using (cod_cliente);

select * from cuenta_clientes;

-- Elimina los clientes sin cuentas
select * from cliente;
select * from cuenta;

insert into cliente(apellidos, nombre, direccion) values
('de la Palmilla', 'Juan', 'La palmilla');

delete from cliente
where cod_cliente not in (select cod_cliente from cuenta);

-- Modifica el ID de un cliente que tenga cuentas asociadas. Debes de poder
-- hacerlo, para ello decide cómo va a implicar esto en el resto de tablas donde
-- se referencia dicho ID.
alter table cuenta
drop constraint cuenta_ibfk_1;

alter table cuenta
add constraint cuenta_ibfk_1 foreign key (cod_cliente) references cliente(cod_cliente) on update cascade;

update cliente
set cod_cliente = 55
where cod_cliente = 1;

-- 1.e Crea una tabla llamada movimientos_antiguos con aquellos movimientos
-- realizados hace más de cinco años. La información que almacenará será
-- importe, hora día año y descripción del tipo de movimiento.
create table movimientos_antiguos as
select m.importe, concat_ws(' ', m.hora, m.dia, m.anio) as hora_dia_anio, tm.descripcion from movimiento m
join tipo_movimiento tm using (cod_tipo_mov)
where anio < year(now()) - 5;

select * from movimientos_antiguos;

-- 3.c. Elimina los tipos de movimiento nunca utilizados
delete from tipo_movimiento tm
where tm.cod_tipo_mov not in (select m.cod_tipo_mov from movimiento m);

-- 3.d. Añade el prefijo OFF_ al nombre del cliente para aquellos clientes que no
-- realizan movimientos desde hace 2 años.
update cliente cl set cl.nombre = concat('OFF_', cl.nombre) 
where cl.cod_cliente in (
	select cu.cod_cliente from cuenta cu 
	where cu.cod_cuenta not in (
		select m.cod_cuenta 
		from movimiento m 
		where anio > year(now()) - 2
		)
    );

select * from cliente;

-- modificar el nombre del movimiento mas utilizado con _GOLD
update tipo_movimiento tm set descripcion = concat(descripcion, '_GOLD')
where tm.cod_tipo_mov = (
	select cod_tipo_mov 
    from movimiento
	group by cod_tipo_mov
	order by count(*) desc
	limit 1
	);

select * from tipo_movimiento;
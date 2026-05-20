show tables;

select * from cuenta;

select * from movimiento;

create table cuentas_sin_mov as
	select c.* from cuenta c
	left join movimiento m using (cod_cuenta)
	where m.cod_cuenta is null;
    
select * from movimiento;
select * from tipo_movimiento;

update cuenta set saldo = saldo*1.10 
where cod_cuenta in (
	select distinct cod_cuenta 
	from movimiento 
	where cod_tipo_mov not in (
		Select cod_tipo_mov 
		from tipo_movimiento tm 
		where tm.descripcion ="Retiro Cajero"
	)
);
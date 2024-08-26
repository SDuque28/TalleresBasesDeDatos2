CREATE OR REPLACE PROCEDURE transferir_dinero(
	p_cuenta_origen INTEGER,
	p_cuenta_destino INTEGER,
	p_monto NUMERIC
)
LANGUAGE plpgsql 
AS $$
DECLARE 
	v_saldo_origen NUMERIC;
	v_saldo_destino NUMERIC;
BEGIN
	--Obtenemos los saldos de las cuentas
	SELECT saldo INTO v_saldo_origen FROM Cuentas WHERE "id" = p_cuenta_origen;
	SELECT saldo INTO v_saldo_destino FROM Cuentas WHERE "id" = p_cuenta_destino;

	--Realizamos la transferencia
	UPDATE cuentas SET saldo = saldo - p_monto WHERE "id" = p_cuenta_origen;
	UPDATE cuentas SET saldo = saldo + p_monto WHERE "id" = p_cuenta_origen;
END;
$$;

begin;
insert into clientes(identificacion,nombre,edad,correo) 
values (0, 'Santiago Duque', 22, 'santiago.duquer@gmail.com'),
	   (1, 'Juan Pérez', 30, 'juan.perez@example.com'),
	   (2, 'María Gómez', 25, 'maria.gomez@example.com');
	  
insert into productos(codigo,nombre,stock,valor_unitario)
values (00, 'Aceite',true, 33),
	   (01, 'Arroz',false, 0),
	   (02, 'Huevos',true, 47);
	  
insert into pedidos(fecha,cantidad,valor_total,producto_id,cliente_id) 
values ('01/01/2001', 12,15.3, 00,0),
	   ('10/11/2014', 6,22.4, 01,2),
	   ('23/09/2020', 22,9.63, 02,1);
	  
savepoint restaurar_insert;

UPDATE pedidos SET cantidad = 7
WHERE producto_id = 00;

UPDATE pedidos SET valor_total = 85.2
WHERE cliente_id = 1;

DELETE FROM pedidos 
WHERE fecha = '01/01/2001';

rollback to savepoint restaurar_insert;
commit;
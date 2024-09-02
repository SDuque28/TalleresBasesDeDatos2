CREATE OR REPLACE PROCEDURE public.obtener_total_stock()
LANGUAGE plpgsql
AS $$
DECLARE 
	total_stock INTEGER := 0;
	v_nombre TEXT;
	v_cantidad INTEGER;
BEGIN
	FOR v_nombre, v_cantidad IN 
		SELECT nombre, stock FROM productos
	LOOP
		RAISE NOTICE 'El nombre del producto es: %', v_nombre;
		RAISE NOTICE 'El stock actual del producto es: %', v_cantidad;
		total_stock = total_stock + v_cantidad;
	END LOOP;
	RAISE NOTICE 'El total del Stock es: %',total_stock;
END;
$$;

call obtener_total_stock() 

CREATE OR REPLACE PROCEDURE public.generar_auditoria(in p_fecha_inicio date, in p_fecha_fin date)
LANGUAGE plpgsql
AS $$
DECLARE 
	factura_id INTEGER;
	factura_estado VARCHAR;
	v_fecha date;
BEGIN
	FOR factura_id, factura_estado, v_fecha IN 
		SELECT id, estado, fecha FROM pedidos
	LOOP
		IF v_fecha >= p_fecha_inicio AND v_fecha <= p_fecha_fin THEN
			INSERT INTO auditoria(fecha_inicio, fecha_fin, factura_id, pedido_estado) VALUES (p_fecha_inicio, p_fecha_fin, factura_id, factura_estado);
		END IF;
	END LOOP;
END;
$$;

call generar_auditoria('2000-01-01'::date,'2014-12-12'::date);
select * from 

create or replace procedure simular_ventas_mes()
language plpgsql
as $$
declare
	v_dia integer := 1;
	v_identificacion int2;
	v_total int;
begin
	while v_dia <= 30 loop
		for v_identificacion in 
			select identificacion from clientes
		loop
			v_total := FLOOR(RANDOM() * 10 + 1)::INT;
			insert into pedidos values (CURRENT_DATE, v_total, v_total * 33.1, 0, v_identificacion,'PENDIENTE',3 + v_dia);
			v_dia := v_dia + 1;
		end loop;
	end loop;
end;
$$;

call simular_ventas_mes(); 
CREATE OR REPLACE PROCEDURE public.verificar_stock(IN p_producto_id integer, IN p_catidad_compra integer)
 LANGUAGE plpgsql
AS $$
DECLARE 
	stock_producto NUMERIC;
	total NUMERIC;
BEGIN
	--Obtenemos los saldos de las cuentas
	SELECT stock INTO stock_producto FROM productos WHERE codigo = p_producto_id;
	total = stock_producto - p_catidad_compra;
	IF total >= 0 THEN 
		RAISE NOTICE 'Hay suficiente stock';
	ELSE
		RAISE NOTICE 'No hay suficiente stock';
	END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE public.actualizar_estado_pedido(IN p_factura_id integer, IN p_nuevo_estado varchar)
 LANGUAGE plpgsql
AS $$
DECLARE 
	estado_pedido varchar;
BEGIN
	--Obtenemos los saldos de las cuentas
	SELECT estado INTO estado_pedido FROM pedidos WHERE id = p_factura_id;
	IF estado_pedido =  p_nuevo_estado THEN 
		IF p_nuevo_estado = 'ENTREGADO' THEN
			RAISE NOTICE 'El pedido ya fue entregado';
		ELSIF p_nuevo_estado = 'BLOQUEADO' THEN
			RAISE NOTICE 'El pedido ya esta bloqueado';
		ELSIF p_nuevo_estado = 'PENDIENTE' THEN
			RAISE NOTICE 'El pedido ya esta pendiente';
		END IF;
	ELSE
		UPDATE pedidos SET estado = p_nuevo_estado
		WHERE id = p_factura_id;
		RAISE NOTICE 'Se actualizo el estado del pedido';
	END IF;
END;
$$;

select * from pedidos;
call actualizar_estado_pedido(1,'BLOQUEADO');
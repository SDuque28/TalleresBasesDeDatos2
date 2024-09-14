-- Taller 8
create or replace procedure generar_clientes()
language plpgsql
as $$
DECLARE
    v_identificacion INT4;
    v_nombre TEXT;
    v_edad INT2;
    v_correo TEXT;
begin
	for i in 0..49 loop
        v_identificacion := i;  
        v_nombre := 'santiago' || i; 
        v_edad := trunc(random() * 82 + 18)::INT2; 
        v_correo := 'santiago' || i || '@gmail.com'; 
        
        INSERT INTO clientes (identificacion, nombre, edad, correo)
        VALUES (v_identificacion, v_nombre, v_edad, v_correo);
	end loop;
end;
$$;

call generar_clientes() 

CREATE OR REPLACE PROCEDURE insertar_facturas()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    v_producto VARCHAR;
    v_fecha DATE;
	v_cantidad INT2;
	v_valor_unitario INT2;
    v_total NUMERIC;
    v_usuario_id INT2;
BEGIN
    FOR i IN 0..49 LOOP
        -- Generate data
        v_producto := 'Producto ' || i; 
        v_fecha := date '2024-01-01' + trunc(random() * 365)::INT;
		v_cantidad := trunc(random() * 30 + 1)::INT;
		v_valor_unitario := trunc(random() * 500 + 1)::INT;
        v_total := v_cantidad * v_valor_unitario; 
        v_usuario_id := i;  

        INSERT INTO factura 
        VALUES (i, v_fecha, v_producto, v_cantidad, v_valor_unitario, v_total, v_usuario_id);
    END LOOP;
END;
$$;

call insertar_facturas()

CREATE OR REPLACE PROCEDURE prueba_idetificacion_unica()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO clientes VALUES (0,'Santiago',22,'correo@example.com');
EXCEPTION
	WHEN unique_violation THEN
		ROLLBACK;
		RAISE NOTICE 'Error al insertar el registro %',SQLERRM;
END;
$$;

call prueba_idetificacion_unica();

CREATE OR REPLACE PROCEDURE prueba_cliente_debe_existir()
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO factura VALUES (50,CURRENT_DATE,'producto 50',16,300,4800,0);
	INSERT INTO factura VALUES (51,CURRENT_DATE,'producto 50',16,300,4800,50);
EXCEPTION
	WHEN foreign_key_violation THEN
		ROLLBACK;
		RAISE NOTICE 'Error por el foreig key %',SQLERRM;
		INSERT INTO clientes VALUES (50,'santiago50',22,'santiago50@gmail.com');
END;
$$;

call prueba_cliente_debe_existir();
create or replace function calcular_area_circulo(p_radio numeric)
returns numeric as 
	$$
	declare
		v_area numeric;
	begin 
		v_area := 3.14159 * p_radio * p_radio;
		return v_area;
	end
	$$
language plpgsql;

select calcular_area_circulo(10) as "Calculo";

create or replace procedure generar_clientes(in num_clientes integer)
language plpgsql
as $$
DECLARE
    v_identificacion INT4;
    v_nombre TEXT;
    v_edad INT2;
    v_correo TEXT;
begin
	for i in 3..num_clientes +  3 loop
        v_identificacion := i;  
        v_nombre := 'santiago' || i; 
        v_edad := trunc(random() * 82 + 18)::INT2; 
        v_correo := 'santiago' || i || '@gmail.com'; 
        
        INSERT INTO clientes (identificacion, nombre, edad, correo)
        VALUES (v_identificacion, v_nombre, v_edad, v_correo);
	end loop;
end;
$$;

call generar_clientes(50);

CREATE OR REPLACE PROCEDURE insertar_servicios()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    v_ser_id INT;
    v_tipo VARCHAR;
    v_monto NUMERIC;
    v_cuota INT2;
    v_intereses INT4;
    v_valor_total NUMERIC;
    v_estado VARCHAR;
    v_cliente_id INT4;
    v_estados VARCHAR[] := ARRAY['pago', 'no_pago', 'pendiente_pago'];
BEGIN
    FOR i IN 0..149 LOOP
        v_ser_id := i;
        v_tipo := 'tipo' || i;
        v_monto := trunc(random() * (100000 - 1000) + 1000)::NUMERIC;
        v_cuota := trunc(random() * 13)::INT2; 
        v_intereses := trunc(random() * 20 + 1)::INT4;
        v_valor_total := v_monto + (v_monto * v_intereses / 100); 
        v_estado := v_estados[trunc(random() * 3 + 1)::INT]; 
        v_cliente_id := (i / 3)::INT4;
        
        INSERT INTO servicios (ser_id, tipo, monto, cuota, intereses, valor_total, estado, cliente_id)
        VALUES (v_ser_id, v_tipo, v_monto, v_cuota, v_intereses, v_valor_total, v_estado, v_cliente_id);
    END LOOP;
END;
$$;

call insertar_servicios();

CREATE OR REPLACE PROCEDURE insertar_pagos()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
    v_codigo_transaccion INT4;
    v_fecha_pago DATE;
    v_total NUMERIC;
    v_servicio_id INT2;
BEGIN
    FOR i IN 0..49 LOOP
        -- Generate data
        v_codigo_transaccion := trunc(random() * 90000000 + 10000000)::INT4; 
        v_fecha_pago := date '2024-01-01' + trunc(random() * 365)::INT;  
        v_total := trunc(random() * (100000 - 1000) + 1000)::NUMERIC; 
        v_servicio_id := i;  

        INSERT INTO pagos (pa_id, codigo_transaccion, fecha_pago, total, servicio_id)
        VALUES (i, v_codigo_transaccion, v_fecha_pago, v_total, v_servicio_id);
    END LOOP;
END;
$$;

call insertar_pagos(); 

CREATE OR REPLACE FUNCTION transacciones_total_mes(p_mes INT, p_id_cliente INT4)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_mes NUMERIC := 0;
BEGIN
    SELECT COALESCE(SUM(p.total), 0)
    INTO v_total_mes
    FROM pagos p
    INNER JOIN servicios s ON p.servicio_id = s.ser_id
    WHERE s.cliente_id = p_id_cliente
    AND EXTRACT(MONTH FROM p.fecha_pago) = p_mes;

    RETURN v_total_mes;
END;
$$;

select transacciones_total_mes(6,0) as "Transacciones";
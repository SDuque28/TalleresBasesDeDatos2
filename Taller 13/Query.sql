CREATE TABLE public.facturas (
	id_factura serial4 NOT NULL,
	codigo int4 NULL,
	cliente varchar NULL,
	producto varchar NULL,
	descuento int2 NULL,
	valor_toal float4 NULL,
	numero_fe int2 NULL,
	CONSTRAINT facturas_pk PRIMARY KEY (id_factura)
);

create sequence codigo_facturacion
start with 1 increment by 1;

create sequence codigo_facturacion_electronica
start with 100 increment by 100;


CREATE OR REPLACE PROCEDURE generar_facturas()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
	v_cliente VARCHAR;
	v_producto VARCHAR;
    v_descuento INT;
    v_valor_total FLOAT4;
BEGIN
    FOR i IN 1..10 LOOP
        v_cliente := 'cliente ' || i;
		v_producto := 'producto ' || i;
        v_descuento := FLOOR(RANDOM() * (90 - 10 + 1)) + 10;
        v_valor_total := RANDOM() * (50000 - 20000) + 20000;

        INSERT INTO facturas VALUES (i, nextval('codigo_facturacion'), v_cliente, v_producto, v_descuento, v_valor_total, nextval('codigo_facturacion_electronica'));
    END LOOP;
END;
$$;

call generar_facturas(); 

-- Taller 15
CREATE TABLE public.factura_json (
	codigo serial NOT NULL,
	descripcion jsonb NULL,
	CONSTRAINT factura_json_pk PRIMARY KEY (codigo)
);

insert into factura_json(descripcion) 
values ('{"cliente": "Santiago", "identificación": "1002609206", "dirección":"Palermo", "código": "2150", "total_descuento": 42100, "total_factura": 53120 , "cantidad": 2, "valor": 600, "producto": {"nombre": "Papa", "descripción": "Tuberculo", "precio": 300, "categorías": ["Sting 1","Sting 2","Sting 3"]}}');

create or replace procedure guardar_factura_json(p_descripcion jsonb)
language plpgsql
as $$
declare
    total_factura numeric;
    total_descuento numeric;
begin
    total_factura := (p_descripcion->>'total_factura')::numeric;
    total_descuento := (p_descripcion->>'total_descuento')::numeric;

    if total_factura > 10000 then
        raise exception 'El total de la factura no puede superar los 10,000 dólares. valor recibido: %', total_factura;
    end if;

    if total_descuento > 50 then
        raise exception 'El descuento máximo permitido es de 50 dólares. valor recibido: %', total_descuento;
    end if;

    insert into factura_json(descripcion) values (p_descripcion);
    
end;
$$;

call guardar_factura_json('{"cliente": "Daniela", "identificación": "1003628566", "dirección":"La Cumbre", "código": "1120", "total_descuento": 40, "total_factura": 8000, "cantidad": 3, "valor": 1200, "producto": {"nombre": "Manzana", "descripción": "Fruta", "precio": 400, "categorías": ["Sting 1","Sting 2","Sting 3"]}}'::jsonb);

create or replace procedure actualizar_factura_json(
    p_codigo int,
    p_descripcion jsonb
)
language plpgsql
as $$
begin
    if not exists (select 1 from factura_json where codigo = p_codigo) then
        raise exception 'la factura con el codigo % no existe.', p_codigo;
    end if;

    update factura_json set descripcion = p_descripcion where codigo = p_codigo;

end;
$$;

call actualizar_factura_json(2,'{"cliente": "Carlos", "identificación": "2008609206", "dirección":"Centro", "código": "2151", "total_descuento": 35, "total_factura": 8000, "cantidad": 3, "valor": 1000, "producto": {"nombre": "Manzana", "descripción": "Fruta", "precio": 500, "categorías": ["Fruta","Comida saludable"]}}'::jsonb);

create or replace function obtener_nombre_cliente(p_identificacion text)
returns text
language plpgsql
as $$
declare
    nombre_cliente text;
begin
    select descripcion->>'cliente' as Cliente
    into nombre_cliente from factura_json
    where descripcion->>'identificación' = p_identificacion;

    if nombre_cliente is null then
        raise exception 'No se encontró un cliente con la identificación %', p_identificacion;
    end if;

    return nombre_cliente;
end;
$$;

select obtener_nombre_cliente('1002609206') as Nombre;

create or replace function obtener_facturas_json()
returns table (
    cliente text,
    identificacion text,
    codigo_factura int,
    total_descuento numeric,
    total_factura numeric
)
language plpgsql
as $$
begin
    return query
    select 
        descripcion->>'cliente' as cliente,
        descripcion->>'identificación' as identificacion,
        codigo as codigo_factura,
        (descripcion->>'total_descuento')::numeric as total_descuento,
        (descripcion->>'total_factura')::numeric as total_factura
    from factura_json;
end;
$$;

select * from obtener_facturas_json();

create or replace function obtener_productos_por_factura(p_codigo_factura int)
returns table (
    nombre_producto text,
    descripcion_producto text,
    precio_producto numeric,
    categorias text
)
language plpgsql
as $$
begin
    return query
    select 
        descripcion->'producto'->>'nombre' as nombre_producto,
        descripcion->'producto'->>'descripción' as descripcion_producto,
        (descripcion->'producto'->>'precio')::numeric as precio_producto,
        (descripcion->'producto'->'categorías')::text as categorias
    from factura_json
    where codigo = p_codigo_factura;
end;
$$;

select * from obtener_productos_por_factura(1);
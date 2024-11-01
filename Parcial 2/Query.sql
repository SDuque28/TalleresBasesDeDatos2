-- ** Parcial 2 **
-- Primera Pregunta
CREATE TABLE public.usuarios (
	id serial NOT NULL,
	nombre varchar NULL,
	direccion varchar NULL,
	email varchar NULL,
	fecha_registro date NULL,
	estado varchar NULL,
	CONSTRAINT usuarios_pk PRIMARY KEY (id)
);

CREATE TABLE public.tarjetas (
	id serial NOT NULL,
	numero_tarjeta varchar NULL,
	fecha_expiracion date NULL,
	cvv smallint NULL,
	tipo_tarjeta varchar NULL,
	CONSTRAINT tarjetas_pk PRIMARY KEY (id)
);

CREATE TABLE public.productos (
	id serial4 NOT NULL,
	codigo_producto varchar NULL,
	nombre varchar NULL,
	categoria varchar NULL,
	porcentaje_impuesto int2 NULL,
	precio numeric NULL,
	CONSTRAINT productos_pk PRIMARY KEY (id)
);

CREATE TABLE public.pagos (
	id serial NOT NULL,
	codigo_pago varchar NULL,
	fecha date NULL,
	estado varchar NULL,
	monto numeric NULL,
	producto_id integer NULL,
	tarjeta_id integer NULL,
	usuario_id integer NULL,
	CONSTRAINT pagos_pk PRIMARY KEY (id),
	CONSTRAINT pagos_usuarios_fk FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id),
	CONSTRAINT pagos_tarjetas_fk FOREIGN KEY (tarjeta_id) REFERENCES public.tarjetas(id),
	CONSTRAINT pagos_productos_fk FOREIGN KEY (producto_id) REFERENCES public.productos(id)
);

CREATE TABLE public.comprobantes_json (
	id serial4 NOT NULL,
	detalles varchar NULL,
	CONSTRAINT comprobantes_json_pk PRIMARY KEY (id)
);

CREATE TABLE public.comprobantes_xml (
	id int4 DEFAULT nextval('comprobantes_pago_id_seq'::regclass) NOT NULL,
	detalles xml NULL,
	CONSTRAINT comprobantes_pago_pk PRIMARY KEY (id)
);

create or replace function obtener_pagos_usuario(p_usuario_id Integer, p_fecha Date)
returns table(codigo_pago varchar, nombre_producto varchar, monto numeric, estado varchar)
as $$
begin
    return query
    select p.codigo_pago, pr.nombre, p.monto, p.estado
    from pagos p 
		join usuarios u on u.id = p.usuario_id
		join productos pr on pr.id = p.producto_id
	where p.fecha = p_fecha and u.id = p_usuario_id;
end;
$$ language plpgsql;

select * from obtener_pagos_usuario(1,'2024-01-11'::Date)

create or replace function obtener_tarjetas_usuario(p_usuario_id Integer)
returns table(nombre_usuario varchar, email varchar, numero_tarjeta varchar, cvv int2, tipo_tarjeta varchar)
as $$
begin
    return query
    select u.nombre, u.email, t.numero_tarjeta, t.cvv, t.tipo_tarjeta
    from pagos p 
		join usuarios u on u.id = p.usuario_id
		join tarjetas t on t.id = p.tarjeta_id
		join productos pr on pr.id = p.producto_id
	where p.monto > 1000 and u.id = p_usuario_id;
end;
$$ language plpgsql;

select * from obtener_tarjetas_usuario(1)

-- Punto 2 
create or replace function obtener_tarjetas_con_detalle(p_usuario_id integer)
returns varchar 
as $$
declare
    tarjeta_cursor cursor for
        select t.numero_tarjeta, t.fecha_expiracion, u.nombre, u.email
        from pagos p 
			join usuarios u on u.id = p.usuario_id
			join tarjetas t on t.id = p.tarjeta_id
        where u.id = p_usuario_id;
    tarjeta_record record;
    resultado varchar := '';
begin
    open tarjeta_cursor;
    loop
        fetch tarjeta_cursor into tarjeta_record;
        exit when not found;
        resultado := resultado || 'número de tarjeta: ' || tarjeta_record.numero_tarjeta || ', ' ||
            'fecha expiración: ' || tarjeta_record.fecha_expiracion || ', ' || 'nombre: ' || tarjeta_record.nombre || ', ' ||
            'email: ' || tarjeta_record.email || '; ';
    end loop;
    
    close tarjeta_cursor;
    return resultado;
end;
$$ language plpgsql;

select obtener_tarjetas_con_detalle(1);

create or replace function obtener_pagos_menores(p_fecha date)
returns varchar 
as $$
declare
    pagos_menores cursor for
        select p.monto, p.estado, pr.nombre, pr.porcentaje_impuesto, u.direccion, u.email
        from pagos p 
			join usuarios u on u.id = p.usuario_id
			join productos pr on pr.id = p.producto_id
        where p.fecha = p_fecha and p.monto < 1000;
    pagos_record record;
    resultado varchar := '';
begin
    open pagos_menores;
    loop
        fetch pagos_menores into pagos_record;
        exit when not found;
        resultado := resultado || 'Monto: ' || pagos_record.monto || ', Estado:' || pagos_record.estado || 
							   ', Nombre: ' || pagos_record.nombre || ', Porcentaje Impuesto: ' || pagos_record.porcentaje_impuesto || 
							  ', Direccion' || pagos_record.direccion || ', Email: ' || pagos_record.email || ';';
    end loop;
    
    close pagos_menores;
    return resultado;
end;
$$ language plpgsql;

select obtener_pagos_menores('2024-01-11'::Date)

create or replace procedure guardar_xml(p_detalles varchar)
as $$
begin
    insert into comprobantes_xml(detalles) values (xmlparse(document p_detalles));
end;
$$ language plpgsql;

call guardar_xml('<pago>
					<codigoPago>12345</codigoPago>
					<nombreUsuario>Santiago</nombreUsuario>
					<numeroTarjeta>435676554</numeroTarjeta>
					<nombreProducto>Proteina</nombreProducto>
					<montoPago>11500</montoPago>
				</pago>');


create or replace procedure guardar_Json(p_detalles varchar)
as $$
begin
    insert into comprobantes_json(detalles) values (p_detalles);
end;
$$ language plpgsql;

call guardar_json('{emailUsuario:"email@ejemplo.com",numeroTarjeta:65416531,tipoTarjeta:"Visa",codigoProducto:54321654,codigoPago:84651654,montoPago:11500}');

create or replace function validaciones_producto()
returns trigger as $$
begin
    if new.precio < 0 or new.precio < 20000 then
        raise exception 'El precio debe estar entre 0 y 20000';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger trg_validar_productos
before insert on public.productos 
for each row
execute procedure validaciones_producto();

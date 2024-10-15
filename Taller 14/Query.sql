CREATE TABLE public.libros (
	isbn serial4 NOT NULL,
	descripcion xml NULL,
	CONSTRAINT libros_pk PRIMARY KEY (isbn)
);

insert into libros(descripcion) 
values (xmlparse(document '<libros><libro><titulo>100 años de soledad</titulo><autor>Garcia Marques</autor><año>1948</año></libro></libros>'));

CREATE OR REPLACE PROCEDURE guardar_libro(p_descripcion xml)
AS $$
DECLARE
    v_titulo text;
    v_count  int;
BEGIN
    SELECT 
        unnest(xpath('//libro/titulo/text()',p_descripcion))::text
    INTO 
        v_titulo;
    
    SELECT COUNT(*) INTO v_count
    FROM libros, xmltable('/libros/libro' passing descripcion columns titulo text path 'titulo') as l
    WHERE l.titulo = v_titulo;
    
    IF v_count = 0 THEN
        INSERT INTO libros (descripcion) VALUES (p_descripcion);
    ELSE
        RAISE EXCEPTION 'El título del libro "%" ya existe en la tabla.', v_titulo;
    END IF;
END;
$$ LANGUAGE plpgsql;

call guardar_libro(xmlparse(document '<libros><libro><titulo>Old news</titulo><autor>George Orwell</autor><año>1949</año></libro></libros>'));

create or replace procedure actualizar_libro(p_libro_id integer, p_libro varchar)
language plpgsql
as $$
begin 	
	update libros set descripcion = xmlparse(document p_libro) where isbn = p_libro_id;
end;
$$;

call actualizar_libro(2,'<libros><libro><titulo>Old news</titulo><autor>George Orwell</autor><año>1948</año></libro></libros>');

create or replace function obtener_autor_libro_por_isbn(p_libro_id integer)
returns text
as $$
declare
	v_autor text;
begin 	
	select unnest(xpath('//libro/autor/text()',descripcion))::text into v_autor from libros where isbn = p_libro_id;
	return v_autor;
end;
$$ language plpgsql;

select obtener_autor_libro_por_isbn(2) as Autor;

create or replace function obtener_autor_libro_por_titulo(p_titulo varchar)
returns text
as $$
declare
	v_autor text;
begin 	
	select l.autor into v_autor 
		from libros, xmltable('/libros/libro' passing descripcion columns titulo text path 'titulo',autor text path 'autor')
		as l where titulo = p_titulo;
	return v_autor;
end;
$$ language plpgsql;

select obtener_autor_libro_por_titulo('El Quijote') as Autor;

create or replace function obtener_libros_por_año(p_año varchar)
returns table(titulo text, autor text) 
as $$
begin
    return query
    select l.titulo, l.autor
    from libros, 
    xmltable('/libros/libro' passing descripcion
        columns 
            titulo text path 'titulo',
            autor text path 'autor',
            año text path 'año') as l
    where l.año = p_año;
end;
$$ language plpgsql;

select * from obtener_libros_por_año('1948') as Libros;
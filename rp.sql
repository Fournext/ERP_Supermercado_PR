PGDMP                       }            DB_supermarket    17.4    17.4 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    23496    DB_supermarket    DATABASE     v   CREATE DATABASE "DB_supermarket" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'es-MX';
     DROP DATABASE "DB_supermarket";
                     postgres    false            N           1255    23497 �   actualizar_lote(integer, integer, integer, character varying, character varying, character varying, character varying, numeric, character varying) 	   PROCEDURE     t  CREATE PROCEDURE public.actualizar_lote(IN p_id_lote integer, IN p_stock integer, IN p_stock_minimo integer, IN p_cod_repisa character varying, IN p_nombre_estado character varying, IN p_descripcion_producto character varying, IN p_cod_almacen character varying, IN p_costo_unitario numeric, IN p_fecha_caducidad character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_repisa INT;
    v_id_estado INT;
    v_id_producto INT;
    v_id_almacen INT;
BEGIN
    -- Validar que el lote existe
    IF NOT EXISTS (SELECT 1 FROM lote WHERE id_lote = p_id_lote) THEN
        RAISE EXCEPTION 'No existe un lote con id: %', p_id_lote;
    END IF;

    -- Obtener IDs relacionados
    SELECT id_repisa INTO v_id_repisa
    FROM repisa
    WHERE codigo = p_cod_repisa;

    IF v_id_repisa IS NULL THEN
        RAISE EXCEPTION 'Repisa no encontrada con código: %', p_cod_repisa;
    END IF;

    SELECT id_estado INTO v_id_estado
    FROM estado_lote
    WHERE nombre = p_nombre_estado;

    IF v_id_estado IS NULL THEN
        RAISE EXCEPTION 'Estado no encontrado: %', p_nombre_estado;
    END IF;

    SELECT id_producto INTO v_id_producto
    FROM producto
    WHERE descripcion = p_descripcion_producto;

    IF v_id_producto IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado: %', p_descripcion_producto;
    END IF;

    SELECT id_almacen INTO v_id_almacen
    FROM almacen
    WHERE codigo = p_cod_almacen;

    IF v_id_almacen IS NULL THEN
        RAISE EXCEPTION 'Almacén no encontrado: %', p_cod_almacen;
    END IF;

    -- Actualizar el lote
    UPDATE lote
    SET stock = p_stock,
        stock_minimo = p_stock_minimo,
        id_repisa = v_id_repisa,
        id_estado = v_id_estado,
        id_producto = v_id_producto,
        id_almacen = v_id_almacen,
        costo_unitario = p_costo_unitario,
        fecha_caducidad = p_fecha_caducidad
    WHERE id_lote = p_id_lote;
END;
$$;
 K  DROP PROCEDURE public.actualizar_lote(IN p_id_lote integer, IN p_stock integer, IN p_stock_minimo integer, IN p_cod_repisa character varying, IN p_nombre_estado character varying, IN p_descripcion_producto character varying, IN p_cod_almacen character varying, IN p_costo_unitario numeric, IN p_fecha_caducidad character varying);
       public               postgres    false            O           1255    23498 7   actualizar_nombre_categoria(integer, character varying) 	   PROCEDURE       CREATE PROCEDURE public.actualizar_nombre_categoria(IN p_id_categoria integer, IN p_nuevo_nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.categoria
    SET nombre = p_nuevo_nombre
    WHERE id_categoria = p_id_categoria;
END;
$$;
 s   DROP PROCEDURE public.actualizar_nombre_categoria(IN p_id_categoria integer, IN p_nuevo_nombre character varying);
       public               postgres    false            P           1255    23499 3   actualizar_nombre_marca(integer, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.actualizar_nombre_marca(IN p_id_marca integer, IN p_nuevo_nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.marca
    SET nombre = p_nuevo_nombre
    WHERE id_marca = p_id_marca;
END;
$$;
 k   DROP PROCEDURE public.actualizar_nombre_marca(IN p_id_marca integer, IN p_nuevo_nombre character varying);
       public               postgres    false            Q           1255    23500 ;   actualizar_nombre_tipo_producto(integer, character varying) 	   PROCEDURE        CREATE PROCEDURE public.actualizar_nombre_tipo_producto(IN p_id_tipo integer, IN p_nuevo_nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.tipo_producto
    SET nombre = p_nuevo_nombre
    WHERE id_tipo = p_id_tipo;
END;
$$;
 r   DROP PROCEDURE public.actualizar_nombre_tipo_producto(IN p_id_tipo integer, IN p_nuevo_nombre character varying);
       public               postgres    false            R           1255    23501 ,   actualizar_precio_producto(integer, numeric) 	   PROCEDURE     �   CREATE PROCEDURE public.actualizar_precio_producto(IN p_id_producto integer, IN p_nuevo_precio numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public.precio
    SET precio_unitario = p_nuevo_precio
    WHERE id_producto = p_id_producto;
END;
$$;
 g   DROP PROCEDURE public.actualizar_precio_producto(IN p_id_producto integer, IN p_nuevo_precio numeric);
       public               postgres    false            S           1255    23502    actualizar_stock_lote()    FUNCTION     )  CREATE FUNCTION public.actualizar_stock_lote() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Solo actualizar si id_lote no es nulo
  IF NEW.id_lote IS NOT NULL THEN
    UPDATE lote
    SET stock = stock + NEW.cantidad
    WHERE id_lote = NEW.id_lote;
  END IF;

  RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.actualizar_stock_lote();
       public               postgres    false            T           1255    23503 1   actualizar_url_imagen(integer, character varying) 	   PROCEDURE     �   CREATE PROCEDURE public.actualizar_url_imagen(IN p_id_imagen integer, IN p_url character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE producto_imagen
    SET url = p_url
    WHERE id_imagen = p_id_imagen;
END;
$$;
 a   DROP PROCEDURE public.actualizar_url_imagen(IN p_id_imagen integer, IN p_url character varying);
       public               postgres    false            U           1255    23504 Z   cargarbitacora(character varying, character varying, character varying, character varying) 	   PROCEDURE     r  CREATE PROCEDURE public.cargarbitacora(IN p_username character varying, IN p_ip character varying, IN p_fecha character varying, IN p_descripcion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_usuario INT;
    v_max_id INT;
BEGIN
    -- Buscar el ID del usuario dado el username
    SELECT id_usuario INTO v_id_usuario
    FROM usuario
    WHERE username = p_username;

    IF v_id_usuario IS NULL THEN
        RAISE EXCEPTION 'Usuario no encontrado: %', p_username;
    END IF;

    -- Alinear la secuencia antes del insert
    SELECT COALESCE(MAX(id), 0) INTO v_max_id FROM bitacora;
    -- Reiniciar la secuencia al siguiente valor disponible
    PERFORM setval('bitacora_id_seq', v_max_id + 1, false);

    -- Insertar en bitacora
    INSERT INTO bitacora(id_usuario, ip, fecha, descripcion)
    VALUES (v_id_usuario, p_ip, p_fecha, p_descripcion);
END;
$$;
 �   DROP PROCEDURE public.cargarbitacora(IN p_username character varying, IN p_ip character varying, IN p_fecha character varying, IN p_descripcion character varying);
       public               postgres    false            V           1255    23505 k   editar_producto_y_precio(integer, character varying, character varying, integer, integer, integer, numeric) 	   PROCEDURE     �  CREATE PROCEDURE public.editar_producto_y_precio(IN p_id_producto integer, IN p_codigo character varying, IN p_descripcion character varying, IN p_id_marca integer, IN p_id_categoria integer, IN p_id_tipo integer, IN p_precio_unitario numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Actualizar producto
    UPDATE producto
    SET 
        codigo = p_codigo,
        descripcion = p_descripcion,
        id_marca = p_id_marca,
        id_categoria = p_id_categoria,
        id_tipo = p_id_tipo
    WHERE id_producto = p_id_producto;

    -- Actualizar precio
    UPDATE precio
    SET precio_unitario = p_precio_unitario
    WHERE id_producto = p_id_producto;
END;
$$;
 �   DROP PROCEDURE public.editar_producto_y_precio(IN p_id_producto integer, IN p_codigo character varying, IN p_descripcion character varying, IN p_id_marca integer, IN p_id_categoria integer, IN p_id_tipo integer, IN p_precio_unitario numeric);
       public               postgres    false            8           1255    23506 )   eliminar_boleta_entrada_completa(integer) 	   PROCEDURE     '  CREATE PROCEDURE public.eliminar_boleta_entrada_completa(IN p_id_boleta_entrada integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
  detalle RECORD;
  existe_boleta BOOLEAN;
BEGIN
  -- Verificar si la boleta de entrada existe
  SELECT EXISTS (
    SELECT 1 FROM boleta_entrada WHERE id_boleta = p_id_boleta_entrada
  ) INTO existe_boleta;

  IF NOT existe_boleta THEN
    RAISE EXCEPTION 'La boleta de entrada con ID % no existe.', p_id_boleta_entrada;
  END IF;

  -- Recorremos los detalles asociados a la boleta
  FOR detalle IN
    SELECT id_lote, cantidad
    FROM detalle_boleta_entrada
    WHERE id_boleta_entrada = p_id_boleta_entrada
  LOOP
    IF detalle.id_lote IS NOT NULL THEN
      UPDATE lote
      SET stock = stock - detalle.cantidad
      WHERE id_lote = detalle.id_lote;
    END IF;
  END LOOP;

  -- Eliminar los detalles de la boleta
  DELETE FROM detalle_boleta_entrada
  WHERE id_boleta_entrada = p_id_boleta_entrada;

  -- Eliminar la boleta de entrada principal
  DELETE FROM boleta_entrada
  WHERE id_boleta = p_id_boleta_entrada;
END;
$$;
 X   DROP PROCEDURE public.eliminar_boleta_entrada_completa(IN p_id_boleta_entrada integer);
       public               postgres    false            9           1255    23507    eliminar_boleta_salida(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.eliminar_boleta_salida(IN p_id_boleta integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar que la boleta exista
    IF NOT EXISTS (SELECT 1 FROM boleta_salida WHERE id_boleta = p_id_boleta) THEN
        RAISE EXCEPTION 'No existe una boleta de salida con ID: %', p_id_boleta;
    END IF;

    -- Eliminar la boleta
    DELETE FROM boleta_salida
    WHERE id_boleta = p_id_boleta;
END;
$$;
 F   DROP PROCEDURE public.eliminar_boleta_salida(IN p_id_boleta integer);
       public               postgres    false            :           1255    23508    eliminar_lote(integer) 	   PROCEDURE     �  CREATE PROCEDURE public.eliminar_lote(IN p_id_lote integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar existencia
    IF NOT EXISTS (SELECT 1 FROM lote WHERE id_lote = p_id_lote) THEN
        RAISE EXCEPTION 'No existe el lote con ID: %', p_id_lote;
    END IF;

    -- Actualizar estado a "agotado" (id_estado = 2)
    UPDATE lote
    SET id_estado = 2
    WHERE id_lote = p_id_lote;
END;
$$;
 ;   DROP PROCEDURE public.eliminar_lote(IN p_id_lote integer);
       public               postgres    false            ;           1255    23509 #   existe_carrito_por_cliente(integer)    FUNCTION     2  CREATE FUNCTION public.existe_carrito_por_cliente(p_id_cliente integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM public.carrito
        WHERE id_cliente = p_id_cliente
    ) INTO existe;

    RETURN existe;
END;
$$;
 G   DROP FUNCTION public.existe_carrito_por_cliente(p_id_cliente integer);
       public               postgres    false            <           1255    23510 =   insertar_asignacion_permiso(integer, date, character varying) 	   PROCEDURE     (  CREATE PROCEDURE public.insertar_asignacion_permiso(IN p_id_personal integer, IN p_fecha date, IN p_motivo character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO asignacion_estado (fecha, motivo, id_personal, id_estado)
    VALUES (p_fecha, p_motivo, p_id_personal, 2);
END;
$$;
 }   DROP PROCEDURE public.insertar_asignacion_permiso(IN p_id_personal integer, IN p_fecha date, IN p_motivo character varying);
       public               postgres    false            >           1255    23511 [   insertar_backup(character varying, character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.insertar_backup(IN p_username character varying, IN p_nombre_archivo character varying, IN p_fecha character varying, IN p_tipo character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_usuario INT;
BEGIN
    -- Buscar el ID del usuario por username
    SELECT id_usuario INTO v_id_usuario
    FROM usuario
    WHERE username = p_username;

    IF v_id_usuario IS NULL THEN
        RAISE EXCEPTION 'Usuario no encontrado: %', p_username;
    END IF;

    -- Insertar en backup
    INSERT INTO backup (id_usuario, nombre_archivo, fecha, tipo)
    VALUES (v_id_usuario, p_nombre_archivo, p_fecha, p_tipo);
END;
$$;
 �   DROP PROCEDURE public.insertar_backup(IN p_username character varying, IN p_nombre_archivo character varying, IN p_fecha character varying, IN p_tipo character varying);
       public               postgres    false            ?           1255    23512 ;   insertar_boleta_salida(integer, integer, character varying) 	   PROCEDURE       CREATE PROCEDURE public.insertar_boleta_salida(IN p_id_lote integer, IN p_id_personal integer, IN p_fecha character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verificar existencia del lote
    IF NOT EXISTS (SELECT 1 FROM lote WHERE id_lote = p_id_lote) THEN
        RAISE EXCEPTION 'No existe lote con ID: %', p_id_lote;
    END IF;

    -- Verificar existencia del personal
    IF NOT EXISTS (SELECT 1 FROM personal WHERE id_personal = p_id_personal) THEN
        RAISE EXCEPTION 'No existe personal con ID: %', p_id_personal;
    END IF;

    -- Insertar la boleta de salida
    INSERT INTO boleta_salida (id_lote, id_personal, fecha)
    VALUES (p_id_lote, p_id_personal, p_fecha);

    UPDATE lote
    SET id_estado = 3
    WHERE id_lote = p_id_lote;
END;
$$;
 |   DROP PROCEDURE public.insertar_boleta_salida(IN p_id_lote integer, IN p_id_personal integer, IN p_fecha character varying);
       public               postgres    false            W           1255    23513 �   insertar_lote(integer, integer, character varying, character varying, character varying, character varying, numeric, character varying) 	   PROCEDURE       CREATE PROCEDURE public.insertar_lote(IN p_stock integer, IN p_stock_minimo integer, IN p_cod_repisa character varying, IN p_nombre_estado character varying, IN p_descripcion_producto character varying, IN p_cod_almacen character varying, IN p_costo_unitario numeric, IN p_fecha_caducidad character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_repisa INT;
    v_id_estado INT;
    v_id_producto INT;
    v_id_almacen INT;
BEGIN
    -- Obtener id_repisa por código
    SELECT id_repisa INTO v_id_repisa
    FROM repisa
    WHERE codigo = p_cod_repisa;

    IF v_id_repisa IS NULL THEN
        RAISE EXCEPTION 'Repisa no encontrada con código: %', p_cod_repisa;
    END IF;

    -- Obtener id_estado por nombre
    SELECT id_estado INTO v_id_estado
    FROM estado_lote
    WHERE nombre = p_nombre_estado;

    IF v_id_estado IS NULL THEN
        RAISE EXCEPTION 'Estado de lote no encontrado: %', p_nombre_estado;
    END IF;

    -- Obtener id_producto por descripción
    SELECT id_producto INTO v_id_producto
    FROM producto
    WHERE descripcion = p_descripcion_producto;

    IF v_id_producto IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado: %', p_descripcion_producto;
    END IF;

    -- Obtener id_almacen por código
    SELECT id_almacen INTO v_id_almacen
    FROM almacen
    WHERE codigo = p_cod_almacen;

    IF v_id_almacen IS NULL THEN
        RAISE EXCEPTION 'Almacén no encontrado con código: %', p_cod_almacen;
    END IF;

    -- Insertar en lote
    INSERT INTO lote (
        stock, stock_minimo, id_repisa, id_estado, id_producto,
        id_almacen, costo_unitario, fecha_caducidad
    )
    VALUES (
        p_stock, p_stock_minimo, v_id_repisa, v_id_estado,
        v_id_producto, v_id_almacen, p_costo_unitario, p_fecha_caducidad
    );
END;
$$;
 3  DROP PROCEDURE public.insertar_lote(IN p_stock integer, IN p_stock_minimo integer, IN p_cod_repisa character varying, IN p_nombre_estado character varying, IN p_descripcion_producto character varying, IN p_cod_almacen character varying, IN p_costo_unitario numeric, IN p_fecha_caducidad character varying);
       public               postgres    false            X           1255    23514 f   insertar_producto_con_precio(character varying, character varying, integer, integer, integer, numeric) 	   PROCEDURE     �  CREATE PROCEDURE public.insertar_producto_con_precio(IN p_codigo character varying, IN p_descripcion character varying, IN p_id_marca integer, IN p_id_categoria integer, IN p_id_tipo integer, IN p_precio_unitario numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_producto INTEGER;
BEGIN
    -- Insertar producto y obtener su ID
    INSERT INTO producto (codigo, descripcion, id_marca, id_categoria, id_tipo)
    VALUES (p_codigo, p_descripcion, p_id_marca, p_id_categoria, p_id_tipo)
    RETURNING id_producto INTO v_id_producto;

    -- Insertar precio para el producto recién creado
    INSERT INTO precio (precio_unitario, id_producto)
    VALUES (p_precio_unitario, v_id_producto);
END;
$$;
 �   DROP PROCEDURE public.insertar_producto_con_precio(IN p_codigo character varying, IN p_descripcion character varying, IN p_id_marca integer, IN p_id_categoria integer, IN p_id_tipo integer, IN p_precio_unitario numeric);
       public               postgres    false            Y           1255    23515    obtener_backups()    FUNCTION     �  CREATE FUNCTION public.obtener_backups() RETURNS TABLE(id integer, username character varying, nombre_archivo character varying, fecha character varying, tipo character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id,
        u.username,
        b.nombre_archivo,
        b.fecha,
        b.tipo
    FROM backup b
    JOIN usuario u ON b.id_usuario = u.id_usuario
    ORDER BY b.id DESC;
END;
$$;
 (   DROP FUNCTION public.obtener_backups();
       public               postgres    false            Z           1255    23516    obtener_boleta_salida(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_boleta_salida(p_id_boleta integer) RETURNS TABLE(id_boleta integer, lote_info character varying, nombre_personal character varying, fecha character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        bs.id_boleta,
        (l.id_lote || ' - ' || p.descripcion)::varchar AS lote_info,
        (pr.nombre || ' ' || pr.apellido)::varchar AS nombre_personal,
        bs.fecha::varchar
    FROM boleta_salida bs
    JOIN lote l ON bs.id_lote = l.id_lote
    JOIN producto p ON l.id_producto = p.id_producto
    JOIN personal pr ON bs.id_personal = pr.id_personal
    WHERE bs.id_boleta = p_id_boleta;
END;
$$;
 A   DROP FUNCTION public.obtener_boleta_salida(p_id_boleta integer);
       public               postgres    false            [           1255    23517    obtener_boletas_salida()    FUNCTION     �  CREATE FUNCTION public.obtener_boletas_salida() RETURNS TABLE(id_boleta integer, lote_info character varying, nombre_personal character varying, fecha character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        bs.id_boleta,
        (l.id_lote || ' - ' || p.descripcion)::varchar AS lote_info,
        (pr.nombre || ' ' || pr.apellido)::varchar AS nombre_personal,
        bs.fecha::varchar
    FROM boleta_salida bs
    JOIN lote l ON bs.id_lote = l.id_lote
    JOIN producto p ON l.id_producto = p.id_producto
    JOIN personal pr ON bs.id_personal = pr.id_personal
    ORDER BY bs.id_boleta DESC;
END;
$$;
 /   DROP FUNCTION public.obtener_boletas_salida();
       public               postgres    false            \           1255    23518     obtener_carrito_cliente(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_carrito_cliente(p_id_cliente integer) RETURNS TABLE(id_carrito integer, total numeric, estado character varying, fecha date, id_cliente integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    carrito_encontrado RECORD;
BEGIN
    SELECT *
    INTO carrito_encontrado
    FROM public.carrito c
    WHERE c.id_cliente = p_id_cliente
    ORDER BY c.id_carrito DESC
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró ningún carrito para el cliente con ID %', p_id_cliente;
    END IF;

    RETURN QUERY SELECT 
        carrito_encontrado.id_carrito,
        carrito_encontrado.total,
        carrito_encontrado.estado,
        carrito_encontrado.fecha,
        carrito_encontrado.id_cliente;
END;
$$;
 D   DROP FUNCTION public.obtener_carrito_cliente(p_id_cliente integer);
       public               postgres    false            ]           1255    23519 $   obtener_cliente_por_usuario(integer)    FUNCTION       CREATE FUNCTION public.obtener_cliente_por_usuario(p_id_usuario integer) RETURNS TABLE(id_cliente integer, nombre_cliente character varying, apellido_cliente character varying, carnet_cliente character varying, nit_cliente character varying, direccion_cliente character varying, id_usuario integer, estado_cliente_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cliente_encontrado RECORD;
BEGIN
    SELECT *
    INTO cliente_encontrado
    FROM public.cliente c
    WHERE c.id_usuario = p_id_usuario
    LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No se encontró ningún cliente para el usuario con ID %', p_id_usuario;
    END IF;

    RETURN QUERY SELECT 
        cliente_encontrado.id_cliente,
        cliente_encontrado.nombre_cliente,
        cliente_encontrado.apellido_cliente,
        cliente_encontrado.carnet_cliente,
        cliente_encontrado.nit_cliente,
        cliente_encontrado.direccion_cliente,
        cliente_encontrado.id_usuario,
        cliente_encontrado.estado_cliente_id;
END;
$$;
 H   DROP FUNCTION public.obtener_cliente_por_usuario(p_id_usuario integer);
       public               postgres    false            ^           1255    23520     obtener_detalles_boleta(integer)    FUNCTION       CREATE FUNCTION public.obtener_detalles_boleta(p_id_boleta_entrada integer) RETURNS TABLE(id_boleta integer, cantidad integer, id_boleta_entrada integer, id_producto integer, cantidad_comprada integer, costo_unitario numeric, id_lote integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    filas_encontradas INT;
BEGIN
  RETURN QUERY
  SELECT 
    d.id_boleta,
    d.cantidad,
    d.id_boleta_entrada,
    d.id_producto,
    d.cantidad_comprada,
    d.costo_unitario,
    d.id_lote
  FROM detalle_boleta_entrada d
  WHERE d.id_boleta_entrada = p_id_boleta_entrada;

  GET DIAGNOSTICS filas_encontradas = ROW_COUNT;

  IF filas_encontradas = 0 THEN
    RAISE EXCEPTION 'No se encontraron detalles para la boleta de entrada con id %', p_id_boleta_entrada;
  END IF;
END;
$$;
 K   DROP FUNCTION public.obtener_detalles_boleta(p_id_boleta_entrada integer);
       public               postgres    false            @           1255    23521 '   obtener_detalles_boleta_compra(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_detalles_boleta_compra(p_id_boleta integer) RETURNS TABLE(id_detalle integer, id_boleta integer, cantidad integer, costo_unitario numeric, id_producto integer, codigo_producto character varying, descripcion_producto character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.id_detalle,
        d.id_boleta_compra AS id_boleta,
        d.cantidad,
        d.costo_unitario,
        d.id_producto,
        p.codigo,
        p.descripcion
    FROM 
        public.detalle_boleta_compra d
    JOIN 
        public.producto p ON d.id_producto = p.id_producto
    WHERE 
        d.id_boleta_compra = p_id_boleta;
END;
$$;
 J   DROP FUNCTION public.obtener_detalles_boleta_compra(p_id_boleta integer);
       public               postgres    false            A           1255    23522 %   obtener_detalles_por_carrito(integer)    FUNCTION     L  CREATE FUNCTION public.obtener_detalles_por_carrito(p_id_carrito integer) RETURNS TABLE(id_detalle_carrito integer, cantidad integer, precio numeric, subtotal numeric, id_producto integer, id_carrito integer, url character varying, descripcion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.id_detalle_carrito,
        d.cantidad,
        d.precio,
        d.subtotal,
        d.id_producto,
        d.id_carrito,
        d.url,
        d.descripcion
    FROM public.detalle_carrito_compra d
    WHERE d.id_carrito = p_id_carrito;
END;
$$;
 I   DROP FUNCTION public.obtener_detalles_por_carrito(p_id_carrito integer);
       public               postgres    false            B           1255    23523 $   obtener_factura_por_cliente(integer)    FUNCTION     (  CREATE FUNCTION public.obtener_factura_por_cliente(p_id_cliente integer) RETURNS TABLE(id_factura integer, fecha date, fecha_vencimiento date, total numeric, id_carrito integer, id_caja integer, id_metodo_pago integer, id_cliente integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.id_factura,
        f.fecha,
        f.fecha_vencimiento,
        f.total,
        f.id_carrito,
        f.id_caja,
        f.id_metodo_pago,
        f.id_cliente
    FROM public.factura f
    WHERE f.id_cliente = p_id_cliente;
END;
$$;
 H   DROP FUNCTION public.obtener_factura_por_cliente(p_id_cliente integer);
       public               postgres    false            7           1255    23524    obtener_info_productos()    FUNCTION     �  CREATE FUNCTION public.obtener_info_productos() RETURNS TABLE(id_producto integer, codigo character varying, descripcion character varying, marca character varying, categoria character varying, tipo_producto character varying, precio numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id_producto,
        p.codigo,
        p.descripcion,
        m.nombre AS marca,
        c.nombre AS categoria,
        tp.nombre AS tipo_producto,
        pr.precio_unitario AS precio
    FROM producto p
    JOIN marca m ON p.id_marca = m.id_marca
    JOIN categoria c ON p.id_categoria = c.id_categoria
    LEFT JOIN tipo_producto tp ON p.id_tipo = tp.id_tipo
    LEFT JOIN precio pr ON p.id_producto = pr.id_producto;
END;
$$;
 /   DROP FUNCTION public.obtener_info_productos();
       public               postgres    false            _           1255    23525    obtener_lote(integer)    FUNCTION     �  CREATE FUNCTION public.obtener_lote(p_id integer) RETURNS TABLE(id_lote integer, stock integer, stock_minimo integer, cod_repisa character varying, nombre_estado character varying, descripcion_producto character varying, cod_almacen character varying, costo_unitario numeric, fecha_caducidad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        l.id_lote,
        l.stock,
        l.stock_minimo,
        r.codigo AS repisa_codigo,
        e.nombre AS estado_nombre,
        p.descripcion AS producto_descripcion,
        a.codigo AS almacen_codigo,
        l.costo_unitario,
        l.fecha_caducidad
    FROM lote l
    JOIN repisa r ON l.id_repisa = r.id_repisa
    JOIN estado_lote e ON l.id_estado = e.id_estado
    JOIN producto p ON l.id_producto = p.id_producto
    JOIN almacen a ON l.id_almacen = a.id_almacen
    WHERE l.id_lote = p_id;
END;
$$;
 1   DROP FUNCTION public.obtener_lote(p_id integer);
       public               postgres    false            `           1255    23526    obtener_lotes()    FUNCTION     v  CREATE FUNCTION public.obtener_lotes() RETURNS TABLE(id_lote integer, stock integer, stock_minimo integer, cod_repisa character varying, nombre_estado character varying, descripcion_producto character varying, cod_almacen character varying, costo_unitario integer, fecha_caducidad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        l.id_lote,
        l.stock,
        l.stock_minimo,
        r.codigo AS repisa_codigo,
        e.nombre AS estado_nombre,
        p.descripcion AS producto_descripcion,
        a.codigo AS almacen_codigo,
        l.costo_unitario,
        l.fecha_caducidad
    FROM lote l
    JOIN repisa r ON l.id_repisa = r.id_repisa
    JOIN estado_lote e ON l.id_estado = e.id_estado
    JOIN producto p ON l.id_producto = p.id_producto
    JOIN almacen a ON l.id_almacen = a.id_almacen
    ORDER BY l.id_lote DESC;
END;
$$;
 &   DROP FUNCTION public.obtener_lotes();
       public               postgres    false            a           1255    23527    obtener_productos()    FUNCTION     �  CREATE FUNCTION public.obtener_productos() RETURNS TABLE(id_producto integer, codigo character varying, descripcion character varying, marca_nombre character varying, categoria_nombre character varying, tipo_nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_producto,
        p.codigo,
        p.descripcion,
        m.nombre AS marca_nombre,
        c.nombre AS categoria_nombre,
        t.nombre AS tipo_nombre
    FROM producto p
    JOIN marca m ON p.id_marca = m.id_marca
    JOIN categoria c ON p.id_categoria = c.id_categoria
    LEFT JOIN tipo_producto t ON p.id_tipo = t.id_tipo;
END;
$$;
 *   DROP FUNCTION public.obtener_productos();
       public               postgres    false            e           1255    28788 .   obtener_productos_vendidos_por_dia(date, date)    FUNCTION     �  CREATE FUNCTION public.obtener_productos_vendidos_por_dia(fecha_inicio date, fecha_fin date) RETURNS TABLE(dia date, id_producto integer, descripcion character varying, cantidad_total integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        f.fecha AS dia,
        p.id_producto,
        p.descripcion,
        SUM(dc.cantidad)::INTEGER AS cantidad_total
    FROM factura f
    INNER JOIN carrito c ON f.id_carrito = c.id_carrito
    INNER JOIN detalle_carrito_compra dc ON c.id_carrito = dc.id_carrito
    INNER JOIN producto p ON dc.id_producto = p.id_producto
    WHERE f.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY f.fecha, p.id_producto, p.descripcion
    ORDER BY f.fecha, p.id_producto;
END;
$$;
 \   DROP FUNCTION public.obtener_productos_vendidos_por_dia(fecha_inicio date, fecha_fin date);
       public               postgres    false            =           1255    28787 )   obtener_total_vendido_por_dia(date, date)    FUNCTION     \  CREATE FUNCTION public.obtener_total_vendido_por_dia(fecha_inicio date, fecha_fin date) RETURNS TABLE(dia date, monto_total numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        fecha,
        SUM(total)
    FROM factura
    WHERE fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY fecha
    ORDER BY fecha;
END;
$$;
 W   DROP FUNCTION public.obtener_total_vendido_por_dia(fecha_inicio date, fecha_fin date);
       public               postgres    false            b           1255    23528    obtenerbitacoras()    FUNCTION     �  CREATE FUNCTION public.obtenerbitacoras() RETURNS TABLE(id integer, username character varying, ip character varying, fecha character varying, descripcion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.id,
        u.username,
        b.ip,
        b.fecha,
        b.descripcion
    FROM bitacora b
    JOIN usuario u ON b.id_usuario = u.id_usuario
    ORDER BY b.id DESC; -- 👈 Aquí el orden de mayor a menor
END;
$$;
 )   DROP FUNCTION public.obtenerbitacoras();
       public               postgres    false            c           1255    23529    restaurar_estado_lote()    FUNCTION     �   CREATE FUNCTION public.restaurar_estado_lote() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE lote
    SET id_estado = 1
    WHERE id_lote = OLD.id_lote;

    RETURN OLD;
END;
$$;
 .   DROP FUNCTION public.restaurar_estado_lote();
       public               postgres    false            d           1255    23530    rol_de_usuario(text)    FUNCTION     �  CREATE FUNCTION public.rol_de_usuario(p_username text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id_usuario INT;
BEGIN
    -- Buscar el id_usuario por username
    SELECT id_usuario INTO v_id_usuario
    FROM usuario
    WHERE username = p_username;

    IF NOT FOUND THEN
        RETURN 'ninguno';
    END IF;

    -- Verificar si está en la tabla personal
    IF EXISTS (
        SELECT 1 FROM personal WHERE id_usuario = v_id_usuario
    ) THEN
        RETURN 'personal';
    END IF;

    -- Verificar si está en la tabla cliente
    IF EXISTS (
        SELECT 1 FROM cliente WHERE id_usuario = v_id_usuario
    ) THEN
        RETURN 'cliente';
    END IF;

    RETURN 'ninguno';
END;
$$;
 6   DROP FUNCTION public.rol_de_usuario(p_username text);
       public               postgres    false            �            1259    23531    almacen    TABLE     �   CREATE TABLE public.almacen (
    id_almacen integer NOT NULL,
    codigo character varying(255) NOT NULL,
    dimenciones character varying(255)
);
    DROP TABLE public.almacen;
       public         heap r       postgres    false            �            1259    23536    almacen_id_almacen_seq    SEQUENCE     �   CREATE SEQUENCE public.almacen_id_almacen_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.almacen_id_almacen_seq;
       public               postgres    false    217            �           0    0    almacen_id_almacen_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.almacen_id_almacen_seq OWNED BY public.almacen.id_almacen;
          public               postgres    false    218            �            1259    23537    asignacion_estado    TABLE     �   CREATE TABLE public.asignacion_estado (
    id_asignacion integer NOT NULL,
    fecha date NOT NULL,
    motivo character varying(255) NOT NULL,
    id_personal integer NOT NULL,
    id_estado integer NOT NULL
);
 %   DROP TABLE public.asignacion_estado;
       public         heap r       postgres    false            �            1259    23540 #   asignacion_estado_id_asignacion_seq    SEQUENCE     �   CREATE SEQUENCE public.asignacion_estado_id_asignacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.asignacion_estado_id_asignacion_seq;
       public               postgres    false    219            �           0    0 #   asignacion_estado_id_asignacion_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.asignacion_estado_id_asignacion_seq OWNED BY public.asignacion_estado.id_asignacion;
          public               postgres    false    220            �            1259    23541    asignacion_permiso    TABLE     �   CREATE TABLE public.asignacion_permiso (
    id_asignacion integer NOT NULL,
    fecha date NOT NULL,
    id_personal integer NOT NULL,
    id_permiso integer NOT NULL
);
 &   DROP TABLE public.asignacion_permiso;
       public         heap r       postgres    false            �            1259    23544 $   asignacion_permiso_id_asignacion_seq    SEQUENCE     �   CREATE SEQUENCE public.asignacion_permiso_id_asignacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.asignacion_permiso_id_asignacion_seq;
       public               postgres    false    221            �           0    0 $   asignacion_permiso_id_asignacion_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.asignacion_permiso_id_asignacion_seq OWNED BY public.asignacion_permiso.id_asignacion;
          public               postgres    false    222            �            1259    23545    backup    TABLE     �   CREATE TABLE public.backup (
    id integer NOT NULL,
    id_usuario integer NOT NULL,
    nombre_archivo character varying(255) NOT NULL,
    fecha character varying(20) NOT NULL,
    tipo character varying(50) NOT NULL
);
    DROP TABLE public.backup;
       public         heap r       postgres    false            �            1259    23548    backup_id_seq    SEQUENCE     �   CREATE SEQUENCE public.backup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.backup_id_seq;
       public               postgres    false    223            �           0    0    backup_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.backup_id_seq OWNED BY public.backup.id;
          public               postgres    false    224            �            1259    23549    bitacora    TABLE     �   CREATE TABLE public.bitacora (
    id integer NOT NULL,
    id_usuario integer,
    ip character varying(255),
    fecha character varying(255),
    descripcion character varying(255)
);
    DROP TABLE public.bitacora;
       public         heap r       postgres    false            �            1259    23554    bitacora_id_seq    SEQUENCE     �   ALTER TABLE public.bitacora ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bitacora_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    225            �            1259    23555    boleta_compra    TABLE     �   CREATE TABLE public.boleta_compra (
    id_boleta integer NOT NULL,
    costo_total numeric(38,2),
    fecha date NOT NULL,
    id_proveedor integer NOT NULL,
    id_metodo_pago integer NOT NULL,
    estado character varying(255)
);
 !   DROP TABLE public.boleta_compra;
       public         heap r       postgres    false            �            1259    23558    boleta_compra_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.boleta_compra_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.boleta_compra_id_boleta_seq;
       public               postgres    false    227            �           0    0    boleta_compra_id_boleta_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.boleta_compra_id_boleta_seq OWNED BY public.boleta_compra.id_boleta;
          public               postgres    false    228            �            1259    23559    boleta_devolucion    TABLE     �   CREATE TABLE public.boleta_devolucion (
    id_boleta integer NOT NULL,
    descripcion character varying(255) NOT NULL,
    total numeric(10,2),
    id_cliente integer NOT NULL
);
 %   DROP TABLE public.boleta_devolucion;
       public         heap r       postgres    false            �            1259    23562    boleta_devolucion_compra    TABLE     �   CREATE TABLE public.boleta_devolucion_compra (
    id_boleta integer NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(255) NOT NULL,
    id_boleta_compra integer NOT NULL
);
 ,   DROP TABLE public.boleta_devolucion_compra;
       public         heap r       postgres    false            �            1259    23565 &   boleta_devolucion_compra_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.boleta_devolucion_compra_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.boleta_devolucion_compra_id_boleta_seq;
       public               postgres    false    230            �           0    0 &   boleta_devolucion_compra_id_boleta_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.boleta_devolucion_compra_id_boleta_seq OWNED BY public.boleta_devolucion_compra.id_boleta;
          public               postgres    false    231            �            1259    23566    boleta_devolucion_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.boleta_devolucion_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.boleta_devolucion_id_boleta_seq;
       public               postgres    false    229            �           0    0    boleta_devolucion_id_boleta_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.boleta_devolucion_id_boleta_seq OWNED BY public.boleta_devolucion.id_boleta;
          public               postgres    false    232            �            1259    23567    boleta_entrada    TABLE     �   CREATE TABLE public.boleta_entrada (
    id_boleta integer NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(255) NOT NULL,
    id_boleta_compra integer NOT NULL,
    estado character varying(255),
    id_personal integer
);
 "   DROP TABLE public.boleta_entrada;
       public         heap r       postgres    false            �            1259    23572    boleta_entrada_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.boleta_entrada_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.boleta_entrada_id_boleta_seq;
       public               postgres    false    233            �           0    0    boleta_entrada_id_boleta_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.boleta_entrada_id_boleta_seq OWNED BY public.boleta_entrada.id_boleta;
          public               postgres    false    234            �            1259    23573    boleta_recepcion    TABLE     �   CREATE TABLE public.boleta_recepcion (
    id_boleta integer NOT NULL,
    descripcion character varying(255) NOT NULL,
    puntaje integer NOT NULL,
    id_cliente integer NOT NULL,
    id_factura integer
);
 $   DROP TABLE public.boleta_recepcion;
       public         heap r       postgres    false            �            1259    23576    boleta_recepcion_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.boleta_recepcion_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.boleta_recepcion_id_boleta_seq;
       public               postgres    false    235            �           0    0    boleta_recepcion_id_boleta_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.boleta_recepcion_id_boleta_seq OWNED BY public.boleta_recepcion.id_boleta;
          public               postgres    false    236            �            1259    23577    boleta_reclamos    TABLE       CREATE TABLE public.boleta_reclamos (
    id_boleta integer NOT NULL,
    motivo character varying(255) NOT NULL,
    descripcion character varying(255) NOT NULL,
    fecha date NOT NULL,
    estado character varying(255) NOT NULL,
    id_cliente integer NOT NULL
);
 #   DROP TABLE public.boleta_reclamos;
       public         heap r       postgres    false            �            1259    23582    boleta_reclamos_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.boleta_reclamos_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.boleta_reclamos_id_boleta_seq;
       public               postgres    false    237            �           0    0    boleta_reclamos_id_boleta_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.boleta_reclamos_id_boleta_seq OWNED BY public.boleta_reclamos.id_boleta;
          public               postgres    false    238            �            1259    23583    boleta_salida    TABLE     �   CREATE TABLE public.boleta_salida (
    id_boleta integer NOT NULL,
    id_lote integer NOT NULL,
    id_personal integer NOT NULL,
    fecha character varying(255)
);
 !   DROP TABLE public.boleta_salida;
       public         heap r       postgres    false            �            1259    23586    boleta_salida_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.boleta_salida_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.boleta_salida_id_boleta_seq;
       public               postgres    false    239            �           0    0    boleta_salida_id_boleta_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.boleta_salida_id_boleta_seq OWNED BY public.boleta_salida.id_boleta;
          public               postgres    false    240            �            1259    23587    caja    TABLE     �   CREATE TABLE public.caja (
    id_caja integer NOT NULL,
    codigo character varying(10) NOT NULL,
    id_personal integer NOT NULL
);
    DROP TABLE public.caja;
       public         heap r       postgres    false            �            1259    23590    caja_id_caja_seq    SEQUENCE     �   CREATE SEQUENCE public.caja_id_caja_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.caja_id_caja_seq;
       public               postgres    false    241            �           0    0    caja_id_caja_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.caja_id_caja_seq OWNED BY public.caja.id_caja;
          public               postgres    false    242            �            1259    23591    carrito    TABLE     �   CREATE TABLE public.carrito (
    id_carrito integer NOT NULL,
    total numeric(10,2),
    estado character varying(255) NOT NULL,
    fecha date NOT NULL,
    id_cliente integer NOT NULL
);
    DROP TABLE public.carrito;
       public         heap r       postgres    false            �            1259    23594    carrito_id_carrito_seq    SEQUENCE     �   CREATE SEQUENCE public.carrito_id_carrito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.carrito_id_carrito_seq;
       public               postgres    false    243            �           0    0    carrito_id_carrito_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.carrito_id_carrito_seq OWNED BY public.carrito.id_carrito;
          public               postgres    false    244            �            1259    23595 	   categoria    TABLE     q   CREATE TABLE public.categoria (
    id_categoria integer NOT NULL,
    nombre character varying(255) NOT NULL
);
    DROP TABLE public.categoria;
       public         heap r       postgres    false            �            1259    23598    categoria_id_categoria_seq    SEQUENCE     �   CREATE SEQUENCE public.categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.categoria_id_categoria_seq;
       public               postgres    false    245            �           0    0    categoria_id_categoria_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.categoria.id_categoria;
          public               postgres    false    246            �            1259    23599    cliente    TABLE     |  CREATE TABLE public.cliente (
    id_cliente integer NOT NULL,
    nombre_cliente character varying(100) NOT NULL,
    apellido_cliente character varying(100) NOT NULL,
    carnet_cliente character varying(10) NOT NULL,
    nit_cliente character varying(30),
    direccion_cliente character varying(100),
    id_usuario integer NOT NULL,
    estado_cliente_id integer NOT NULL
);
    DROP TABLE public.cliente;
       public         heap r       postgres    false            �            1259    23602    cliente_id_cliente_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cliente_id_cliente_seq;
       public               postgres    false    247            �           0    0    cliente_id_cliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.cliente_id_cliente_seq OWNED BY public.cliente.id_cliente;
          public               postgres    false    248            �            1259    23603    control_asistencia    TABLE     �   CREATE TABLE public.control_asistencia (
    id_control integer NOT NULL,
    fecha date NOT NULL,
    hora time without time zone NOT NULL,
    estado character varying(255) NOT NULL,
    id_personal integer NOT NULL
);
 &   DROP TABLE public.control_asistencia;
       public         heap r       postgres    false            �            1259    23606 !   control_asistencia_id_control_seq    SEQUENCE     �   CREATE SEQUENCE public.control_asistencia_id_control_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.control_asistencia_id_control_seq;
       public               postgres    false    249            �           0    0 !   control_asistencia_id_control_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.control_asistencia_id_control_seq OWNED BY public.control_asistencia.id_control;
          public               postgres    false    250            �            1259    23607 	   descuento    TABLE     �   CREATE TABLE public.descuento (
    id_descuento integer NOT NULL,
    porcentaje integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_culminacion date NOT NULL,
    id_temporada integer NOT NULL
);
    DROP TABLE public.descuento;
       public         heap r       postgres    false            �            1259    23610    descuento_id_descuento_seq    SEQUENCE     �   CREATE SEQUENCE public.descuento_id_descuento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.descuento_id_descuento_seq;
       public               postgres    false    251            �           0    0    descuento_id_descuento_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.descuento_id_descuento_seq OWNED BY public.descuento.id_descuento;
          public               postgres    false    252            �            1259    23611    detalle_boleta_compra    TABLE     �   CREATE TABLE public.detalle_boleta_compra (
    id_detalle integer NOT NULL,
    cantidad integer NOT NULL,
    costo_unitario numeric(38,2) NOT NULL,
    id_boleta_compra integer NOT NULL,
    id_producto integer NOT NULL
);
 )   DROP TABLE public.detalle_boleta_compra;
       public         heap r       postgres    false            �            1259    23614 $   detalle_boleta_compra_id_detalle_seq    SEQUENCE     �   CREATE SEQUENCE public.detalle_boleta_compra_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.detalle_boleta_compra_id_detalle_seq;
       public               postgres    false    253            �           0    0 $   detalle_boleta_compra_id_detalle_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.detalle_boleta_compra_id_detalle_seq OWNED BY public.detalle_boleta_compra.id_detalle;
          public               postgres    false    254            �            1259    23615     detalle_boleta_devolucion_compra    TABLE     �   CREATE TABLE public.detalle_boleta_devolucion_compra (
    id_boleta integer NOT NULL,
    cantidad integer NOT NULL,
    motivo character varying(255) NOT NULL,
    id_devolucion_compra integer NOT NULL,
    id_producto integer NOT NULL
);
 4   DROP TABLE public.detalle_boleta_devolucion_compra;
       public         heap r       postgres    false                        1259    23618 .   detalle_boleta_devolucion_compra_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.detalle_boleta_devolucion_compra_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 E   DROP SEQUENCE public.detalle_boleta_devolucion_compra_id_boleta_seq;
       public               postgres    false    255            �           0    0 .   detalle_boleta_devolucion_compra_id_boleta_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public.detalle_boleta_devolucion_compra_id_boleta_seq OWNED BY public.detalle_boleta_devolucion_compra.id_boleta;
          public               postgres    false    256                       1259    23619    detalle_boleta_entrada    TABLE       CREATE TABLE public.detalle_boleta_entrada (
    id_boleta integer NOT NULL,
    cantidad integer NOT NULL,
    id_boleta_entrada integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad_comprada integer,
    costo_unitario numeric(10,2),
    id_lote integer
);
 *   DROP TABLE public.detalle_boleta_entrada;
       public         heap r       postgres    false                       1259    23622 $   detalle_boleta_entrada_id_boleta_seq    SEQUENCE     �   CREATE SEQUENCE public.detalle_boleta_entrada_id_boleta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.detalle_boleta_entrada_id_boleta_seq;
       public               postgres    false    257            �           0    0 $   detalle_boleta_entrada_id_boleta_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.detalle_boleta_entrada_id_boleta_seq OWNED BY public.detalle_boleta_entrada.id_boleta;
          public               postgres    false    258                       1259    23623    detalle_boleta_salida    TABLE     �   CREATE TABLE public.detalle_boleta_salida (
    id_detalle integer NOT NULL,
    cantidad integer NOT NULL,
    motivo character varying(255) NOT NULL,
    id_boleta_salida integer NOT NULL,
    id_producto integer NOT NULL
);
 )   DROP TABLE public.detalle_boleta_salida;
       public         heap r       postgres    false                       1259    23626 $   detalle_boleta_salida_id_detalle_seq    SEQUENCE     �   CREATE SEQUENCE public.detalle_boleta_salida_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public.detalle_boleta_salida_id_detalle_seq;
       public               postgres    false    259            �           0    0 $   detalle_boleta_salida_id_detalle_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.detalle_boleta_salida_id_detalle_seq OWNED BY public.detalle_boleta_salida.id_detalle;
          public               postgres    false    260                       1259    23627    detalle_carrito_compra    TABLE     A  CREATE TABLE public.detalle_carrito_compra (
    id_detalle_carrito integer NOT NULL,
    cantidad integer NOT NULL,
    precio numeric(10,2) NOT NULL,
    subtotal numeric(10,2),
    id_producto integer NOT NULL,
    id_carrito integer NOT NULL,
    url character varying(255),
    descripcion character varying(255)
);
 *   DROP TABLE public.detalle_carrito_compra;
       public         heap r       postgres    false                       1259    23632 -   detalle_carrito_compra_id_detalle_carrito_seq    SEQUENCE     �   CREATE SEQUENCE public.detalle_carrito_compra_id_detalle_carrito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 D   DROP SEQUENCE public.detalle_carrito_compra_id_detalle_carrito_seq;
       public               postgres    false    261            �           0    0 -   detalle_carrito_compra_id_detalle_carrito_seq    SEQUENCE OWNED BY        ALTER SEQUENCE public.detalle_carrito_compra_id_detalle_carrito_seq OWNED BY public.detalle_carrito_compra.id_detalle_carrito;
          public               postgres    false    262                       1259    23633    detalle_devolucion    TABLE     �   CREATE TABLE public.detalle_devolucion (
    id_boleta_detalle integer NOT NULL,
    codigo_producto character varying(10) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    cantidad integer NOT NULL,
    id_boleta integer NOT NULL
);
 &   DROP TABLE public.detalle_devolucion;
       public         heap r       postgres    false                       1259    23636 (   detalle_devolucion_id_boleta_detalle_seq    SEQUENCE     �   CREATE SEQUENCE public.detalle_devolucion_id_boleta_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ?   DROP SEQUENCE public.detalle_devolucion_id_boleta_detalle_seq;
       public               postgres    false    263            �           0    0 (   detalle_devolucion_id_boleta_detalle_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public.detalle_devolucion_id_boleta_detalle_seq OWNED BY public.detalle_devolucion.id_boleta_detalle;
          public               postgres    false    264            6           1259    28802    id_encargado_seq    SEQUENCE     y   CREATE SEQUENCE public.id_encargado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.id_encargado_seq;
       public               postgres    false            5           1259    28789    encargado_inventario    TABLE     �   CREATE TABLE public.encargado_inventario (
    id_encargado integer DEFAULT nextval('public.id_encargado_seq'::regclass) NOT NULL,
    nombre character varying,
    correo_notificacion character varying,
    id_personal integer
);
 (   DROP TABLE public.encargado_inventario;
       public         heap r       postgres    false    310            	           1259    23637    estado_cliente    TABLE     u   CREATE TABLE public.estado_cliente (
    id_estado integer NOT NULL,
    nombre_estado character varying NOT NULL
);
 "   DROP TABLE public.estado_cliente;
       public         heap r       postgres    false            
           1259    23642    estado_cliente_id_estado_seq    SEQUENCE     �   CREATE SEQUENCE public.estado_cliente_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.estado_cliente_id_estado_seq;
       public               postgres    false    265            �           0    0    estado_cliente_id_estado_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.estado_cliente_id_estado_seq OWNED BY public.estado_cliente.id_estado;
          public               postgres    false    266                       1259    23643    estado_lote    TABLE     p   CREATE TABLE public.estado_lote (
    id_estado integer NOT NULL,
    nombre character varying(255) NOT NULL
);
    DROP TABLE public.estado_lote;
       public         heap r       postgres    false                       1259    23646    estado_lote_id_estado_seq    SEQUENCE     �   CREATE SEQUENCE public.estado_lote_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.estado_lote_id_estado_seq;
       public               postgres    false    267            �           0    0    estado_lote_id_estado_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.estado_lote_id_estado_seq OWNED BY public.estado_lote.id_estado;
          public               postgres    false    268                       1259    23647    estado_personal    TABLE     t   CREATE TABLE public.estado_personal (
    id_estado integer NOT NULL,
    nombre character varying(255) NOT NULL
);
 #   DROP TABLE public.estado_personal;
       public         heap r       postgres    false                       1259    23650    estado_personal_id_estado_seq    SEQUENCE     �   CREATE SEQUENCE public.estado_personal_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.estado_personal_id_estado_seq;
       public               postgres    false    269            �           0    0    estado_personal_id_estado_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.estado_personal_id_estado_seq OWNED BY public.estado_personal.id_estado;
          public               postgres    false    270                       1259    23651    factura    TABLE       CREATE TABLE public.factura (
    id_factura integer NOT NULL,
    fecha date NOT NULL,
    fecha_vencimiento date NOT NULL,
    total numeric(10,2) NOT NULL,
    id_carrito integer NOT NULL,
    id_caja integer,
    id_metodo_pago integer NOT NULL,
    id_cliente integer NOT NULL
);
    DROP TABLE public.factura;
       public         heap r       postgres    false                       1259    23654    factura_id_factura_seq    SEQUENCE     �   CREATE SEQUENCE public.factura_id_factura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.factura_id_factura_seq;
       public               postgres    false    271            �           0    0    factura_id_factura_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.factura_id_factura_seq OWNED BY public.factura.id_factura;
          public               postgres    false    272                       1259    23655    lote    TABLE     3  CREATE TABLE public.lote (
    id_lote integer NOT NULL,
    stock integer,
    stock_minimo integer,
    id_repisa integer NOT NULL,
    id_estado integer NOT NULL,
    id_producto integer NOT NULL,
    id_almacen integer NOT NULL,
    costo_unitario integer,
    fecha_caducidad character varying(255)
);
    DROP TABLE public.lote;
       public         heap r       postgres    false                       1259    23658    lote_id_lote_seq    SEQUENCE     �   CREATE SEQUENCE public.lote_id_lote_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.lote_id_lote_seq;
       public               postgres    false    273            �           0    0    lote_id_lote_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.lote_id_lote_seq OWNED BY public.lote.id_lote;
          public               postgres    false    274                       1259    23659    marca    TABLE     i   CREATE TABLE public.marca (
    id_marca integer NOT NULL,
    nombre character varying(255) NOT NULL
);
    DROP TABLE public.marca;
       public         heap r       postgres    false                       1259    23662    marca_id_marca_seq    SEQUENCE     �   CREATE SEQUENCE public.marca_id_marca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.marca_id_marca_seq;
       public               postgres    false    275                        0    0    marca_id_marca_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.marca_id_marca_seq OWNED BY public.marca.id_marca;
          public               postgres    false    276                       1259    23663    metodo_pago    TABLE     p   CREATE TABLE public.metodo_pago (
    id_metodo integer NOT NULL,
    nombre character varying(255) NOT NULL
);
    DROP TABLE public.metodo_pago;
       public         heap r       postgres    false                       1259    23666    metodo_pago_id_metodo_seq    SEQUENCE     �   CREATE SEQUENCE public.metodo_pago_id_metodo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.metodo_pago_id_metodo_seq;
       public               postgres    false    277                       0    0    metodo_pago_id_metodo_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.metodo_pago_id_metodo_seq OWNED BY public.metodo_pago.id_metodo;
          public               postgres    false    278                       1259    23667    permiso    TABLE     �   CREATE TABLE public.permiso (
    id_permiso integer NOT NULL,
    vista character varying(50),
    ver boolean,
    insertar boolean,
    editar boolean,
    eliminar boolean,
    id_rol integer
);
    DROP TABLE public.permiso;
       public         heap r       postgres    false                       1259    23670    permiso_id_permiso_seq    SEQUENCE     �   CREATE SEQUENCE public.permiso_id_permiso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.permiso_id_permiso_seq;
       public               postgres    false    279                       0    0    permiso_id_permiso_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.permiso_id_permiso_seq OWNED BY public.permiso.id_permiso;
          public               postgres    false    280                       1259    23671    personal    TABLE     a  CREATE TABLE public.personal (
    id_personal integer NOT NULL,
    nombre character varying(255) NOT NULL,
    apellido character varying(255) NOT NULL,
    carnet character varying(255) NOT NULL,
    fecha_creacion timestamp(6) without time zone NOT NULL,
    id_rol integer NOT NULL,
    id_turno integer NOT NULL,
    id_usuario bigint NOT NULL
);
    DROP TABLE public.personal;
       public         heap r       postgres    false                       1259    23676    personal_id_personal_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_id_personal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.personal_id_personal_seq;
       public               postgres    false    281                       0    0    personal_id_personal_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.personal_id_personal_seq OWNED BY public.personal.id_personal;
          public               postgres    false    282                       1259    23677    precio    TABLE     {   CREATE TABLE public.precio (
    id_precio integer NOT NULL,
    precio_unitario numeric(38,2),
    id_producto integer
);
    DROP TABLE public.precio;
       public         heap r       postgres    false                       1259    23680    precio_id_precio_seq    SEQUENCE     �   ALTER TABLE public.precio ALTER COLUMN id_precio ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.precio_id_precio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 100000
    CACHE 1
);
            public               postgres    false    283                       1259    23681    producto    TABLE       CREATE TABLE public.producto (
    id_producto integer NOT NULL,
    codigo character varying(255) NOT NULL,
    descripcion character varying(255) NOT NULL,
    id_marca integer NOT NULL,
    id_categoria integer NOT NULL,
    id_tipo integer,
    id_precio integer
);
    DROP TABLE public.producto;
       public         heap r       postgres    false                       1259    23686    producto_id_producto_seq    SEQUENCE     �   CREATE SEQUENCE public.producto_id_producto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.producto_id_producto_seq;
       public               postgres    false    285                       0    0    producto_id_producto_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.producto_id_producto_seq OWNED BY public.producto.id_producto;
          public               postgres    false    286                       1259    23687    producto_imagen    TABLE     �   CREATE TABLE public.producto_imagen (
    id_imagen integer NOT NULL,
    url character varying(255),
    id_producto integer
);
 #   DROP TABLE public.producto_imagen;
       public         heap r       postgres    false                        1259    23690    producto_imagen_id_imagen_seq    SEQUENCE     �   ALTER TABLE public.producto_imagen ALTER COLUMN id_imagen ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.producto_imagen_id_imagen_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 10000
    CACHE 1
);
            public               postgres    false    287            !           1259    23691 	   proveedor    TABLE     �   CREATE TABLE public.proveedor (
    id_proveedor integer NOT NULL,
    nombre character varying(255) NOT NULL,
    direccion character varying(255),
    estado character varying(255) NOT NULL
);
    DROP TABLE public.proveedor;
       public         heap r       postgres    false            "           1259    23696    proveedor_id_proveedor_seq    SEQUENCE     �   CREATE SEQUENCE public.proveedor_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.proveedor_id_proveedor_seq;
       public               postgres    false    289                       0    0    proveedor_id_proveedor_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNED BY public.proveedor.id_proveedor;
          public               postgres    false    290            #           1259    23697    repisa    TABLE     �   CREATE TABLE public.repisa (
    id_repisa integer NOT NULL,
    codigo character varying(255) NOT NULL,
    capacidad integer NOT NULL,
    id_sector integer NOT NULL
);
    DROP TABLE public.repisa;
       public         heap r       postgres    false            $           1259    23700    repisa_id_repisa_seq    SEQUENCE     �   CREATE SEQUENCE public.repisa_id_repisa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.repisa_id_repisa_seq;
       public               postgres    false    291                       0    0    repisa_id_repisa_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.repisa_id_repisa_seq OWNED BY public.repisa.id_repisa;
          public               postgres    false    292            %           1259    23701    rol    TABLE     \   CREATE TABLE public.rol (
    id_rol integer NOT NULL,
    nombre character varying(255)
);
    DROP TABLE public.rol;
       public         heap r       postgres    false            &           1259    23704    rol_id_rol_seq    SEQUENCE     �   CREATE SEQUENCE public.rol_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.rol_id_rol_seq;
       public               postgres    false    293                       0    0    rol_id_rol_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.rol_id_rol_seq OWNED BY public.rol.id_rol;
          public               postgres    false    294            '           1259    23705    sector    TABLE     �   CREATE TABLE public.sector (
    id_sector integer NOT NULL,
    nombre character varying(255) NOT NULL,
    ubicacion character varying(255) NOT NULL
);
    DROP TABLE public.sector;
       public         heap r       postgres    false            (           1259    23710    sector_id_sector_seq    SEQUENCE     �   CREATE SEQUENCE public.sector_id_sector_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.sector_id_sector_seq;
       public               postgres    false    295                       0    0    sector_id_sector_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.sector_id_sector_seq OWNED BY public.sector.id_sector;
          public               postgres    false    296            )           1259    23711    solicitud_permiso    TABLE     �   CREATE TABLE public.solicitud_permiso (
    id_solicitud integer NOT NULL,
    fecha date NOT NULL,
    motivo character varying(255) NOT NULL,
    estado character varying(255) NOT NULL,
    id_personal integer NOT NULL
);
 %   DROP TABLE public.solicitud_permiso;
       public         heap r       postgres    false            *           1259    23716 "   solicitud_permiso_id_solicitud_seq    SEQUENCE     �   CREATE SEQUENCE public.solicitud_permiso_id_solicitud_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.solicitud_permiso_id_solicitud_seq;
       public               postgres    false    297            	           0    0 "   solicitud_permiso_id_solicitud_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.solicitud_permiso_id_solicitud_seq OWNED BY public.solicitud_permiso.id_solicitud;
          public               postgres    false    298            +           1259    23717    tareas    TABLE     �   CREATE TABLE public.tareas (
    id_tareas integer NOT NULL,
    fecha date NOT NULL,
    descripcion character varying(255) NOT NULL,
    estado character varying(255) NOT NULL,
    id_personal integer NOT NULL
);
    DROP TABLE public.tareas;
       public         heap r       postgres    false            ,           1259    23722    tareas_id_tareas_seq    SEQUENCE     �   CREATE SEQUENCE public.tareas_id_tareas_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tareas_id_tareas_seq;
       public               postgres    false    299            
           0    0    tareas_id_tareas_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tareas_id_tareas_seq OWNED BY public.tareas.id_tareas;
          public               postgres    false    300            -           1259    23723 	   temporada    TABLE     �   CREATE TABLE public.temporada (
    id_temporada integer NOT NULL,
    nombre character varying(255) NOT NULL,
    mes_inicio character varying(255) NOT NULL,
    mes_culminacion character varying(255) NOT NULL
);
    DROP TABLE public.temporada;
       public         heap r       postgres    false            .           1259    23728    temporada_id_temporada_seq    SEQUENCE     �   CREATE SEQUENCE public.temporada_id_temporada_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.temporada_id_temporada_seq;
       public               postgres    false    301                       0    0    temporada_id_temporada_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.temporada_id_temporada_seq OWNED BY public.temporada.id_temporada;
          public               postgres    false    302            /           1259    23729    tipo_producto    TABLE     p   CREATE TABLE public.tipo_producto (
    id_tipo integer NOT NULL,
    nombre character varying(255) NOT NULL
);
 !   DROP TABLE public.tipo_producto;
       public         heap r       postgres    false            0           1259    23732    tipo_producto_id_tipo_seq    SEQUENCE     �   CREATE SEQUENCE public.tipo_producto_id_tipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.tipo_producto_id_tipo_seq;
       public               postgres    false    303                       0    0    tipo_producto_id_tipo_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.tipo_producto_id_tipo_seq OWNED BY public.tipo_producto.id_tipo;
          public               postgres    false    304            1           1259    23733    turno    TABLE     �   CREATE TABLE public.turno (
    id_turno integer NOT NULL,
    descripcion character varying(255),
    hora_entrada time without time zone NOT NULL,
    hora_salida time without time zone NOT NULL
);
    DROP TABLE public.turno;
       public         heap r       postgres    false            2           1259    23736    turno_id_turno_seq    SEQUENCE     �   CREATE SEQUENCE public.turno_id_turno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.turno_id_turno_seq;
       public               postgres    false    305                       0    0    turno_id_turno_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.turno_id_turno_seq OWNED BY public.turno.id_turno;
          public               postgres    false    306            3           1259    23737    usuario    TABLE     �   CREATE TABLE public.usuario (
    id_usuario bigint NOT NULL,
    username character varying(255) NOT NULL,
    correo_electronico character varying(255) NOT NULL,
    contrasenia character varying(255) NOT NULL
);
    DROP TABLE public.usuario;
       public         heap r       postgres    false            4           1259    23742    usuario_id_usuario_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.usuario_id_usuario_seq;
       public               postgres    false    307                       0    0    usuario_id_usuario_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.usuario_id_usuario_seq OWNED BY public.usuario.id_usuario;
          public               postgres    false    308            +           2604    23743    almacen id_almacen    DEFAULT     x   ALTER TABLE ONLY public.almacen ALTER COLUMN id_almacen SET DEFAULT nextval('public.almacen_id_almacen_seq'::regclass);
 A   ALTER TABLE public.almacen ALTER COLUMN id_almacen DROP DEFAULT;
       public               postgres    false    218    217            ,           2604    23744    asignacion_estado id_asignacion    DEFAULT     �   ALTER TABLE ONLY public.asignacion_estado ALTER COLUMN id_asignacion SET DEFAULT nextval('public.asignacion_estado_id_asignacion_seq'::regclass);
 N   ALTER TABLE public.asignacion_estado ALTER COLUMN id_asignacion DROP DEFAULT;
       public               postgres    false    220    219            -           2604    23745     asignacion_permiso id_asignacion    DEFAULT     �   ALTER TABLE ONLY public.asignacion_permiso ALTER COLUMN id_asignacion SET DEFAULT nextval('public.asignacion_permiso_id_asignacion_seq'::regclass);
 O   ALTER TABLE public.asignacion_permiso ALTER COLUMN id_asignacion DROP DEFAULT;
       public               postgres    false    222    221            .           2604    23746 	   backup id    DEFAULT     f   ALTER TABLE ONLY public.backup ALTER COLUMN id SET DEFAULT nextval('public.backup_id_seq'::regclass);
 8   ALTER TABLE public.backup ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    224    223            /           2604    23747    boleta_compra id_boleta    DEFAULT     �   ALTER TABLE ONLY public.boleta_compra ALTER COLUMN id_boleta SET DEFAULT nextval('public.boleta_compra_id_boleta_seq'::regclass);
 F   ALTER TABLE public.boleta_compra ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    228    227            0           2604    23748    boleta_devolucion id_boleta    DEFAULT     �   ALTER TABLE ONLY public.boleta_devolucion ALTER COLUMN id_boleta SET DEFAULT nextval('public.boleta_devolucion_id_boleta_seq'::regclass);
 J   ALTER TABLE public.boleta_devolucion ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    232    229            1           2604    23749 "   boleta_devolucion_compra id_boleta    DEFAULT     �   ALTER TABLE ONLY public.boleta_devolucion_compra ALTER COLUMN id_boleta SET DEFAULT nextval('public.boleta_devolucion_compra_id_boleta_seq'::regclass);
 Q   ALTER TABLE public.boleta_devolucion_compra ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    231    230            2           2604    23750    boleta_entrada id_boleta    DEFAULT     �   ALTER TABLE ONLY public.boleta_entrada ALTER COLUMN id_boleta SET DEFAULT nextval('public.boleta_entrada_id_boleta_seq'::regclass);
 G   ALTER TABLE public.boleta_entrada ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    234    233            3           2604    23751    boleta_recepcion id_boleta    DEFAULT     �   ALTER TABLE ONLY public.boleta_recepcion ALTER COLUMN id_boleta SET DEFAULT nextval('public.boleta_recepcion_id_boleta_seq'::regclass);
 I   ALTER TABLE public.boleta_recepcion ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    236    235            4           2604    23752    boleta_reclamos id_boleta    DEFAULT     �   ALTER TABLE ONLY public.boleta_reclamos ALTER COLUMN id_boleta SET DEFAULT nextval('public.boleta_reclamos_id_boleta_seq'::regclass);
 H   ALTER TABLE public.boleta_reclamos ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    238    237            5           2604    23753    boleta_salida id_boleta    DEFAULT     �   ALTER TABLE ONLY public.boleta_salida ALTER COLUMN id_boleta SET DEFAULT nextval('public.boleta_salida_id_boleta_seq'::regclass);
 F   ALTER TABLE public.boleta_salida ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    240    239            6           2604    23754    caja id_caja    DEFAULT     l   ALTER TABLE ONLY public.caja ALTER COLUMN id_caja SET DEFAULT nextval('public.caja_id_caja_seq'::regclass);
 ;   ALTER TABLE public.caja ALTER COLUMN id_caja DROP DEFAULT;
       public               postgres    false    242    241            7           2604    23755    carrito id_carrito    DEFAULT     x   ALTER TABLE ONLY public.carrito ALTER COLUMN id_carrito SET DEFAULT nextval('public.carrito_id_carrito_seq'::regclass);
 A   ALTER TABLE public.carrito ALTER COLUMN id_carrito DROP DEFAULT;
       public               postgres    false    244    243            8           2604    23756    categoria id_categoria    DEFAULT     �   ALTER TABLE ONLY public.categoria ALTER COLUMN id_categoria SET DEFAULT nextval('public.categoria_id_categoria_seq'::regclass);
 E   ALTER TABLE public.categoria ALTER COLUMN id_categoria DROP DEFAULT;
       public               postgres    false    246    245            9           2604    23757    cliente id_cliente    DEFAULT     x   ALTER TABLE ONLY public.cliente ALTER COLUMN id_cliente SET DEFAULT nextval('public.cliente_id_cliente_seq'::regclass);
 A   ALTER TABLE public.cliente ALTER COLUMN id_cliente DROP DEFAULT;
       public               postgres    false    248    247            :           2604    23758    control_asistencia id_control    DEFAULT     �   ALTER TABLE ONLY public.control_asistencia ALTER COLUMN id_control SET DEFAULT nextval('public.control_asistencia_id_control_seq'::regclass);
 L   ALTER TABLE public.control_asistencia ALTER COLUMN id_control DROP DEFAULT;
       public               postgres    false    250    249            ;           2604    23759    descuento id_descuento    DEFAULT     �   ALTER TABLE ONLY public.descuento ALTER COLUMN id_descuento SET DEFAULT nextval('public.descuento_id_descuento_seq'::regclass);
 E   ALTER TABLE public.descuento ALTER COLUMN id_descuento DROP DEFAULT;
       public               postgres    false    252    251            <           2604    23760     detalle_boleta_compra id_detalle    DEFAULT     �   ALTER TABLE ONLY public.detalle_boleta_compra ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_boleta_compra_id_detalle_seq'::regclass);
 O   ALTER TABLE public.detalle_boleta_compra ALTER COLUMN id_detalle DROP DEFAULT;
       public               postgres    false    254    253            =           2604    23761 *   detalle_boleta_devolucion_compra id_boleta    DEFAULT     �   ALTER TABLE ONLY public.detalle_boleta_devolucion_compra ALTER COLUMN id_boleta SET DEFAULT nextval('public.detalle_boleta_devolucion_compra_id_boleta_seq'::regclass);
 Y   ALTER TABLE public.detalle_boleta_devolucion_compra ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    256    255            >           2604    23762     detalle_boleta_entrada id_boleta    DEFAULT     �   ALTER TABLE ONLY public.detalle_boleta_entrada ALTER COLUMN id_boleta SET DEFAULT nextval('public.detalle_boleta_entrada_id_boleta_seq'::regclass);
 O   ALTER TABLE public.detalle_boleta_entrada ALTER COLUMN id_boleta DROP DEFAULT;
       public               postgres    false    258    257            ?           2604    23763     detalle_boleta_salida id_detalle    DEFAULT     �   ALTER TABLE ONLY public.detalle_boleta_salida ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalle_boleta_salida_id_detalle_seq'::regclass);
 O   ALTER TABLE public.detalle_boleta_salida ALTER COLUMN id_detalle DROP DEFAULT;
       public               postgres    false    260    259            @           2604    23764 )   detalle_carrito_compra id_detalle_carrito    DEFAULT     �   ALTER TABLE ONLY public.detalle_carrito_compra ALTER COLUMN id_detalle_carrito SET DEFAULT nextval('public.detalle_carrito_compra_id_detalle_carrito_seq'::regclass);
 X   ALTER TABLE public.detalle_carrito_compra ALTER COLUMN id_detalle_carrito DROP DEFAULT;
       public               postgres    false    262    261            A           2604    23765 $   detalle_devolucion id_boleta_detalle    DEFAULT     �   ALTER TABLE ONLY public.detalle_devolucion ALTER COLUMN id_boleta_detalle SET DEFAULT nextval('public.detalle_devolucion_id_boleta_detalle_seq'::regclass);
 S   ALTER TABLE public.detalle_devolucion ALTER COLUMN id_boleta_detalle DROP DEFAULT;
       public               postgres    false    264    263            B           2604    23766    estado_cliente id_estado    DEFAULT     �   ALTER TABLE ONLY public.estado_cliente ALTER COLUMN id_estado SET DEFAULT nextval('public.estado_cliente_id_estado_seq'::regclass);
 G   ALTER TABLE public.estado_cliente ALTER COLUMN id_estado DROP DEFAULT;
       public               postgres    false    266    265            C           2604    23767    estado_lote id_estado    DEFAULT     ~   ALTER TABLE ONLY public.estado_lote ALTER COLUMN id_estado SET DEFAULT nextval('public.estado_lote_id_estado_seq'::regclass);
 D   ALTER TABLE public.estado_lote ALTER COLUMN id_estado DROP DEFAULT;
       public               postgres    false    268    267            D           2604    23768    estado_personal id_estado    DEFAULT     �   ALTER TABLE ONLY public.estado_personal ALTER COLUMN id_estado SET DEFAULT nextval('public.estado_personal_id_estado_seq'::regclass);
 H   ALTER TABLE public.estado_personal ALTER COLUMN id_estado DROP DEFAULT;
       public               postgres    false    270    269            E           2604    23769    factura id_factura    DEFAULT     x   ALTER TABLE ONLY public.factura ALTER COLUMN id_factura SET DEFAULT nextval('public.factura_id_factura_seq'::regclass);
 A   ALTER TABLE public.factura ALTER COLUMN id_factura DROP DEFAULT;
       public               postgres    false    272    271            F           2604    23770    lote id_lote    DEFAULT     l   ALTER TABLE ONLY public.lote ALTER COLUMN id_lote SET DEFAULT nextval('public.lote_id_lote_seq'::regclass);
 ;   ALTER TABLE public.lote ALTER COLUMN id_lote DROP DEFAULT;
       public               postgres    false    274    273            G           2604    23771    marca id_marca    DEFAULT     p   ALTER TABLE ONLY public.marca ALTER COLUMN id_marca SET DEFAULT nextval('public.marca_id_marca_seq'::regclass);
 =   ALTER TABLE public.marca ALTER COLUMN id_marca DROP DEFAULT;
       public               postgres    false    276    275            H           2604    23772    metodo_pago id_metodo    DEFAULT     ~   ALTER TABLE ONLY public.metodo_pago ALTER COLUMN id_metodo SET DEFAULT nextval('public.metodo_pago_id_metodo_seq'::regclass);
 D   ALTER TABLE public.metodo_pago ALTER COLUMN id_metodo DROP DEFAULT;
       public               postgres    false    278    277            I           2604    23773    permiso id_permiso    DEFAULT     x   ALTER TABLE ONLY public.permiso ALTER COLUMN id_permiso SET DEFAULT nextval('public.permiso_id_permiso_seq'::regclass);
 A   ALTER TABLE public.permiso ALTER COLUMN id_permiso DROP DEFAULT;
       public               postgres    false    280    279            J           2604    23774    personal id_personal    DEFAULT     |   ALTER TABLE ONLY public.personal ALTER COLUMN id_personal SET DEFAULT nextval('public.personal_id_personal_seq'::regclass);
 C   ALTER TABLE public.personal ALTER COLUMN id_personal DROP DEFAULT;
       public               postgres    false    282    281            K           2604    23775    producto id_producto    DEFAULT     |   ALTER TABLE ONLY public.producto ALTER COLUMN id_producto SET DEFAULT nextval('public.producto_id_producto_seq'::regclass);
 C   ALTER TABLE public.producto ALTER COLUMN id_producto DROP DEFAULT;
       public               postgres    false    286    285            L           2604    23776    proveedor id_proveedor    DEFAULT     �   ALTER TABLE ONLY public.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedor_id_proveedor_seq'::regclass);
 E   ALTER TABLE public.proveedor ALTER COLUMN id_proveedor DROP DEFAULT;
       public               postgres    false    290    289            M           2604    23777    repisa id_repisa    DEFAULT     t   ALTER TABLE ONLY public.repisa ALTER COLUMN id_repisa SET DEFAULT nextval('public.repisa_id_repisa_seq'::regclass);
 ?   ALTER TABLE public.repisa ALTER COLUMN id_repisa DROP DEFAULT;
       public               postgres    false    292    291            N           2604    23778 
   rol id_rol    DEFAULT     h   ALTER TABLE ONLY public.rol ALTER COLUMN id_rol SET DEFAULT nextval('public.rol_id_rol_seq'::regclass);
 9   ALTER TABLE public.rol ALTER COLUMN id_rol DROP DEFAULT;
       public               postgres    false    294    293            O           2604    23779    sector id_sector    DEFAULT     t   ALTER TABLE ONLY public.sector ALTER COLUMN id_sector SET DEFAULT nextval('public.sector_id_sector_seq'::regclass);
 ?   ALTER TABLE public.sector ALTER COLUMN id_sector DROP DEFAULT;
       public               postgres    false    296    295            P           2604    23780    solicitud_permiso id_solicitud    DEFAULT     �   ALTER TABLE ONLY public.solicitud_permiso ALTER COLUMN id_solicitud SET DEFAULT nextval('public.solicitud_permiso_id_solicitud_seq'::regclass);
 M   ALTER TABLE public.solicitud_permiso ALTER COLUMN id_solicitud DROP DEFAULT;
       public               postgres    false    298    297            Q           2604    23781    tareas id_tareas    DEFAULT     t   ALTER TABLE ONLY public.tareas ALTER COLUMN id_tareas SET DEFAULT nextval('public.tareas_id_tareas_seq'::regclass);
 ?   ALTER TABLE public.tareas ALTER COLUMN id_tareas DROP DEFAULT;
       public               postgres    false    300    299            R           2604    23782    temporada id_temporada    DEFAULT     �   ALTER TABLE ONLY public.temporada ALTER COLUMN id_temporada SET DEFAULT nextval('public.temporada_id_temporada_seq'::regclass);
 E   ALTER TABLE public.temporada ALTER COLUMN id_temporada DROP DEFAULT;
       public               postgres    false    302    301            S           2604    23783    tipo_producto id_tipo    DEFAULT     ~   ALTER TABLE ONLY public.tipo_producto ALTER COLUMN id_tipo SET DEFAULT nextval('public.tipo_producto_id_tipo_seq'::regclass);
 D   ALTER TABLE public.tipo_producto ALTER COLUMN id_tipo DROP DEFAULT;
       public               postgres    false    304    303            T           2604    23784    turno id_turno    DEFAULT     p   ALTER TABLE ONLY public.turno ALTER COLUMN id_turno SET DEFAULT nextval('public.turno_id_turno_seq'::regclass);
 =   ALTER TABLE public.turno ALTER COLUMN id_turno DROP DEFAULT;
       public               postgres    false    306    305            U           2604    23785    usuario id_usuario    DEFAULT     x   ALTER TABLE ONLY public.usuario ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuario_id_usuario_seq'::regclass);
 A   ALTER TABLE public.usuario ALTER COLUMN id_usuario DROP DEFAULT;
       public               postgres    false    308    307            �          0    23531    almacen 
   TABLE DATA           B   COPY public.almacen (id_almacen, codigo, dimenciones) FROM stdin;
    public               postgres    false    217   �p      �          0    23537    asignacion_estado 
   TABLE DATA           a   COPY public.asignacion_estado (id_asignacion, fecha, motivo, id_personal, id_estado) FROM stdin;
    public               postgres    false    219   �p      �          0    23541    asignacion_permiso 
   TABLE DATA           [   COPY public.asignacion_permiso (id_asignacion, fecha, id_personal, id_permiso) FROM stdin;
    public               postgres    false    221   tq      �          0    23545    backup 
   TABLE DATA           M   COPY public.backup (id, id_usuario, nombre_archivo, fecha, tipo) FROM stdin;
    public               postgres    false    223   �q      �          0    23549    bitacora 
   TABLE DATA           J   COPY public.bitacora (id, id_usuario, ip, fecha, descripcion) FROM stdin;
    public               postgres    false    225   r      �          0    23555    boleta_compra 
   TABLE DATA           l   COPY public.boleta_compra (id_boleta, costo_total, fecha, id_proveedor, id_metodo_pago, estado) FROM stdin;
    public               postgres    false    227   �}      �          0    23559    boleta_devolucion 
   TABLE DATA           V   COPY public.boleta_devolucion (id_boleta, descripcion, total, id_cliente) FROM stdin;
    public               postgres    false    229   ~      �          0    23562    boleta_devolucion_compra 
   TABLE DATA           c   COPY public.boleta_devolucion_compra (id_boleta, fecha, descripcion, id_boleta_compra) FROM stdin;
    public               postgres    false    230   /~      �          0    23567    boleta_entrada 
   TABLE DATA           n   COPY public.boleta_entrada (id_boleta, fecha, descripcion, id_boleta_compra, estado, id_personal) FROM stdin;
    public               postgres    false    233   L~      �          0    23573    boleta_recepcion 
   TABLE DATA           c   COPY public.boleta_recepcion (id_boleta, descripcion, puntaje, id_cliente, id_factura) FROM stdin;
    public               postgres    false    235   �~      �          0    23577    boleta_reclamos 
   TABLE DATA           d   COPY public.boleta_reclamos (id_boleta, motivo, descripcion, fecha, estado, id_cliente) FROM stdin;
    public               postgres    false    237         �          0    23583    boleta_salida 
   TABLE DATA           O   COPY public.boleta_salida (id_boleta, id_lote, id_personal, fecha) FROM stdin;
    public               postgres    false    239   (      �          0    23587    caja 
   TABLE DATA           <   COPY public.caja (id_caja, codigo, id_personal) FROM stdin;
    public               postgres    false    241   S      �          0    23591    carrito 
   TABLE DATA           O   COPY public.carrito (id_carrito, total, estado, fecha, id_cliente) FROM stdin;
    public               postgres    false    243   p      �          0    23595 	   categoria 
   TABLE DATA           9   COPY public.categoria (id_categoria, nombre) FROM stdin;
    public               postgres    false    245   ��      �          0    23599    cliente 
   TABLE DATA           �   COPY public.cliente (id_cliente, nombre_cliente, apellido_cliente, carnet_cliente, nit_cliente, direccion_cliente, id_usuario, estado_cliente_id) FROM stdin;
    public               postgres    false    247   ��      �          0    23603    control_asistencia 
   TABLE DATA           Z   COPY public.control_asistencia (id_control, fecha, hora, estado, id_personal) FROM stdin;
    public               postgres    false    249   ��      �          0    23607 	   descuento 
   TABLE DATA           l   COPY public.descuento (id_descuento, porcentaje, fecha_inicio, fecha_culminacion, id_temporada) FROM stdin;
    public               postgres    false    251   ��      �          0    23611    detalle_boleta_compra 
   TABLE DATA           t   COPY public.detalle_boleta_compra (id_detalle, cantidad, costo_unitario, id_boleta_compra, id_producto) FROM stdin;
    public               postgres    false    253   ҁ      �          0    23615     detalle_boleta_devolucion_compra 
   TABLE DATA           z   COPY public.detalle_boleta_devolucion_compra (id_boleta, cantidad, motivo, id_devolucion_compra, id_producto) FROM stdin;
    public               postgres    false    255   ��      �          0    23619    detalle_boleta_entrada 
   TABLE DATA           �   COPY public.detalle_boleta_entrada (id_boleta, cantidad, id_boleta_entrada, id_producto, cantidad_comprada, costo_unitario, id_lote) FROM stdin;
    public               postgres    false    257   �      �          0    23623    detalle_boleta_salida 
   TABLE DATA           l   COPY public.detalle_boleta_salida (id_detalle, cantidad, motivo, id_boleta_salida, id_producto) FROM stdin;
    public               postgres    false    259   Q�      �          0    23627    detalle_carrito_compra 
   TABLE DATA           �   COPY public.detalle_carrito_compra (id_detalle_carrito, cantidad, precio, subtotal, id_producto, id_carrito, url, descripcion) FROM stdin;
    public               postgres    false    261   n�      �          0    23633    detalle_devolucion 
   TABLE DATA           o   COPY public.detalle_devolucion (id_boleta_detalle, codigo_producto, subtotal, cantidad, id_boleta) FROM stdin;
    public               postgres    false    263   ��      �          0    28789    encargado_inventario 
   TABLE DATA           f   COPY public.encargado_inventario (id_encargado, nombre, correo_notificacion, id_personal) FROM stdin;
    public               postgres    false    309   ��      �          0    23637    estado_cliente 
   TABLE DATA           B   COPY public.estado_cliente (id_estado, nombre_estado) FROM stdin;
    public               postgres    false    265   ކ      �          0    23643    estado_lote 
   TABLE DATA           8   COPY public.estado_lote (id_estado, nombre) FROM stdin;
    public               postgres    false    267   �      �          0    23647    estado_personal 
   TABLE DATA           <   COPY public.estado_personal (id_estado, nombre) FROM stdin;
    public               postgres    false    269   I�      �          0    23651    factura 
   TABLE DATA              COPY public.factura (id_factura, fecha, fecha_vencimiento, total, id_carrito, id_caja, id_metodo_pago, id_cliente) FROM stdin;
    public               postgres    false    271   |�      �          0    23655    lote 
   TABLE DATA           �   COPY public.lote (id_lote, stock, stock_minimo, id_repisa, id_estado, id_producto, id_almacen, costo_unitario, fecha_caducidad) FROM stdin;
    public               postgres    false    273   �      �          0    23659    marca 
   TABLE DATA           1   COPY public.marca (id_marca, nombre) FROM stdin;
    public               postgres    false    275   ��      �          0    23663    metodo_pago 
   TABLE DATA           8   COPY public.metodo_pago (id_metodo, nombre) FROM stdin;
    public               postgres    false    277   ��      �          0    23667    permiso 
   TABLE DATA           ]   COPY public.permiso (id_permiso, vista, ver, insertar, editar, eliminar, id_rol) FROM stdin;
    public               postgres    false    279   �      �          0    23671    personal 
   TABLE DATA           w   COPY public.personal (id_personal, nombre, apellido, carnet, fecha_creacion, id_rol, id_turno, id_usuario) FROM stdin;
    public               postgres    false    281   W�      �          0    23677    precio 
   TABLE DATA           I   COPY public.precio (id_precio, precio_unitario, id_producto) FROM stdin;
    public               postgres    false    283   �      �          0    23681    producto 
   TABLE DATA           p   COPY public.producto (id_producto, codigo, descripcion, id_marca, id_categoria, id_tipo, id_precio) FROM stdin;
    public               postgres    false    285   ��      �          0    23687    producto_imagen 
   TABLE DATA           F   COPY public.producto_imagen (id_imagen, url, id_producto) FROM stdin;
    public               postgres    false    287   ��      �          0    23691 	   proveedor 
   TABLE DATA           L   COPY public.proveedor (id_proveedor, nombre, direccion, estado) FROM stdin;
    public               postgres    false    289   ��      �          0    23697    repisa 
   TABLE DATA           I   COPY public.repisa (id_repisa, codigo, capacidad, id_sector) FROM stdin;
    public               postgres    false    291   �      �          0    23701    rol 
   TABLE DATA           -   COPY public.rol (id_rol, nombre) FROM stdin;
    public               postgres    false    293   C�      �          0    23705    sector 
   TABLE DATA           >   COPY public.sector (id_sector, nombre, ubicacion) FROM stdin;
    public               postgres    false    295   ��      �          0    23711    solicitud_permiso 
   TABLE DATA           ]   COPY public.solicitud_permiso (id_solicitud, fecha, motivo, estado, id_personal) FROM stdin;
    public               postgres    false    297   Ս      �          0    23717    tareas 
   TABLE DATA           T   COPY public.tareas (id_tareas, fecha, descripcion, estado, id_personal) FROM stdin;
    public               postgres    false    299   �      �          0    23723 	   temporada 
   TABLE DATA           V   COPY public.temporada (id_temporada, nombre, mes_inicio, mes_culminacion) FROM stdin;
    public               postgres    false    301   �      �          0    23729    tipo_producto 
   TABLE DATA           8   COPY public.tipo_producto (id_tipo, nombre) FROM stdin;
    public               postgres    false    303   ,�      �          0    23733    turno 
   TABLE DATA           Q   COPY public.turno (id_turno, descripcion, hora_entrada, hora_salida) FROM stdin;
    public               postgres    false    305   ]�      �          0    23737    usuario 
   TABLE DATA           X   COPY public.usuario (id_usuario, username, correo_electronico, contrasenia) FROM stdin;
    public               postgres    false    307   ��                 0    0    almacen_id_almacen_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.almacen_id_almacen_seq', 2, false);
          public               postgres    false    218                       0    0 #   asignacion_estado_id_asignacion_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.asignacion_estado_id_asignacion_seq', 10, false);
          public               postgres    false    220                       0    0 $   asignacion_permiso_id_asignacion_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.asignacion_permiso_id_asignacion_seq', 1, false);
          public               postgres    false    222                       0    0    backup_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.backup_id_seq', 2, true);
          public               postgres    false    224                       0    0    bitacora_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.bitacora_id_seq', 293, true);
          public               postgres    false    226                       0    0    boleta_compra_id_boleta_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.boleta_compra_id_boleta_seq', 2, true);
          public               postgres    false    228                       0    0 &   boleta_devolucion_compra_id_boleta_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.boleta_devolucion_compra_id_boleta_seq', 1, false);
          public               postgres    false    231                       0    0    boleta_devolucion_id_boleta_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.boleta_devolucion_id_boleta_seq', 1, false);
          public               postgres    false    232                       0    0    boleta_entrada_id_boleta_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.boleta_entrada_id_boleta_seq', 2, true);
          public               postgres    false    234                       0    0    boleta_recepcion_id_boleta_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.boleta_recepcion_id_boleta_seq', 4, true);
          public               postgres    false    236                       0    0    boleta_reclamos_id_boleta_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.boleta_reclamos_id_boleta_seq', 1, false);
          public               postgres    false    238                       0    0    boleta_salida_id_boleta_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.boleta_salida_id_boleta_seq', 13, false);
          public               postgres    false    240                       0    0    caja_id_caja_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.caja_id_caja_seq', 1, false);
          public               postgres    false    242                       0    0    carrito_id_carrito_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.carrito_id_carrito_seq', 83, true);
          public               postgres    false    244                       0    0    categoria_id_categoria_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 6, false);
          public               postgres    false    246                       0    0    cliente_id_cliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.cliente_id_cliente_seq', 47, true);
          public               postgres    false    248                       0    0 !   control_asistencia_id_control_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.control_asistencia_id_control_seq', 1, false);
          public               postgres    false    250                        0    0    descuento_id_descuento_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.descuento_id_descuento_seq', 1, false);
          public               postgres    false    252            !           0    0 $   detalle_boleta_compra_id_detalle_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.detalle_boleta_compra_id_detalle_seq', 1, true);
          public               postgres    false    254            "           0    0 .   detalle_boleta_devolucion_compra_id_boleta_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public.detalle_boleta_devolucion_compra_id_boleta_seq', 1, false);
          public               postgres    false    256            #           0    0 $   detalle_boleta_entrada_id_boleta_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('public.detalle_boleta_entrada_id_boleta_seq', 2, true);
          public               postgres    false    258            $           0    0 $   detalle_boleta_salida_id_detalle_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.detalle_boleta_salida_id_detalle_seq', 1, false);
          public               postgres    false    260            %           0    0 -   detalle_carrito_compra_id_detalle_carrito_seq    SEQUENCE SET     ]   SELECT pg_catalog.setval('public.detalle_carrito_compra_id_detalle_carrito_seq', 200, true);
          public               postgres    false    262            &           0    0 (   detalle_devolucion_id_boleta_detalle_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.detalle_devolucion_id_boleta_detalle_seq', 1, false);
          public               postgres    false    264            '           0    0    estado_cliente_id_estado_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.estado_cliente_id_estado_seq', 2, true);
          public               postgres    false    266            (           0    0    estado_lote_id_estado_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.estado_lote_id_estado_seq', 3, false);
          public               postgres    false    268            )           0    0    estado_personal_id_estado_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.estado_personal_id_estado_seq', 2, false);
          public               postgres    false    270            *           0    0    factura_id_factura_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.factura_id_factura_seq', 13, true);
          public               postgres    false    272            +           0    0    id_encargado_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.id_encargado_seq', 1, true);
          public               postgres    false    310            ,           0    0    lote_id_lote_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.lote_id_lote_seq', 5, true);
          public               postgres    false    274            -           0    0    marca_id_marca_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.marca_id_marca_seq', 7, false);
          public               postgres    false    276            .           0    0    metodo_pago_id_metodo_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.metodo_pago_id_metodo_seq', 2, false);
          public               postgres    false    278            /           0    0    permiso_id_permiso_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.permiso_id_permiso_seq', 7, true);
          public               postgres    false    280            0           0    0    personal_id_personal_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.personal_id_personal_seq', 6, false);
          public               postgres    false    282            1           0    0    precio_id_precio_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.precio_id_precio_seq', 14, true);
          public               postgres    false    284            2           0    0    producto_id_producto_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.producto_id_producto_seq', 26, false);
          public               postgres    false    286            3           0    0    producto_imagen_id_imagen_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.producto_imagen_id_imagen_seq', 17, true);
          public               postgres    false    288            4           0    0    proveedor_id_proveedor_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.proveedor_id_proveedor_seq', 2, false);
          public               postgres    false    290            5           0    0    repisa_id_repisa_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.repisa_id_repisa_seq', 2, false);
          public               postgres    false    292            6           0    0    rol_id_rol_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.rol_id_rol_seq', 4, true);
          public               postgres    false    294            7           0    0    sector_id_sector_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.sector_id_sector_seq', 5, false);
          public               postgres    false    296            8           0    0 "   solicitud_permiso_id_solicitud_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.solicitud_permiso_id_solicitud_seq', 1, false);
          public               postgres    false    298            9           0    0    tareas_id_tareas_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.tareas_id_tareas_seq', 1, false);
          public               postgres    false    300            :           0    0    temporada_id_temporada_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.temporada_id_temporada_seq', 1, false);
          public               postgres    false    302            ;           0    0    tipo_producto_id_tipo_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.tipo_producto_id_tipo_seq', 2, false);
          public               postgres    false    304            <           0    0    turno_id_turno_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.turno_id_turno_seq', 2, false);
          public               postgres    false    306            =           0    0    usuario_id_usuario_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.usuario_id_usuario_seq', 71, true);
          public               postgres    false    308            X           2606    23787    almacen almacen_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.almacen
    ADD CONSTRAINT almacen_pkey PRIMARY KEY (id_almacen);
 >   ALTER TABLE ONLY public.almacen DROP CONSTRAINT almacen_pkey;
       public                 postgres    false    217            Z           2606    23789 (   asignacion_estado asignacion_estado_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.asignacion_estado
    ADD CONSTRAINT asignacion_estado_pkey PRIMARY KEY (id_asignacion);
 R   ALTER TABLE ONLY public.asignacion_estado DROP CONSTRAINT asignacion_estado_pkey;
       public                 postgres    false    219            \           2606    23791 *   asignacion_permiso asignacion_permiso_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.asignacion_permiso
    ADD CONSTRAINT asignacion_permiso_pkey PRIMARY KEY (id_asignacion);
 T   ALTER TABLE ONLY public.asignacion_permiso DROP CONSTRAINT asignacion_permiso_pkey;
       public                 postgres    false    221            ^           2606    23793    backup backup_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.backup
    ADD CONSTRAINT backup_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.backup DROP CONSTRAINT backup_pkey;
       public                 postgres    false    223            `           2606    23795    bitacora bitacora_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.bitacora DROP CONSTRAINT bitacora_pkey;
       public                 postgres    false    225            b           2606    23797     boleta_compra boleta_compra_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.boleta_compra
    ADD CONSTRAINT boleta_compra_pkey PRIMARY KEY (id_boleta);
 J   ALTER TABLE ONLY public.boleta_compra DROP CONSTRAINT boleta_compra_pkey;
       public                 postgres    false    227            f           2606    23799 6   boleta_devolucion_compra boleta_devolucion_compra_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.boleta_devolucion_compra
    ADD CONSTRAINT boleta_devolucion_compra_pkey PRIMARY KEY (id_boleta);
 `   ALTER TABLE ONLY public.boleta_devolucion_compra DROP CONSTRAINT boleta_devolucion_compra_pkey;
       public                 postgres    false    230            d           2606    23801 (   boleta_devolucion boleta_devolucion_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.boleta_devolucion
    ADD CONSTRAINT boleta_devolucion_pkey PRIMARY KEY (id_boleta);
 R   ALTER TABLE ONLY public.boleta_devolucion DROP CONSTRAINT boleta_devolucion_pkey;
       public                 postgres    false    229            h           2606    23803 "   boleta_entrada boleta_entrada_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.boleta_entrada
    ADD CONSTRAINT boleta_entrada_pkey PRIMARY KEY (id_boleta);
 L   ALTER TABLE ONLY public.boleta_entrada DROP CONSTRAINT boleta_entrada_pkey;
       public                 postgres    false    233            j           2606    23805 &   boleta_recepcion boleta_recepcion_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.boleta_recepcion
    ADD CONSTRAINT boleta_recepcion_pkey PRIMARY KEY (id_boleta);
 P   ALTER TABLE ONLY public.boleta_recepcion DROP CONSTRAINT boleta_recepcion_pkey;
       public                 postgres    false    235            l           2606    23807 $   boleta_reclamos boleta_reclamos_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.boleta_reclamos
    ADD CONSTRAINT boleta_reclamos_pkey PRIMARY KEY (id_boleta);
 N   ALTER TABLE ONLY public.boleta_reclamos DROP CONSTRAINT boleta_reclamos_pkey;
       public                 postgres    false    237            n           2606    23809     boleta_salida boleta_salida_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.boleta_salida
    ADD CONSTRAINT boleta_salida_pkey PRIMARY KEY (id_boleta);
 J   ALTER TABLE ONLY public.boleta_salida DROP CONSTRAINT boleta_salida_pkey;
       public                 postgres    false    239            p           2606    23811    caja caja_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_pkey PRIMARY KEY (id_caja);
 8   ALTER TABLE ONLY public.caja DROP CONSTRAINT caja_pkey;
       public                 postgres    false    241            r           2606    23813    carrito carrito_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.carrito
    ADD CONSTRAINT carrito_pkey PRIMARY KEY (id_carrito);
 >   ALTER TABLE ONLY public.carrito DROP CONSTRAINT carrito_pkey;
       public                 postgres    false    243            t           2606    23815    categoria categoria_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id_categoria);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public                 postgres    false    245            v           2606    23817    cliente cliente_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public                 postgres    false    247            x           2606    23819 *   control_asistencia control_asistencia_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.control_asistencia
    ADD CONSTRAINT control_asistencia_pkey PRIMARY KEY (id_control);
 T   ALTER TABLE ONLY public.control_asistencia DROP CONSTRAINT control_asistencia_pkey;
       public                 postgres    false    249            z           2606    23821    descuento descuento_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.descuento
    ADD CONSTRAINT descuento_pkey PRIMARY KEY (id_descuento);
 B   ALTER TABLE ONLY public.descuento DROP CONSTRAINT descuento_pkey;
       public                 postgres    false    251            |           2606    23823 0   detalle_boleta_compra detalle_boleta_compra_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.detalle_boleta_compra
    ADD CONSTRAINT detalle_boleta_compra_pkey PRIMARY KEY (id_detalle);
 Z   ALTER TABLE ONLY public.detalle_boleta_compra DROP CONSTRAINT detalle_boleta_compra_pkey;
       public                 postgres    false    253            ~           2606    23825 F   detalle_boleta_devolucion_compra detalle_boleta_devolucion_compra_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_devolucion_compra
    ADD CONSTRAINT detalle_boleta_devolucion_compra_pkey PRIMARY KEY (id_boleta);
 p   ALTER TABLE ONLY public.detalle_boleta_devolucion_compra DROP CONSTRAINT detalle_boleta_devolucion_compra_pkey;
       public                 postgres    false    255            �           2606    23827 2   detalle_boleta_entrada detalle_boleta_entrada_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.detalle_boleta_entrada
    ADD CONSTRAINT detalle_boleta_entrada_pkey PRIMARY KEY (id_boleta);
 \   ALTER TABLE ONLY public.detalle_boleta_entrada DROP CONSTRAINT detalle_boleta_entrada_pkey;
       public                 postgres    false    257            �           2606    23829 0   detalle_boleta_salida detalle_boleta_salida_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.detalle_boleta_salida
    ADD CONSTRAINT detalle_boleta_salida_pkey PRIMARY KEY (id_detalle);
 Z   ALTER TABLE ONLY public.detalle_boleta_salida DROP CONSTRAINT detalle_boleta_salida_pkey;
       public                 postgres    false    259            �           2606    23831 2   detalle_carrito_compra detalle_carrito_compra_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.detalle_carrito_compra
    ADD CONSTRAINT detalle_carrito_compra_pkey PRIMARY KEY (id_detalle_carrito);
 \   ALTER TABLE ONLY public.detalle_carrito_compra DROP CONSTRAINT detalle_carrito_compra_pkey;
       public                 postgres    false    261            �           2606    23833 *   detalle_devolucion detalle_devolucion_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.detalle_devolucion
    ADD CONSTRAINT detalle_devolucion_pkey PRIMARY KEY (id_boleta_detalle);
 T   ALTER TABLE ONLY public.detalle_devolucion DROP CONSTRAINT detalle_devolucion_pkey;
       public                 postgres    false    263            �           2606    28795 .   encargado_inventario encargado_inventario_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.encargado_inventario
    ADD CONSTRAINT encargado_inventario_pkey PRIMARY KEY (id_encargado);
 X   ALTER TABLE ONLY public.encargado_inventario DROP CONSTRAINT encargado_inventario_pkey;
       public                 postgres    false    309            �           2606    23835 "   estado_cliente estado_cliente_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.estado_cliente
    ADD CONSTRAINT estado_cliente_pkey PRIMARY KEY (id_estado);
 L   ALTER TABLE ONLY public.estado_cliente DROP CONSTRAINT estado_cliente_pkey;
       public                 postgres    false    265            �           2606    23837    estado_lote estado_lote_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.estado_lote
    ADD CONSTRAINT estado_lote_pkey PRIMARY KEY (id_estado);
 F   ALTER TABLE ONLY public.estado_lote DROP CONSTRAINT estado_lote_pkey;
       public                 postgres    false    267            �           2606    23839 $   estado_personal estado_personal_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.estado_personal
    ADD CONSTRAINT estado_personal_pkey PRIMARY KEY (id_estado);
 N   ALTER TABLE ONLY public.estado_personal DROP CONSTRAINT estado_personal_pkey;
       public                 postgres    false    269            �           2606    23841    factura factura_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_pkey PRIMARY KEY (id_factura);
 >   ALTER TABLE ONLY public.factura DROP CONSTRAINT factura_pkey;
       public                 postgres    false    271            �           2606    23843    lote lote_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.lote
    ADD CONSTRAINT lote_pkey PRIMARY KEY (id_lote);
 8   ALTER TABLE ONLY public.lote DROP CONSTRAINT lote_pkey;
       public                 postgres    false    273            �           2606    23845    marca marca_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.marca
    ADD CONSTRAINT marca_pkey PRIMARY KEY (id_marca);
 :   ALTER TABLE ONLY public.marca DROP CONSTRAINT marca_pkey;
       public                 postgres    false    275            �           2606    23847    metodo_pago metodo_pago_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.metodo_pago
    ADD CONSTRAINT metodo_pago_pkey PRIMARY KEY (id_metodo);
 F   ALTER TABLE ONLY public.metodo_pago DROP CONSTRAINT metodo_pago_pkey;
       public                 postgres    false    277            �           2606    23849    permiso permiso_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_pkey PRIMARY KEY (id_permiso);
 >   ALTER TABLE ONLY public.permiso DROP CONSTRAINT permiso_pkey;
       public                 postgres    false    279            �           2606    23851    personal personal_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.personal
    ADD CONSTRAINT personal_pkey PRIMARY KEY (id_personal);
 @   ALTER TABLE ONLY public.personal DROP CONSTRAINT personal_pkey;
       public                 postgres    false    281            �           2606    23853    precio precio_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.precio
    ADD CONSTRAINT precio_pkey PRIMARY KEY (id_precio);
 <   ALTER TABLE ONLY public.precio DROP CONSTRAINT precio_pkey;
       public                 postgres    false    283            �           2606    23855 $   producto_imagen producto_imagen_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.producto_imagen
    ADD CONSTRAINT producto_imagen_pkey PRIMARY KEY (id_imagen);
 N   ALTER TABLE ONLY public.producto_imagen DROP CONSTRAINT producto_imagen_pkey;
       public                 postgres    false    287            �           2606    23857    producto producto_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);
 @   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_pkey;
       public                 postgres    false    285            �           2606    23859    proveedor proveedor_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);
 B   ALTER TABLE ONLY public.proveedor DROP CONSTRAINT proveedor_pkey;
       public                 postgres    false    289            �           2606    23861    repisa repisa_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.repisa
    ADD CONSTRAINT repisa_pkey PRIMARY KEY (id_repisa);
 <   ALTER TABLE ONLY public.repisa DROP CONSTRAINT repisa_pkey;
       public                 postgres    false    291            �           2606    23863    rol rol_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);
 6   ALTER TABLE ONLY public.rol DROP CONSTRAINT rol_pkey;
       public                 postgres    false    293            �           2606    23865    sector sector_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.sector
    ADD CONSTRAINT sector_pkey PRIMARY KEY (id_sector);
 <   ALTER TABLE ONLY public.sector DROP CONSTRAINT sector_pkey;
       public                 postgres    false    295            �           2606    23867 (   solicitud_permiso solicitud_permiso_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.solicitud_permiso
    ADD CONSTRAINT solicitud_permiso_pkey PRIMARY KEY (id_solicitud);
 R   ALTER TABLE ONLY public.solicitud_permiso DROP CONSTRAINT solicitud_permiso_pkey;
       public                 postgres    false    297            �           2606    23869    tareas tareas_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT tareas_pkey PRIMARY KEY (id_tareas);
 <   ALTER TABLE ONLY public.tareas DROP CONSTRAINT tareas_pkey;
       public                 postgres    false    299            �           2606    23871    temporada temporada_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.temporada
    ADD CONSTRAINT temporada_pkey PRIMARY KEY (id_temporada);
 B   ALTER TABLE ONLY public.temporada DROP CONSTRAINT temporada_pkey;
       public                 postgres    false    301            �           2606    23873     tipo_producto tipo_producto_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.tipo_producto
    ADD CONSTRAINT tipo_producto_pkey PRIMARY KEY (id_tipo);
 J   ALTER TABLE ONLY public.tipo_producto DROP CONSTRAINT tipo_producto_pkey;
       public                 postgres    false    303            �           2606    23875    turno turno_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.turno
    ADD CONSTRAINT turno_pkey PRIMARY KEY (id_turno);
 :   ALTER TABLE ONLY public.turno DROP CONSTRAINT turno_pkey;
       public                 postgres    false    305            �           2606    23877    usuario usuario_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public                 postgres    false    307            �           2620    23878 '   boleta_salida trg_restaurar_estado_lote    TRIGGER     �   CREATE TRIGGER trg_restaurar_estado_lote AFTER DELETE ON public.boleta_salida FOR EACH ROW EXECUTE FUNCTION public.restaurar_estado_lote();
 @   DROP TRIGGER trg_restaurar_estado_lote ON public.boleta_salida;
       public               postgres    false    239    355            �           2620    23879 4   detalle_boleta_entrada trigger_actualizar_stock_lote    TRIGGER     �   CREATE TRIGGER trigger_actualizar_stock_lote AFTER INSERT ON public.detalle_boleta_entrada FOR EACH ROW EXECUTE FUNCTION public.actualizar_stock_lote();
 M   DROP TRIGGER trigger_actualizar_stock_lote ON public.detalle_boleta_entrada;
       public               postgres    false    339    257            �           2606    23880 2   asignacion_estado asignacion_estado_id_estado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.asignacion_estado
    ADD CONSTRAINT asignacion_estado_id_estado_fkey FOREIGN KEY (id_estado) REFERENCES public.estado_personal(id_estado);
 \   ALTER TABLE ONLY public.asignacion_estado DROP CONSTRAINT asignacion_estado_id_estado_fkey;
       public               postgres    false    5004    219    269            �           2606    23885 4   asignacion_estado asignacion_estado_id_personal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.asignacion_estado
    ADD CONSTRAINT asignacion_estado_id_personal_fkey FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 ^   ALTER TABLE ONLY public.asignacion_estado DROP CONSTRAINT asignacion_estado_id_personal_fkey;
       public               postgres    false    281    5016    219            �           2606    23890 5   asignacion_permiso asignacion_permiso_id_permiso_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.asignacion_permiso
    ADD CONSTRAINT asignacion_permiso_id_permiso_fkey FOREIGN KEY (id_permiso) REFERENCES public.permiso(id_permiso);
 _   ALTER TABLE ONLY public.asignacion_permiso DROP CONSTRAINT asignacion_permiso_id_permiso_fkey;
       public               postgres    false    5014    221    279            �           2606    23895 6   asignacion_permiso asignacion_permiso_id_personal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.asignacion_permiso
    ADD CONSTRAINT asignacion_permiso_id_personal_fkey FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 `   ALTER TABLE ONLY public.asignacion_permiso DROP CONSTRAINT asignacion_permiso_id_personal_fkey;
       public               postgres    false    281    5016    221            �           2606    23900    backup backup_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.backup
    ADD CONSTRAINT backup_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);
 G   ALTER TABLE ONLY public.backup DROP CONSTRAINT backup_id_usuario_fkey;
       public               postgres    false    307    223    5042            �           2606    23905 !   bitacora bitacora_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);
 K   ALTER TABLE ONLY public.bitacora DROP CONSTRAINT bitacora_id_usuario_fkey;
       public               postgres    false    225    307    5042            �           2606    23910 /   boleta_compra boleta_compra_id_metodo_pago_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_compra
    ADD CONSTRAINT boleta_compra_id_metodo_pago_fkey FOREIGN KEY (id_metodo_pago) REFERENCES public.metodo_pago(id_metodo);
 Y   ALTER TABLE ONLY public.boleta_compra DROP CONSTRAINT boleta_compra_id_metodo_pago_fkey;
       public               postgres    false    277    5012    227            �           2606    23915 -   boleta_compra boleta_compra_id_proveedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_compra
    ADD CONSTRAINT boleta_compra_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);
 W   ALTER TABLE ONLY public.boleta_compra DROP CONSTRAINT boleta_compra_id_proveedor_fkey;
       public               postgres    false    5024    227    289            �           2606    23920 G   boleta_devolucion_compra boleta_devolucion_compra_id_boleta_compra_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_devolucion_compra
    ADD CONSTRAINT boleta_devolucion_compra_id_boleta_compra_fkey FOREIGN KEY (id_boleta_compra) REFERENCES public.boleta_compra(id_boleta);
 q   ALTER TABLE ONLY public.boleta_devolucion_compra DROP CONSTRAINT boleta_devolucion_compra_id_boleta_compra_fkey;
       public               postgres    false    227    230    4962            �           2606    23925 3   boleta_devolucion boleta_devolucion_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_devolucion
    ADD CONSTRAINT boleta_devolucion_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 ]   ALTER TABLE ONLY public.boleta_devolucion DROP CONSTRAINT boleta_devolucion_id_cliente_fkey;
       public               postgres    false    229    4982    247            �           2606    23930 3   boleta_entrada boleta_entrada_id_boleta_compra_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_entrada
    ADD CONSTRAINT boleta_entrada_id_boleta_compra_fkey FOREIGN KEY (id_boleta_compra) REFERENCES public.boleta_compra(id_boleta);
 ]   ALTER TABLE ONLY public.boleta_entrada DROP CONSTRAINT boleta_entrada_id_boleta_compra_fkey;
       public               postgres    false    233    4962    227            �           2606    23935 ,   boleta_entrada boleta_entrada_id_personal_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_entrada
    ADD CONSTRAINT boleta_entrada_id_personal_fk FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal) NOT VALID;
 V   ALTER TABLE ONLY public.boleta_entrada DROP CONSTRAINT boleta_entrada_id_personal_fk;
       public               postgres    false    233    281    5016            �           2606    23940 1   boleta_recepcion boleta_recepcion_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_recepcion
    ADD CONSTRAINT boleta_recepcion_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 [   ALTER TABLE ONLY public.boleta_recepcion DROP CONSTRAINT boleta_recepcion_id_cliente_fkey;
       public               postgres    false    247    4982    235            �           2606    24151 1   boleta_recepcion boleta_recepcion_id_factura_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_recepcion
    ADD CONSTRAINT boleta_recepcion_id_factura_fkey FOREIGN KEY (id_factura) REFERENCES public.factura(id_factura) NOT VALID;
 [   ALTER TABLE ONLY public.boleta_recepcion DROP CONSTRAINT boleta_recepcion_id_factura_fkey;
       public               postgres    false    235    5006    271            �           2606    23945 /   boleta_reclamos boleta_reclamos_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_reclamos
    ADD CONSTRAINT boleta_reclamos_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 Y   ALTER TABLE ONLY public.boleta_reclamos DROP CONSTRAINT boleta_reclamos_id_cliente_fkey;
       public               postgres    false    237    4982    247            �           2606    23950 (   boleta_salida boleta_salida_id_lote_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_salida
    ADD CONSTRAINT boleta_salida_id_lote_fkey FOREIGN KEY (id_lote) REFERENCES public.lote(id_lote);
 R   ALTER TABLE ONLY public.boleta_salida DROP CONSTRAINT boleta_salida_id_lote_fkey;
       public               postgres    false    273    239    5008            �           2606    23955 ,   boleta_salida boleta_salida_id_personal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.boleta_salida
    ADD CONSTRAINT boleta_salida_id_personal_fkey FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 V   ALTER TABLE ONLY public.boleta_salida DROP CONSTRAINT boleta_salida_id_personal_fkey;
       public               postgres    false    239    5016    281            �           2606    23960    caja caja_id_personal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.caja
    ADD CONSTRAINT caja_id_personal_fkey FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 D   ALTER TABLE ONLY public.caja DROP CONSTRAINT caja_id_personal_fkey;
       public               postgres    false    241    281    5016            �           2606    23965    carrito carrito_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.carrito
    ADD CONSTRAINT carrito_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 I   ALTER TABLE ONLY public.carrito DROP CONSTRAINT carrito_id_cliente_fkey;
       public               postgres    false    4982    247    243            �           2606    23970 &   cliente cliente_estado_cliente_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_estado_cliente_id_fkey FOREIGN KEY (estado_cliente_id) REFERENCES public.estado_cliente(id_estado);
 P   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_estado_cliente_id_fkey;
       public               postgres    false    247    5000    265            �           2606    23975    cliente cliente_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);
 I   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_id_usuario_fkey;
       public               postgres    false    307    247    5042            �           2606    23980 6   control_asistencia control_asistencia_id_personal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.control_asistencia
    ADD CONSTRAINT control_asistencia_id_personal_fkey FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 `   ALTER TABLE ONLY public.control_asistencia DROP CONSTRAINT control_asistencia_id_personal_fkey;
       public               postgres    false    5016    281    249            �           2606    23985 %   descuento descuento_id_temporada_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.descuento
    ADD CONSTRAINT descuento_id_temporada_fkey FOREIGN KEY (id_temporada) REFERENCES public.temporada(id_temporada);
 O   ALTER TABLE ONLY public.descuento DROP CONSTRAINT descuento_id_temporada_fkey;
       public               postgres    false    301    251    5036            �           2606    23990 A   detalle_boleta_compra detalle_boleta_compra_id_boleta_compra_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_compra
    ADD CONSTRAINT detalle_boleta_compra_id_boleta_compra_fkey FOREIGN KEY (id_boleta_compra) REFERENCES public.boleta_compra(id_boleta);
 k   ALTER TABLE ONLY public.detalle_boleta_compra DROP CONSTRAINT detalle_boleta_compra_id_boleta_compra_fkey;
       public               postgres    false    227    4962    253            �           2606    23995 <   detalle_boleta_compra detalle_boleta_compra_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_compra
    ADD CONSTRAINT detalle_boleta_compra_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);
 f   ALTER TABLE ONLY public.detalle_boleta_compra DROP CONSTRAINT detalle_boleta_compra_id_producto_fkey;
       public               postgres    false    253    5020    285            �           2606    24000 [   detalle_boleta_devolucion_compra detalle_boleta_devolucion_compra_id_devolucion_compra_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_devolucion_compra
    ADD CONSTRAINT detalle_boleta_devolucion_compra_id_devolucion_compra_fkey FOREIGN KEY (id_devolucion_compra) REFERENCES public.boleta_devolucion_compra(id_boleta);
 �   ALTER TABLE ONLY public.detalle_boleta_devolucion_compra DROP CONSTRAINT detalle_boleta_devolucion_compra_id_devolucion_compra_fkey;
       public               postgres    false    4966    255    230            �           2606    24005 R   detalle_boleta_devolucion_compra detalle_boleta_devolucion_compra_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_devolucion_compra
    ADD CONSTRAINT detalle_boleta_devolucion_compra_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);
 |   ALTER TABLE ONLY public.detalle_boleta_devolucion_compra DROP CONSTRAINT detalle_boleta_devolucion_compra_id_producto_fkey;
       public               postgres    false    5020    255    285            �           2606    24010 D   detalle_boleta_entrada detalle_boleta_entrada_id_boleta_entrada_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_entrada
    ADD CONSTRAINT detalle_boleta_entrada_id_boleta_entrada_fkey FOREIGN KEY (id_boleta_entrada) REFERENCES public.boleta_entrada(id_boleta);
 n   ALTER TABLE ONLY public.detalle_boleta_entrada DROP CONSTRAINT detalle_boleta_entrada_id_boleta_entrada_fkey;
       public               postgres    false    233    257    4968            �           2606    24015 8   detalle_boleta_entrada detalle_boleta_entrada_id_lote_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_entrada
    ADD CONSTRAINT detalle_boleta_entrada_id_lote_fk FOREIGN KEY (id_lote) REFERENCES public.lote(id_lote) NOT VALID;
 b   ALTER TABLE ONLY public.detalle_boleta_entrada DROP CONSTRAINT detalle_boleta_entrada_id_lote_fk;
       public               postgres    false    257    5008    273            �           2606    24020 >   detalle_boleta_entrada detalle_boleta_entrada_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_entrada
    ADD CONSTRAINT detalle_boleta_entrada_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);
 h   ALTER TABLE ONLY public.detalle_boleta_entrada DROP CONSTRAINT detalle_boleta_entrada_id_producto_fkey;
       public               postgres    false    257    5020    285            �           2606    24025 A   detalle_boleta_salida detalle_boleta_salida_id_boleta_salida_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_salida
    ADD CONSTRAINT detalle_boleta_salida_id_boleta_salida_fkey FOREIGN KEY (id_boleta_salida) REFERENCES public.boleta_salida(id_boleta);
 k   ALTER TABLE ONLY public.detalle_boleta_salida DROP CONSTRAINT detalle_boleta_salida_id_boleta_salida_fkey;
       public               postgres    false    239    4974    259            �           2606    24030 <   detalle_boleta_salida detalle_boleta_salida_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_boleta_salida
    ADD CONSTRAINT detalle_boleta_salida_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);
 f   ALTER TABLE ONLY public.detalle_boleta_salida DROP CONSTRAINT detalle_boleta_salida_id_producto_fkey;
       public               postgres    false    285    259    5020            �           2606    24035 =   detalle_carrito_compra detalle_carrito_compra_id_carrito_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_carrito_compra
    ADD CONSTRAINT detalle_carrito_compra_id_carrito_fkey FOREIGN KEY (id_carrito) REFERENCES public.carrito(id_carrito);
 g   ALTER TABLE ONLY public.detalle_carrito_compra DROP CONSTRAINT detalle_carrito_compra_id_carrito_fkey;
       public               postgres    false    4978    243    261            �           2606    24040 >   detalle_carrito_compra detalle_carrito_compra_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_carrito_compra
    ADD CONSTRAINT detalle_carrito_compra_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);
 h   ALTER TABLE ONLY public.detalle_carrito_compra DROP CONSTRAINT detalle_carrito_compra_id_producto_fkey;
       public               postgres    false    261    5020    285            �           2606    24045 4   detalle_devolucion detalle_devolucion_id_boleta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_devolucion
    ADD CONSTRAINT detalle_devolucion_id_boleta_fkey FOREIGN KEY (id_boleta) REFERENCES public.boleta_devolucion(id_boleta);
 ^   ALTER TABLE ONLY public.detalle_devolucion DROP CONSTRAINT detalle_devolucion_id_boleta_fkey;
       public               postgres    false    263    4964    229            �           2606    28796 6   encargado_inventario encargado_alamacen_fk_id_personal    FK CONSTRAINT     �   ALTER TABLE ONLY public.encargado_inventario
    ADD CONSTRAINT encargado_alamacen_fk_id_personal FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 `   ALTER TABLE ONLY public.encargado_inventario DROP CONSTRAINT encargado_alamacen_fk_id_personal;
       public               postgres    false    281    309    5016            �           2606    24050    factura factura_id_caja_fkey    FK CONSTRAINT        ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_id_caja_fkey FOREIGN KEY (id_caja) REFERENCES public.caja(id_caja);
 F   ALTER TABLE ONLY public.factura DROP CONSTRAINT factura_id_caja_fkey;
       public               postgres    false    4976    271    241            �           2606    24055    factura factura_id_carrito_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_id_carrito_fkey FOREIGN KEY (id_carrito) REFERENCES public.carrito(id_carrito);
 I   ALTER TABLE ONLY public.factura DROP CONSTRAINT factura_id_carrito_fkey;
       public               postgres    false    4978    271    243            �           2606    24060    factura factura_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 I   ALTER TABLE ONLY public.factura DROP CONSTRAINT factura_id_cliente_fkey;
       public               postgres    false    271    4982    247            �           2606    24065 #   factura factura_id_metodo_pago_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.factura
    ADD CONSTRAINT factura_id_metodo_pago_fkey FOREIGN KEY (id_metodo_pago) REFERENCES public.metodo_pago(id_metodo);
 M   ALTER TABLE ONLY public.factura DROP CONSTRAINT factura_id_metodo_pago_fkey;
       public               postgres    false    271    277    5012            �           2606    24070 '   producto_imagen imagen_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto_imagen
    ADD CONSTRAINT imagen_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto) NOT VALID;
 Q   ALTER TABLE ONLY public.producto_imagen DROP CONSTRAINT imagen_id_producto_fkey;
       public               postgres    false    285    287    5020            �           2606    24075    lote lote_id_almacen_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.lote
    ADD CONSTRAINT lote_id_almacen_fkey FOREIGN KEY (id_almacen) REFERENCES public.almacen(id_almacen);
 C   ALTER TABLE ONLY public.lote DROP CONSTRAINT lote_id_almacen_fkey;
       public               postgres    false    4952    217    273            �           2606    24080    lote lote_id_estado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.lote
    ADD CONSTRAINT lote_id_estado_fkey FOREIGN KEY (id_estado) REFERENCES public.estado_lote(id_estado);
 B   ALTER TABLE ONLY public.lote DROP CONSTRAINT lote_id_estado_fkey;
       public               postgres    false    273    5002    267            �           2606    24085    lote lote_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.lote
    ADD CONSTRAINT lote_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto);
 D   ALTER TABLE ONLY public.lote DROP CONSTRAINT lote_id_producto_fkey;
       public               postgres    false    285    5020    273            �           2606    24090    lote lote_id_repisa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.lote
    ADD CONSTRAINT lote_id_repisa_fkey FOREIGN KEY (id_repisa) REFERENCES public.repisa(id_repisa);
 B   ALTER TABLE ONLY public.lote DROP CONSTRAINT lote_id_repisa_fkey;
       public               postgres    false    5026    273    291            �           2606    24095    permiso permiso_id_rol_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.rol(id_rol);
 E   ALTER TABLE ONLY public.permiso DROP CONSTRAINT permiso_id_rol_fkey;
       public               postgres    false    5028    293    279            �           2606    24100    personal personal_id_rol_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.personal
    ADD CONSTRAINT personal_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.rol(id_rol);
 G   ALTER TABLE ONLY public.personal DROP CONSTRAINT personal_id_rol_fkey;
       public               postgres    false    5028    293    281            �           2606    24105    personal personal_id_turno_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.personal
    ADD CONSTRAINT personal_id_turno_fkey FOREIGN KEY (id_turno) REFERENCES public.turno(id_turno);
 I   ALTER TABLE ONLY public.personal DROP CONSTRAINT personal_id_turno_fkey;
       public               postgres    false    5040    305    281            �           2606    24110 !   personal personal_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.personal
    ADD CONSTRAINT personal_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario);
 K   ALTER TABLE ONLY public.personal DROP CONSTRAINT personal_id_usuario_fkey;
       public               postgres    false    5042    307    281            �           2606    24115    precio precio_id_producto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.precio
    ADD CONSTRAINT precio_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto) NOT VALID;
 H   ALTER TABLE ONLY public.precio DROP CONSTRAINT precio_id_producto_fkey;
       public               postgres    false    5020    285    283            �           2606    24120 #   producto producto_id_categoria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categoria(id_categoria);
 M   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_id_categoria_fkey;
       public               postgres    false    285    4980    245            �           2606    24125    producto producto_id_marca_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_id_marca_fkey FOREIGN KEY (id_marca) REFERENCES public.marca(id_marca);
 I   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_id_marca_fkey;
       public               postgres    false    285    275    5010            �           2606    24130    producto producto_id_tipo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_id_tipo_fkey FOREIGN KEY (id_tipo) REFERENCES public.tipo_producto(id_tipo) NOT VALID;
 H   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_id_tipo_fkey;
       public               postgres    false    285    5038    303            �           2606    24135    repisa repisa_id_sector_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.repisa
    ADD CONSTRAINT repisa_id_sector_fkey FOREIGN KEY (id_sector) REFERENCES public.sector(id_sector);
 F   ALTER TABLE ONLY public.repisa DROP CONSTRAINT repisa_id_sector_fkey;
       public               postgres    false    5030    291    295            �           2606    24140 4   solicitud_permiso solicitud_permiso_id_personal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.solicitud_permiso
    ADD CONSTRAINT solicitud_permiso_id_personal_fkey FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 ^   ALTER TABLE ONLY public.solicitud_permiso DROP CONSTRAINT solicitud_permiso_id_personal_fkey;
       public               postgres    false    281    5016    297            �           2606    24145    tareas tareas_id_personal_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT tareas_id_personal_fkey FOREIGN KEY (id_personal) REFERENCES public.personal(id_personal);
 H   ALTER TABLE ONLY public.tareas DROP CONSTRAINT tareas_id_personal_fkey;
       public               postgres    false    299    281    5016            �       x�3�ts�55�45�21�-8-�b���� A9]      �   �   x�}�M�@��p�^ 33�\\�)8�25�g�<�����~}���j��:�M��,P��+�l�^N=	`�`��Q%?���Aɾ�kG<�0�tn�䱦��zz���!��/�Zwq��-N�(�n��ӌ͘��N]��y�h:x7?��ы�Z�!'�yE�c�S�      �      x������ � �      �   q   x�5�M
�0@���)<A��k ;�е0��BT�mr ���l��>8��V�N���4���Э�;����w2IF0^֒�d��<K�{���,��C��Z���]�ӌ��8$#*      �   �  x����nG��ɧ�=]}�;���� {� �%Z�M�
�u�f�a!/�UM��!��b���_�L��u���d&��	� jg^�WԒo�t6tdgoV��Ms�l��ܭ6s�q�:�9�q>v�_s��Qg�%��8���,��͉�*���}��p~�+���(]�2�@Kcgƨ���x������|g�7E$�Φo~���x�Lۉ��
�;�o�2vmdE_<i*T`ʦE���f���
��[.\��Z��W��z��\c�D���E	ލ�fg�Ly�:��7M��'	&�Ѱ��ݘ�'�X����U	���Ƅ�z��O�Xy���Y:a�h g㕯!�9��^���z�ǟ�k�ϛ����<4oj�5�����v��j~��y�?��b��a�u��ۤ�����w�*���:H.tހ,`��wP\�(����q�T!���_����˵�����n�횿oW����ي	ñ��攉_V�9�}�w���7�7�得���|y��O�ebVw]c���M����w2&�G+S�l#7}��v9w�n�J�}�]������o���%ڪW_W�?�T�
y���R���l��4��_���Cy�7���kz��;w�j,v,���W_V��)b.����d���t��8m�P�k�,y�5U�0S8�y�R�����)�8�>�$��(x��������4hO�UD���6��c/���~�?4����ͮy���۹we<s�0�F�G=/�9��Q��e�˷<C�ͽ�J�rX��!��ZP��)�p�PY�C*UF=ˊ�w��[}Xݢ`��<0~Aα7��$:��ih�>YU�kb���k�L��~�z(p���y0uӁK�˵�$����)�<��j:O�CM�R�[XF{����)�=XZ�]Uc�F���?��h��:�E��ym����@�@�C�3,�|���+�|k��k��V��u��oo9��c��ƛ���K�f�A�	>�D?�V1�:ru#a�j��V5��+F�̢f$�FH7�F&dK�阪\�K�Ŋ�ޞKp=�R;����ҭ����Vb��ݾ?l�u������ӟ7������{�������<]v7"�40�Ň�8�t�q6�RIu�%�K�U�	�c�FB�)k�
qh��cc$S����ƥ��V�v��M��	�5�v��eGU��Y�TB9���V�W�h���/��Z3�S�Y�<�sb����'S�����t�j����2'�3p
��y�	���ܔ���T��:��/(��.
��L�gl�$��	n��\�b�r���* �岘1�){#������L���|3R�@%���Ii�紣~�����%-�����a��U怜��A�N̴Q3l29S+ �.X�65:�EoL�yxN�r����V6� H��t���HV2����Ҙ�	t��#��)G$A�Xꏦ?�7_���t�����}�9W'dOՉ��޸X�#˕)���oUS�s�S��'@6�s�R��e���q����`�\絒��1��5�p�3d.�Dl��9�[	��n�+�{�*瓐����qI�d�q(H8k�	�mg���9�l�z���bF5#9˙�
�e�q������>�;�3�I#�|��������J�CV�&쿱	?��	R_�Ѷ����m�� �VBm�J�¨>q�r��F�em��-�~�I�0	L����~�����76�g��ZܲN)�88�-�K�L�e�qF=n}�5ДCP��x�w��8� ��f&V�~�ё����`�����K�HY�{X� �d�}]Fr�A� �22�e��d��Y: �2�Rv"yW����h�x��"AăSW�+[��Q��qr��Y�('��B���<L��
��R��G� וkE� W���B=��/^��s
�UДC~�Q5�0�\Д�-�t���pc=�Ȑ�G��r2��1QS��8�EM9)j��_�є#��Ǻr��F��3&<�g ֕��%4�����r��/]9�XW���T�V����(�P��ϻ�6�.�d5��L 	��#��)�8���p��P��~"U%T�<��ܖA��Q�sB��872*r� �������������a��h�U�h'<V�#��Un�+������u�^���f֔� ��H��ٱ��+'NI��Y-��֕#�&9���\:�y����( ~Ǫr8k�8tP[U�]챪:ރ�wU�ʑ�WGd��႓C�GMU9T�U���T�#���ڪrķ��T�#`�'�d��9���L]9�>N]9��QWN�sQx$SWM]���
a�#�+GfvՕCr� �#!�o2g��Q�C��s�d[�ÛXD~tr*9 ��*tT�\��Ӯ�4%! ��Ӿu�ĵ*�v�+d�QN�K�-��iT�x�%���m ��E��������$˧ЧWI�$�A%�6$"���{*�Rc�f����9'�h(�:�!�)J�^7��h(I%g�)Je3	� �h(ɮ4[�h(�����S4��N�ʽ�:��&w�h(ICۦ�T����W5�p�D^Ր�/�jh�9 �j�R5��!�O�ɫ�x{���!?�形�r��^ѐ�4�����?
��r)�Q������[�SѐS��ɽf������+��h(��� Y����_0R�X'K[c/���P�ϑ�� ��#�Zx�B�՞������Ũ�;FBTP�q��Hw9���)��ƻk�K���;�Ɲ��8 �n��O8E��gҖ�`Q�L0�IٽC�`��+ )ڱR��M_J�v��"����4�����H�Ux�Պ �>�+�����9������l���/?;��Ml�p?�e}Ƨ���T�C��t��<�xx�gV�r�yRa�d�w��1��٦�l�ًyΤ@�Ҡ%}�>ʥ>�E������/���      �   0   x�3�450�30�4202�50�54�4�4�t��-�I-IL������ �U�      �      x������ � �      �      x������ � �      �   9   x�3�4202�50�54���S��/KMILI-��4�t,(�OJL��4�2"Va� ���      �   f   x�3�JMN-H�<�9O!%U� 5%3%_!�� 5931�ӄ�ȀӜ˘�71'Q��� �(35(�������������iRj�e�雚�s��qqq J�j      �      x������ � �      �      x�34�4A#S] ������� +��      �      x������ � �      �   *  x���=r! ����]ҾɤI����۴�������Z<��߯����I/ԋ�Y~؍;,����␾{g<�:8���8\`mo\��^���� �xg�y�.ئ�a�\�\�] ��{9*Ew�rg��l�6��@Z_z�o��çZ�"\}@N_D]�R_�rw��W���G��;5l5�%�M�겼S���4����݀N}p}7���,6�W��5�������/�<����Co:���~���[s����4��2?g����h��: ���
cu����!4w���9��m�sR      �   D   x�3��IL.I�/�2�t�M*-�L�M8������\��ΩE��9��\�H*�8}2s2S��b���� 9o      �   �   x�]���0C��W�P/IX#�X.�A��z���	�
�ɖ-?��LO�b��n�HBz`��}����'�=�48ܒL��!�c*��g�L���<V�i��@rM��X]�E`�Ak�]�"�^@WG��R�]�2$      �      x������ � �      �      x������ � �      �      x�3�45�44�30�4�44����� "[�      �      x������ � �      �   %   x�3�44�4�44�4�z@��$h�&���� �"�      �      x������ � �      �     x���Ɏ1���)x��KnQ.�DJ� 3�����<}�h\L[ui$$�s���e��L�y���tLY��v�~7���a���|n�-��ُ�zv����Y;~<��y3�R�;��B��нc��ov�'�m�����0[�4�?|�~�̖��O��Oқ'��j��&o��DtNM6'�ox�l��V��� U��ݝwLd���C	{�EH��8�z�tW�{�z%��T�Q%5�2<n�Sq�oe�v�%��@�ᛗ9�5��L4�є�pQ� F�
��k#u2��ݭ�_�l�l����:�x̤h�^�+�J�/�f���9�ld��O'zwbwj�Cu��V�+Q 5�P#�?N���/���j�5Gׯ|x���"�E�裔y�����e��L��T瀤.�&�=�Z�3���
��Zj!|O��/p�ĕ���K�T�oU�:o\@���_S�<>anx��萾+�rp��	>����i6���٬���š}[�jEQ��3�Bږ��^��kO����&���H���eP�󎪩��XsӃm-kn=N{����V[�T�(<�S��y�Px7j 8.We�u��5u����2���k��:�lV�C�@*Te��v�f��W��Rhd���:M����9��0A53�z$�"�%."��J���Ԩ��>�z��Ԩ�F"r��V5�;<X��M@�wD������y��`�Oꃖ�j&ǚ�+R�3�:���Ɵ%�j�L�g"�N]�1�ܧ��p�X�VC~� J�!�@�gM���L��}H({��QO�Ɣ�pyT���PG��,�uTؾ�٠l�:*�):X�B�.�P�eT���z�j�J$A���>'z�
4�t^�A+�U���
��zE�-\�5�=Ó,z�2�Whcx?&	�S�\��7��x�M8e�I����^FJ����%ʋ�WLm��\�_m0��`̆š�Y���b��S�jQ*�/:ԭ�T��B�ԯ�
���>R�ye�P⩛�oQ��E�c�nUЏ��/>��he�?      �      x������ � �      �   ,   x�3�NMJ,.�L��,����L�s3s���s9��b���� D�}      �   #   x�3��HL���,IL��2�L������c���� �q�      �   (   x�3�LL.�,��2�LL�/IL��2�LNL)M1c���� ��
      �   #   x�3��HL���,IL��2�L������c���� �q�      �   �   x�uϹ�0D�xً�7ل+P�uX�Ұ�l��Rh�C�y� � e��"!���4��#(��l'��+e��w2��S�)kɜG!�b�Ne�h}�����WN��cɾ�^��n����_*;
�eǲ��<���:���N�I�      �   \   x�M�[
�0�ݻXt�)�K���G�D�HH�x
��_�1�RIP��f�?l�ס�2�#85mƫ/��}W&����Olz�5<��$�      �   K   x�3����2�t�ON�M��I�2�JMQp*���2�,H-(��2�tK��/N�2��.�,�2��LO,I����� ���      �   .   x�3�I,�J-ITHIUH.:�2%�$�ˈ�5-5�$�,�+F��� ��,      �   )   x�3�,-.M,��/�,�4 4�2�L��-(JD����� 7/�      �   �   x�]��
�0Dϛ���d7I��&�	EЛx��`�m�i����w�˛A8���~��" ic�)���L�T�p	�ss�ij� ��u]L�j��jB���?[�cl7��]��QV��v8��uX��o�%biLI�#;f�.�(�4���c�k�5_I*�j�s�m�N\s!���8�      �   ]   x�5ͻ1ј,F0�����_����a�I���)�ò�`���ú�ܗÃj�_�C˪�ɹYT ���E���e{Û��t���^|��:�      �     x�}�IR�0E��S�P���^Ra��a���RE&&
��鑇$rU�������� nE��<����]�[��D��3�ۗ���2���h'o�x���� qdg/��knn�^���Hr��4���I���vzp����xZ�l���h���$>%t]���s7�a�
A�]��3T�����syB�1�!+��ݕ��ӽ�	��4� ���1��p6����
���7����6��k��k�����s��҇����a̗��m��mr}�lAm�,����S      �   �   x���MN�0�u�0����Y�P��hk7M��=!A���p�O3��NoӔO���k/q�[3~�6^y7�����pm�3��%6����x#yc7�S|�{�O �
2 '�F
2�s@Fʍ�d�� �N�UT�*@�m6�&B�?�5�ϒt���Bt��_EO��kC����βj�?�X�g��v[�;)�jJC(��KsS�t[LM(��bZ��B�]b9��[i�#����3#�o�i�L      �   U   x�3�t+�L�/�4)�Wp����Rez��y%��
.���y%���%�e�\F��9��E���
�y)��%E��9�~�
�1z\\\ ��$      �   %   x�3�w�50�4".#�� ]#NC#NC�=... S��      �   :   x�3�LL����,.)JL�/�2�LN�J-��2�L�-�I
r�p&��%s��qqq �T�      �   8   x�3�tN,�K-�H,����W0�2��IL.I�G�Yp�r:��&� )4����� �Y      �      x������ � �      �      x������ � �      �      x������ � �      �   !   x�3���WH-JMNMI-��2�D���qqq �
      �   6   x�3���O�H�40�26�20�44�0��8soL�K�40��rFW� �U=      �   �  x���ٶ�����9�Hf�ZQPQֹaH�yP��U��k�q�.��\ߟDDF�H�TAo���Y�L?�_p����X�T�7���ov��=~���%rОPq�I����8�%�ƽMӚڤǽ
n��8CyĴ$d��?��_�!A��T~V~Fo�0������[�d��be�{@ƏZ�Q��]���fzFB�B��w���Q�豆�����uf]+�xyύ0l��Yʲ��=�( >�~Te�W��8]b���v ~�9�La��/�i��L���1�5��KG�X �7��X�Tݴ\��B��D;$��й���Nq�,ݷ{O"�̇�wG��s�k���m{b�T�� ��2�c/���ċ�L"����.����vޡ�B����p	�o
��r�*��)!�'�6V�c� 4��{�#�<��bf�o�FM�~�t�?���s |!:�j�iI�y>�Xy�D{��'6\.�䅃'��:F0�#�T^�a������vȆV� �=J,��ŀ���ǳP	�@��>_uRT���&:4�6-R�җ��[�(`�z����iޱɶ��[�1�-I��])�x��'
'��M\��w��V��i7������A���W!�.U��ь��e��F�K��ɔ��J�&aM�X���?y����w��"7a��D��%���fn�2��\a�+ɰTE���J�2�J/��yU���M��S-��ޱZe��s���n�6&��0MATyu�#J��zq��#S���l�$���vM3˿<��%E3,J҈���_�/f0H�c�F~�=������'T�Re8MC'����j��XFq@مQ�d��GTWW�o�X�+�DI�7�f�O��z��� `�Y������Z^�38Wo��1���уh�(�#-,��'?�;�g�vץ�9���~���HA����
������:p
�J
��Jѿ�w��U끰�-w�ٱ.�{��0z�"c�����.6�E�^�IJ�a5�,J�?D���y���q���A�ڂ=߆�*%�W{HwZ�{G*��{`�Bp3���!J��8I���y'�姱X7a�d�����B3��ލ3ȕ�d�TT�׺ezcS5toH�"��	��wfl.���m���$AGM]z�|V!�͔���|\�B��_r�v{.(E���ˇy窺����#0Zߪ�|�7wLVOw۲}���fz]ʿ��xٻiyL2��Uͯb�wo��Bf�����
�����B�0-*Ʋx�tS�(�޺�x�N(��Q�r���e�v0�!1<n��i���+[����%���)cQm5�1��:	�#a��0�q}E6��������ݕѾ��Ο:��i���l�ncp��{���A #��^KM�����˻U٧�V�WG�0_3�C,[HV��4�,aNF�R��
�j�k��h����:O����;]qJ!`�GF���K
%�k�`�%�b������'�ߙc3��ׯ����g9#���*�i���=w���"��x�<�@߽S�U$ֵ��`(��VF�     
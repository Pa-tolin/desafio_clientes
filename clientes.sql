--punto 1
CREATE DATABASE respaldo;
psql -U postgres respaldo < C:\Users\pojie\OneDrive\Escritorio\desafio_clientes\unidad2.sql

\set AUTOCOMMIT OFF
\echo :AUTOCOMMIT

--punto 2
SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio
FROM cliente
LEFT JOIN compra ON cliente.id = compra.cliente_id
LEFT JOIN detalle_compra ON compra.id = detalle_compra.compra_id
LEFT JOIN producto ON detalle_compra.producto_id = producto.id 
WHERE cliente.nombre = 'usuario01'
AND producto.descripcion = 'producto9'
AND detalle_compra.cantidad = 5
AND compra.fecha = CURRENT_DATE;

BEGIN;
    INSERT INTO compra (id, cliente_id, fecha) VALUES (DEFAULT, 1, CURRENT_DATE);
    INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad) VALUES (DEFAULT, 9, (SELECT compra.id FROM compra WHERE cliente_id=1 AND fecha=CURRENT_DATE), 5);
    UPDATE producto SET stock = stock - 5 WHERE producto.id = 9;
COMMIT;   

SELECT ID, descripcion, stock, precio FROM producto where descripcion = 'producto9';

SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio
FROM cliente
LEFT JOIN compra ON cliente.id = compra.cliente_id
LEFT JOIN detalle_compra ON compra.id = detalle_compra.compra_id
LEFT JOIN producto ON detalle_compra.producto_id = producto.id 
WHERE cliente.nombre = 'usuario01'
AND producto.descripcion = 'producto9'
AND detalle_compra.cantidad = 5
AND compra.fecha = CURRENT_DATE;
COMMIT;

-- punto 3
SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio
FROM cliente
LEFT JOIN compra ON cliente.id = compra.cliente_id
LEFT JOIN detalle_compra ON compra_id = detalle_compra.compra_id
LEFT JOIN producto ON detalle_compra.producto_id =producto.id
WHERE cliente.nombre = 'usuario02'
AND producto.descripcion in ('producto1', 'producto2', 'producto8')
AND detalle_compra.cantidad = 3
AND compra.fecha = CURRENT_DATE;

BEGIN; 
    INSERT INTO compra (cliente_id, fecha)
    SELECT id, CURRENT_DATE FROM cliente WHERE nombre = 'usuario02';
    INSERT INTO detalle_compra (producto_id, compra_id, cantidad)
    SELECT id, CURRVAL('compra_id_seq'), 3
    FROM producto WHERE descripcion = 'producto1';
    UPDATE producto SET stock = stock - 3
    WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto1');
    SAVEPOINT producto1;

    INSERT INTO compra (cliente_id, fecha)
    SELECT id, CURRENT_DATE FROM cliente WHERE nombre = 'usuario02';
    INSERT INTO detalle_compra (producto_id, compra_id, cantidad)
    SELECT id, CURRVAL('compra_id_seq'), 3
    FROM producto WHERE descripcion = 'producto2';
    UPDATE producto SET stock = stock - 3
    WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto2');
    SAVEPOINT producto2;

    INSERT INTO compra (cliente_id, fecha)
    SELECT id, CURRENT_DATE FROM cliente WHERE nombre = 'usuario02';
    INSERT INTO detalle_compra (producto_id, compra_id, cantidad)
    SELECT id, CURRVAL('compra_id_seq'), 3
    FROM producto WHERE descripcion = 'producto8';
    UPDATE producto SET stock = stock - 3
    WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto8');
COMMIT;


SELECT id, descripcion, stock, precio FROM producto
WHERE descripcion IN ('producto1', 'producto2', 'producto8');

SELECT cliente.nombre, cliente.email, compra.fecha, detalle_compra.cantidad, producto.descripcion, producto.stock, producto.precio
FROM cliente
LEFT JOIN compra ON cliente.id = compra.cliente_id
LEFT JOIN detalle_compra ON compra_id = detalle_compra.compra_id
LEFT JOIN producto ON detalle_compra.producto_id =producto.id
WHERE cliente.nombre = 'usuario02'
AND producto.descripcion in ('producto1', 'producto2', 'producto8')
AND detalle_compra.cantidad = 3
AND compra.fecha = CURRENT_DATE;
COMMIT;

--punto 4
--deshabilitar AUTOCOMMIT: SE HIZO AL INICIO

INSERT INTO cliente  (nombre, email)
VALUES ('Juan Perez', 'juanperez@gmail.com');

SELECT id, nombre, email FROM cliente WHERE nombre LIKE 'Juan%';

ROLLBACK;

SELECT id, nombre, email FROM cliente WHERE nombre LIKE 'Juan%';
COMMIT;

\set AUTOCOMMIT ON
\echo :AUTOCOMMIT
    
    




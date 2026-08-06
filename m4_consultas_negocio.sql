---Consulta 1 

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

---Consulta 2 

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


---Consulta 3

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


---Consulta 4

WITH ventas_mensuales AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM ventas_mensuales
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas_mensuales
ORDER BY mes;

-- ===============================
-- HALLAZGOS DEL ANÁLISIS
-- ===============================

-- Hallazgo 1:
-- Durante el período analizado solo se registraron ventas en el mes 3.
-- La facturación total fue de $6.444, correspondiente a 10 pedidos,
-- con un ticket promedio de $644,40 por pedido.

-- Hallazgo 2:
-- El producto con ID 1 fue el de mayor facturación del período,
-- generando un total de $3.600 con la venta de 3 unidades.

-- Hallazgo 3:
-- Todos los clientes recurrentes realizaron exactamente 2 pedidos.
-- Sin embargo, el cliente con ID 1 registró el mayor gasto acumulado ($2.640),
-- seguido por el cliente con ID 5 con un total de $2.100.

-- Hallazgo 4:
-- Según el análisis realizado, el mes 3 quedó clasificado por debajo
-- del promedio mensual de facturación, con un total facturado de $6.444.

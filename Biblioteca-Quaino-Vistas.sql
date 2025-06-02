USE BibliotecaDB;

-- Vista de libros con detalles
CREATE VIEW Vista_Libros_Detalles AS
SELECT 
    l.id_libro,
    l.titulo,
    l.isbn,
    l.anio_publicacion,
    l.estado,
    e.nombre AS editorial,
    c.nombre AS categoria,
    GROUP_CONCAT(a.nombre SEPARATOR ', ') AS autores
FROM Libro l
LEFT JOIN Editorial e ON l.id_editorial = e.id_editorial
LEFT JOIN Categoria c ON l.id_categoria = c.id_categoria
LEFT JOIN Libro_Autor la ON l.id_libro = la.id_libro
LEFT JOIN Autor a ON la.id_autor = a.id_autor
GROUP BY l.id_libro;

-- Vista de libros disponibles actualmente
CREATE VIEW Vista_Libros_Disponibles AS
SELECT * 
FROM Vista_Libros_Detalles
WHERE estado = 'disponible';

-- Vista de historial de prestamos
CREATE VIEW Vista_Historial_Prestamos AS
SELECT 
    p.id_prestamo,
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS nombre_usuario,
    l.titulo,
    p.fecha_prestamo,
    p.fecha_devolucion
FROM Prestamo p
JOIN Usuario u ON p.id_usuario = u.id_usuario
JOIN Libro l ON p.id_libro = l.id_libro;

-- Vista de no devueltos
CREATE VIEW Vista_Prestamos_Activos AS
SELECT * 
FROM Vista_Historial_Prestamos
WHERE fecha_devolucion IS NULL;
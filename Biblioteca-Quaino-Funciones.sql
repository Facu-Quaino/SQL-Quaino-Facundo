USE BibliotecaDB;

-- Cantidad de prestamos de un usuario
DELIMITER $$
CREATE FUNCTION fn_CantidadPrestamosUsuario(id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(*) INTO cantidad
    FROM Prestamo
    WHERE id_usuario = id;
    RETURN cantidad;
END$$
DELIMITER ;

-- Estado del prestamo de un libro
DELIMITER $$
CREATE FUNCTION fn_EstaLibroPrestado(id_lib INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE existe INT;
    SELECT COUNT(*) INTO existe
    FROM Prestamo
    WHERE id_libro = id_lib AND fecha_devolucion IS NULL;
    RETURN existe > 0;
END$$
DELIMITER ;

-- Calcular dias desde el prestamo de un libro
DELIMITER $$
CREATE FUNCTION fn_DiasPrestamo(id_prestamo INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE dias INT;
    SELECT DATEDIFF(
        IFNULL(fecha_devolucion, CURDATE()), 
        fecha_prestamo
    ) INTO dias
    FROM Prestamo
    WHERE id_prestamo = id_prestamo;
    RETURN dias;
END$$
DELIMITER ;

-- Total de prestamos de un libro
DELIMITER $$
CREATE FUNCTION fn_TotalPrestamosLibro(id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Prestamo
    WHERE id_libro = id;
    RETURN total;
END$$
DELIMITER ;

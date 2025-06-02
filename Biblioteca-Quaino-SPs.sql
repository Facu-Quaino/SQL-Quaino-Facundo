USE BibliotecaDB;

-- Registrar un nuevo prestamo
DELIMITER $$
CREATE PROCEDURE sp_RegistrarPrestamo(
    IN p_id_usuario INT,
    IN p_id_libro INT,
    IN p_fecha_prestamo DATE
)
BEGIN
    DECLARE libro_disponible ENUM('disponible', 'no disponible');

    SELECT estado INTO libro_disponible
    FROM Libro
    WHERE id_libro = p_id_libro;

    IF libro_disponible = 'disponible' THEN
        INSERT INTO Prestamo(fecha_prestamo, id_usuario, id_libro)
        VALUES (p_fecha_prestamo, p_id_usuario, p_id_libro);

        UPDATE Libro
        SET estado = 'no disponible'
        WHERE id_libro = p_id_libro;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El libro no está disponible para préstamo.';
    END IF;
END$$
DELIMITER ;

-- Registrar una devolucion
DELIMITER $$
CREATE PROCEDURE sp_RegistrarDevolucion(
    IN p_id_prestamo INT,
    IN p_fecha_devolucion DATE
)
BEGIN
    DECLARE libro_id INT;

    SELECT id_libro INTO libro_id
    FROM Prestamo
    WHERE id_prestamo = p_id_prestamo;

    UPDATE Prestamo
    SET fecha_devolucion = p_fecha_devolucion
    WHERE id_prestamo = p_id_prestamo;

    UPDATE Libro
    SET estado = 'disponible'
    WHERE id_libro = libro_id;
END$$
DELIMITER ;

-- Historial de usuario
DELIMITER $$
CREATE PROCEDURE sp_ObtenerHistorialUsuario(IN p_id_usuario INT)
BEGIN
    SELECT 
        p.id_prestamo,
        l.titulo AS libro,
        p.fecha_prestamo,
        p.fecha_devolucion
    FROM Prestamo p
    JOIN Libro l ON p.id_libro = l.id_libro
    WHERE p.id_usuario = p_id_usuario
    ORDER BY p.fecha_prestamo DESC;
END$$
DELIMITER ;

-- Actualizar datos de usuario
DELIMITER $$
CREATE PROCEDURE sp_ActualizarDatosUsuario(
    IN p_id_usuario INT,
    IN p_direccion VARCHAR(200),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100)
)
BEGIN
    UPDATE Usuario
    SET direccion = p_direccion,
        telefono = p_telefono,
        email = p_email
    WHERE id_usuario = p_id_usuario;
END$$
DELIMITER ;

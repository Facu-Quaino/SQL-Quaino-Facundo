USE BibliotecaDB;

-- Impedir que se inserte un prestamo si el libro ya esta prestado
DELIMITER $$
CREATE TRIGGER trg_AntesInsertarPrestamo_VerificarDisponibilidad
BEFORE INSERT ON Prestamo
FOR EACH ROW
BEGIN
    DECLARE estado_libro ENUM('disponible', 'no disponible');

    SELECT estado INTO estado_libro
    FROM Libro
    WHERE id_libro = NEW.id_libro;

    IF estado_libro = 'no disponible' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El libro no está disponible para préstamo.';
    END IF;
END$$
DELIMITER ;

-- Marcar como no disponible despues de insertar un prestamo
DELIMITER $$
CREATE TRIGGER trg_AfterInsertPrestamo_CambiarEstadoLibro
AFTER INSERT ON Prestamo
FOR EACH ROW
BEGIN
    UPDATE Libro
    SET estado = 'no disponible'
    WHERE id_libro = NEW.id_libro;
END$$
DELIMITER ;

-- Cuando se registra una fecha de devolucion marcar el libro como disponible
DELIMITER $$
CREATE TRIGGER trg_AfterUpdatePrestamo_RegistrarDevolucion
AFTER UPDATE ON Prestamo
FOR EACH ROW
BEGIN
    IF NEW.fecha_devolucion IS NOT NULL AND OLD.fecha_devolucion IS NULL THEN
        UPDATE Libro
        SET estado = 'disponible'
        WHERE id_libro = NEW.id_libro;
    END IF;
END$$
DELIMITER ;

-- Registrar una multa si el prestamo excede 15 dias
DELIMITER $$
CREATE TRIGGER trg_RegistrarMultaSiExcedePlazo
AFTER UPDATE ON Prestamo
FOR EACH ROW
BEGIN
    DECLARE dias_prestamo INT;
    DECLARE multa_dia DECIMAL(10,2) DEFAULT 1.50;
    DECLARE dias_exceso INT;
    DECLARE monto_total DECIMAL(10,2);

    IF NEW.fecha_devolucion IS NOT NULL AND OLD.fecha_devolucion IS NULL THEN
        SET dias_prestamo = DATEDIFF(NEW.fecha_devolucion, NEW.fecha_prestamo);

        IF dias_prestamo > 15 THEN
            SET dias_exceso = dias_prestamo - 15;
            SET monto_total = dias_exceso * multa_dia;

            INSERT INTO Multa (id_usuario, id_prestamo, monto, fecha_multa)
            VALUES (NEW.id_usuario, NEW.id_prestamo, monto_total, CURDATE());
        END IF;
    END IF;
END$$
DELIMITER ;

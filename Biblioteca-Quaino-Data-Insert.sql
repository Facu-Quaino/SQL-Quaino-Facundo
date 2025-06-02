USE BibliotecaDB;

-- Insertar nuevas editoriales
INSERT INTO Editorial (nombre, pais) VALUES
('Siglo XXI Editores', 'México'),
('Ediciones B', 'España');

-- Insertar nuevas categorias
INSERT INTO Categoria (nombre) VALUES
('Poesía'),
('Biografía');

-- Insertar nuevos autores
INSERT INTO Autor (nombre, pais_origen) VALUES
('Pablo Neruda', 'Chile'),
('Mario Vargas Llosa', 'Perú');

-- Insertar nuevos libros
INSERT INTO Libro (titulo, isbn, anio_publicacion, estado, id_editorial, id_categoria) VALUES
('Veinte poemas de amor y una canción desesperada', '9788437604947', 1924, 'disponible', 4, 5),
('La ciudad y los perros', '9788432225352', 1963, 'disponible', 5, 1);

-- Relacionar libros con autores
INSERT INTO Libro_Autor (id_libro, id_autor) VALUES
(5, 5),
(6, 6);

-- Insertar nuevos usuarios
INSERT INTO Usuario (nombre, apellido, direccion, telefono, email, fecha_inscripcion) VALUES
('Javier', 'López', 'Calle Luna 45, Buenos Aires', '1145678901', 'javier@example.com', '2023-09-15'),
('María', 'Fernández', 'Carrera 7 #123, Medellín', '3109876543', 'mariaf@example.com', '2023-12-01');

-- Insertar nuevos prestamos
INSERT INTO Prestamo (fecha_prestamo, fecha_devolucion, id_usuario, id_libro) VALUES
('2025-05-10', '2025-05-20', 4, 5), -- Javier tomó libro de Neruda
('2025-05-22', NULL, 5, 6);         -- María tomó libro de Vargas Llosa, aún sin devolver

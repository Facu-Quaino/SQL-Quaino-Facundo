-- Crear base de datos
CREATE DATABASE IF NOT EXISTS BibliotecaDB;
USE BibliotecaDB;

-- Tabla Editorial
CREATE TABLE Editorial (
    id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(100)
);

-- Tabla Categoría
CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla Autor
CREATE TABLE Autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_origen VARCHAR(100)
);

-- Tabla Libro
CREATE TABLE Libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    anio_publicacion YEAR,
    estado ENUM('disponible', 'no disponible') DEFAULT 'disponible',
    id_editorial INT,
    id_categoria INT,
    FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- Tabla Libro_Autor (relación muchos a muchos)
CREATE TABLE Libro_Autor (
    id_libro INT,
    id_autor INT,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro),
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor)
);

-- Tabla Usuario
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100),
    fecha_inscripcion DATE
);

-- Tabla Prestamo
CREATE TABLE Prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    id_usuario INT,
    id_libro INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

-- Tabla Multa
CREATE TABLE Multa (
    id_multa INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_prestamo INT,
    monto DECIMAL(10,2),
    fecha_multa DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo)
);

-- datos de prueba

-- Insertar Editoriales
INSERT INTO Editorial (nombre, pais) VALUES
('Planeta', 'España'),
('Penguin Random House', 'EE.UU.'),
('Alfaguara', 'Argentina');

-- Insertar Categorías
INSERT INTO Categoria (nombre) VALUES
('Novela'),
('Ciencia Ficción'),
('Historia'),
('Educativo');

-- Insertar Autores
INSERT INTO Autor (nombre, pais_origen) VALUES
('Gabriel García Márquez', 'Colombia'),
('J.K. Rowling', 'Reino Unido'),
('Isaac Asimov', 'Rusia'),
('Eduardo Galeano', 'Uruguay');

-- Insertar Libros
INSERT INTO Libro (titulo, isbn, anio_publicacion, estado, id_editorial, id_categoria) VALUES
('Cien años de soledad', '9780307474728', 1967, 'disponible', 1, 1),
('Harry Potter y la piedra filosofal', '9788478884452', 1997, 'disponible', 2, 1),
('Fundación', '9788497594257', 1951, 'disponible', 2, 2),
('Las venas abiertas de América Latina', '9786070704207', 1971, 'no disponible', 3, 3);

-- Relacionar Libros y Autores (tabla intermedia)
INSERT INTO Libro_Autor (id_libro, id_autor) VALUES
(1, 1), -- Cien años de soledad - Gabriel García Márquez
(2, 2), -- Harry Potter - J.K. Rowling
(3, 3), -- Fundación - Isaac Asimov
(4, 4); -- Las venas abiertas - Eduardo Galeano

-- Insertar Usuarios
INSERT INTO Usuario (nombre, apellido, direccion, telefono, email, fecha_inscripcion) VALUES
('Laura', 'Gómez', 'Calle 123, Bogotá', '3001234567', 'laura@example.com', '2023-01-10'),
('Carlos', 'Pérez', 'Av. Central 456, Madrid', '612345678', 'carlos@example.com', '2022-11-20'),
('Ana', 'Martínez', 'Rua das Flores 789, Lisboa', '912345678', 'ana@example.com', '2023-05-05');

-- Insertar Préstamos
INSERT INTO Prestamo (fecha_prestamo, fecha_devolucion, id_usuario, id_libro) VALUES
('2024-04-01', '2024-04-15', 1, 1), -- Laura tomó Cien años de soledad
('2024-04-10', '2024-04-25', 2, 2), -- Carlos tomó Harry Potter
('2024-04-15', NULL, 3, 3); -- Ana tomó Fundación, aún no lo devolvió
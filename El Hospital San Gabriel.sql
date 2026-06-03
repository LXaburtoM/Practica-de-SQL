--MÓDULO I: 
-- 1. Crear una base de datos llamada HospitalDB
CREATE DATABASE HospitalDB;
GO

-- 2. Mostrar todas las bases de datos existentes en SQL Server
SELECT name FROM sys.databases;
-- Alternativa: EXEC sp_databases;
GO

-- 3. Seleccionar HospitalDB para trabajar
USE HospitalDB;
GO

-- 4. Crear la tabla Pacientes
CREATE TABLE Pacientes (
    PacienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Telefono VARCHAR(20) NULL
);
GO

-- 5. Crear la tabla Especialidades
CREATE TABLE Especialidades (
    EspecialidadID INT IDENTITY(1,1) PRIMARY KEY,
    NombreEspecialidad NVARCHAR(100) NOT NULL
);
GO

-- 6. Crear la tabla Medicos
CREATE TABLE Medicos (
    MedicoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    EspecialidadID INT NOT NULL -- Preparado para ser Foreign Key en el Módulo II
);
GO

-- 7. Crear la tabla Citas
CREATE TABLE Citas (
    CitaID INT IDENTITY(1,1) PRIMARY KEY,
    PacienteID INT NOT NULL,  -- Preparado para Foreign Key
    MedicoID INT NOT NULL,    -- Preparado para Foreign Key
    FechaHoraCita DATETIME NOT NULL,
    Motivo NVARCHAR(255) NULL
);
GO

-- 8. Crear la tabla Habitaciones
CREATE TABLE Habitaciones (
    HabitacionID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroHabitacion VARCHAR(10) NOT NULL,
    TipoHabitacion NVARCHAR(50) NOT NULL,
    Estado VARCHAR(20) DEFAULT 'Disponible'
);
GO

-- 9. Crear la tabla Tratamientos
CREATE TABLE Tratamientos (
    TratamientoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreTratamiento NVARCHAR(100) NOT NULL,
    Costo DECIMAL(10,2) NULL
);
GO

-- 10. Crear la tabla Medicamentos
CREATE TABLE Medicamentos (
    MedicamentoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreMedicamento NVARCHAR(100) NOT NULL,
    Presentacion NVARCHAR(50) NULL, -- Ej. Pastilla, Jarabe, Inyección
    Stock INT DEFAULT 0
);
GO
--MÓDULO II:
-- 1 y 2. Definir Primary Key
Alter Table Pacientes Add Constraint PK_Pacientes Primary Key (PacienteID);
Go
Alter Table Medicos Add Constraint PK_Medicos Primary Key (MedicoID);
Go
-- 3 y 4. Agregar Not Null
Alter Table Pacientes Alter Column Nombre Nvarchar(100) Not Null;
Go
Alter Table Medicos Alter Column Nombre Nvarchar(100) Not Null;
Go
-- 5 y 6. Crear restricción Unique para correos
Alter Table Pacientes Add Constraint UQ_Pacientes_Correo Unique (Correo);
Go
Alter Table Medicos Add Constraint UQ_Medicos_Correo Unique (Correo);
Go
-- 7 y 8. Agregar Check para edad y salario
Alter Table Pacientes Add Constraint CK_Pacientes_Edad Check (Edad >= 0);
Go
Alter Table Medicos Add Constraint CK_Medicos_Salario Check (Salario > 0);
Go
-- 9. Agregar Default para fecha de registro
Alter Table Pacientes Add Constraint DF_Pacientes_FechaRegistro Default Getdate() For FechaRegistro;
Go
-- 10 al 15. Crear Foreign Keys
Alter Table Medicos Add Constraint FK_Medicos_Especialidades Foreign Key (EspecialidadID) References Especialidades(EspecialidadID);
Go
Alter Table Citas Add Constraint FK_Citas_Pacientes Foreign Key (PacienteID) References Pacientes(PacienteID);
Go
Alter Table Citas Add Constraint FK_Citas_Medicos Foreign Key (MedicoID) References Medicos(MedicoID);
Go
Alter Table Tratamientos Add Constraint FK_Tratamientos_Pacientes Foreign Key (PacienteID) References Pacientes(PacienteID);
Go
Alter Table Medicamentos Add Constraint FK_Medicamentos_Tratamientos Foreign Key (TratamientoID) References Tratamientos(TratamientoID);
Go
Alter Table Habitaciones Add Constraint FK_Habitaciones_Pacientes Foreign Key (PacienteID) References Pacientes(PacienteID);
Go

-- MÓDULO III: MODIFICACIÓN DE ESTRUCTURAS 

-- Agregar múltiples columnas a la tabla Pacientes
Alter Table Pacientes Add Telefono Varchar(20);
Alter Table Pacientes Add Direccion Nvarchar(200);
Alter Table Pacientes Add Genero Varchar(15);
Alter Table Pacientes Add Tipo_Sangre Varchar(5);
Alter Table Pacientes Add Fecha_Nacimiento Date;
Go

-- 6 y 7. Modificar el tamaño del campo Nombre y Dirección
-- Se asume que estos cambios son en la tabla Pacientes
Alter Table Pacientes Alter Column Nombre Nvarchar(150) Not Null;
Alter Table Pacientes Alter Column Direccion Nvarchar(250);
Go

-- 8 al 10. Agregar columnas a la tabla Médicos
Alter Table Medicos Add Experiencia Int; 
Alter Table Medicos Add Turno Varchar(50);
Alter Table Medicos Add Observaciones Nvarchar(Max);
Go

-- 11. Eliminar la columna Observaciones
Alter Table Medicos Drop Column Observaciones;
Go

-- 12 y 13. Agregar columnas a la tabla Citas
Alter Table Citas Add Estado Varchar(50);
Alter Table Citas Add Costo_Consulta Decimal(10,2);
Go

-- 14. Modificar el tipo de dato del costo
-- Ejemplo: Se amplía la precisión de 10 a 12 dígitos en total
Alter Table Citas Alter Column Costo_Consulta Decimal(12,2);
Go

Alter Table Habitaciones Add Disponibilidad Varchar(20);
Go


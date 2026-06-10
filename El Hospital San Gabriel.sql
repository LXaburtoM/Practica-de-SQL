-- Módulo I: Creación De Tablas
Create Database Hospitaldb;
Go

Use Hospitaldb;
Go

Create Table Pacientes (
    Pacienteid Int Identity(1,1) Primary Key,
    Nombre Nvarchar(100) Not Null,
    Apellido Nvarchar(100) Not Null,
    Fechanacimiento Date Not Null,
    Telefono Varchar(20) Null,
    Correo Varchar(100) Null,
    Edad Int Null,
    Fecharegistro Datetime Null
);
Go

Create Table Especialidades (
    Especialidadid Int Identity(1,1) Primary Key,
    Nombreespecialidad Nvarchar(100) Not Null
);
Go

Create Table Medicos (
    Medicoid Int Identity(1,1) Primary Key,
    Nombre Nvarchar(100) Not Null,
    Apellido Nvarchar(100) Not Null,
    Especialidadid Int Not Null,
    Correo Varchar(100) Null,
    Salario Decimal(10,2) Null
);
Go

Create Table Citas (
    Citaid Int Identity(1,1) Primary Key,
    Pacienteid Int Not Null,
    Medicoid Int Not Null,
    Fechahoracita Datetime Not Null,
    Motivo Nvarchar(255) Null
);
Go

Create Table Habitaciones (
    Habitacionid Int Identity(1,1) Primary Key,
    Numerohabitacion Varchar(10) Not Null,
    Tipohabitacion Nvarchar(50) Not Null,
    Estado Varchar(20) Default 'Disponible',
    Pacienteid Int Null
);
Go

Create Table Tratamientos (
    Tratamientoid Int Identity(1,1) Primary Key,
    Nombretratamiento Nvarchar(100) Not Null,
    Costo Decimal(10,2) Null,
    Pacienteid Int Not Null
);
Go

Create Table Medicamentos (
    Medicamentoid Int Identity(1,1) Primary Key,
    Nombremedicamento Nvarchar(100) Not Null,
    Presentacion Nvarchar(50) Null, 
    Stock Int Default 0,
    Tratamientoid Int Not Null
);
Go

-- Módulo II: Restricciones Y Claves Foráneas
Alter Table Pacientes Add Constraint Uq_Pacientes_Correo Unique (Correo);
Go
Alter Table Medicos Add Constraint Uq_Medicos_Correo Unique (Correo);
Go

Alter Table Pacientes Add Constraint Ck_Pacientes_Edad Check (Edad >= 0);
Go
Alter Table Medicos Add Constraint Ck_Medicos_Salario Check (Salario > 0);
Go

Alter Table Pacientes Add Constraint Df_Pacientes_Fecharegistro Default Getdate() For Fecharegistro;
Go

Alter Table Medicos Add Constraint Fk_Medicos_Especialidades Foreign Key (Especialidadid) References Especialidades(Especialidadid);
Go
Alter Table Citas Add Constraint Fk_Citas_Pacientes Foreign Key (Pacienteid) References Pacientes(Pacienteid);
Go
Alter Table Citas Add Constraint Fk_Citas_Medicos Foreign Key (Medicoid) References Medicos(Medicoid);
Go
Alter Table Tratamientos Add Constraint Fk_Tratamientos_Pacientes Foreign Key (Pacienteid) References Pacientes(Pacienteid);
Go
Alter Table Medicamentos Add Constraint Fk_Medicamentos_Tratamientos Foreign Key (Tratamientoid) References Tratamientos(Tratamientoid);
Go
Alter Table Habitaciones Add Constraint Fk_Habitaciones_Pacientes Foreign Key (Pacienteid) References Pacientes(Pacienteid);
Go

-- Módulo III: Modificación De Estructuras 
Alter Table Pacientes Add Direccion Nvarchar(200);
Alter Table Pacientes Add Genero Varchar(15);
Alter Table Pacientes Add Tipo_Sangre Varchar(5);
Go

Alter Table Pacientes Alter Column Nombre Nvarchar(150) Not Null;
Alter Table Pacientes Alter Column Direccion Nvarchar(250);
Go

Alter Table Medicos Add Experiencia Int; 
Alter Table Medicos Add Turno Varchar(50);
Go

Alter Table Citas Add Estado Varchar(50);
Alter Table Citas Add Costo_Consulta Decimal(12,2);
Go

Alter Table Habitaciones Add Disponibilidad Varchar(20);
Go

-- MÓDULO IV: ELIMINACIÓN DE OBJETOS
-- 1. Eliminar una tabla temporal (En SQL Server usan el prefijo #)
Drop Table If Exists #TablaTemporal;
Go
-- 2. Eliminar una restricción CHECK (La que creamos en el Módulo II)
Alter Table Pacientes Drop Constraint CK_Pacientes_Edad;
Go
-- 3. Eliminar una restricción UNIQUE
Alter Table Pacientes Drop Constraint UQ_Pacientes_Correo;
Go
-- 4. Eliminar una columna 
Alter Table Pacientes Drop Column Genero;
Go
-- 5. Eliminar una tabla de pruebas
Drop Table If Exists TablaPruebas;
Go
-- 6 y 7. Crear y eliminar tablas Auditoria y Logs
Create Table Auditoria (ID Int);
Drop Table Auditoria;
Create Table Logs (ID Int);
Drop Table Logs;
Go
-- 8. Eliminar una FOREIGN KEY
Alter Table Citas Drop Constraint FK_Citas_Pacientes;
Go
-- 9 y 10. Eliminar tabla y base de datos de pruebas
Drop Table If Exists MedicamentosPrueba;
-- (Ten cuidado con este comando en la vida real)
Drop Database If Exists DB_Pruebas;
Go

--MÓDULO V: INSERCIÓN DE DATOS--
Alter Table Tratamientos Add Estado Varchar(20) Default 'Activo';
Go
-- 1. Insertar 5 especialidades
Insert Into Especialidades (NombreEspecialidad) 
Values ('Cardiología'), ('Pediatría'), ('Neurología'), ('Dermatología'), ('Traumatología');
Go
-- 2 y 9. Insertar 10 médicos especialistas
Insert Into Medicos (Nombre, Apellido, EspecialidadID, Correo, Salario, Experiencia, Turno) 
Values 
('Juan', 'Perez', 1, 'j1@h.com', 5000, 10, 'Mañana'),
('Ana', 'Gomez', 2, 'a2@h.com', 4500, 5, 'Tarde'),
('Luis', 'Diaz', 3, 'l3@h.com', 6000, 12, 'Noche'),
('Maria', 'Lopez', 4, 'm4@h.com', 4000, 8, 'Mañana'),
('Carlos', 'Ruiz', 5, 'c5@h.com', 5500, 15, 'Mañana'),
('Elena', 'Mora', 1, 'e6@h.com', 5200, 11, 'Tarde'),
('Jorge', 'Vega', 2, 'j7@h.com', 4600, 6, 'Noche'),
('Sofia', 'Rios', 3, 's8@h.com', 6100, 14, 'Mañana'),
('Pablo', 'Luna', 4, 'p9@h.com', 4100, 9, 'Tarde'),
('Lucia', 'Cruz', 5, 'l10@h.com', 5600, 16, 'Noche');
Go
-- 3 y 8. Insertar 20 pacientes (Con todos los campos)
Insert Into Pacientes (Nombre, Apellido, FechaNacimiento, Telefono, Correo, Edad, FechaRegistro, Direccion, Tipo_Sangre)
Values 
('Pedro', 'Alvarez', '1990-01-01', '555-1', 'p1@m.com', 36, Getdate(), 'C1', 'O+'), ('Laura', 'Bustos', '1985-02-02', '555-2', 'p2@m.com', 41, Getdate(), 'C2', 'A+'),
('Diego', 'Cortes', '2000-03-03', '555-3', 'p3@m.com', 26, Getdate(), 'C3', 'B-'), ('Rosa', 'Dominguez', '1970-04-04', '555-4', 'p4@m.com', 56, Getdate(), 'C4', 'O-'),
('Raul', 'Esteban', '1995-05-05', '555-5', 'p5@m.com', 31, Getdate(), 'C5', 'AB+'), ('Carmen', 'Flores', '1988-06-06', '555-6', 'p6@m.com', 38, Getdate(), 'C6', 'A-'),
('Hugo', 'Garcia', '1992-07-07', '555-7', 'p7@m.com', 34, Getdate(), 'C7', 'O+'), ('Irene', 'Herrera', '1981-08-08', '555-8', 'p8@m.com', 45, Getdate(), 'C8', 'B+'),
('Mario', 'Iglesias', '1975-09-09', '555-9', 'p9@m.com', 51, Getdate(), 'C9', 'AB-'), ('Julia', 'Jimenez', '2002-10-10', '555-10', 'p10@m.com', 24, Getdate(), 'C10', 'O+'),
('Andres', 'Krauss', '1999-11-11', '555-11', 'p11@m.com', 27, Getdate(), 'C11', 'A+'), ('Marta', 'Lara', '1983-12-12', '555-12', 'p12@m.com', 43, Getdate(), 'C12', 'O-'),
('Oscar', 'Molina', '1991-01-13', '555-13', 'p13@m.com', 35, Getdate(), 'C13', 'B-'), ('Diana', 'Navarro', '1986-02-14', '555-14', 'p14@m.com', 40, Getdate(), 'C14', 'A-'),
('Tito', 'Ochoa', '1978-03-15', '555-15', 'p15@m.com', 48, Getdate(), 'C15', 'AB+'), ('Sara', 'Paredes', '1994-04-16', '555-16', 'p16@m.com', 32, Getdate(), 'C16', 'O+'),
('Rene', 'Quintero', '1989-05-17', '555-17', 'p17@m.com', 37, Getdate(), 'C17', 'B+'), ('Luz', 'Ramos', '1972-06-18', '555-18', 'p18@m.com', 54, Getdate(), 'C18', 'A+'),
('Omar', 'Soto', '1996-07-19', '555-19', 'p19@m.com', 30, Getdate(), 'C19', 'O-'), ('Alba', 'Torres', '1984-08-20', '555-20', 'p20@m.com', 42, Getdate(), 'C20', 'AB-');
Go
-- 6, 14 y 15. Insertar 10 tratamientos (Activos y Finalizados)
Insert Into Tratamientos (NombreTratamiento, Costo, PacienteID, Estado)
Values 
('Terapia Física', 150.00, 1, 'Activo'), ('Quimioterapia', 2000.00, 2, 'Activo'), ('Rehabilitación', 300.00, 3, 'Finalizado'),
('Diálisis', 800.00, 4, 'Activo'), ('Cirugía Menor', 500.00, 5, 'Finalizado'), ('Tratamiento Dental', 120.00, 6, 'Activo'),
('Radioterapia', 1500.00, 7, 'Activo'), ('Tratamiento Psicológico', 80.00, 8, 'Finalizado'),
('Tratamiento Dermatológico', 90.00, 9, 'Activo'), ('Control Prenatal', 50.00, 10, 'Finalizado');
Go
-- 7. Insertar 20 medicamentos
Insert Into Medicamentos (NombreMedicamento, Presentacion, Stock, TratamientoID)
Values 
('Paracetamol', 'Pastilla', 100, 1), ('Ibuprofeno', 'Pastilla', 50, 1), ('Amoxicilina', 'Cápsula', 200, 2), ('Azitromicina', 'Pastilla', 30, 2),
('Omeprazol', 'Cápsula', 150, 3), ('Loratadina', 'Jarabe', 80, 3), ('Aspirina', 'Pastilla', 500, 4), ('Diclofenaco', 'Inyección', 40, 4),
('Losartan', 'Pastilla', 300, 5), ('Enalapril', 'Pastilla', 250, 5), ('Metformina', 'Pastilla', 400, 6), ('Glibenclamida', 'Pastilla', 100, 6),
('Clonazepam', 'Gotas', 20, 7), ('Diazepam', 'Pastilla', 15, 7), ('Salbutamol', 'Inhalador', 60, 8), ('Budesonida', 'Inhalador', 45, 8),
('Insulina', 'Inyección', 90, 9), ('Ketorolaco', 'Pastilla', 110, 9), ('Ciprofloxacino', 'Pastilla', 70, 10), ('Ceftriaxona', 'Inyección', 25, 10);
Go
-- 5, 12 y 13. Insertar 10 habitaciones (Ocupadas y Disponibles)
Insert Into Habitaciones (NumeroHabitacion, TipoHabitacion, Estado, Disponibilidad, PacienteID)
Values 
('101', 'Individual', 'Ocupada', 'No Disponible', 1), ('102', 'Doble', 'Disponible', 'Disponible', Null),
('103', 'UCI', 'Ocupada', 'No Disponible', 2), ('104', 'Individual', 'Disponible', 'Disponible', Null),
('105', 'Doble', 'Ocupada', 'No Disponible', 3), ('106', 'Pediatría', 'Disponible', 'Disponible', Null),
('107', 'Individual', 'Ocupada', 'No Disponible', 4), ('108', 'Doble', 'Disponible', 'Disponible', Null),
('109', 'Maternidad', 'Ocupada', 'No Disponible', 5), ('110', 'Individual', 'Disponible', 'Disponible', Null);
Go
-- 4, 10 y 11. Insertar 15 citas (Actuales y Futuras)
Insert Into Citas (PacienteID, MedicoID, FechaHoraCita, Motivo, Estado, Costo_Consulta)
Values 
(1, 1, Getdate(), 'Dolor', 'Programada', 100.00), (2, 2, Getdate(), 'Control', 'Programada', 80.00),
(3, 3, Dateadd(day, 5, Getdate()), 'Migraña', 'Programada', 120.00), (4, 4, Dateadd(day, 10, Getdate()), 'Alergia', 'Programada', 90.00),
(5, 5, Dateadd(day, 2, Getdate()), 'Fractura', 'Programada', 150.00), (6, 6, Getdate(), 'Revisión', 'Completada', 100.00),
(7, 7, Dateadd(day, 15, Getdate()), 'Vacunación', 'Programada', 80.00), (8, 8, Dateadd(day, 20, Getdate()), 'Neurología', 'Programada', 120.00),
(9, 9, Dateadd(day, 3, Getdate()), 'Piel', 'Programada', 90.00), (10, 10, Dateadd(day, 7, Getdate()), 'Articulación', 'Programada', 150.00),
(11, 1, Dateadd(day, 1, Getdate()), 'Corazón', 'Programada', 100.00), (12, 2, Dateadd(day, 4, Getdate()), 'Fiebre', 'Programada', 80.00),
(13, 3, Dateadd(day, 8, Getdate()), 'Insomnio', 'Programada', 120.00), (14, 4, Dateadd(day, 12, Getdate()), 'Dermatitis', 'Programada', 90.00),
(15, 5, Dateadd(day, 14, Getdate()), 'Esguince', 'Programada', 150.00);

Go
--MÓDULO VI: ACTUALIZACIÓN DE DATOS

Update Pacientes Set Telefono = '999-888-777' Where PacienteID = 1;
Update Pacientes Set Direccion = 'Avenida Siempre Viva 742' Where PacienteID = 2;
Update Medicos Set Salario = 6500.00 Where MedicoID = 3;
Update Medicos Set Turno = 'Tarde' Where MedicoID = 1;
Update Citas Set Estado = 'Cancelada' Where CitaID = 5;
Update Citas Set Costo_Consulta = 130.00 Where CitaID = 3;
Update Especialidades Set NombreEspecialidad = 'Cardiología Avanzada' Where EspecialidadID = 1;
Update Habitaciones Set Disponibilidad = 'No Disponible', Estado = 'En Mantenimiento' Where HabitacionID = 2;
Update Tratamientos Set Estado = 'Finalizado' Where TratamientoID = 1;
Update Medicamentos Set Stock = 150, Presentacion = 'Jarabe' Where MedicamentoID = 1;
Update Pacientes Set Correo = 'nuevo.correo@mail.com' Where PacienteID = 4;
Update Medicos Set Correo = 'dr.nuevo@hosp.com' Where MedicoID = 5;
Update Citas Set FechaHoraCita = Dateadd(day, 1, FechaHoraCita) Where CitaID = 7;
Update Medicos Set Experiencia = 16 Where MedicoID = 5;
Update Pacientes Set Tipo_Sangre = 'O-' Where PacienteID = 10;
Go

-- MÓDULO VII: ELIMINACIÓN DE DATOS

-- 1 y 2. Eliminar medicamento y cita directa
Delete From Medicamentos Where MedicamentoID = 20;
Delete From Citas Where CitaID = 15;
Go
-- 3. Eliminar una habitación
Delete From Habitaciones Where HabitacionID = 10;
Go
-- 4. Eliminar un tratamiento (Requiere borrar primero sus medicamentos por la FK)
Delete From Medicamentos Where TratamientoID = 9;
Delete From Tratamientos Where TratamientoID = 9;
Go
-- 5. Eliminar un paciente específico (Requiere desvincularlo primero de sus FK)
Delete From Citas Where PacienteID = 20;
Update Habitaciones Set PacienteID = Null Where PacienteID = 20;
Delete From Pacientes Where PacienteID = 20;
Go
-- 6 y 8. Eliminar por condiciones
Delete From Citas Where Estado = 'Cancelada';
Delete From Habitaciones Where Estado = 'Disponible';
Go
-- 7. Eliminar pacientes sin citas (Usando Subconsulta)
Delete From Pacientes Where PacienteID Not In (Select Distinct PacienteID From Citas);
Go
-- 9 y 10. Eliminar medicamentos "vencidos" (Simulados por stock 0) y registros prueba
Delete From Medicamentos Where Stock = 0;
Delete From Pacientes Where Nombre = 'Prueba';

--MÓDULO VIII: CONSULTAS BÁSICAS 

-- 1 al 4. Mostrar tablas completas
Select * From Pacientes;
Select * From Medicos;
Select * From Especialidades;
Select * From Citas;
Go
-- 5 y 6. Ordenamientos (Order By)
Select * From Pacientes Order By Apellido Asc;
Select * From Medicos Order By Salario Desc;
Go
-- 7. Citas del día actual (Ignorando la hora)
Select * From Citas Where Cast(FechaHoraCita As Date) = Cast(Getdate() As Date);
Go
-- 8. Mostrar habitaciones disponibles
Select * From Habitaciones Where Disponibilidad = 'Disponible';
Go
-- 9. Mostrar cantidad de pacientes (Agregación)
Select Count(*) As TotalPacientes From Pacientes;
Go
-- 10. Mostrar cantidad de citas por médico (Agrupación)
Select MedicoID, Count(*) As TotalCitas 
From Citas 
Group By MedicoID;
Go

-- MÓDULO VIII: CONSULTAS BÁSICAS (SELECT)

Select * From Pacientes;
Select * From Medicos;
Select * From Especialidades;
Select * From Citas;
Go
Select * From Pacientes    Order By Apellido Asc;
Select * From Medicos      Order By Salario  Desc;
Go
Select * From Citas
Where Cast(FechaHoraCita As Date) = Cast(Getdate() As Date);
Go
Select * From Habitaciones Where Disponibilidad = 'Disponible';
Go
Select Count(*) As TotalPacientes From Pacientes;
Go
Select   MedicoID, Count(*) As TotalCitas
From     Citas
Group By MedicoID
Order By TotalCitas Desc;
Go

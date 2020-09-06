-- Creacion de base de datos
use master;
GO;
use db_imports_sugar_confectionary
GO;


-- Creacion de dimensiones (Se puede crear desde acá o en el componente de SSIS)
create table DimCountry (
id uniqueidentifier primary key,
"name" nvarchar(255)
)
create table DimTariff (
id uniqueidentifier primary key,
code nvarchar(10),
"description" nvarchar(255)
)

-- Creacion de tabla de hechos (Se puede crear desde acá o en el componente de SSIS)
create table Fact_imports (
id uniqueidentifier primary key,
id_country uniqueidentifier foreign key references DimCountry(id),
id_tariff_cod uniqueidentifier foreign key references DimTariff(id),
"year" int,
"value" float
)

-- Para reingresar los datos
delete from DimCountry;
delete from DimTariff;
delete from Fact_imports;

-- Por equivocaciones realizadas con anterioridad
drop table DimCountry;
drop table DimTariff;
drop table Fact_imports;

-- Consultas
select * from Fact_imports
-- Creacion de base de datos
use master;
GO;
use db_imports_sugar_confectionary
GO;





-- Creacion de dimensiones (Se puede crear desde acá o en el componente de SSIS)
create table DimCountry (
id uniqueidentifier primary key,
"name" varchar(100)
)
create table DimTariff (
id uniqueidentifier primary key,
code varchar(10),
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
--Calcular el total de un codigo alancerario de todos los paises con el paso de los años (1994-2016)
select dt.code, sum(fi.value) as Total from Fact_imports fi
join DimTariff dt on fi.id_tariff_cod = dt.id
group by dt.code order by dt.code;

--Calcular el total de un codigo alancerario y pais con el paso de los años (1994-2016)
select dc.name, dt.code, sum(fi.value) as Total from Fact_imports fi
join DimTariff dt on fi.id_tariff_cod = dt.id
join DimCountry dc on fi.id_country = dc.id
group by dt.code, dc.name order by dc.name, dt.code

--Calcular el total gastado en un año especifo, por país
select dc.name, fi.year, sum(fi.value) as Total from Fact_imports fi
join DimCountry dc on fi.id_country = dc.id
group by dc.name, fi.year order by dc.name, fi.year

--Calcular el total gastado en un pais, incluyendo todos los codigos alancerarios con el paso de los años (1994-2016)
select sum(fi.value) as Total, dc.name from Fact_imports fi
join DimCountry dc on fi.id_country = dc.id
group by dc.name;

--Calcular el total por categoria en un año
select fi.year, concat('Categoria ', substring(dt.code, 4, 1)) as Categoria, sum(fi.value) as Total from Fact_imports fi
join DimTariff dt on fi.id_tariff_cod = dt.id
group by concat('Categoria ', substring(dt.code, 4, 1)), fi.year order by fi.year, Categoria

--Calcular el total por categoria de un pais a lo largo de los años (1994-2016)
select dc.name, concat('Categoria ', substring(dt.code, 4, 1)) as Categoria, sum(fi.value) as Total from Fact_imports fi
join DimTariff dt on fi.id_tariff_cod = dt.id
join DimCountry dc on fi.id_country = dc.id
group by concat('Categoria ', substring(dt.code, 4, 1)), dc.name order by dc.name, Categoria

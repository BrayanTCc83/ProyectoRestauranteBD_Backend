SET check_function_bodies = false;

CREATE TABLE "CATEGORIA"(
  "idCat" smallint NOT NULL,
  "nombreCat" varchar(100) NOT NULL,
  "desCat" text NOT NULL,
  CONSTRAINT "CATEGORIA_pkey" PRIMARY KEY("idCat")
);

CREATE TABLE "TELEFONO"(
  "rfcTel" char(13) NOT NULL,
  telefono bigint NOT NULL,
  CONSTRAINT "TELEFONO_pkey" PRIMARY KEY("rfcTel")
);

CREATE TABLE "EMPLEADO"(
  rfc char(13) NOT NULL,
  "numEmp" integer NOT NULL,
  "fotoEmp" bytea NOT NULL,
  "nomPilaEmp" varchar(100) NOT NULL,
  "apPatEmp" varchar(100) NOT NULL,
  "apMatEmp" varchar(100),
  "fecNacEmp" date NOT NULL,
  sueldo numeric(8,2) NOT NULL,
  edad numeric(2) NOT NULL,
  "estadoEmp" varchar(100) NOT NULL,
  "calleEmp" varchar(200) NOT NULL,
  "codPosEmp" char(5) NOT NULL,
  "colEmp" varchar(100) NOT NULL,
  "numExt" smallint NOT NULL,
  "numInt" smallint,
  CONSTRAINT "EMPLEADO_pkey" PRIMARY KEY(rfc)
);
COMMENT ON COLUMN "EMPLEADO".fecNacEmp IS 'Calculado del rfc';
COMMENT ON COLUMN "EMPLEADO".edad IS 'Calculado de fecNacEmp';
COMMENT ON COLUMN "EMPLEADO".nomPilaEmp IS 'Calculado del rfc';
COMMENT ON COLUMN "EMPLEADO".apPatEmp IS 'Calculado del rfc';
COMMENT ON COLUMN "EMPLEADO".apMatEmp IS 'Calculado del rfc';


-- Luego las tablas con dependencias

CREATE TABLE "FACTURA"(
  "idFac" serial NOT NULL,
  "rfcClt" char(13) NOT NULL,
  "nomPilaClt" varchar(100) NOT NULL,
  "apPatClt" varchar(100) NOT NULL,
  "apMatClt" varchar(100),
  "fechaNacClt" date NOT NULL,
  "estadoClt" varchar(100) NOT NULL,
  "emailClt" varchar(225) NOT NULL,
  "rznSocial" text NOT NULL,
  "calleClt" varchar(200) NOT NULL,
  "codPosClt" char(5) NOT NULL,
  "colClt" varchar(100) NOT NULL,
  "numExtClt" smallint NOT NULL,
  "numIntClt" smallint,
  CONSTRAINT "FACTURA_pkey" PRIMARY KEY("idFac")
);
COMMENT ON COLUMN "FACTURA".fecNacClt IS 'Calculado del rfcClt';
COMMENT ON COLUMN "FACTURA".nomPilaClt IS 'Calculado del rfcClt';
COMMENT ON COLUMN "FACTURA".apPatClt IS 'Calculado del rfcClt';
COMMENT ON COLUMN "FACTURA".apMatClt IS 'Calculado del rfcClt';

CREATE TABLE "ADMINISTRATIVO"(
  "rfcAdm" char(13) NOT NULL,
  rol varchar(100) NOT NULL,
  CONSTRAINT "ADMINISTRATIVO_pkey" PRIMARY KEY("rfcAdm")
);

CREATE TABLE "MESERO"(
  "rfcMsr" char(13) NOT NULL,
  horario timestamp NOT NULL,
  CONSTRAINT "MESERO_pkey" PRIMARY KEY("rfcMsr")
);

CREATE TABLE "COCINERO"(
  "rfcCoc" char(13) NOT NULL, 
  especialidad text NOT NULL,
  CONSTRAINT "COCINERO_pkey" PRIMARY KEY("rfcCoc")
);

CREATE TABLE "DEPENDIENTE"(
  rfc char(13) NOT NULL,
  curp char(18) NOT NULL,
  "nomPilaDep" varchar(100) NOT NULL,
  "apPatDep" varchar(100) NOT NULL,
  "apMatDep" varchar(100),
  "parentesCo" varchar(100) NOT NULL
);

CREATE TABLE "COBORD"(
  rfc char(13) NOT NULL,
  folio varchar(20) NOT NULL,
  CONSTRAINT "COBORD_pkey" PRIMARY KEY(rfc, folio)
);

CREATE TABLE "ORDPROD"(
  folio varchar(20) NOT NULL,
  "idProducto" INTEGER NOT NULL,
  "detalleCnt" smallint NOT NULL,
  "detallePrc" numeric(10, 2) NOT NULL,
  CONSTRAINT "ORDPROD_pkey" PRIMARY KEY(folio, "idProducto")
);

CREATE TABLE "PRODUCTO"(
  "idProducto" integer NOT NULL,
  "numVentas" integer NOT NULL,
  "descProd" text NOT NULL,
  disponibilidad boolean NOT NULL,
  precio numeric(10, 2) NOT NULL,
  "nomProd" varchar(100) NOT NULL,
  receta text NOT NULL,
  "idCat" smallint GENERATED ALWAYS AS ("idProducto" / 100000) STORED,
  CONSTRAINT "PRODUCTO_pkey" PRIMARY KEY("idProducto")
);

CREATE TABLE "ORDEN"(
  folio varchar(20) NOT NULL,
  "cantTotPag" numeric(10,2) NOT NULL,
  "fechaOrd" timestamp NOT NULL,
  "rfcMsr" char(13) NOT NULL,
  "idFac" integer,
  CONSTRAINT "ORDEN_pkey" PRIMARY KEY(folio),
  CONSTRAINT "ORDEN_idFac_key" UNIQUE("idFac")
);

-- Luego los FOREIGN KEYS

ALTER TABLE "ADMINISTRATIVO"
ADD CONSTRAINT "ADMINISTRATIVO_rfcAdm_fkey" FOREIGN KEY ("rfcAdm") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "PRODUCTO"
ADD CONSTRAINT "PRODUCTO_idCat_fkey" FOREIGN KEY ("idCat") REFERENCES "CATEGORIA" ("idCat");

ALTER TABLE "COBORD"
ADD CONSTRAINT "COBORD_folio_fkey" FOREIGN KEY (folio) REFERENCES "ORDEN" (folio);

ALTER TABLE "COBORD"
ADD CONSTRAINT "COBORD_rfc_fkey" FOREIGN KEY (rfc) REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "COCINERO"
ADD CONSTRAINT "COCINERO_rfcCoc_fkey" FOREIGN KEY ("rfcCoc") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "DEPENDIENTE"
ADD CONSTRAINT "DEPENDIENTE_rfc_fkey" FOREIGN KEY (rfc) REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "FACTURA"
ADD CONSTRAINT "FACTURA_idFac_fkey" FOREIGN KEY ("idFac") REFERENCES "ORDEN" ("idFac");

ALTER TABLE "MESERO"
ADD CONSTRAINT "MESERO_rfcMsr_fkey" FOREIGN KEY ("rfcMsr") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "ORDEN"
ADD CONSTRAINT "ORDEN_rfcMsr_fkey" FOREIGN KEY ("rfcMsr") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "ORDPROD"
ADD CONSTRAINT "ORDPROD_folio_fkey" FOREIGN KEY (folio) REFERENCES "ORDEN" (folio);

ALTER TABLE "ORDPROD"
ADD CONSTRAINT "ORDPROD_idProducto_fkey" FOREIGN KEY ("idProducto") REFERENCES "PRODUCTO" ("idProducto");

ALTER TABLE "TELEFONO"
ADD CONSTRAINT "TELEFONO_rfcTel_fkey" FOREIGN KEY ("rfcTel") REFERENCES "EMPLEADO" (rfc);

-- Mas desmadre
-- Creando FOLIO por default (sin tener que ingresarlo pues)

CREATE SEQUENCE ordenFolioSec START 1;

ALTER TABLE "ORDEN"
ALTER COLUMN folio SET DEFAULT 'ORD-' || LPAD(nextval('ordenFolioSec')::TEXT, 4, '0');


-- Calculando el total de prod en ORDPROD
CREATE OR REPLACE FUNCTION calculate_order_product_total() RETURNS TRIGGER AS $$
DECLARE
    product_price NUMERIC(10, 2);
BEGIN
    SELECT precio INTO product_price FROM "PRODUCTO" WHERE "idProducto" = NEW."idProducto";
    NEW."detallePrc" := NEW."detalleCnt" * product_price;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_order_product_total
BEFORE INSERT OR UPDATE ON "ORDPROD"
FOR EACH ROW
EXECUTE FUNCTION calculate_order_product_total();


-- Actualizando el total de ventas
-- No salio xd

-- Si no esta disponible un prod, manda alv
CREATE OR REPLACE FUNCTION check_product_availability() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM "PRODUCTO"
        WHERE "idProducto" = NEW."idProducto" AND disponibilidad = TRUE
    ) THEN
        RAISE EXCEPTION 'El producto no está disponible.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_availability_before_insert_or_update
BEFORE INSERT OR UPDATE ON "ORDPROD"
FOR EACH ROW
EXECUTE FUNCTION check_product_availability();


-- Calculando la canTotPag
CREATE OR REPLACE FUNCTION actcantTotPag()
RETURNS TRIGGER AS
$$
BEGIN
    SELECT SUM("detallePrc") 
    FROM "ORDPROD"
    WHERE "ORDPROD".folio = NEW.folio;
    
    UPDATE "ORDEN" SET "cantTotPag" = total
    WHERE folio = NEW.folio;
    
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER actcantTotPagtrigger
AFTER INSERT OR UPDATE OR DELETE ON "ORDPROD"
FOR EACH ROW
EXECUTE FUNCTION actualizar_cantTotPag();

-- Obteniendo al mesero, las ordenes que ha atendido y el total que se ha pagado
CREATE OR REPLACE FUNCTION empMesero(numEmp INTEGER, OUT ordenesAtendidas INTEGER, OUT totalPagado NUMERIC)
RETURNS RECORD AS
$$
DECLARE
    esMesero BOOLEAN;
BEGIN
    -- Verificar si el empleado es un mesero
    SELECT EXISTS(SELECT 1 FROM "MESERO" WHERE "rfcMsr" = (SELECT rfc FROM "EMPLEADO" WHERE "numEmp" = numEmp)) INTO esMesero;

    IF esMesero THEN
        -- Contar la cantidad de órdenes registradas por el mesero en el día
        SELECT COUNT(*), COALESCE(SUM("cantTotPag"), 0)
        INTO ordenesAtendidas, totalPagado
        FROM "ORDEN"
        WHERE "rfcMsr" = (SELECT rfc FROM "EMPLEADO" WHERE "numEmp" = numEmp);
        
    ELSE
        -- Mostrar un mensaje de error si no es un mesero
        RAISE EXCEPTION 'El numero de empleado introducido no corresponde a un mesero';
    END IF;
END;
$$
LANGUAGE plpgsql;

-- Usarla como 
SELECT * FROM empMesero(7); -- Es el caso válido
SELECT * FROM empMesero(13); -- Es el caso que no va a salir, pq no es mesero

-- Índices creados para mayor rapidez
  --> Ver los productos no disponibles
  CREATE INDEX ixDispoProd ON "PRODUCTO" (disponibilidad) WHERE disponibilidad = TRUE;

-- Devolviendo los productos que no se encuentran disponibles
CREATE OR REPLACE FUNCTION prodNoDisp()
RETURNS TABLE (
    productoNoDisponible varchar(100)
) AS
$$
BEGIN
    RETURN QUERY 
    SELECT "nomProd" FROM "PRODUCTO"
    WHERE disponibilidad = FALSE;
END;
$$
LANGUAGE plpgsql;

-- Usarla como
SELECT * FROM prodNoDisp();


-- Trigger para actualizar el número de ventas del producto
CREATE OR REPLACE FUNCTION update_product_sales() RETURNS TRIGGER AS $$
BEGIN
    UPDATE "PRODUCTO" 
    SET "numVentas" = "numVentas" + NEW."detalleCnt"
    WHERE "idProducto" = NEW."idProducto";
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_product_sales_trigger
AFTER INSERT ON "ORDPROD"
FOR EACH ROW
EXECUTE FUNCTION update_product_sales();

-- Funcion, dadas dos fechas, devuelve el total de ventas y el monto total entre esas fechas
CREATE OR REPLACE FUNCTION ventas(fechaI DATE, fechaF DATE)
RETURNS TABLE(totVentas INT, montTot NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT
        CAST(COUNT(DISTINCT folio) AS INTEGER) AS totVentas, 
        COALESCE(SUM("cantTotPag"), 0) AS montTot
    FROM
        "ORDEN"
    WHERE
        "fechaOrd" BETWEEN fechaI AND fechaF;
END;
$$ LANGUAGE plpgsql;

-- EJEMPLO DE USO
SELECT * FROM ventas('2024-05-01', '2024-05-05');

-- Insertar una nueva categoría
INSERT INTO "CATEGORIA" ("idCat", "nombreCat", "desCat") 
VALUES 
(100, 'Aperitivos y Entradas', 'Variedad de pequeños platos que tienen lugar antes de la comida principal. Diseñados para abrir el apetito del comensal. Pueden variar según el tipo de cocina o del restaurante mismo, puede incluir amplia cantidad de alimentos como canapés, ensaladas, tapas, sopas, o hasta platos de mariscos, carnes y quesos'),
(200, 'Plato Fuerte', 'Variedad de platos principales que incluye una amplia gama de alimentos desde carnes rojas, aves, pescados, o platos vegetarianos. Los platos fuertes suelen ir acompañados de nua guarnicion como veerdueas, pastas, arroces entre otros. Los platos fuertes son generalmente el centro de la comida en el que los chefs y cocineros suelen crear grandes platos y visualmente atractivos'),
(300, 'Bebidas', 'Incluye una amplia gama de opciones como agua, refrescos, jugos naturales, tés, cafés, batidos, y más. Además tambien hay bebidas especiales como limonadas caseras, tés de hierbas, o batidos de frutas.'),
(400, 'Bebidas Alcohólicas y Cocteles', 'Puede abarcar desde cervezas, vinos cocteles y licores. Los cocteless son bebidas especiales preparadas con algunos jarabes o jugos de fruta para un sabor mas dulce o neutro para acompañar la comida'),
(500, 'Postres', 'Variedad de alimentos dulces que tienen ligar al final de una comida. Los postres pueden incluir una amplia gama de alimentos como pasteles, tartas, helados, flanes, galletas, brownies, mousses, pudines, frutas frescas y más.Los postres son a menudo la culminación de la experiencia culinaria, proporcionando un final dulce y satisfactorio a la comida. Pueden variar en complejidad, desde simples frutas frescas hasta elaboradas creaciones de repostería.'),
(600, 'Extras', 'Referente a servicios adicionales: órdenes extra de pan, de crema, tortillas, salsas etc');

-- Inserts para productos de la categoría "Aperitivos y Entradas" (ID de categoría: 100)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES
(10032143, 10, 'Canapés de salmón ahumado', true, 12.99, 'Canapés de salmón ahumado', 'Salmón ahumado, pan tostado, queso crema, eneldo'),
(10032144, 15, 'Ensalada Caprese', true, 8.99, 'Ensalada Caprese', 'Tomate, mozzarella fresca, albahaca, aceite de oliva'),
(10032145, 20, 'Patatas Bravas', true, 7.99, 'Patatas Bravas', 'Patatas fritas, salsa brava, alioli'),
(10032146, 18, 'Brochetas de Pollo Teriyaki', true, 9.99, 'Brochetas de Pollo Teriyaki', 'Pechuga de pollo, salsa teriyaki, pimiento, cebolla'),
(10032147, 25, 'Croquetas de Jamón', true, 6.49, 'Croquetas de Jamón', 'Jamón serrano, leche, harina, huevo, pan rallado'),
(10032148, 30, 'Bruschetta de Tomate y Albahaca', true, 7.99, 'Bruschetta de Tomate y Albahaca', 'Tomate, albahaca, aceite de oliva, pan rústico'),
(10032149, 12, 'Hummus de Garbanzos', false, 5.99, 'Hummus de Garbanzos', 'Garbanzos, tahini, limón, aceite de oliva, ajo'),
(10032150, 8, 'Tabla de Quesos', false, 15.99, 'Tabla de Quesos', 'Variedad de quesos, frutos secos, frutas'),
(10032151, 10, 'Tostadas de Aguacate', false, 7.49, 'Tostadas de Aguacate', 'Aguacate, pan integral, tomate cherry, cilantro, limón'),
(10032152, 22, 'Alitas de Pollo BBQ', true, 11.99, 'Alitas de Pollo BBQ', 'Alitas de pollo, salsa BBQ, miel, limón'),
(10032153, 17, 'Rollitos de Primavera', true, 8.99, 'Rollitos de Primavera', 'Verduras, carne de cerdo, masa de rollito'),
(10032154, 14, 'Ceviche de Pescado', true, 13.49, 'Ceviche de Pescado', 'Pescado blanco, limón, cilantro, cebolla, ají'),
(10032155, 9, 'Sopa de Tomate', false, 6.99, 'Sopa de Tomate', 'Tomate, cebolla, zanahoria, caldo de pollo'),
(10032156, 11, 'Tacos de Camarón', false, 10.99, 'Tacos de Camarón', 'Camarones, tortillas de maíz, salsa de aguacate, repollo'),
(10032157, 6, 'Carpaccio de Res', false, 14.99, 'Carpaccio de Res', 'Carne de res, parmesano, rúcula, aceite de oliva'),
(10032158, 20, 'Empanadas Argentinas', true, 9.49, 'Empanadas Argentinas', 'Carne molida, cebolla, aceitunas, huevo, masa de empanada'),
(10032159, 16, 'Tartar de Atún', true, 16.99, 'Tartar de Atún', 'Atún fresco, aguacate, salsa de soja, sésamo'),
(10032160, 13, 'Nachos Supremos', true, 10.99, 'Nachos Supremos', 'Nachos de maíz, carne molida, queso cheddar, guacamole, crema agria'),
(10032161, 7, 'Sushi de Salmón', false, 18.99, 'Sushi de Salmón', 'Salmón fresco, arroz de sushi, alga nori, wasabi, jengibre'),
(10032162, 5, 'Ensalada de Pulpo', false, 17.99, 'Ensalada de Pulpo', 'Pulpo cocido, pimiento, cebolla morada, aceitunas, limón'),
(10032163, 8, 'Rollitos de Queso de Cabra', false, 12.99, 'Rollitos de Queso de Cabra', 'Queso de cabra, hojaldre, miel, nueces'),
(10032164, 19, 'Camarones al Ajillo', true, 14.99, 'Camarones al Ajillo', 'Camarones, ajo, guindilla, aceite de oliva'),
(10032165, 23, 'Calamares a la Romana', true, 12.49, 'Calamares a la Romana', 'Calamares, harina, huevo, aceite de oliva'),
(10032166, 28, 'Gambas al Ajillo', true, 15.99, 'Gambas al Ajillo', 'Gambas, ajo, guindilla, aceite de oliva'),
(10032167, 9, 'Tabule', false, 8.49, 'Tabule', 'Perejil, menta, tomate, cebolla, trigo bulgur'),
(10032168, 11, 'Langostinos al Curry', false, 16.99, 'Langostinos al Curry', 'Langostinos, leche de coco, curry, limón'),
(10032169, 6, 'Tartaleta de Champiñones', false, 11.99, 'Tartaleta de Champiñones', 'Champiñones, cebolla, nata, masa de tarta');

-- Inserts para productos de la categoría "Plato Fuerte" (ID de categoría: 200)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(20054321, 30, 'Filete de Ternera al Grill', true, 24.99, 'Filete de Ternera al Grill', 'Filete de ternera, sal, pimienta, aceite de oliva'),
(20054322, 25, 'Salmón a la Parrilla', true, 22.99, 'Salmón a la Parrilla', 'Filete de salmón, limón, aceite de oliva, hierbas frescas'),
(20054323, 20, 'Risotto de Champiñones', true, 18.99, 'Risotto de Champiñones', 'Arroz arborio, caldo de verduras, champiñones, queso parmesano'),
(20054324, 28, 'Pollo al Horno con Verduras', true, 19.99, 'Pollo al Horno con Verduras', 'Pechuga de pollo, zanahoria, pimiento, cebolla, aceite de oliva'),
(20054325, 22, 'Filete de Pescado a la Plancha', true, 17.49, 'Filete de Pescado a la Plancha', 'Filete de pescado blanco, limón, sal, pimienta'),
(20054326, 18, 'Lasaña de Carne', true, 16.99, 'Lasaña de Carne', 'Carne molida, pasta para lasaña, salsa de tomate, queso mozzarella'),
(20054327, 15, 'Paella de Mariscos', false, 23.99, 'Paella de Mariscos', 'Arroz, caldo de pescado, camarones, mejillones, calamares, guisantes'),
(20054328, 12, 'Chuletas de Cerdo a la Barbacoa', false, 21.99, 'Chuletas de Cerdo a la Barbacoa', 'Chuletas de cerdo, salsa barbacoa, miel, especias'),
(20054329, 10, 'Vegetales al Wok', false, 15.99, 'Vegetales al Wok', 'Vegetales mixtos, salsa de soja, jengibre, ajo'),
(20054330, 26, 'Hamburguesa de Ternera', true, 14.99, 'Hamburguesa de Ternera', 'Carne de ternera, pan de hamburguesa, lechuga, tomate, cebolla, queso'),
(20054331, 20, 'Pechuga de Pollo a la Parmesana', true, 18.49, 'Pechuga de Pollo a la Parmesana', 'Pechuga de pollo, salsa marinara, queso parmesano, mozzarella'),
(20054332, 16, 'Sopa de Mariscos', true, 20.99, 'Sopa de Mariscos', 'Camarones, calamares, mejillones, pescado, caldo de pescado'),
(20054333, 14, 'Filete de Tofu al Curry', false, 16.99, 'Filete de Tofu al Curry', 'Tofu, leche de coco, curry, verduras'),
(20054334, 11, 'Ensalada César con Pollo a la Parrilla', false, 19.99, 'Ensalada César con Pollo a la Parrilla', 'Lechuga romana, pechuga de pollo, crutones, aderezo césar'),
(20054335, 9, 'Pasta con Salsa Alfredo', false, 17.99, 'Pasta con Salsa Alfredo', 'Pasta fettuccine, crema, queso parmesano, mantequilla'),
(20054336, 18, 'Costillas de Cerdo a la Parrilla', true, 22.99, 'Costillas de Cerdo a la Parrilla', 'Costillas de cerdo, salsa barbacoa, especias'),
(20054337, 15, 'Pescado al Horno con Limón y Hierbas', true, 19.99, 'Pescado al Horno con Limón y Hierbas', 'Filete de pescado blanco, limón, aceite de oliva, hierbas aromáticas'),
(20054338, 12, 'Chili con Carne', true, 17.49, 'Chili con Carne', 'Carne molida, frijoles rojos, tomate, chile, especias');

-- Inserts para productos de la categoría "Bebidas" (ID de categoría: 300)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(30065432, 40, 'Limonada Natural', true, 4.99, 'Limonada Natural', 'Limón, agua, azúcar, hielo'),
(30065433, 35, 'Jugo de Naranja Fresco', true, 4.49, 'Jugo de Naranja Fresco', 'Naranjas frescas exprimidas'),
(30065434, 45, 'Té Helado de Frutos Rojos', true, 5.49, 'Té Helado de Frutos Rojos', 'Té negro, frutos rojos, azúcar'),
(30065435, 99, 'Agua Natural', false, 3.99, 'Agua Natural', 'Agua Natural'),
(30065436, 55, 'Café Americano', true, 3.99, 'Café Americano', 'Café espresso, agua caliente'),
(30065437, 60, 'Refresco de Cola', true, 2.99, 'Refresco de Cola', 'Refresco de cola carbonatado, hielo'),
(30065438, 65, 'Agua Mineral con Gas', true, 3.49, 'Agua Mineral con Gas', 'Agua mineral carbonatada'),
(30065439, 30, 'Limonada de Fresa', false, 5.49, 'Limonada de Fresa', 'Limón, fresas, agua, azúcar'),
(30065440, 25, 'Batido de Mango', false, 6.99, 'Batido de Mango', 'Mango, leche, azúcar, hielo'),
(30065441, 20, 'Agua de Horchata', false, 4.99, 'Agua de Horchata', 'Arroz, canela, azúcar, agua'),
(30065442, 70, 'Té Verde Frío', true, 4.99, 'Té Verde Frío', 'Té verde, limón, menta, azúcar'),
(30065443, 75, 'Café Latte', true, 4.49, 'Café Latte', 'Café espresso, leche vaporizada'),
(30065444, 80, 'Zumo de Piña', true, 3.99, 'Zumo de Piña', 'Piña fresca exprimida'),
(30065445, 35, 'Smoothie de Frutos Rojos', false, 6.49, 'Smoothie de Frutos Rojos', 'Frutos rojos, yogur, miel, hielo'),
(30065446, 40, 'Café Mocha', false, 5.99, 'Café Mocha', 'Café espresso, chocolate, leche, nata'),
(30065447, 45, 'Agua de Coco', false, 4.49, 'Agua de Coco', 'Coco fresco, agua'),
(30065448, 85, 'Té Chai Latte', true, 5.49, 'Té Chai Latte', 'Té negro, especias, leche, miel'),
(30065449, 90, 'Zumo de Manzana', true, 3.49, 'Zumo de Manzana', 'Manzanas frescas exprimidas'),
(30065450, 95, 'Café Frappé', true, 6.99, 'Café Frappé', 'Café espresso, hielo, leche, jarabe de vainilla'),
(30065451, 50, 'Té de Hibisco Frío', false, 5.99, 'Té de Hibisco Frío', 'Flores de hibisco, limón, menta, azúcar'),
(30065452, 55, 'Lassi de Mango', false, 6.49, 'Lassi de Mango', 'Mango, yogur, azúcar, hielo'),
(30065453, 60, 'Jugo de Granada', false, 4.99, 'Jugo de Granada', 'Granadas frescas exprimidas'),
(30065454, 100, 'Té de Hierbabuena', true, 4.49, 'Té de Hierbabuena', 'Hierbabuena fresca, limón, azúcar'),
(30065455, 105, 'Zumo de Zanahoria', true, 3.99, 'Zumo de Zanahoria', 'Zanahorias frescas exprimidas'),
(30065456, 110, 'Café Cortado', true, 3.49, 'Café Cortado', 'Café espresso, un chorrito de leche'),
(30065457, 65, 'Té Matcha Latte', false, 6.99, 'Té Matcha Latte', 'Té matcha, leche, azúcar'),
(30065458, 70, 'Jugo de Papaya', false, 5.49, 'Jugo de Papaya', 'Papaya fresca exprimida'),
(30065459, 75, 'Café Vienés', false, 5.99, 'Café Vienés', 'Café espresso, nata montada, chocolate rallado');

-- Inserts para productos de la categoría "Bebidas Alcohólicas y Cocteles" (ID de categoría: 400)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(40076543, 30, 'Margarita', true, 8.99, 'Margarita', 'Tequila, licor de naranja, jugo de limón, azúcar'),
(40076544, 25, 'Mojito', true, 9.49, 'Mojito', 'Ron blanco, menta fresca, lima, azúcar, soda'),
(40076545, 20, 'Piña Colada', true, 7.99, 'Piña Colada', 'Ron blanco, crema de coco, jugo de piña, hielo'),
(40076546, 32, 'Cosmopolitan', true, 10.99, 'Cosmopolitan', 'Vodka, licor de naranja, jugo de arándano, jugo de limón'),
(40076547, 27, 'Cuba Libre', true, 9.99, 'Cuba Libre', 'Ron blanco, refresco de cola, lima'),
(40076548, 23, 'Daiquiri de Fresa', true, 11.49, 'Daiquiri de Fresa', 'Ron blanco, fresas frescas, jugo de limón, azúcar'),
(40076549, 18, 'Mimosa', false, 7.99, 'Mimosa', 'Champán, jugo de naranja'),
(40076550, 14, 'Caipirinha', false, 9.49, 'Caipirinha', 'Cachaça, lima, azúcar'),
(40076551, 20, 'Gin Tonic', false, 8.99, 'Gin Tonic', 'Gin, tónica, limón'),
(40076552, 28, 'Old Fashioned', true, 12.99, 'Old Fashioned', 'Bourbon, azúcar, angostura, cáscara de naranja'),
(40076553, 22, 'Sangría', true, 9.99, 'Sangría', 'Vino tinto, brandy, frutas, azúcar'),
(40076554, 26, 'Pisco Sour', true, 10.49, 'Pisco Sour', 'Pisco, limón, azúcar, clara de huevo, amargo de angostura'),
(40076555, 16, 'Vodka Martini', false, 11.99, 'Vodka Martini', 'Vodka, vermut seco, aceituna'),
(40076556, 11, 'Tequila Sunrise', false, 10.99, 'Tequila Sunrise', 'Tequila, jugo de naranja, granadina'),
(40076557, 19, 'Mai Tai', false, 12.49, 'Mai Tai', 'Ron dorado, licor de naranja, almendra, ron blanco, lima'),
(40076558, 30, 'Whiskey Sour', true, 11.99, 'Whiskey Sour', 'Bourbon, limón, azúcar, clara de huevo, amargo de angostura'),
(40076559, 25, 'Negroni', true, 10.99, 'Negroni', 'Gin, vermut rojo, Campari'),
(40076560, 21, 'Paloma', true, 9.99, 'Paloma', 'Tequila, refresco de toronja, lima, sal'),
(40076561, 17, 'Mint Julep', false, 12.99, 'Mint Julep', 'Bourbon, menta, azúcar'),
(40076562, 12, 'Margarita de Mango', false, 11.99, 'Margarita de Mango', 'Tequila, licor de mango, jugo de limón, azúcar'),
(40076563, 18, 'Piña Colada de Fresa', false, 10.99, 'Piña Colada de Fresa', 'Ron blanco, crema de coco, jugo de piña, fresas'),
(40076564, 24, 'Martini Espresso', true, 13.49, 'Martini Espresso', 'Vodka, licor de café, café espresso'),
(40076565, 29, 'Dark and Stormy', true, 10.49, 'Dark and Stormy', 'Ron oscuro, ginger beer, lima'),
(40076566, 35, 'Whiskey Ginger', true, 9.49, 'Whiskey Ginger', 'Whiskey, ginger ale, lima');


-- Inserts para productos de la categoría "Postres" (ID de categoría: 500)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(50087654, 20, 'Tarta de Queso con Frutos Rojos', true, 9.99, 'Tarta de Queso con Frutos Rojos', 'Queso crema, azúcar, huevos, frutos rojos, galleta'),
(50087655, 15, 'Brownie con Helado de Vainilla', true, 7.99, 'Brownie con Helado de Vainilla', 'Chocolate, mantequilla, azúcar, huevos, vainilla, helado de vainilla'),
(50087656, 10, 'Mousse de Chocolate', true, 6.99, 'Mousse de Chocolate', 'Chocolate negro, huevos, azúcar, nata, gelatina'),
(50087657, 18, 'Pastel de Zanahoria', true, 8.99, 'Pastel de Zanahoria', 'Zanahoria, harina, azúcar, huevos, nueces, crema de queso'),
(50087658, 22, 'Helado de Chocolate', true, 6.49, 'Helado de Chocolate', 'Leche, cacao, azúcar, nata'),
(50087659, 25, 'Cheesecake de Mango', true, 10.49, 'Cheesecake de Mango', 'Mango, queso crema, azúcar, huevos, galleta'),
(50087660, 14, 'Tiramisú', false, 9.49, 'Tiramisú', 'Café, licor de café, mascarpone, huevos, cacao en polvo'),
(50087661, 12, 'Flan de Caramelo', false, 7.99, 'Flan de Caramelo', 'Leche, huevos, azúcar, vainilla, caramelo líquido'),
(50087662, 16, 'Coulant de Chocolate', false, 11.99, 'Coulant de Chocolate', 'Chocolate negro, mantequilla, azúcar, huevos, harina'),
(50087663, 20, 'Tarta de Manzana', true, 7.99, 'Tarta de Manzana', 'Manzana, harina, azúcar, mantequilla, canela'),
(50087664, 28, 'Gelatina de Frutas', true, 5.99, 'Gelatina de Frutas', 'Gelatina en polvo, frutas variadas, agua'),
(50087665, 30, 'Crema Catalana', true, 8.49, 'Crema Catalana', 'Leche, azúcar, yema de huevo, canela, maicena'),
(50087666, 10, 'Natillas', false, 6.99, 'Natillas', 'Leche, azúcar, yema de huevo, canela, vainilla'),
(50087667, 8, 'Cupcakes de Vainilla', false, 7.49, 'Cupcakes de Vainilla', 'Harina, azúcar, mantequilla, huevos, vainilla, frosting'),
(50087668, 15, 'Soufflé de Frambuesa', false, 12.99, 'Soufflé de Frambuesa', 'Frambuesas, claras de huevo, azúcar, harina'),
(50087669, 25, 'Helado de Limón', true, 6.49, 'Helado de Limón', 'Limón, azúcar, nata, agua'),
(50087670, 22, 'Pudin de Pan', true, 8.99, 'Pudin de Pan', 'Pan duro, leche, huevos, azúcar, pasas'),
(50087671, 18, 'Bizcocho de Almendras', true, 7.99, 'Bizcocho de Almendras', 'Almendras molidas, harina, azúcar, huevos'),
(50087672, 14, 'Mouse de Frutos Rojos', false, 10.49, 'Mouse de Frutos Rojos', 'Frutos rojos, azúcar, gelatina, nata'),
(50087673, 16, 'Tarta de Limón', false, 9.99, 'Tarta de Limón', 'Limón, azúcar, huevos, mantequilla, galleta'),
(50087674, 20, 'Crepes de Nutella', false, 8.49, 'Crepes de Nutella', 'Harina, leche, huevos, Nutella'),
(50087675, 22, 'Gofres', true, 6.99, 'Gofres', 'Harina, azúcar, huevos, leche, mantequilla'),
(50087676, 24, 'Panna Cotta', true, 9.49, 'Panna Cotta', 'Nata, azúcar, gelatina, vainilla'),
(50087677, 5, 'Pay de Limón', true, 10.99, 'Pay de Limón', 'Limón, azucar, leche condensada, galletas');

-- Inserts para productos de la categoría "Extras" (ID de categoría: 600)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(60098765, 10, 'Porción Extra de Guacamole', true, 3.49, 'Porción Extra de Guacamole', 'Aguacate, tomate, cebolla, cilantro, limón'),
(60098766, 5, 'Cesta de Pan Artesanal', true, 4.99, 'Cesta de Pan Artesanal', 'Variedad de panes artesanales recién horneados'),
(60098767, 8, 'Salsa Adicional Picante', true, 1.99, 'Salsa Adicional Picante', 'Chiles, tomate, cebolla, ajo, cilantro'),
(60098768, 12, 'Queso Fundido', true, 6.99, 'Queso Fundido', 'Queso derretido, chorizo, jalapeños'),
(60098769, 15, 'Papas Fritas con Queso y Tocino', true, 8.49, 'Papas Fritas con Queso y Tocino', 'Papas fritas, queso cheddar fundido, tocino crujiente'),
(60098770, 20, 'Nachos con Carne y Queso', true, 9.99, 'Nachos con Carne y Queso', 'Nachos de maíz, carne molida, queso cheddar fundido'),
(60098771, 8, 'Ensalada de Frutas', false, 5.99, 'Ensalada de Frutas', 'Variedad de frutas frescas picadas'),
(60098772, 10, 'Papas Gajo con Queso y Guacamole', false, 7.99, 'Papas Gajo con Queso y Guacamole', 'Papas gajo, queso cheddar fundido, guacamole'),
(60098773, 6, 'Palomitas de Maíz', false, 3.99, 'Palomitas de Maíz', 'Maíz reventado, mantequilla, sal'),
(60098774, 18, 'Aros de Cebolla Crujientes', true, 6.49, 'Aros de Cebolla Crujientes', 'Cebolla, harina, huevo, pan rallado'),
(60098775, 22, 'Alitas de Pollo Picantes', true, 10.99, 'Alitas de Pollo Picantes', 'Alitas de pollo, salsa picante, miel'),
(60098776, 25, 'Rollitos de Primavera Vegetarianos', true, 7.99, 'Rollitos de Primavera Vegetarianos', 'Vegetales, fideos de arroz, salsa de soja'),
(60098777, 9, 'Chips de Yuca', false, 4.99, 'Chips de Yuca', 'Yuca, aceite vegetal, sal'),
(60098778, 11, 'Hummus de Betabel', false, 6.49, 'Hummus de Betabel', 'Betabel, garbanzos, tahini, limón'),
(60098779, 7, 'Ensalada de Alcachofa', false, 8.99, 'Ensalada de Alcachofa', 'Alcachofa, tomate cherry, queso feta, vinagreta'),
(60098780, 20, 'Tostadas de Chorizo', true, 8.99, 'Tostadas de Chorizo', 'Chorizo, frijoles refritos, crema, queso fresco'),
(60098781, 15, 'Palitos de Queso Empanizados', true, 7.49, 'Palitos de Queso Empanizados', 'Queso mozzarella, pan rallado, huevo'),
(60098782, 18, 'Guacamole y Totopos', true, 5.99, 'Guacamole y Totopos', 'Aguacate, tomate, cebolla, limón, totopos'),
(60098783, 6, 'Tiras de Pollo Empanizadas', false, 9.99, 'Tiras de Pollo Empanizadas', 'Pechuga de pollo, pan rallado, huevo, especias'),
(60098784, 9, 'Dip de Espinacas', false, 7.99, 'Dip de Espinacas', 'Espinacas, queso crema, crema agria, cebolla, ajo'),
(60098785, 12, 'Palitos de Zanahoria y Apio con Hummus', false, 6.99, 'Palitos de Zanahoria y Apio con Hummus', 'Zanahoria, apio, hummus');



-- Inserts para los empleados
INSERT INTO "EMPLEADO" (rfc, "numEmp", "fotoEmp", "nomPilaEmp", "apPatEmp", "apMatEmp", "fecNacEmp", sueldo, edad, "estadoEmp", "calleEmp", "codPosEmp", "colEmp", "numExt", "numInt") VALUES
('ABC1234567890', 1,  decode('FFD8FFE0', 'hex'), 'Juan', 'Pérez', 'López', '1980-05-10', 30000.00, 43,'México', 'Av. Siempre Viva', '07500', 'Centro', 100, 10),
('DEF1234567890', 2,  decode('FFD8FFE0', 'hex'), 'Ana', 'Martínez', 'García', '1992-11-23', 25000.00, 31,'México', 'Calle Luna', '08400', 'Industrial', 101, NULL),
('GHI1234567890', 3,  decode('FFD8FFE0', 'hex'), 'Luis', 'Hernández', NULL, '1975-02-15', 28000.00, 49,'México', 'Calle Sol', '03200', 'Jardines', 102, 20),
('JKL1234567890', 4,  decode('FFD8FFE0', 'hex'), 'Carlos', 'Navarro', 'Ruiz', '1988-08-12', 32000.00, 35,'México', 'Avenida Norte', '01010', 'Reforma', 103, 30),
('MNO1234567890', 5,  decode('FFD8FFE0', 'hex'), 'Isabel', 'Mendoza', NULL, '1990-03-25', 27000.00, 33,'México', 'Calle Oeste', '02220', 'Norte', 104, NULL),
('PQR1234567890', 6,  decode('FFD8FFE0', 'hex'), 'Sofía', 'Castro', 'Fernández', '1984-07-19', 29000.00, 39,'México', 'Calle Este', '07700', 'Este', 105, 15),
('STU1234567890', 7,  decode('FFD8FFE0', 'hex'), 'Marco', 'Díaz', 'Moreno', '1979-12-05', 31000.00, 44,'México', 'Avenida Central', '01180', 'Centro Sur', 106, 25),
('VWX1234567890', 8,  decode('FFD8FFE0', 'hex'), 'Patricia', 'Jiménez', NULL, '1995-04-20', 26000.00, 29,'México', 'Calle Sur', '03900', 'Sur', 107, NULL),
('YZA1234567890', 9,  decode('FFD8FFE0', 'hex'), 'Ernesto', 'Vega', 'Pérez', '1981-09-30', 28000.00, 42,'México', 'Boulevard Este', '02700', 'Este Alto', 108, 5),
('BCD2345678901', 10, decode('FFD8FFE0', 'hex'), 'Mónica', 'Lara', 'Mora', '1978-01-29', 29500.00, 46,'México', 'Calle Norte', '07000', 'Noroeste', 109, NULL),
('EFG2345678901', 11, decode('FFD8FFE0', 'hex'), 'Roberto', 'Álvarez', NULL, '1993-05-15', 25500.00, 30,'México', 'Avenida Sur', '08000', 'Suroeste', 110, 22),
('HIJ2345678901', 12, decode('FFD8FFE0', 'hex'), 'Claudia', 'Ortiz', 'Ramírez', '1985-03-22', 27500.00, 38,'México', 'Callejón Diagonal', '05000', 'Este Sur', 111, 12),
('KLM2345678901', 13, decode('FFD8FFE0', 'hex'), 'Raúl', 'González', 'López', '1991-07-14', 26500.00, 32,'México', 'Avenida Oeste', '04500', 'Oeste', 112, 7),
('NOP2345678901', 14, decode('FFD8FFE0', 'hex'), 'Verónica', 'Ruiz', NULL, '1987-11-11', 30500.00, 36,'México', 'Paseo Colón', '01500', 'Colonial', 113, 18),
('QRS2345678901', 15, decode('FFD8FFE0', 'hex'), 'Jorge', 'Mora', 'Castillo', '1983-02-28', 31200.00, 41,'Oaxaca', 'Circuito Interior', '03500', 'Central', 114, 2),
('TUV2345678901', 16, decode('FFD8FFE0', 'hex'), 'Elena', 'Campos', 'Guerrero', '1994-12-08', 24700.00, 29,'México', 'Camino Viejo', '06000', 'Antiguo', 115, NULL),
('WXY2345678901', 17, decode('FFD8FFE0', 'hex'), 'Daniel', 'Sánchez', 'Méndez', '1989-06-10', 29200.00, 34,'México', 'Ruta 20', '07520', 'Nuevo', 116, 8),
('ZAB3456789012', 18, decode('FFD8FFE0', 'hex'), 'Irene', 'Torres', NULL, '1976-10-30', 28700.00, 47,'México', 'Avenida Revolución', '06600', 'Revolucionario', 117, NULL),
('CDE3456789012', 19, decode('FFD8FFE0', 'hex'), 'Fernando', 'Nieto', 'Vidal', '1990-02-14', 26000.00, 33,'México', 'Calle Revuelta', '08040', 'Barrio Alto', 118, 9),
('FGH3456789012', 20, decode('FFD8FFE0', 'hex'), 'Laura', 'Blanco', 'Contreras', '1991-05-20', 26500.00, 32,'México', 'Avenida de los Árboles', '04000', 'Arbórea', 119, 21),
('BCD3456789012', 21, decode('FFD8FFE0', 'hex'), 'María', 'Guzmán', NULL, '1989-08-18', 29500.00, 32,'México', 'Calle de la Rosa', '07010', 'Rosa', 120, NULL),
('EFG3456789012', 22, decode('FFD8FFE0', 'hex'), 'Alejandro', 'Sosa', 'Hernández', '1992-02-10', 27500.00, 29,'México', 'Avenida del Sol', '08120', 'Solar', 121, 15),
('HIJ3456789012', 23, decode('FFD8FFE0', 'hex'), 'Natalia', 'Vargas', 'Paz', '1987-04-25', 30500.00, 34,'México', 'Calle de la Luna', '05130', 'Lunar', 122, NULL),
('KLM3456789012', 24, decode('FFD8FFE0', 'hex'), 'Hugo', 'Moreno', NULL, '1993-12-05', 28000.00, 28,'México', 'Boulevard de la Estrella', '04520', 'Estelar', 123, 11),
('NOP3456789012', 25, decode('FFD8FFE0', 'hex'), 'Paulina', 'Herrera', 'Gómez', '1984-06-15', 31200.00, 37,'México', 'Calle de los Pinos', '01600', 'Pinar', 124, NULL),
('QRS3456789012', 26, decode('FFD8FFE0', 'hex'), 'Arturo', 'Ramírez', NULL, '1990-10-20', 27000.00, 31,'México', 'Avenida del Río', '03600', 'Fluvial', 125, 18),
('TUV3456789012', 27, decode('FFD8FFE0', 'hex'), 'Diana', 'López', 'Ortega', '1983-03-30', 29500.00, 38,'México', 'Calle de las Flores', '06100', 'Floral', 126, NULL),
('WXY3456789012', 28, decode('FFD8FFE0', 'hex'), 'Eduardo', 'Cruz', NULL, '1981-05-08', 31000.00, 40,'México', 'Avenida de las Palmas', '07600', 'Palmario', 127, 20),
('ZAB4567890123', 29, decode('FFD8FFE0', 'hex'), 'Martha', 'Sánchez', 'Vega', '1986-11-12', 28200.00, 35,'México', 'Boulevard de los Cerezos', '06700', 'Cerezo', 128, NULL),
('CDE4567890123', 30, decode('FFD8FFE0', 'hex'), 'Ricardo', 'Mendoza', NULL, '1985-02-28', 29000.00, 36,'México', 'Calle del Águila', '08080', 'Aguilera', 129, 14),
('FGH4567890123', 31, decode('FFD8FFE0', 'hex'), 'Adriana', 'Ortega', 'Soto', '1994-04-15', 26000.00, 27,'México', 'Avenida de las Estrellas', '04100', 'Estelar', 130, NULL),
('IJK4567890123', 32, decode('FFD8FFE0', 'hex'), 'Martín', 'Gutiérrez', 'Cabrera', '1980-09-10', 32000.00, 41,'México', 'Calle de la Aurora', '02500', 'Auroral', 131, 17),
('LMN4567890123', 33, decode('FFD8FFE0', 'hex'), 'Sara', 'Campos', NULL, '1991-07-28', 27500.00, 30,'México', 'Avenida de los Pinos', '04200', 'Pinar', 132, 12),
('OPQ4567890123', 34, decode('FFD8FFE0', 'hex'), 'Javier', 'Reyes', 'Cervantes', '1987-03-22', 29000.00, 35,'México', 'Calle de la Playa', '07210', 'Costera', 133, 22),
('RST4567890123', 35, decode('FFD8FFE0', 'hex'), 'Silvia', 'Martínez', 'Sánchez', '1989-01-18', 30500.00, 32,'México', 'Avenida del Mar', '05500', 'Marítima', 134, NULL),
('TUV5678901234', 36, decode('FFD8FFE0', 'hex'), 'Héctor', 'Guerrero', NULL, '1993-12-10', 27000.00, 28,'México', 'Calle de la Montaña', '03120', 'Montañosa', 135, 16),
('VWX5678901234', 37, decode('FFD8FFE0', 'hex'), 'Laura', 'Ramos', 'León', '1985-08-25', 32000.00, 36,'México', 'Avenida del Trébol', '06780', 'Trebolera', 136, NULL),
('YZA5678901234', 38, decode('FFD8FFE0', 'hex'), 'Felipe', 'Vázquez', NULL, '1984-06-15', 28500.00, 37,'México', 'Calle de la Aurora', '02500', 'Auroral', 137, 19),
('BCD5678901234', 39, decode('FFD8FFE0', 'hex'), 'Monica', 'González', 'Luna', '1990-04-20', 30000.00, 31,'México', 'Avenida del Sol', '04100', 'Solar', 138, NULL),
('EFG5678901234', 40, decode('FFD8FFE0', 'hex'), 'Roberto', 'Hernández', NULL, '1981-11-30', 31000.00, 40,'México', 'Calle de la Luna', '06500', 'Lunar', 139, 13),
('HIJ5678901234', 41, decode('FFD8FFE0', 'hex'), 'María', 'Sánchez', 'García', '1995-03-12', 26000.00, 26,'México', 'Avenida del Bosque', '03000', 'Boscosa', 140, NULL),
('KLM5678901234', 42, decode('FFD8FFE0', 'hex'), 'Jorge', 'Pérez', 'López', '1983-09-02', 29500.00, 38,'México', 'Calle de la Palma', '07010', 'Palmario', 141, 21),
('NOP5678901234', 43, decode('FFD8FFE0', 'hex'), 'Ana', 'Martínez', NULL, '1992-07-20', 28200.00, 29,'México', 'Avenida del Lago', '08400', 'Lacustre', 142, 10),
('QRS5678901234', 44, decode('FFD8FFE0', 'hex'), 'Carlos', 'Soto', 'Guzmán', '1988-05-14', 31200.00, 33,'México', 'Calle de la Selva', '06300', 'Selvático', 143, NULL),
('TUV6789012345', 45, decode('FFD8FFE0', 'hex'), 'Laura', 'Hernández', NULL, '1987-02-28', 30500.00, 34,'México', 'Avenida del Bosque', '04500', 'Boscosa', 144, 18),
('VWX6789012345', 46, decode('FFD8FFE0', 'hex'), 'Miguel', 'González', 'Hernández', '1990-11-10', 28000.00, 31,'México', 'Calle del Mar', '07000', 'Marino', 145, NULL),
('YZA6789012345', 47, decode('FFD8FFE0', 'hex'), 'Sandra', 'Torres', NULL, '1994-09-18', 26500.00, 27,'México', 'Avenida del Sol', '08500', 'Solar', 146, 16),
('BCD6789012345', 48, decode('FFD8FFE0', 'hex'), 'Diego', 'Martínez', NULL, '1984-08-05', 29000.00, 38,'México', 'Calle de la Luna', '03000', 'Lunar', 147, NULL),
('EFG6789012345', 49, decode('FFD8FFE0', 'hex'), 'Verónica', 'Gómez', 'Martínez', '1989-06-23', 28500.00, 32,'México', 'Avenida del Bosque', '05000', 'Boscosa', 148, 13),
('HIJ6789012345', 50, decode('FFD8FFE0', 'hex'), 'Javier', 'Rodríguez', NULL, '1991-04-12', 30000.00, 30,'México', 'Calle de la Palma', '08010', 'Palmario', 149, NULL),
('KLM6789012345', 51, decode('FFD8FFE0', 'hex'), 'María', 'Pérez', 'González', '1982-01-20', 29500.00, 39,'México', 'Avenida del Lago', '06200', 'Lacustre', 150, 20),
('NOP6789012345', 52, decode('FFD8FFE0', 'hex'), 'Fernando', 'López', NULL, '1980-07-05', 31000.00, 41,'México', 'Calle del Mar', '07100', 'Marino', 151, 10),
('QRS6789012345', 53, decode('FFD8FFE0', 'hex'), 'Ana', 'Hernández', 'García', '1986-10-15', 28500.00, 35,'México', 'Avenida del Sol', '08200', 'Solar', 152, NULL),
('TUV7890123456', 54, decode('FFD8FFE0', 'hex'), 'Luis', 'Martínez', NULL, '1992-09-30', 26500.00, 29,'México', 'Calle de la Luna', '03600', 'Lunar', 153, 15),
('VWX7890123456', 55, decode('FFD8FFE0', 'hex'), 'Gabriela', 'Gómez', 'Pérez', '1987-12-18', 30500.00, 34,'México', 'Avenida del Bosque', '07500', 'Boscosa', 154, NULL),
('YZA7890123456', 56, decode('FFD8FFE0', 'hex'), 'Alejandro', 'Rodríguez', NULL, '1984-08-20', 29200.00, 37,'México', 'Calle del Mar', '08010', 'Marino', 155, 18),
('BCD7890123456', 57, decode('FFD8FFE0', 'hex'), 'Mónica', 'García', 'Hernández', '1991-03-10', 28000.00, 30,'México', 'Avenida del Lago', '06500', 'Lacustre', 156, NULL),
('EFG7890123456', 58, decode('FFD8FFE0', 'hex'), 'Ricardo', 'López', NULL, '1990-11-05', 31500.00, 31,'México', 'Calle del Sol', '07120', 'Solar', 157, 13),
('HIJ7890123456', 59, decode('FFD8FFE0', 'hex'), 'Sofía', 'Martínez', 'García', '1988-09-25', 30000.00, 33,'México', 'Avenida del Bosque', '08200', 'Boscosa', 158, NULL),
('KLM7890123456', 60, decode('FFD8FFE0', 'hex'), 'Héctor', 'González', NULL, '1983-07-15', 29000.00, 38,'México', 'Calle del Lago', '06600', 'Lacustre', 159, 20);

-- Inserts a Mesero
INSERT INTO "MESERO" ("rfcMsr", horario) VALUES
('ABC1234567890', '2024-05-02 08:00:00'),
('DEF1234567890', '2024-05-02 14:00:00'),
('GHI1234567890', '2024-05-02 16:00:00'),
('JKL1234567890', '2024-05-02 12:00:00'),
('MNO1234567890', '2024-05-02 20:00:00'),
('PQR1234567890', '2024-05-02 22:00:00'),
('STU1234567890', '2024-05-02 06:00:00'),
('VWX1234567890', '2024-05-02 18:00:00'),
('YZA5678901234', '2024-05-03 08:00:00'),
('BCD5678901234', '2024-05-03 14:00:00'),
('EFG5678901234', '2024-05-03 16:00:00'),
('HIJ5678901234', '2024-05-03 12:00:00'),
('KLM5678901234', '2024-05-03 20:00:00'),
('NOP5678901234', '2024-05-03 22:00:00'),
('QRS5678901234', '2024-05-03 06:00:00'),
('TUV7890123456', '2024-05-03 18:00:00');

-- Inserts a Cocinero
INSERT INTO "COCINERO" ("rfcCoc", especialidad) VALUES
('YZA1234567890', 'Mexicana'),
('BCD2345678901', 'Italiana'),
('EFG2345678901', 'Vegetariana'),
('HIJ2345678901', 'Asiática'),
('KLM2345678901', 'Repostería'),
('NOP2345678901', 'Carnes'),
('QRS2345678901', 'Mariscos'),
('TUV2345678901', 'Parrilla'),
('BCD3456789012', 'Pasta'),
('EFG3456789012', 'Ensaladas'),
('HIJ3456789012', 'Tapas'),
('KLM3456789012', 'Pizzas'),
('NOP3456789012', 'Cocina Internacional'),
('QRS3456789012', 'Comida Rápida');

-- Inserts a Administrativo
INSERT INTO "ADMINISTRATIVO" ("rfcAdm", rol) VALUES
('WXY2345678901', 'Finanzas'),
('ZAB3456789012', 'Compras'),
('CDE3456789012', 'Soporte Técnico'),
('FGH3456789012', 'Marketing'),
('IJK4567890123', 'Logística'),
('LMN4567890123', 'Atención al Cliente'),
('OPQ4567890123', 'Contabilidad'),
('RST4567890123', 'Calidad'),
('BCD5678901234', 'Operaciones'),
('EFG5678901234', 'Innovación Tecnológica'),
('HIJ5678901234', 'Desarrollo de Negocios'),
('KLM5678901234', 'Seguridad'),
('NOP5678901234', 'Comunicación Corporativa'),
('QRS5678901234', 'Servicio al Cliente');

-- Insert de Orden
INSERT INTO "ORDEN" ("cantTotPag", "fechaOrd", "rfcMsr", "idFac") VALUES 
(0, '2024-05-02 12:30:00', 'STU1234567890', '1'),
(0, '2024-05-02 12:50:00', 'STU1234567890', '2'),
(0, '2024-05-02 12:50:00', 'STU1234567890', NULL),
(0, '2024-05-02 13:20:00', 'VWX1234567890', NULL),
(0, '2024-05-02 14:15:00', 'ABC1234567890', NULL),
(0, '2024-05-02 15:30:00', 'DEF1234567890', '3'),
(0, '2024-05-02 16:45:00', 'GHI1234567890', NULL),
(0, '2024-05-02 17:10:00', 'JKL1234567890', NULL),
(0, '2024-05-02 18:25:00', 'MNO1234567890', NULL),
(0, '2024-05-02 19:40:00', 'PQR1234567890', NULL),
(0, '2024-05-02 20:55:00', 'STU1234567890', NULL),
(0, '2024-05-02 21:20:00', 'VWX1234567890', NULL),
(0, '2024-05-02 22:45:00', 'ABC1234567890', NULL),
(0, '2024-05-02 23:15:00', 'DEF1234567890', NULL),
(0, '2024-05-03 01:30:00', 'GHI1234567890', NULL),
(0, '2024-05-03 02:10:00', 'JKL1234567890', NULL),
(0, '2024-05-03 03:25:00', 'MNO1234567890', NULL),
(0, '2024-05-03 04:50:00', 'PQR1234567890', NULL),
(0, '2024-05-03 06:15:00', 'STU1234567890', NULL),
(0, '2024-05-03 07:40:00', 'VWX1234567890', NULL),
(0, '2024-05-03 08:55:00', 'ABC1234567890', NULL),
(0, '2024-05-03 09:20:00', 'DEF1234567890', NULL),
(0, '2024-05-03 10:35:00', 'GHI1234567890', NULL),
(0, '2024-05-03 11:10:00', 'JKL1234567890', NULL),
(0, '2024-05-03 12:25:00', 'MNO1234567890', NULL),
(0, '2024-05-03 13:40:00', 'PQR1234567890', NULL),
(0, '2024-05-03 14:55:00', 'STU1234567890', '4'),
(0, '2024-05-03 15:20:00', 'VWX1234567890', NULL),
(0, '2024-05-03 16:45:00', 'ABC1234567890', NULL),
(0, '2024-05-03 17:10:00', 'DEF1234567890', NULL),
(0, '2024-05-03 18:25:00', 'GHI1234567890', NULL),
(0, '2024-05-03 19:40:00', 'JKL1234567890', NULL),
(0, '2024-05-03 20:55:00', 'MNO1234567890', NULL),
(0, '2024-05-03 21:20:00', 'PQR1234567890', NULL),
(0, '2024-05-03 22:35:00', 'STU1234567890', NULL),
(0, '2024-05-03 23:50:00', 'VWX1234567890', NULL),
(0, '2024-05-04 01:05:00', 'ABC1234567890', NULL),
(0, '2024-05-04 02:20:00', 'DEF1234567890', NULL),
(0, '2024-05-04 03:35:00', 'GHI1234567890', NULL),
(0, '2024-05-04 04:50:00', 'JKL1234567890', NULL),
(0, '2024-05-04 06:05:00', 'MNO1234567890', NULL),
(0, '2024-05-04 07:20:00', 'PQR1234567890', NULL),
(0, '2024-05-04 08:35:00', 'STU1234567890', NULL),
(0, '2024-05-04 09:50:00', 'VWX1234567890', NULL),
(0, '2024-05-04 11:05:00', 'ABC1234567890', NULL),
(0, '2024-05-04 12:20:00', 'DEF1234567890', NULL),
(0, '2024-05-04 13:35:00', 'GHI1234567890', NULL),
(0, '2024-05-04 14:50:00', 'JKL1234567890', NULL),
(0, '2024-05-04 16:05:00', 'MNO1234567890', NULL),
(0, '2024-05-04 17:20:00', 'PQR1234567890', NULL),
(0, '2024-05-04 18:35:00', 'STU1234567890', NULL),
(0, '2024-05-04 19:50:00', 'VWX1234567890', NULL),
(0, '2024-05-04 21:05:00', 'ABC1234567890', NULL),
(0, '2024-05-04 22:20:00', 'DEF1234567890', NULL),
(0, '2024-05-04 23:35:00', 'GHI1234567890', NULL),
(0, '2024-05-05 00:50:00', 'JKL1234567890', NULL),
(0, '2024-05-05 02:05:00', 'MNO1234567890', NULL),
(0, '2024-05-05 03:20:00', 'PQR1234567890', NULL),
(0, '2024-05-05 04:35:00', 'STU1234567890', NULL),
(0, '2024-05-05 05:50:00', 'VWX1234567890', NULL),
(0, '2024-05-05 07:05:00', 'ABC1234567890', NULL),
(0, '2024-05-05 08:20:00', 'DEF1234567890', NULL),
(0, '2024-05-05 09:35:00', 'GHI1234567890', NULL),
(0, '2024-05-05 10:50:00', 'JKL1234567890', NULL),
(0, '2024-05-05 12:05:00', 'MNO1234567890', NULL),
(0, '2024-05-05 13:20:00', 'PQR1234567890', NULL),
(0, '2024-05-05 14:35:00', 'STU1234567890', NULL),
(0, '2024-05-05 15:50:00', 'VWX1234567890', NULL),
(0, '2024-05-05 17:05:00', 'ABC1234567890', NULL),
(0, '2024-05-05 18:20:00', 'DEF1234567890', NULL),
(0, '2024-05-05 19:35:00', 'GHI1234567890', NULL),
(0, '2024-05-05 20:50:00', 'JKL1234567890', NULL),
(0, '2024-05-05 22:05:00', 'MNO1234567890', NULL),
(0, '2024-05-05 23:20:00', 'PQR1234567890', NULL),
(0, '2024-05-06 00:35:00', 'STU1234567890', NULL),
(0, '2024-05-06 01:50:00', 'VWX1234567890', NULL),
(0, '2024-05-06 03:05:00', 'ABC1234567890', NULL),
(0, '2024-05-06 04:20:00', 'DEF1234567890', '5'),
(0, '2024-05-06 05:35:00', 'GHI1234567890', NULL),
(0, '2024-05-06 06:50:00', 'JKL1234567890', NULL),
(0, '2024-05-06 08:05:00', 'MNO1234567890', NULL),
(0, '2024-05-06 09:20:00', 'PQR1234567890', NULL),
(0, '2024-05-06 10:35:00', 'STU1234567890', NULL),
(0, '2024-05-06 11:50:00', 'VWX1234567890', NULL),
(0, '2024-05-06 13:05:00', 'ABC1234567890', NULL),
(0, '2024-05-06 14:20:00', 'DEF1234567890', NULL),
(0, '2024-05-06 15:35:00', 'GHI1234567890', NULL),
(0, '2024-05-06 16:50:00', 'JKL1234567890', '6'),
(0, '2024-05-06 18:05:00', 'MNO1234567890', NULL),
(0, '2024-05-06 19:20:00', 'PQR1234567890', '7'),
(0, '2024-05-06 20:35:00', 'STU1234567890', NULL),
(0, '2024-05-06 21:50:00', 'VWX1234567890', NULL),
(0, '2024-05-06 23:05:00', 'ABC1234567890', '8'),
(0, '2024-05-06 00:20:00', 'DEF1234567890', NULL);

-- Insert en OrdenProd
INSERT INTO "ORDPROD" (folio, "idProducto", "detalleCnt") VALUES 
('ORD-0001', 40076543, 5),
('ORD-0002', 10032143, 4),
('ORD-0003', 10032143, 4),
('ORD-0002', 10032144, 7),
('ORD-0002', 20054323, 3),
('ORD-0003', 30065432, 10),
('ORD-0003', 30065434, 8),
('ORD-0003', 50087654, 6),
('ORD-0004', 60098765, 2),
('ORD-0015', 10032145, 5),
('ORD-0011', 40076544, 9),
('ORD-0012', 30065433, 1),
('ORD-0013', 20054322, 11),
('ORD-0014', 60098766, 3),
('ORD-0015', 50087655, 8),
('ORD-0016', 40076545, 6),
('ORD-0017', 20054321, 2),
('ORD-0018', 50087656, 4),
('ORD-0019', 10032144, 7),
('ORD-0020', 30065432, 5),
('ORD-0021', 50087654, 7),
('ORD-0022', 30065433, 3),
('ORD-0023', 10032145, 8),
('ORD-0024', 20054323, 4),
('ORD-0025', 40076544, 6),
('ORD-0026', 60098766, 2),
('ORD-0027', 50087655, 9),
('ORD-0028', 20054322, 11),
('ORD-0029', 40076543, 11),
('ORD-0030', 30065434, 8),
('ORD-0031', 10032143, 5),
('ORD-0032', 40076545, 6),
('ORD-0033', 20054321, 2),
('ORD-0034', 50087656, 4),
('ORD-0036', 30065432, 3),
('ORD-0037', 40076543, 7),
('ORD-0038', 10032144, 6),
('ORD-0039', 60098767, 8),
('ORD-0040', 30065433, 10),
('ORD-0040', 20054322, 2),
('ORD-0040', 50087654, 5),
('ORD-0040', 40076544, 6),
('ORD-0045', 10032143, 6),
('ORD-0046', 20054321, 9),
('ORD-0047', 60098767, 8),
('ORD-0048', 40076543, 7),
('ORD-0049', 10032144, 6),
('ORD-0050', 20054322, 2);

-- Insert en Factura
INSERT INTO "FACTURA" ("rfcClt", "nomPilaClt", "apPatClt", "apMatClt", "fechaNacClt", "emailClt", "rznSocial","estadoClt", "calleClt", "codPosClt", "colClt", "numExtClt") 
VALUES ('SIMA021010452', 'Andrés', 'Silverio', 'Martínez', '2002-10-11', 'kylosarrollo1234@gmail.com', 
'Razon social genérica','México', 'Olivos', '09840', 'San Abedúl', '2'),
('CASI121314453', 'Juan', 'Alberto', 'Pérez', '2000-01-21', 'wazaaaaa@gmail.com', 'Razon social genérica',
'México', 'Piedras', '00100', 'Calle Victoria', '15'),
('OMEGA87654321', 'María', 'Fernanda', 'Gómez', '1995-08-17', 'mfgomez@example.com', 'Razón Social Omega', 'México', 'Pinos', '07700', 'Santa Rosa', '20'),
('ZETA567812134', 'Alejandro', 'Hernández', 'López', '1988-03-05', 'alehdez@example.com', 'Razón Social Zeta', 'México', 'Reforma', '06080', 'Libertad', '35'),
('DELTA12345678', 'Laura', 'Sánchez', 'García', '1990-11-28', 'lsgarcia@example.com', 'Razón Social Delta', 'México', 'Juárez', '09020', 'Centro', '12'),
('BETA234567849', 'Carlos', 'Martínez', 'Ortiz', '1985-06-10', 'cmortiz@example.com', 'Razón Social Beta', 'México', 'Miraflores', '05500', 'Jardines', '8'),
('GAMMA34567890', 'Ana', 'González', 'Rodríguez', '1992-09-03', 'agrodriguez@example.com', 'Razón Social Gamma', 'México', 'Morelos', '07040', 'San Juan', '25'),
('EPSILON456781', 'José', 'López', 'Hernández', '1983-12-15', 'jolopez@example.com', 'Razón Social Epsilon', 'México', 'Hidalgo', '04030', 'Revolución', '18');

-- VISTAS
-- Para el producto con mas ventas
CREATE VIEW vistaProdMasVendido AS SELECT * FROM "PRODUCTO" WHERE "numVentas" = (SELECT MAX("numVentas") FROM "PRODUCTO");
SELECT * FROM vistaProdMasVendido; -- Validando la vista

-- Vista de factura
CREATE OR REPLACE VIEW vistaFactura AS SELECT 
o.folio, 
"cantTotPag", 
"fechaOrd", 
op."idProducto", 
"nomProd", 
"detalleCnt", 
"detallePrc", 
f."idFac", 
"rfcClt", 
"nomPilaClt", 
"apPatClt", 
"apMatClt", 
"fechaNacClt", 
"emailClt", 
"rznSocial", 
"calleClt", 
"codPosClt", 
"colClt", 
"numExtClt", 
"numIntClt" 
FROM "ORDEN" o
JOIN "ORDPROD" op ON o.folio = op.folio 
JOIN "PRODUCTO" p ON p."idProducto" = op."idProducto" 
RIGHT JOIN "FACTURA" f ON f."idFac" = o."idFac" 
WHERE f."idFac" = (SELECT MAX("idFac") FROM "FACTURA");

-- Para ver la vista:
SELECT * FROM vistaFactura;

/*
DROP TABLE "ADMINISTRATIVO" CASCADE;
DROP TABLE "CATEGORIA" CASCADE;
DROP TABLE "COBORD" CASCADE;
DROP TABLE "COCINERO" CASCADE;
DROP TABLE "DEPENDIENTE" CASCADE;
DROP TABLE "EMPLEADO" CASCADE;
DROP TABLE "FACTURA" CASCADE;
DROP TABLE "MESERO" CASCADE;
DROP TABLE "ORDEN" CASCADE;
DROP TABLE "ORDPROD" CASCADE;
DROP TABLE "PRODUCTO" CASCADE;
DROP TABLE "TELEFONO" CASCADE;
DROP SEQUENCE ordenfoliosec;
*/


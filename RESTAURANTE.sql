
SET check_function_bodies = false;

CREATE TABLE "ADMINISTRATIVO"(
  "rfcAdm" char(12) NOT NULL,
  rol varchar(100) NOT NULL,
  CONSTRAINT "ADMINISTRATIVO_pkey" PRIMARY KEY("rfcAdm")
);
CREATE TABLE "CATEGORIA"(
  "idCat" smallint NOT NULL,
  "nombreCat" varchar(100) NOT NULL,
  "desCat" text NOT NULL,
  CONSTRAINT "CATEGORIA_pkey" PRIMARY KEY("idCat")
);

CREATE TABLE "COBORD"(
  rfc char(13) NOT NULL,
  folio varchar(20) NOT NULL,
  CONSTRAINT "COBORD_pkey" PRIMARY KEY(rfc, folio)
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
  "calleEmp" varchar(100) NOT NULL,
  "codPosEmp" char(5) NOT NULL,
  "colEmp" varchar(100) NOT NULL,
  "numExt" smallint NOT NULL,
  "numInt" smallint,
  CONSTRAINT "EMPLEADO_pkey" PRIMARY KEY(rfc)
);
COMMENT ON COLUMN "EMPLEADO".edad IS 'Calculado de fecNacEmp';

-- Comando necesario para usar la generacion de UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT * FROM "FACTURA";

CREATE TABLE "FACTURA"(
  "idFac" uuid NOT NULL,
  "rfcClt" char(13) NOT NULL,
  "nomPilaClt" varchar(100) NOT NULL,
  "apPatClt" varchar(100) NOT NULL,
  "apMatClt" varchar(100),
  "fechaNacClt" date NOT NULL,
  "emailClt" varchar(100) NOT NULL,
  "rznSocial" text NOT NULL,
  "calleClt" varchar(200) NOT NULL,
  "codPosClt" varchar(7) NOT NULL,
  "colClt" varchar(100) NOT NULL,
  "numExtClt" smallint NOT NULL,
  "numIntClt" smallint,
  CONSTRAINT "FACTURA_pkey" PRIMARY KEY("idFac")
);
CREATE TABLE "MESERO"(
  "rfcMsr" char(13) NOT NULL,
  horario timestamp NOT NULL,
  CONSTRAINT "MESERO_pkey" PRIMARY KEY("rfcMsr")
);
CREATE TABLE "ORDEN"(
  folio varchar(20) NOT NULL,
  "cantTotPag" smallint NOT NULL,
  "fechaOrd" timestamp NOT NULL,
  "rfcMsr" char(13) NOT NULL,
  "idFac" integer,
  CONSTRAINT "ORDEN_pkey" PRIMARY KEY(folio),
  CONSTRAINT "ORDEN_idFac_key" UNIQUE("idFac")
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
  "idCat" smallint GENERATED ALWAYS AS (idProducto / 100000) STORED,
  CONSTRAINT "PRODUCTO_pkey" PRIMARY KEY("idProducto")
);

CREATE TABLE "TELEFONO"(
  "rfcTel" char(13) NOT NULL,
  telefono bigint NOT NULL,
  CONSTRAINT "TELEFONO_pkey" PRIMARY KEY("rfcTel")
);

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

SELECT * FROM "CATEGORIA";
-- Insertar una nueva categoría
INSERT INTO "CATEGORIA" ("idCat", "nombreCat", "desCat") 
VALUES 
(100, 'Aperitivos y Entradas', 'Variedad de pequeños platos que tienen lugar antes de la comida principal. Diseñados para abrir el apetito del comensal. Pueden variar según el tipo de cocina o del restaurante mismo, puede incluir amplia cantidad de alimentos como canapés, ensaladas, tapas, sopas, o hasta platos de mariscos, carnes y quesos'),
(200, 'Plato Fuerte', 'Variedad de platos principales que incluye una amplia gama de alimentos desde carnes rojas, aves, pescados, o platos vegetarianos. Los platos fuertes suelen ir acompañados de nua guarnicion como veerdueas, pastas, arroces entre otros. Los platos fuertes son generalmente el centro de la comida en el que los chefs y cocineros suelen crear grandes platos y visualmente atractivos'),
(300, 'Bebidas', 'Incluye una amplia gama de opciones como agua, refrescos, jugos naturales, tés, cafés, batidos, y más. Además tambien hay bebidas especiales como limonadas caseras, tés de hierbas, o batidos de frutas.'),
(400, 'Bebidas Alcohólicas y Cocteles', 'Puede abarcar desde cervezas, vinos cocteles y licores. Los cocteless son bebidas especiales preparadas con algunos jarabes o jugos de fruta para un sabor mas dulce o neutro para acompañar la comida'),
(500, 'Postres', 'Variedad de alimentos dulces que tienen ligar al final de una comida. Los postres pueden incluir una amplia gama de alimentos como pasteles, tartas, helados, flanes, galletas, brownies, mousses, pudines, frutas frescas y más.Los postres son a menudo la culminación de la experiencia culinaria, proporcionando un final dulce y satisfactorio a la comida. Pueden variar en complejidad, desde simples frutas frescas hasta elaboradas creaciones de repostería.'),
(600, 'Extras', 'Referente a servicios adicionales: órdenes extra de pan, de crema, tortillas, salsas etc');

SELECT * FROM "PRODUCTO";

-- Inserts para productos de la categoría "Aperitivos y Entradas" (ID de categoría: 100)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(10032143, 10, 'Canapés de salmón ahumado', true, 12.99, 'Canapés de salmón ahumado', 'Salmón ahumado, pan tostado, queso crema, eneldo'),
(10032144, 15, 'Ensalada Caprese', true, 8.99, 'Ensalada Caprese', 'Tomate, mozzarella fresca, albahaca, aceite de oliva'),
(10032145, 20, 'Patatas Bravas', true, 7.99, 'Patatas Bravas', 'Patatas fritas, salsa brava, alioli');

-- Inserts para productos de la categoría "Plato Fuerte" (ID de categoría: 200)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(20054321, 30, 'Filete de Ternera al Grill', true, 24.99, 'Filete de Ternera al Grill', 'Filete de ternera, sal, pimienta, aceite de oliva'),
(20054322, 25, 'Salmón a la Parrilla', true, 22.99, 'Salmón a la Parrilla', 'Filete de salmón, limón, aceite de oliva, hierbas frescas'),
(20054323, 20, 'Risotto de Champiñones', true, 18.99, 'Risotto de Champiñones', 'Arroz arborio, caldo de verduras, champiñones, queso parmesano');

-- Inserts para productos de la categoría "Bebidas" (ID de categoría: 300)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(30065432, 40, 'Limonada Natural', true, 4.99, 'Limonada Natural', 'Limón, agua, azúcar, hielo'),
(30065433, 35, 'Jugo de Naranja Fresco', true, 4.49, 'Jugo de Naranja Fresco', 'Naranjas frescas exprimidas'),
(30065434, 45, 'Té Helado de Frutos Rojos', true, 5.49, 'Té Helado de Frutos Rojos', 'Té negro, frutos rojos, azúcar');

-- Inserts para productos de la categoría "Bebidas Alcohólicas y Cocteles" (ID de categoría: 400)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(40076543, 30, 'Margarita', true, 8.99, 'Margarita', 'Tequila, licor de naranja, jugo de limón, azúcar'),
(40076544, 25, 'Mojito', true, 9.49, 'Mojito', 'Ron blanco, menta fresca, lima, azúcar, soda'),
(40076545, 20, 'Piña Colada', true, 7.99, 'Piña Colada', 'Ron blanco, crema de coco, jugo de piña, hielo');

-- Inserts para productos de la categoría "Postres" (ID de categoría: 500)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(50087654, 20, 'Tarta de Queso con Frutos Rojos', true, 9.99, 'Tarta de Queso con Frutos Rojos', 'Queso crema, azúcar, huevos, frutos rojos, galleta'),
(50087655, 15, 'Brownie con Helado de Vainilla', true, 7.99, 'Brownie con Helado de Vainilla', 'Chocolate, mantequilla, azúcar, huevos, vainilla, helado de vainilla'),
(50087656, 10, 'Mousse de Chocolate', true, 6.99, 'Mousse de Chocolate', 'Chocolate negro, huevos, azúcar, nata, gelatina');

-- Inserts para productos de la categoría "Extras" (ID de categoría: 600)
INSERT INTO "PRODUCTO" ("idProducto", "numVentas", "descProd", disponibilidad, precio, "nomProd", receta)
VALUES 
(60098765, 10, 'Porción Extra de Guacamole', true, 3.49, 'Porción Extra de Guacamole', 'Aguacate, tomate, cebolla, cilantro, limón'),
(60098766, 5, 'Cesta de Pan Artesanal', true, 4.99, 'Cesta de Pan Artesanal', 'Variedad de panes artesanales recién horneados'),
(60098767, 8, 'Salsa Adicional Picante', true, 1.99, 'Salsa Adicional Picante', 'Chiles, tomate, cebolla, ajo, cilantro');

---------------------------------------------------------------------------


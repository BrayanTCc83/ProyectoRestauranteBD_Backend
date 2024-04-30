SET check_function_bodies = false
;

CREATE TABLE "ADMINISTRATIVO"(
"rfcAdm" char(12) NOT NULL, rol varchar(100) NOT NULL,
  CONSTRAINT "ADMINISTRATIVO_pkey" PRIMARY KEY("rfcAdm")
);

CREATE TABLE "CATEGORIA"(
  "idCat" integer NOT NULL,
  "nombreCat" varchar(100) NOT NULL,
  "desCat" text NOT NULL,
  CONSTRAINT "CATEGORIA_pkey" PRIMARY KEY("idCat")
);

CREATE TABLE "COBORD"(
rfc char(13) NOT NULL, folio varchar(20) NOT NULL,
  CONSTRAINT "COBORD_pkey" PRIMARY KEY(rfc, folio)
);

CREATE TABLE "COCINERO"(
"rfcCoc" char(13) NOT NULL, especialidad text NOT NULL,
  CONSTRAINT "COCINERO_pkey" PRIMARY KEY("rfcCoc")
);

CREATE TABLE "DEPENDIENTE"(
  rfc char(13) NOT NULL,
  curp char(18) NOT NULL,
  "nomPilaDep " varchar(100) NOT NULL,
  "apPatDep" varchar(100) NOT NULL,
  "apMatDep" varchar(100),
  "parentesCo" varchar(100) NOT NULL
);

CREATE TABLE "EMPLEADO"(
  rfc char(13) NOT NULL,
  "numEmp" integer NOT NULL,
  "fotoEmp" varbit NOT NULL,
  "nomPilaEmp" varchar(100) NOT NULL,
  "apPatEmp" varchar(100) NOT NULL,
  "apMatEmp" varchar(100),
  "fecNacEmp" date NOT NULL,
  sueldo float8(5) NOT NULL,
  edad numeric(2) NOT NULL,
  "calleEmp" varchar(100) NOT NULL,
  "codPosEmp" char(5) NOT NULL,
  "colEmp" varchar(100) NOT NULL,
  "numExt" smallint NOT NULL,
  "numInt" smallint,
  CONSTRAINT "EMPLEADO_pkey" PRIMARY KEY(rfc)
);

COMMENT ON COLUMN "EMPLEADO".edad IS 'Calculado de fecNacEmp';

CREATE TABLE "FACTURA"(
  "idFac" integer NOT NULL,
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
"rfcMsr" char(13) NOT NULL, horario timestamp NOT NULL,
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
  "idProducto" smallint NOT NULL,
  "detalleCnt" smallint NOT NULL,
  "detallePrc" numeric(10,2) NOT NULL,
  CONSTRAINT "ORDPROD_pkey" PRIMARY KEY(folio, "idProducto")
);

CREATE TABLE "PRODUCTO"(
  "idProducto" integer NOT NULL,
  "numVentas" integer NOT NULL,
  "descProd" text NOT NULL,
  disponibilidad boolean NOT NULL,
  precio numeric(10,2) NOT NULL,
  "nomProd" varchar(100) NOT NULL,
  receta text NOT NULL,
  "idCat" smallint NOT NULL,
  CONSTRAINT "PRODUCTO_pkey" PRIMARY KEY("idProducto"),
  CONSTRAINT "PRODUCTO_key" UNIQUE("idCat")
);

CREATE TABLE "TELEFONO"(
"rfcTel" char(13) NOT NULL, telefono integer NOT NULL,
  CONSTRAINT "TELEFONO_pkey" PRIMARY KEY("rfcTel")
);

ALTER TABLE "ADMINISTRATIVO"
  ADD CONSTRAINT "ADMINISTRATIVO_rfcAdm_fkey"
    FOREIGN KEY ("rfcAdm") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "CATEGORIA"
  ADD CONSTRAINT "CATEGORIA_idCat_fkey"
    FOREIGN KEY ("idCat") REFERENCES "PRODUCTO" ("idCat");

ALTER TABLE "COBORD"
  ADD CONSTRAINT "COBORD_folio_fkey"
    FOREIGN KEY (folio) REFERENCES "ORDEN" (folio);

ALTER TABLE "COBORD"
  ADD CONSTRAINT "COBORD_rfc_fkey" FOREIGN KEY (rfc) REFERENCES "EMPLEADO" (rfc)
  ;

ALTER TABLE "COCINERO"
  ADD CONSTRAINT "COCINERO_rfcCoc_fkey"
    FOREIGN KEY ("rfcCoc") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "DEPENDIENTE"
  ADD CONSTRAINT "DEPENDIENTE_rfc_fkey"
    FOREIGN KEY (rfc) REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "FACTURA"
  ADD CONSTRAINT "FACTURA_idFac_fkey"
    FOREIGN KEY ("idFac") REFERENCES "ORDEN" ("idFac");

ALTER TABLE "MESERO"
  ADD CONSTRAINT "MESERO_rfcMsr_fkey"
    FOREIGN KEY ("rfcMsr") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "ORDEN"
  ADD CONSTRAINT "ORDEN_rfcMsr_fkey"
    FOREIGN KEY ("rfcMsr") REFERENCES "EMPLEADO" (rfc);

ALTER TABLE "ORDPROD"
  ADD CONSTRAINT "ORDPROD_folio_fkey"
    FOREIGN KEY (folio) REFERENCES "ORDEN" (folio);

ALTER TABLE "ORDPROD"
  ADD CONSTRAINT "ORDPROD_idProducto_fkey"
    FOREIGN KEY ("idProducto") REFERENCES "PRODUCTO" ("idProducto");

ALTER TABLE "TELEFONO"
  ADD CONSTRAINT "TELEFONO_rfcTel_fkey"
    FOREIGN KEY ("rfcTel") REFERENCES "EMPLEADO" (rfc);

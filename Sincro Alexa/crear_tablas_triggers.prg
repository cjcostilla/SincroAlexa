* Crea Tabla Auditoria

CREATE TABLE Auditoria (
    ID I(4),
    TABLA CHAR(50),
    OPERACION CHAR(10),
    CAMPOS MEMO,
    FECHA DATETIME,
    PROCESADO LOGICAL
)

* Crea los TRIGGERS para las tablas en cuestion

CREATE TRIGGER ON articulo_univoco1 FOR INSERT AS SincroInsert()
CREATE TRIGGER ON articulo_univoco1 FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON articulo_univoco1 FOR DELETE AS SincroDelete()

CREATE TRIGGER ON depósitos FOR INSERT AS SincroInsert()
CREATE TRIGGER ON depósitos FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON depósitos FOR DELETE AS SincroDelete()

CREATE TRIGGER ON empleados_cliente FOR INSERT AS SincroInsert()
CREATE TRIGGER ON empleados_cliente FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON empleados_cliente FOR DELETE AS SincroDelete()

CREATE TRIGGER ON clientes FOR INSERT AS SincroInsert()
CREATE TRIGGER ON clientes FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON clientes FOR DELETE AS SincroDelete()

CREATE TRIGGER ON unidadmedida FOR INSERT AS SincroInsert()
CREATE TRIGGER ON unidadmedida FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON unidadmedida FOR DELETE AS SincroDelete()

CREATE TRIGGER ON rubro FOR INSERT AS SincroInsert()
CREATE TRIGGER ON rubro FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON rubro FOR DELETE AS SincroDelete()

CREATE TRIGGER ON subrubro FOR INSERT AS SincroInsert()
CREATE TRIGGER ON subrubro FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON subrubro FOR DELETE AS SincroDelete()

CREATE TRIGGER ON unidadmedida FOR INSERT AS SincroInsert()
CREATE TRIGGER ON unidadmedida FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON unidadmedida FOR DELETE AS SincroDelete()

CREATE TRIGGER ON colores FOR INSERT AS SincroInsert()
CREATE TRIGGER ON colores FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON colores FOR DELETE AS SincroDelete()

CREATE TRIGGER ON stock1 FOR INSERT AS SincroInsert()
CREATE TRIGGER ON stock1 FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON stock1 FOR DELETE AS SincroDelete()

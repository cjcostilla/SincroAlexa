CREATE TABLE dep�sitos (;
    NUM I(4),;
    NOMBRE CHAR(50),;
    DIRECCION CHAR(200),;
    TIPO CHAR(30),;
    PREDET1 LOGICAL,;
    PREDET2 LOGICAL,;
    PREDET3 LOGICAL,;
    IDDT DATETIME,;
    IDS I(4),;
    PROPIO I(4),;
    NUMPROP I(4),;
    PROPIET CHAR(50),;
    IDSQL I(4),;
    VERSION I(4),;
    IDGENERAL I(4),;
    IDCLIENTE I(4),;
    NOMBRE_CLIENTE CHAR(50),;
    ULTIMO_USADO LOGICAL,;
    TOTAL_ARTICULOS_EXISTENCIA I(4),;
    TOTAL_ARTICULOS I(4),;
    DEPOSITO_SUBDEPOSITO I(4),;
    NUMDEP_SUBDEPOSITO I(4),;
    NOMDEP_SUBDEPOSITO CHAR(50),;
    ACTIVO LOGICAL,;
    SET_DE_PRENDAS CHAR(50),;
    SET_PRENDAS_MINIMOS_Y_MAXIMOS CHAR(50),;
    NUN_EMPLEADO I(4),;
    CLASIFICACION I(4);
);
CREATE TRIGGER ON dep�sitos FOR INSERT AS SincroInsert()
CREATE TRIGGER ON dep�sitos FOR UPDATE AS SincroUpdate()
CREATE TRIGGER ON dep�sitos FOR DELETE AS SincroDelete()

SET LIBRARY TO mdb.prg ADDITIVE 
INSERT INTO dep�sitos VALUES (144, 'PLANTA -ROPA SUCIA', '', 'Art�culos para la venta', .T., .F., .F., {}, 150, 1, 0, '', 143, 0, 0, 0, '', .T., 0, 0, 1, 0, '', .F., '', '', 0, 2)
INSERT INTO dep�sitos VALUES (145, 'ALVEAR ICON', '', 'Art�culos para la venta', .T., .F., .F., {}, 151, 2, 0, '', 144, 0, 0, 106, 'ALVEAR ICON', .F., 0, 0, 1, 0, '', .F., '', '', 0, 1)
INSERT INTO dep�sitos VALUES (146, 'ALVEAR PALACE', '', 'Art�culos para la venta', .T., .F., .F., {}, 152, 2, 0, '', 145, 0, 0, 107, 'ALVEAR PALACE', .F., 0, 0, 1, 0, '', .F., '', '', 0, 1)
INSERT INTO dep�sitos VALUES (147, 'ALVEAR ART', '', 'Art�culos para la venta', .T., .F., .F., DATETIME(), 153, 2, 0, '', 146, 0, 0, 108, 'ALVEAR ART', .F., 0, 0, 1, 0, '', .F., '', '', 0, 1)
INSERT INTO dep�sitos VALUES (148, 'INOVA 1� PISO', '', 'Art�culos para la venta', .F., .F., .F., DATETIME(), 154, 2, 0, '', 147, 0, 0, 106, 'ALVEAR ICON', .F., 0, 0, 2, 145, 'HOTEL EJEMPLO', .F., '', '', 0, 12)
INSERT INTO dep�sitos VALUES (149, 'OPERADORA HOTELERA SA', '', 'Art�culos para la venta', .T., .F., .F., {}, 155, 2, 0, '', 148, 0, 0, 114, 'OPERADORA HOTELERA SA', .F., 0, 0, 1, 0, '', .F., '', '', 0, 1)
					
					




USE auditoria EXCLUSIVE 
ZAP
PACK
reindex
CLOSE TABLES all







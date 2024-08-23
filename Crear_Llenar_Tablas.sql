CREATE TABLE mapeo (
    TABLA_VFP CHAR(100),
    CAMPO_VFP CHAR(100),
    TABLA_MYSQL CHAR(100),
    CAMPO_MYSQL CHAR(100),
    CLAVE LOGICAL,
    PONER_VALOR CHAR(150),
    PONER_FUNCION CHAR(150)
);

INSERT INTO mapeo VALUES ('depósitos', 'num', 'abm_depositos', 'sincronizacion', .T., '', '')
INSERT INTO mapeo VALUES ('depósitos', 'nombre', 'abm_depositos', 'nombre', .F., '', '')
INSERT INTO mapeo VALUES ('depósitos', 'direccion', 'abm_depositos', 'domicilio', .F., '', '')
INSERT INTO mapeo VALUES ('depósitos', 'tipo', 'abm_depositos', 'descripcion', .F., '', '')
INSERT INTO mapeo VALUES ('depósitos', 'predet1', 'abm_depositos', 'predeterminado', .F., '', '')
INSERT INTO mapeo VALUES ('depósitos', 'propio', 'abm_depositos', 'id_abm_tipos_de_propietario', .F., '', '')
INSERT INTO mapeo VALUES ('depósitos', '', 'abm_depositos', 'version', .F., '', 'depósitos.version + 1')
INSERT INTO mapeo VALUES ('depósitos', 'idcliente', 'abm_depositos', 'id_abm_clientes', .F., '', '')
INSERT INTO mapeo VALUES ('depósitos', 'clasificacion', 'abm_depositos', 'clasificacion', .F., '', '')
INSERT INTO mapeo VALUES ('articulo_univoco1', 'serial', 'abm_articulo_univoco', 'serial', .F., '', '')

CREATE TABLE stock1 ( DEPOSITO CHAR(30), LISTA CHAR(30), SUBRUBRO CHAR(30),  RUBRO CHAR(30),;
    QTY NUMERIC(10,0),  CODIGO CHAR(20),  ITEM CHAR(15),  DETALLE CHAR(50),  UNMEDIDA CHAR(30),;
    COLOR CHAR(15),  SIZE CHAR(15), PROVEEDOR CHAR(50), PVENTA NUMERIC(10,2), PCOSTO NUMERIC(10,2),;
    IMPINTER NUMERIC(5,2),PERFIL CHAR(20), STMINIMO CHAR(5), STMAXIMO CHAR(5), CTACOMPRAS CHAR(40),;
    CCOSTOCPRA CHAR(40), CTAVENTAS CHAR(40), CCOSTOVTA CHAR(40), OBSERVAC MEMO, FTP DATE, IDDT DATETIME,;
    IDS I(4), NUM I(4), ROTACION I(4), IDSQL I(4), VERSION I(4), IDGENERAL I(4), IMAGEN MEMO, PESO_SECO NUMERIC(15,2),;
    PESO_SECO_ERROR NUMERIC(5,0), PESO_HUMEDO NUMERIC(15,2), PESO_HUMERO_ERROR NUMERIC(5,0))

INSERT INTO stock1 (DEPOSITO,;
					LISTA,;
					SUBRUBRO,;
					RUBRO,;
					QTY,;
					CODIGO,;
					ITEM,;
					DETALLE,;
					UNMEDIDA,;
					COLOR,;
					SIZE,;
					PROVEEDOR,;
					PVENTA,;
					PCOSTO,;
					IMPINTER,;
					PERFIL,;
					STMINIMO,;
					STMAXIMO,;
					CTACOMPRAS,;
					CCOSTOCPRA,;
					CTAVENTAS,;
					CCOSTOVTA,;
					OBSERVAC,;
					FTP,;
					IDDT,;
					ROTACION,;
					VERSION,;
					IDGENERAL,;
					IMAGEN,;
					PESO_SECO,;
					PESO_SECO_ERROR,;
					PESO_HUMEDO,;
					PESO_HUMERO_ERROR);
			VALUES ('',;
					'',;
					'VARIOS',;
					'VARIOS',;
					0,;
					'000',;
					'000',;
					'CHIP SIN ASIGNAR',;
					'',;
					'',;
					'',;
					'',;
					0,;
					0,;
					0,;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					'',;
					date(),;
					datetime(),;
					0,;
					1,;
					0,;
					'',;
					0,;
					0,;
					0,;
					0)


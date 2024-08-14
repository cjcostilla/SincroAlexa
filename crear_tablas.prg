CREATE DATABASE MiBaseDeDatos
modi DATABASE MiBaseDeDatos

CREATE TABLE MiTabla (ID I AUTOINC, Nombre C(50), Edad I)

CREATE TABLE Auditoria (ID I AUTOINC, Tabla C(50), IdTabla C(10), ;
						Operacion C(10), TipoDato C(10), Campos M,;
						ValorAntiguo C(200), ValorNuevo C(200),;
						Fecha T DEFAULT DATETIME(), Usuario C(50),procesado l DEFAULT .F.)
						
CREATE TABLE Mapeo (tabla_vfp C(50), ;
					campo_vfp C(50), ;
					tabla_mysql C(50), ;
					campo_mysql C(50),;
					clave L DEFAULT .F.)	

CREATE TRIGGER ON MiTabla FOR INSERT AS MiTablaInsert()
CREATE TRIGGER ON MiTabla FOR UPDATE AS MiTablaUpdate()
CREATE TRIGGER ON MiTabla FOR DELETE AS MiTablaDelete()

***** Table setup for RESULTADOS *****
CREATE TABLE 'RESULTADOS'  (CODIGO I, ;
                         RESULTADO C(80), ;
                         OBSERVACIONES C(254), ;
                         IDS I , ;
                         FECHAHORA T, ;
                         NUM I, ;
                         IMAGEN M)


***** Table setup for CONDVTA *****
CREATE TABLE 'CONDVTA'  (NUMERO N(5, 0), ;
                      DESCRIPCIO C(60), ;
                      FACTCRED L, ;
                      PORCTOTFAC C(2), ;
                      CUOTAS C(3), ;
                      LAPSO1 C(10), ;
                      LAPSO2 C(3), ;
                      PORCENT C(10), ;
                      CALCULO C(20), ;
                      FTP D DEFAULT DATE(), ;
                      IDDT T DEFAULT DATETIME(), ;
                      IDS I , ;
                      IDSQL I , ;
                      VERSION I DEFAULT 0, ;
                      IDGENERAL I)

***** Create each index for CONDVTA *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON DESCRIPCIO TAG DESCRIPCIO COLLATE 'MACHINE'

***** Table setup for ORDEN *****
CREATE TABLE 'ORDEN'  (ORDEN C(50), ;
                    FTP D DEFAULT DATE(), ;
                    IDDT T DEFAULT DATETIME(), ;
                    IDS I , ;
                    IDSQL I , ;
                    VERSION I DEFAULT 0, ;
                    IDGENERAL I)

***** Create each index for ORDEN *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'


***** Table setup for PROVEED *****
CREATE TABLE 'PROVEED'  (NUMERO N(5, 0), ;
                      NOMBRE C(30), ;
                      DOMICILIO C(30), ;
                      LOCALIDAD C(30), ;
                      CODPOST C(5), ;
                      PROVINCIA C(30), ;
                      EXIGEORD C(2), ;
                      TELEFONOS C(30), ;
                      FAX C(15), ;
                      EMAIL C(40), ;
                      CONTACTO C(30), ;
                      CARGO C(30), ;
                      NUMIVA C(20), ;
                      CUIT C(20), ;
                      NUMIB C(20), ;
                      CONDIVA C(30), ;
                      CONDCPRA C(30), ;
                      LIMCRED C(7), ;
                      CUENTA C(40), ;
                      OBSERVAC C(250), ;
                      SALDO N(10, 2), ;
                      NOMFANTASI C(30), ;
                      FTP D DEFAULT DATE(), ;
                      IDDT T DEFAULT DATETIME(), ;
                      IDS I , ;
                      IDSQL I , ;
                      VERSION I DEFAULT 0, ;
                      IDGENERAL I, ;
                      NUM_ARTICU I, ;
                      POLPRINSUM C(60), ;
                      POLPRPROD C(60), ;
                      POLPRSERV C(60))

***** Create each index for PROVEED *****
INDEX ON NUMERO TAG NUMERO CANDIDATE COLLATE 'MACHINE'
INDEX ON NOMFANTASI TAG WIZARD_1 COLLATE 'MACHINE'
INDEX ON NOMBRE TAG NOMBRE COLLATE 'MACHINE'
INDEX ON SALDO TAG SALDO COLLATE 'MACHINE'
INDEX ON TELEFONOS TAG TELEFONOS COLLATE 'MACHINE'
INDEX ON DOMICILIO TAG DOMICILIO COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON NUM_ARTICU TAG NUM_ARTICU COLLATE 'MACHINE'

***** Table setup for POLPRSERV2 *****
CREATE TABLE 'POLPRSERV2'  (NUM I, ;
                         ARTICSERV I, ;
                         NUMARTIC I, ;
                         NUMSERV I, ;
                         PROCESO C(30), ;
                         RUBRO C(30), ;
                         SUBRUBRO C(30), ;
                         CODIGO C(20), ;
                         DETALLE C(50), ;
                         PRECIO N(14, 4), ;
                         NUMLISTA I, ;
                         NOMLISTA C(40), ;
                         PROVEEDOR C(50), ;
                         IDSQL I , ;
                         VERSION I DEFAULT 0, ;
                         IDGENERAL I, ;
                         ACTIVO L, ;
                         PREDET L, ;
                         NOMBRELIST C(50), ;
                         REQUISICION C(10), ;
                         O_COMPRA C(10), ;
                         AUTORIZAC C(10), ;
                         ALIAS C(50), ;
                         ESCALAS N(2, 0), ;
                         DESDE_1 N(6, 0) DEFAULT 0, ;
                         PRECIO_1 N(14, 4) DEFAULT 0, ;
                         DESDE_2 N(6, 0) DEFAULT 0, ;
                         PRECIO_2 N(14, 4) DEFAULT 0, ;
                         DESDE_3 N(6, 0) DEFAULT 0, ;
                         PRECIO_3 N(14, 4) DEFAULT 0, ;
                         ORDEN_PRESENTACION N(5, 0), ;
                         ORDEN_IMPRESION N(4, 0), ;
                         LAPSO_ROTACION_MINIMO I, ;
                         LAPSO_ROTACION_MAXIMO I, ;
                         LISTA C(20))

***** Create each index for POLPRSERV2 *****
INDEX ON SUBRUBRO TAG SUBRUBRO COLLATE 'MACHINE'
INDEX ON RUBRO TAG RUBRO COLLATE 'MACHINE'
INDEX ON DETALLE TAG DETALLE COLLATE 'MACHINE'
INDEX ON CODIGO TAG CODIGO COLLATE 'MACHINE'
INDEX ON NUMARTIC TAG NUMARTIC COLLATE 'MACHINE'
INDEX ON NUMSERV TAG NUMSERV COLLATE 'MACHINE'
INDEX ON PROCESO TAG PROCESO COLLATE 'MACHINE'
INDEX ON ARTICSERV TAG ARTICSERV COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON PRECIO TAG PRECIO COLLATE 'MACHINE'
INDEX ON NOMLISTA TAG NOMLISTA COLLATE 'MACHINE'
INDEX ON NUMLISTA TAG NUMLISTA COLLATE 'MACHINE'
INDEX ON PROVEEDOR TAG PROVEEDOR COLLATE 'MACHINE'
INDEX ON ACTIVO TAG ACTIVO COLLATE 'MACHINE'
INDEX ON ORDEN_IMPRESION TAG ORDEN_IMPR COLLATE 'MACHINE'
INDEX ON LISTA TAG LISTA COLLATE 'MACHINE'
INDEX ON ORDEN_PRESENTACION TAG ORDEN_PRES COLLATE 'MACHINE'	

***** Table setup for POLPRECIOS *****
CREATE TABLE 'POLPRECIOS'  (NUM I , ;
                         PROCESO C(30), ;
                         DENOMINAC C(50), ;
                         CAMPO C(20), ;
                         TASA N(4, 2), ;
                         NUEVOSCLI L, ;
                         BLANCOSCLI L, ;
                         OBSERVAC M, ;
                         FTP D DEFAULT DATE(), ;
                         IDDT T DEFAULT DATETIME(), ;
                         IDS I , ;
                         IDSQL I , ;
                         VERSION I DEFAULT 0, ;
                         IDGENERAL I, ;
                         ESCALAS N(2, 0) DEFAULT 1)

***** Create each index for POLPRECIOS *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
*ALTER TABLE 'POLPRECIOS' ADD PRIMARY KEY NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON DENOMINAC TAG DENOMINAC COLLATE 'MACHINE'

***** Table setup for SERVICIOS_ARTICULOS *****
CREATE TABLE 'SERVICIOS_ARTICULOS'  (ID I , ;
                                  NUM I, ;
                                  NUMARTIC I, ;
                                  CODIGO C(20), ;
                                  ITEM C(15), ;
                                  DETALLE C(50), ;
                                  CANTIDAD N(5, 0) DEFAULT 1)

***** Create each index for SERVICIOS_ARTICULOS *****
INDEX ON NUMARTIC TAG NUMARTIC COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON CANTIDAD TAG CANTIDAD COLLATE 'MACHINE'

***** Table setup for SERVICIOS *****
CREATE TABLE 'SERVICIOS' (NUM I , ;
                        LISTA C(30), ;
                        RUBRO C(30), ;
                        SUBRUBRO C(30), ;
                        CODIGO C(20), ;
                        ITEM C(20), ;
                        DETALLE C(50), ;
                        PCOSTO N(12, 4), ;
                        PVENTA N(10, 2), ;
                        DÍAS N(3, 0), ;
                        APARTIRDE C(50), ;
                        LEYENDA1 C(38), ;
                        LEYENDA2 C(38), ;
                        QTY N(7, 0), ;
                        UNIDMEDIDA C(20), ;
                        PIEZAS N(2, 0), ;
                        PERCHERO C(30), ;
                        CTACOMPRAS C(40), ;
                        CTAVENTAS C(40), ;
                        CCOSTOCPRAS C(40), ;
                        CCOSTOVTAS C(10), ;
                        OBSERVAC M, ;
                        FTP D DEFAULT DATE(), ;
                        IDDT T DEFAULT DATETIME(), ;
                        IDS I , ;
                        NEWFLD C(10), ;
                        ARTICULO N(1, 0), ;
                        NUMART I, ;
                        CODIGOART C(20), ;
                        DETALLEART C(50), ;
                        PUNTOS I, ;
                        IMAGEN M, ;
                        IDSQL I , ;
                        VERSION I DEFAULT 0, ;
                        IDGENERAL I, ;
                        PLANTA N(2, 0), ;
                        COMISION1 N(5, 2), ;
                        COMISION2 N(5, 2), ;
                        PORMETRO N(1, 0), ;
                        PESO_SECO N(15, 2) DEFAULT 0, ;
                        PESO_SECO_ERROR N(5, 0) DEFAULT 0, ;
                        PESO_HUMEDO N(15, 2) DEFAULT 0, ;
                        PESO_HUMEDO_ERROR N(5, 0) DEFAULT 0, ;
                        GRUPO_DE_SERVICIOS C(20), ;
                        NUM_GRUPO_DE_SERVICIOS I)

***** Create each index for SERVICIOS *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON CODIGO TAG CODIGO COLLATE 'MACHINE'
INDEX ON ARTICULO TAG ARTICULO COLLATE 'MACHINE'
INDEX ON NUMART TAG NUMART COLLATE 'MACHINE'
INDEX ON CODIGOART TAG CODIGOART COLLATE 'MACHINE'
INDEX ON DETALLEART TAG DETALLEART COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON DETALLE TAG DETALLE COLLATE 'MACHINE'

***** Table setup for REMI1 *****
CREATE TABLE 'REMI1'  (NUM I , ;
                    TIPO_COMPROBANTE I, ;
                    TIPO C(20), ;
                    FECHA D, ;
                    MONEDA C(12), ;
                    NUMERO N(8, 0), ;
                    LISTAPROD C(50), ;
                    LISTASERV C(50), ;
                    BONIFICACI N(5, 2), ;
                    VENDEDOR C(20), ;
                    CONDVTA C(40), ;
                    FORMAPAGO C(40), ;
                    CLIENTE C(50), ;
                    TELEFONO C(15), ;
                    DOMICILIO C(150), ;
                    CEDULA C(15), ;
                    NUMIMPOS C(15), ;
                    IVA C(40), ;
                    LOCALIDAD C(30), ;
                    CATEGORIA C(40), ;
                    RETEFUENTE N(15, 5), ;
                    RETEIVA N(15, 5) , ;
                    RETEICA N(15, 5) , ;
                    TOTAL N(15, 5), ;
                    ENTREGADO N(1, 0), ;
                    PAGADO N(1, 0), ;
                    FACTURADO N(1, 0), ;
                    FACTURAR L, ;
                    SALDO N(15, 4), ;
                    NUMEREX C(4), ;
                    NUMEROB N(10, 0), ;
                    LEYENDA1 C(38), ;
                    LEYENDA2 C(38), ;
                    MTOENTREGA C(40), ;
                    DEUDA N(15, 4), ;
                    PERCHERO C(40), ;
                    ESTAD N(10, 2), ;
                    RETIRA L, ;
                    CANCELA L, ;
                    CANTPROD N(4, 0) , ;
                    CANTSERV N(6, 0) , ;
                    ANULADA L, ;
                    CONFORMAR D, ;
                    ENTREGA T, ;
                    ENTREGA1 C(30), ;
                    FTP D, ;
                    VENDEDOR1 C(20), ;
                    FECHAHORA T , ;
                    IVA1 N(12, 2), ;
                    NETO N(14, 2), ;
                    IMP1 N(14, 2), ;
                    IMP2 N(14, 2), ;
                    BONIF N(14, 2), ;
                    MTOENTREGA2 C(40), ;
                    ENTREGA2 T, ;
                    ESTAD2 N(10, 2), ;
                    IDDT T , ;
                    IDS I , ;
                    ENPLANTA N(1, 0), ;
                    STATUS C(10), ;
                    NUMTENV N(10, 0), ;
                    TRANSPENV C(50), ;
                    NUMTREC N(10, 0), ;
                    TRANSPREC C(50), ;
                    IDCLIENTE I, ;
                    IMPFACT I, ;
                    DATEIMP T, ;
                    NPOS I, ;
                    IDSQL I , ;
                    VERSION I , ;
                    IDGENERAL I, ;
                    HORARIO2 T, ;
                    NUMAPLIC N(12, 0), ;
                    ESTADO C(20), ;
                    PROCESOS I, ;
                    PROCESOS_PENDIENTES I, ;
                    SUBPROCESOS I, ;
                    SUBPROCESOS_PENDIENTES I, ;
                    PORCENTAJE_TERMINADO N(5, 2), ;
                    FECHAENTREGA C(10), ;
                    BAJADO_EN C(40), ;
                    SIN_DEFINIR L, ;
                    ORDEN_DE_CORTE C(9), ;
                    REMITO_DEL_CLIENTE C(9), ;
                    RESPONSABLE C(40), ;
                    DEPOSITO C(50), ;
                    TALLER C(30), ;
                    ARTICULO C(10), ;
                    KILOS N(12, 5), ;
                    MUESTRA N(10, 0), ;
                    CONTO C(50), ;
                    CONTIENE_MUESTRAS L, ;
                    TICKETS C(50), ;
                    SE_RETIRA_EN I, ;
                    DEP_ORIG I , ;
                    DEP_DEST I , ;
                    EXPORTADO L )

***** Create each index for REMI1 *****
INDEX ON FECHA TAG FECHA COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON VENDEDOR1 TAG VENDEDOR1 COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON ENPLANTA TAG ENPLANTA COLLATE 'MACHINE'
INDEX ON CLIENTE TAG CLIENTE COLLATE 'MACHINE'
INDEX ON NUMERO TAG NUMERO COLLATE 'MACHINE'
INDEX ON STATUS TAG STATUS COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON SIN_DEFINIR TAG SIN_DEFINI COLLATE 'MACHINE'
INDEX ON CONTIENE_MUESTRAS TAG CONTIENE_M COLLATE 'MACHINE'
INDEX ON TOTAL TAG TOTAL COLLATE 'MACHINE'
INDEX ON SALDO TAG SALDO DESCENDING  COLLATE 'MACHINE'
*ALTER TABLE 'REMI1' ADD PRIMARY KEY NUM TAG NUM COLLATE 'MACHINE'
INDEX ON HORARIO2 TAG HORARIO2 COLLATE 'MACHINE'
INDEX ON IDSQL TAG IDSQL COLLATE 'MACHINE'
INDEX ON IDCLIENTE TAG IDCLIENTE COLLATE 'MACHINE'
INDEX ON FECHAHORA TAG FECHAHORA COLLATE 'MACHINE'
INDEX ON ANULADA TAG ANULADA COLLATE 'MACHINE'
INDEX ON TIPO_COMPROBANTE TAG TIPO_COMPR COLLATE 'MACHINE'
INDEX ON EXPORTADO TAG EXPORTADO COLLATE 'MACHINE'

***** Table setup for PLANTAS *****
CREATE TABLE 'PLANTAS'  (CODIGO C(10), ;
                      NOMBRE C(50), ;
                      OBSERVACIONES C(254), ;
                      IDS I , ;
                      DOMICILIO C(100), ;
                      FECHAHORA T DEFAULT DATETIME(), ;
                      PROCESO2 C(50), ;
                      PROCESO3 C(50), ;
                      PROCESO4 C(50), ;
                      PROCESO5 C(50), ;
                      PROCESO6 C(50), ;
                      ENCARGADO_ID I, ;
                      NOMBRE_ENCARGADO C(80), ;
                      PREDET L)

***** Create each index for PLANTAS *****
*ALTER TABLE 'PLANTAS' ADD PRIMARY KEY IDS TAG IDS COLLATE 'MACHINE'
INDEX ON PREDET TAG PREDET COLLATE 'MACHINE'


***** Table setup for SUBPROCESOS_PROCESOS_VINCULADOS *****
CREATE TABLE 'SUBPROCESOS_PROCESOS_VINCULADOS'  (NUM I , ;
                                              NUM_SUBPROC I, ;
                                              NUM_PROCESO I, ;
                                              PROCESO C(50))

***** Create each index for SUBPROCESOS_PROCESOS_VINCULADOS *****
INDEX ON PROCESO TAG PROCESO COLLATE 'MACHINE'
INDEX ON NUM_PROCESO TAG NUM_PROCES COLLATE 'MACHINE'
INDEX ON NUM_SUBPROC TAG NUM_SUBPRO COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'


***** Table setup for SUBPROCESOS *****
CREATE TABLE 'SUBPROCESOS'  (SUBPROCESO C(50), ;
                          PREDET1 L, ;
                          IMAGEN M, ;
                          IDSQL I , ;
                          VERSION I, ;
                          IDGENERAL I, ;
                          TERCEROS L)

***** Create each index for SUBPROCESOS *****
INDEX ON SUBPROCESO TAG SUBPROCESO COLLATE 'MACHINE'
INDEX ON IDGENERAL TAG IDGENERAL COLLATE 'MACHINE'

***** Table setup for PLANTAS_PROCESOS *****
CREATE TABLE 'PLANTAS_PROCESOS'  (IDS I, ;
                               NUM I , ;
                               PROCESO C(50), ;
                               IDDT T DEFAULT DATETIME())

***** Create each index for PLANTAS_PROCESOS *****
INDEX ON PROCESO TAG PROCESO COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Change properties for PLANTAS_PROCESOS *****
ENDFUNC

FUNCTION MakeTable_COMENTARIOS2_POLITICAS
***** Table setup for COMENTARIOS2_POLITICAS *****
CREATE TABLE 'COMENTARIOS2_POLITICAS'  (NUM I , ;
                                     IDS I, ;
                                     NUM_PRENDA I, ;
                                     ACARREA_RECARGO L, ;
                                     RECARGO N(14, 2), ;
                                     TASA_O_FIJO I, ;
                                     INVALIDA_RECARGOS_COLOR L, ;
                                     INVALIDA_RECARGOS_COMPOSICION L, ;
                                     INVALIDA_RECARGOS_ACCESORIOS L, ;
                                     INVALIDA_RECARGOS_MARCAS L, ;
                                     INVALIDA_RECARGOS_MANCHAS L, ;
                                     DATETIME T DEFAULT DATETIME(), ;
                                     USUARIO I, ;
                                     TEXTO_BAJO_EL_ITEM C(254), ;
                                     TEXTO_AL_PIE_DEL_DOCUMENTO C(254), ;
                                     TEXTO_EN_HOJA_APARTE C(254))

***** Create each index for COMENTARIOS2_POLITICAS *****
INDEX ON NUM_PRENDA TAG NUM_PRENDA COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'


***** Table setup for STOCK1 *****
CREATE TABLE 'STOCK1'  (DEPOSITO C(30) DEFAULT "1", ;
                     LISTA C(30) DEFAULT "1", ;
                     SUBRUBRO C(30), ;
                     RUBRO C(30), ;
                     QTY N(10, 0), ;
                     CODIGO C(20), ;
                     ITEM C(15), ;
                     DETALLE C(50), ;
                     UNMEDIDA C(30), ;
                     COLOR C(15), ;
                     SIZE C(15), ;
                     PROVEEDOR C(50), ;
                     PVENTA N(10, 2), ;
                     PCOSTO N(10, 2), ;
                     IMPINTER N(5, 2), ;
                     PERFIL C(20), ;
                     STMINIMO C(5), ;
                     STMAXIMO C(5), ;
                     CTACOMPRAS C(40), ;
                     CCOSTOCPRA C(40), ;
                     CTAVENTAS C(40), ;
                     CCOSTOVTA C(40), ;
                     OBSERVAC M, ;
                     FTP D NULL DEFAULT DATE(), ;
                     IDDT T DEFAULT DATETIME(), ;
                     IDS I , ;
                     NUM I , ;
                     ROTACION I, ;
                     IDSQL I , ;
                     VERSION I DEFAULT 0, ;
                     IDGENERAL I, ;
                     IMAGEN M, ;
                     PESO_SECO N(15, 2) NULL, ;
                     PESO_SECO_ERROR N(5, 0) NULL, ;
                     PESO_HUMEDO N(15, 2) NULL, ;
                     PESO_HUMERO_ERROR N(5, 0) NULL)

***** Create each index for STOCK1 *****
INDEX ON DETALLE TAG DETALLE COLLATE 'MACHINE'
INDEX ON ITEM TAG ITEM COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON DEPOSITO TAG DEPOSITO COLLATE 'MACHINE'
INDEX ON CODIGO TAG CODIGO COLLATE 'MACHINE'
INDEX ON QTY TAG QTY COLLATE 'MACHINE'
INDEX ON LISTA+STR(QTY,5,0)+STR(PCOSTO,10,2) TAG WIZARD_1 COLLATE 'MACHINE'
*ALTER TABLE 'STOCK1' ADD PRIMARY KEY NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON LEFT(DETALLE,40) TAG WIZARD_2 COLLATE 'MACHINE'

***** Table setup for CLASE *****
CREATE TABLE 'CLASE'  (CLASE C(50), ;
                    TASA1 N(5, 2), ;
                    TASA2 N(5, 2), ;
                    INDICE N(6, 3), ;
                    DISCRIMINA L, ;
                    PREDET L, ;
                    CODFACT C(3), ;
                    TALONARIO I, ;
                    FTP D DEFAULT DATE(), ;
                    IDDT T DEFAULT DATETIME(), ;
                    IDS I , ;
                    IDSQL I , ;
                    VERSION I DEFAULT 0, ;
                    IDGENERAL I)

***** Create each index for CLASE *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON CLASE TAG CLASE COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Table setup for COMENTARIO2 *****
CREATE TABLE 'COMENTARIO2'  (COMENTARIO C(40), ;
                          IDDT T, ;
                          IDS I , ;
                          NUM I, ;
                          IMAGEN M, ;
                          IDSQL I , ;
                          VERSION I DEFAULT 0, ;
                          IDGENERAL I, ;
                          NOMBRE_CLIENTE C(50), ;
                          CODIGO_CLIENTE C(20), ;
                          IDCLIENTE I, ;
                          RELACION_BANIO N(5, 2), ;
                          ACARREA_RECARGO L, ;
                          RECARGO N(14, 2), ;
                          TASA_O_FIJO I, ;
                          INVALIDA_RECARGOS_COLOR L, ;
                          INVALIDA_RECARGOS_COMPOSICION L, ;
                          INVALIDA_RECARGOS_ACCESORIOS L, ;
                          INVALIDA_RECARGOS_MARCAS L, ;
                          INVALIDA_RECARGOS_MANCHAS L)

***** Create each index for COMENTARIO2 *****
INDEX ON COMENTARIO TAG COMENTARIO COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON IDCLIENTE TAG IDCLIENTE COLLATE 'MACHINE'
INDEX ON CODIGO_CLIENTE TAG CODIGO_CLI COLLATE 'MACHINE'
INDEX ON NOMBRE_CLIENTE TAG NOMBRE_CLI COLLATE 'MACHINE'
INDEX ON IDGENERAL TAG IDGENERAL COLLATE 'MACHINE'

***** Table setup for COMENTARIO1 *****
CREATE TABLE 'COMENTARIO1'  (COMENTARIO C(40), ;
                          IDDT T, ;
                          IDS I , ;
                          NUM I, ;
                          IDSQL I , ;
                          VERSION I DEFAULT 0, ;
                          IDGENERAL I, ;
                          FILTRO I, ;
                          PREDET L)

***** Create each index for COMENTARIO1 *****
INDEX ON COMENTARIO TAG COMENTARIO COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Table setup for COMENTARIO *****
CREATE TABLE 'COMENTARIO'  (COMENTARIO C(40), ;
                         IDDT T DEFAULT DATETIME(), ;
                         IDS I , ;
                         IDSQL I , ;
                         VERSION I DEFAULT 0, ;
                         IDGENERAL I, ;
                         NOMBRE_CLIENTE C(50), ;
                         CODIGO_CLIENTE C(20), ;
                         IDCLIENTE I)

***** Create each index for COMENTARIO *****
INDEX ON COMENTARIO TAG COMENTARIO COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
INDEX ON IDCLIENTE TAG IDCLIENTE COLLATE 'MACHINE'
INDEX ON CODIGO_CLIENTE TAG CODIGO_CLI COLLATE 'MACHINE'
INDEX ON NOMBRE_CLIENTE TAG NOMBRE_CLI COLLATE 'MACHINE'



***** Table setup for GRUPOS_DE_SERVICIOS *****
CREATE TABLE 'GRUPOS_DE_SERVICIOS'  (NUM I , ;
                                  GRUPO_DE_SERVICIOS C(20), ;
                                  IDDT T, ;
                                  USUARIO I, ;
                                  PROCESOS_SUBPROCESOS I)

***** Create each index for GRUPOS_DE_SERVICIOS *****
INDEX ON USUARIO TAG USUARIO COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON GRUPO_DE_SERVICIOS TAG GRUPO_DE_S COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON PROCESOS_SUBPROCESOS TAG PROCESOS_S COLLATE 'MACHINE'

***** Table setup for CUENTAS *****
CREATE TABLE 'CUENTAS'  (NUM I , ;
                      CÓDIGO C(30), ;
                      NOMBRE C(40), ;
                      SALDOH C(10), ;
                      IMPUTABLE C(5), ;
                      COTIZACIÓN C(20), ;
                      AGRUPACIÓN C(20), ;
                      RESULTADO C(25), ;
                      ASIGNACCOS L, ;
                      CUANTOS C(10), ;
                      CUÁLES C(30), ;
                      ASIGNARAPR L, ;
                      HABITUAL C(30), ;
                      LEYENDA1D C(50), ;
                      LEYENDA2D C(50), ;
                      LEYENDA3D C(50), ;
                      LEYENDA1A C(50), ;
                      LEYENDA2A C(50), ;
                      LEYENDA3A C(50), ;
                      MFONDOS L, ;
                      FTP D, ;
                      IDDT T DEFAULT DATETIME(), ;
                      IDS I , ;
                      AGRUPACION C(30), ;
                      IDSQL I , ;
                      VERSION I DEFAULT 0, ;
                      IDGENERAL I)

***** Create each index for CUENTAS *****
INDEX ON AGRUPACION TAG AGRUPACION COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON NOMBRE TAG NOMBRE COLLATE 'MACHINE'
INDEX ON CÓDIGO TAG CÓDIGO COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'


***** Table setup for REGLAS2 *****
CREATE TABLE 'REGLAS2'  (NUM I, ;
                      CENTCOST C(40), ;
                      EXISTE L, ;
                      PORCENTAJE N(5, 2), ;
                      FTP D DEFAULT DATE(), ;
                      IDDT T DEFAULT DATETIME(), ;
                      IDS I , ;
                      IDSQL I , ;
                      VERSION I DEFAULT 0, ;
                      IDGENERAL I)

***** Create each index for REGLAS2 *****
INDEX ON PORCENTAJE TAG PORCENTAJE COLLATE 'MACHINE'
INDEX ON EXISTE TAG EXISTE COLLATE 'MACHINE'
INDEX ON CENTCOST TAG CENTCOST COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON NUM TAG NUM COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Change properties for REGLAS2 *****
*CREATE TRIGGER ON 'REGLAS2' FOR DELETE AS elimin()
*CREATE TRIGGER ON 'REGLAS2' FOR INSERT AS agregar()
*CREATE TRIGGER ON 'REGLAS2' FOR UPDATE AS modificar()
ENDFUNC

***** Table setup for REGLAS *****
CREATE TABLE 'REGLAS'  (NUM I, ;
                     REGLA C(30), ;
                     A1 C(30), ;
                     A2 N(14, 2), ;
                     FTP D DEFAULT DATE(), ;
                     IDDT T DEFAULT DATETIME(), ;
                     IDS I , ;
                     IDSQL I , ;
                     VERSION I DEFAULT 0, ;
                     IDGENERAL I)

***** Create each index for REGLAS *****
INDEX ON REGLA TAG REGLA COLLATE 'MACHINE'
INDEX ON NUM TAG NUM CANDIDATE COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Table setup for CENTCOST *****
CREATE TABLE 'CENTCOST'  (CÓDIGO C(6), ;
                       CENTCOST C(30), ;
                       SALDO N(10, 0), ;
                       FTP D DEFAULT DATE(), ;
                       IDDT T DEFAULT DATETIME(), ;
                       IDS I , ;
                       IDSQL I , ;
                       VERSION I DEFAULT 0, ;
                       IDGENERAL I)

***** Create each index for CENTCOST *****
INDEX ON CENTCOST TAG CENTCOST COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'


***** Table setup for AGRUPAC *****
CREATE TABLE 'AGRUPAC' (AGRUPAC C(30), ;
                      FTP D DEFAULT DATE(), ;
                      IDDT T DEFAULT DATETIME(), ;
                      IDS I , ;
                      IDSQL I , ;
                      VERSION I DEFAULT 0, ;
                      IDGENERAL I)

***** Create each index for AGRUPAC *****
INDEX ON AGRUPAC TAG AGRUPAC COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'


***** Table setup for CONDCPRA *****
CREATE TABLE 'CONDCPRA'  (NUMERO N(5, 0), ;
                       DESCRIPCIO C(30), ;
                       FACTCRED L, ;
                       PORCTOTFAC C(2), ;
                       CUOTAS C(3), ;
                       LAPSO1 C(10), ;
                       LAPSO11 C(10), ;
                       LAPSO2 C(5), ;
                       FTP D DEFAULT DATE(), ;
                       IDDT T DEFAULT DATETIME(), ;
                       IDS I , ;
                       IDSQL I , ;
                       VERSION I DEFAULT 0, ;
                       IDGENERAL I)

***** Create each index for CONDCPRA *****
INDEX ON DESCRIPCIO TAG DESCRIPCIO COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'


***** Table setup for CLASE *****
CREATE TABLE 'CLASE'  (CLASE C(50), ;
                    TASA1 N(5, 2), ;
                    TASA2 N(5, 2), ;
                    INDICE N(6, 3), ;
                    DISCRIMINA L, ;
                    PREDET L, ;
                    CODFACT C(3), ;
                    TALONARIO I, ;
                    FTP D DEFAULT DATE(), ;
                    IDDT T DEFAULT DATETIME(), ;
                    IDS I , ;
                    IDSQL I , ;
                    VERSION I DEFAULT 0, ;
                    IDGENERAL I)

***** Create each index for CLASE *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON CLASE TAG CLASE COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'


***** Table setup for UNIDMEDIDA *****
CREATE TABLE 'UNIDMEDIDA'  (UNIDMEDIDA C(20), ;
                         FTP D, ;
                         IDDT T DEFAULT DATETIME(), ;
                         IDS I , ;
                         IDSQL I , ;
                         VERSION I DEFAULT 0, ;
                         IDGENERAL I)


***** Table setup for SUBRUBRO *****
CREATE TABLE 'SUBRUBRO'  (SUBRUBRO C(30), ;
                       FTP D DEFAULT DATE(), ;
                       IDDT T DEFAULT DATETIME(), ;
                       IDS I , ;
                       IDSQL I , ;
                       VERSION I DEFAULT 0, ;
                       IDGENERAL I)

***** Create each index for SUBRUBRO *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Table setup for RUBRO *****
CREATE TABLE 'RUBRO'  (RUBRO C(30), ;
                    FTP D DEFAULT DATE(), ;
                    IDDT T DEFAULT DATETIME(), ;
                    IDS I , ;
                    IDSQL I , ;
                    VERSION I DEFAULT 0, ;
                    IDGENERAL I)

***** Create each index for RUBRO *****
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'
SELECT * FROM rubro
***** Table setup for LOCALIDAD *****
CREATE TABLE 'LOCALIDAD'  (LOCALIDAD C(50), ;
                        CIUDAD C(50), ;
                        MUNICIPIO C(50), ;
                        PROVINCIA C(50), ;
                        CODPOSTAL C(15), ;
                        FTP D DEFAULT DATE(), ;
                        IDDT T DEFAULT DATETIME(), ;
                        IDS I , ;
                        IDSQL I , ;
                        VERSION I DEFAULT 0, ;
                        IDGENERAL I)

***** Create each index for LOCALIDAD *****
INDEX ON LOCALIDAD TAG LOCALIDAD COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON CIUDAD TAG CIUDAD COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Table setup for ZONA *****						
CREATE TABLE 'ZONA'  (NUM I , ;
                   ZONA C(40), ;
                   OBSERVACIONES C(254), ;
                   FTP D DEFAULT DATE(), ;
                   IDDT T DEFAULT DATETIME(), ;
                   IDS I , ;
                   IDSQL I , ;
                   VERSION I DEFAULT 0, ;
                   IDGENERAL I, ;
                   ID_TRANSPORTISTA1 I, ;
                   TRANSPORTISTA1 C(60), ;
                   ID_TRANSPORTISTA2 I, ;
                   TRANSPORTISTA2 C(60), ;
                   ID_TRANSPORTISTA3 I, ;
                   TRANSPORTISTA3 C(60), ;
                   ID_TRANSPORTISTA4 I, ;
                   TRANSPORTISTA4 C(60), ;
                   ID_TRANSPORTISTA5 I, ;
                   TRANSPORTISTA5 C(60), ;
                   ID_TRANSPORTISTA6 I, ;
                   TRANSPORTISTA6 C(60), ;
                   BARRIO C(50), ;
                   LOCALIDAD C(50), ;
                   PROVINCIA C(50), ;
                   PREDET L)

***** Create each index for ZONA *****
INDEX ON ZONA TAG ZONA COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

***** Table setup for PROVINCIA *****
CREATE TABLE 'PROVINCIA'  (PROVINCIA C(50), ;
                        FTP D DEFAULT DATE(), ;
                        IDDT T DEFAULT DATETIME(), ;
                        IDS I , ;
                        IDSQL I , ;
                        VERSION I DEFAULT 0, ;
                        IDGENERAL I)

***** Create each index for PROVINCIA *****
INDEX ON PROVINCIA TAG PROVINCIA COLLATE 'MACHINE'
INDEX ON FTP TAG FTP COLLATE 'MACHINE'
INDEX ON IDDT TAG IDDT COLLATE 'MACHINE'
INDEX ON IDS TAG IDS COLLATE 'MACHINE'

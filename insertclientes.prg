SET DATE TO AMERICAN
SET CENTURY ON
SET MARK TO "/"
TEXT TO cejecutar1 NOSHOW  PRETEXT 15
	INSERT INTO remi1 VALUES (575651, 12, 'Guia de Traspaso', CTOD('10/01/22'), '', 474893, '', '', 0, 'NESTLE REMOTO',
	 'DEP�SITO DE TERCEROS', 'ART�CULOS PARA LA VENTA', 'ROPERIA PRINCIPAL NESTLE - (ROPA LIMPIA)', '', 
	 'CAMINO A MELIPILLA 15300, MAIP�, SANTIAGO, REGI�N METROPOLITANA', '', '', '', '', '', 0, 0, 0,
	 0, 0, 0, 0, .F., 0, '5', 0, '', '', '', 0, '', 0, .F., .F., 0, 5, .F.,
	 {}, {}, '01/10/22', {}, 'A A', CTOT('10/01/22 01:42:53 AM'), 0,
	 21033, 0, 0, 0, '', {}, 1, CTOT('10/01/22 01:42:53 AM'),
	 575651, 0, 'C', 0, '', 0, '', 160, 136, {}, 0, 
	 575651, 1, 0, CTOT('10/01/22 01:42:53 AM'), 0, 'SIN COMENZAR', 5, 5, 0, 0, 0,
	  '', '', .F., '', '', 'NESTLE REMOTO', 'ANGELA DEL CARMEN ALVAREZ SAGREDO (PKG)',
	  '', '', 0, 136, '', .F., 'MARIA PEREIRA (PKG)', 0, 6540, 41084, 
	  .F., {}, {},DATETIME(),'I')
ENDTEXT 
&cejecutar1

TEXT TO cejecutar2 NOSHOW  PRETEXT 15
INSERT INTO remi2 VALUES (575651, 'Servicio', 0, '', 'BLUSA BLANCA PLANTA', 1, 0.0100, 0.0100, 0.0100, 0, 1,
 'P', CTOD('10/01/22'), CTOD('10/01/22'), '', '', 0, 'CPW', CTOT('10/01/22 01:43:16 AM'), 3664375, '', 0, 906,
  '', '', '', '', '', '', 0, 3664375, 0, 1, {}, {}, '', 0, 0, 0, '', '', 0, '', 0, '', 0, '', 0, '',
   0, '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '', {}, {}, '', 0, 0, 0,DATETIME(),'I')
ENDTEXT 
&cejecutar2

TEXT TO cejecutar3 NOSHOW  PRETEXT 15
INSERT INTO remi2 VALUES (575651, 'Servicio', 0, 'MASD', 'MASCARILLAS DESECHABLES', 4, 0.0100, 0.0300, 0.0400, 0, 1, 
'P', CTOD('10/01/22'), CTOD('10/01/22'), '', '', 0, 'ELEMENTOS ASEO Y EPP', CTOT('10/01/22 01:43:24 AM'), 3664376,
'', 0, 1113,'', '', '', '', '', '', 0, 3664376, 0, 2, {}, {}, '', 0, 0, 0, '', '', 0, '', 0, '', 0, '', 0, '', 0,
 '', 0, '', 0, '', 0, '', 0, '', 0, '', 0, '',{},{}, '', 0, 0, 0,DATETIME(),'I')
ENDTEXT 
&cejecutar3

TEXT TO cClientes NOSHOW  PRETEXT 15
INSERT INTO clientes VALUES (26, 'JAVIER', '', '', '', '', '', '', '', '', '', '', '', '', 'NORMAL', 'Consumidor Final', '', '',
'', 'GENERAL', 'NESTLE', .F., {}, CTOD('07/11/22'), CTOT('07/11/22 05:58:06 PM'), 41530, 164, '', '', 0, 0, '', 0, 0, 0, 
2928, 2, 0, '', '', '', '', '', .F., .F., .F., .F., .F., .F., .F., 0, '', '', 'AGRUPADO', '', '',{}, '', {}, '', '', '', '', 
0, '', {}, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', 0, '', 0, 0, 0, 
CTOT('10/26/23 05:28:18 PM'),DATETIME(),'A')
ENDTEXT 
&cClientes


BROWSE FIELDS codigo,nombre,domicilio,codigo_postal,documento,telefono_1,fax,email,clave_impositiva,fecha_de_nacimiento,sincronizacion,radio,domicilio_de_entrega,nombre_de_fantasia,telefono_2,telefono_3,website,contacto_1,logo_cliente,contacto_2,cargo_2,email_1,email_2,retencion_fuente,retencion_iva,retencion_ica,id_abm_localidades,id_abm_provincias,id_abm_ciudades,id_abm_municipios,id_abm_regiones_1,cargo_1,contacto_3,cargo_3,email_3,id_abm_calificacion_de_clientes,id_abm_categoria_impositiva,id_abm_asientos_automaticos_ventas,id_abm_cuentas_contables,id_abm_politica_de_precios_articulos,id_abm_politica_de_precios_servicios,activo,observaciones,datetime,ultimo_cambio,eliminado,ui,version,id_abm_empresas,id_abm_regiones,id_abm_usuarios,id_abm_ultimo_usuario


VALUES (25,'CODELCO','','','','','','','',.NULL.,164,'','','','','AGRUPADO','','','','','','','',0,0,0,0,0,0,0,0,
'','','','',0,0,0,0,0,0,0,'',DATETIME(),DATETIME(),0,'6f70d760-69b6-11ef-9cdf-7085c23aa0aa',version + 1,440,1,999,999)


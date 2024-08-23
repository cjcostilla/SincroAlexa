LPARAMETERS osinmensajes
  SET TABLEPROMPT OFF 
  SET CPDIALOG OFF
  SET DELETED OFF
  SET TALK OFF
  SET CONSOLE OFF
  SET SAFETY OFF
  SET CONSOLE off
  SET DEFAULT TO SYS(5) + CURDIR()
  Set Path To oDbsql,forms,class,menu,graphics,data,execute,Execute,Informes,PRG,System,Wizards  ADDITIVE
  SET DELETED off
  
* _xvaciar_tablas = 0 
*_xrutadato*_xempresa*_xusuario *_xregion*_xrubro*_xmoneda*_xexportado 

RELEASE _otabla
PUBLIC _otabla
RELEASE _otabla1
PUBLIC _otabla1
RELEASE _otablaSQL
PUBLIC _otablaSQL
RELEASE _ocursorSQL
PUBLIC _ocursorSQL

_otabla = 'clientes'
_otablaSQL = 'abm_clientes'
_ocursorSQL = 'SQL_abm_clientes'
*_otabla1 = 'depósitos'

IF USED(_otabla)
	USE IN &_otabla
ENDIF
*IF USED(_otabla1)
*	USE IN &_otabla1
*ENDIF
IF USED(_ocursorSQL)
	USE IN &_ocursorSQL
ENDIF

IF !USED(_otabla) AND !USED(UPPER(_otabla))
	sql_oDb_abrir_tabla_dbf(_otabla)
ENDIF
*IF !USED(_otabla1)
*	sql_oDb_abrir_tabla_dbf(_otabla1)
*ENDIF
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		odb_connect()
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*ca_log_pasar_datos_de_empresa_a_sql('Procesando tabla: ' + _otabla)
	*dd = oDb.Query("Select * from " + _otablaSQL, _ocursorSQL, _otablaSQL)
	oDb.Query("Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(_xempresa)), _ocursorSQL, _otablaSQL)		
	IF oDb.CursorOpen(_ocursorSQL)
		IF oDb.CursorEdit(_ocursorSQL)
		ELSE
			IF osinmensajes = 0
			WAIT WINDOW 'El dataset ' + _ocursorSQL + ' no es editable'
			ENDIF 
			ca_log_pasar_datos_de_empresa_a_sql('El cursor ' + _ocursorSQL + ' no es editable. Procedimiento cancelado')
			RETURN 	
		ENDIF 
	ELSE
		IF osinmensajes = 0
		WAIT WINDOW 'El dataset ' + _ocursorSQL +  ' no está abierto'
		ENDIF 
		ca_log_pasar_datos_de_empresa_a_sql('El cursor ' + _ocursorSQL + ' no está abierto. Procedimiento cancelado')
		RETURN 
	ENDIF 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
SELECT &_ocursorSQL&&&_ocursorSQL

SELECT &_otabla
COUNT TO _totales_en_dbf 

SELECT &_ocursorSQL
COUNT TO _totales_en_sql FOR id_ABM_empresas = _xempresa
*BROWSE
IF _xvaciar_tablas = 1 AND _totales_en_sql > 0
*	odb_connect()
	SELECT &_ocursorSQL
	DELETE ALL for id_ABM_empresas = _xempresa
		odb_connect()
		IF oDb.CursorChanges(_ocursorSQL)
				IF oDb.Update(_ocursorSQL,.t.)		&& .t. es para obtener el ultimo ID insertado
						IF oDb.Commit()
								oDb.Refresh(_ocursorSQL,oDb.id_Last)
						ELSE
								oDb.Rollback()
						ENDIF
				ENDIF
		ENDIF
ENDIF 
IF osinmensajes = 0
WAIT windows 'Procesando tabla: ' +  _otabla + CHR(13) +  'cantidad en DBF = ' + ALLTRIM(STR(_totales_en_dbf )) ;
+ CHR(13) + 'cantidad en SQL = ' + ALLTRIM(STR(_totales_en_sql )) NOWAIT noclear
ENDIF 
*ca_log_pasar_datos_de_empresa_a_sql('Procesando tabla ' + _ocursorSQL)
&& crear consulta pra verificar si el num ya existe

SELECT &_otabla
conta_nuevos = 0
conta_ya_existentes = 0
conta_nuevos_error = 0
conta = 0
conta_eliminados = 0
conta_activos = 0
_codigoX_automatico = 0
GO top
*BROWSE
SELECT &_otabla

SCAN 
	
	conta = conta + 1
	_codigoX_automatico = _codigoX_automatico + 1

	_num = codigo
	
	&& ver si ya está
	SELECT COUNT(id) as temp1 from &_ocursorSQL where sincronizacion = _num AND id_ABM_empresas = _xempresa INTO CURSOR temp
	SELECT temp
	COUNT TO cuantoswwqq
	IF cuantoswwqq > 0
		GO 1
	ENDIF 
	IF temp1 = 0		
		
			SELECT &_otabla
			_CODIGOQ = PADL(ALLTRIM(str(_codigoX_automatico)),4, '0')
			_codigo = IIF(codigo = 0, _CODIGOQ , ALLTRIM(STR(codigo)))
			_nombre = ALLTRIM(nombre)
			_Nombre_de_Fantasia = ALLTRIM(marca) 
			_domicilio = ALLTRIM(dirección)
			_domicilio_de_entrega =  ALLTRIM(lugar_entrega)
			_domicilio_de_facturacion = ALLTRIM(marca)  
			_codigo_postal = ALLTRIM(cód_postal)
			_id_ABM_Localidades = 0
			_id_ABM_Provincias = 0
			_id_ABM_Ciudades = 0
			_id_ABM_Municipios = 0  
			_id_ABM_Regiones_1 = 0 
			_documento = ALLTRIM(cedula)  
			_Fecha_de_nacimiento = nacim  
			_clave_impositiva = ALLTRIM(cuit)
			_telefono_1 = ALLTRIM(teléfono)  
			_telefono_2 = ALLTRIM(teléfono2)  
			_telefono_3 = ALLTRIM(teléfono3)  
			_radio = ALLTRIM(num_radio)
			_fax = ALLTRIM(fax)  
			_email = ALLTRIM(mail)  
			_contacto_1 = ALLTRIM(contacto)  
			_cargo_1 = ""  
			_email_1 = ALLTRIM(mail_2)  
			_contacto_2 = ALLTRIM(persona_contacto)  
			_cargo_2 = ALLTRIM(cargo_contacto)    
			_email_2 =  ALLTRIM(mail_3)   
			_contacto_3 = ""  
			_cargo_3 = ""   
			_email_3 = ""  
			_website = ALLTRIM(website)  
			_logo_cliente = ALLTRIM(comentarios)  
*			_foto =   
			_id_ABM_Calificacion_de_Clientes = 0   
			_id_ABM_Categoria_impositiva = 0   
			_retencion_fuente = retefuente  
			_retencion_iva = reteiva  
			_retencion_ica = reteica  
			_id_ABM_Condiciones_de_venta = 0   
			_id_ABM_Asientos_automaticos_ventas = 0   
			_id_ABM_Cuentas_Contables = 0   
			_id_ABM_Politica_de_Precios_Articulos = 0   
			_id_ABM_Politica_de_Precios_Servicios = 0  
			_observaciones = ""  
&&& HASTA ACA
			
			_activo = 0&&IIF(activo = .t., 0, 1)
					_sincronizacion = idcliente
					_ultimo_cambio = DATETIME()
					_ui = odb.uuid()
					SELECT &_otabla
					_datetime = DATETIME()
					_observaciones = ""

				IF DELETED()	
					conta_eliminados = conta_eliminados + 1 
					_eliminado = 1
					_activo = 1
				ELSE
					conta_activos = conta_activos + 1		
					_eliminado = 0
					_activo = 0
				ENDIF 

			*	_id_ABM_localidad = oDb_funcion_ID('ABM_localidades', ALLTRIM(localidad))
			*	_id_ABM_Provincia = oDb_funcion_ID('ABM_provincias', ALLTRIM(provincia))

					SELECT 	&_ocursorSQL
					APPEND BLANK

					replace codigo WITH _codigo IN &_ocursorSQL
					replace nombre WITH _nombre IN &_ocursorSQL
					replace Nombre_de_Fantasia WITH _Nombre_de_Fantasia IN &_ocursorSQL
					replace domicilio WITH _domicilio IN &_ocursorSQL
					replace domicilio_de_entrega WITH _domicilio_de_entrega IN &_ocursorSQL
					replace domicilio_de_facturacion WITH _domicilio_de_facturacion IN &_ocursorSQL
					replace codigo_postal WITH _codigo_postal IN &_ocursorSQL
					replace id_ABM_Localidades WITH _id_ABM_Localidades IN &_ocursorSQL
					replace id_ABM_Provincias WITH _id_ABM_Provincias IN &_ocursorSQL
					replace id_ABM_Ciudades WITH _id_ABM_Ciudades IN &_ocursorSQL
					replace id_ABM_Municipios WITH _id_ABM_Municipios IN &_ocursorSQL
					replace documento WITH _documento IN &_ocursorSQL
					replace id_ABM_Regiones_1 WITH _id_ABM_Regiones_1 IN &_ocursorSQL
					replace Fecha_de_nacimiento WITH _Fecha_de_nacimiento IN &_ocursorSQL
					replace clave_impositiva WITH _clave_impositiva IN &_ocursorSQL
					replace telefono_1 WITH _telefono_1 IN &_ocursorSQL
					replace telefono_2 WITH _telefono_2 IN &_ocursorSQL
					replace telefono_3 WITH _telefono_3 IN &_ocursorSQL
					replace radio WITH _radio IN &_ocursorSQL
					replace fax WITH _fax IN &_ocursorSQL
					replace email WITH _email IN &_ocursorSQL
					replace contacto_1 WITH _contacto_1 IN &_ocursorSQL
					replace cargo_1 WITH _cargo_1 IN &_ocursorSQL
					replace email_1 WITH _email_1 IN &_ocursorSQL
					replace contacto_2 WITH _contacto_2 IN &_ocursorSQL
					replace cargo_2 WITH _cargo_2 IN &_ocursorSQL
					replace email_2 WITH _email_2 IN &_ocursorSQL
					replace contacto_3 WITH _contacto_3 IN &_ocursorSQL
					replace cargo_3 WITH _cargo_3 IN &_ocursorSQL
					replace email_3 WITH _email_3 IN &_ocursorSQL
					replace website WITH _website IN &_ocursorSQL
					replace logo_cliente WITH _logo_cliente IN &_ocursorSQL
					replace id_ABM_Calificacion_de_Clientes WITH _id_ABM_Calificacion_de_Clientes IN &_ocursorSQL
					replace id_ABM_Categoria_impositiva WITH _id_ABM_Categoria_impositiva IN &_ocursorSQL
					replace retencion_fuente WITH _retencion_fuente IN &_ocursorSQL
					replace retencion_iva WITH _retencion_iva IN &_ocursorSQL
					replace retencion_ica WITH _retencion_ica IN &_ocursorSQL
					replace id_ABM_Asientos_automaticos_ventas WITH _id_ABM_Asientos_automaticos_ventas IN &_ocursorSQL
					replace id_ABM_Cuentas_Contables WITH _id_ABM_Cuentas_Contables IN &_ocursorSQL
					replace id_ABM_Politica_de_Precios_Articulos WITH _id_ABM_Politica_de_Precios_Articulos IN &_ocursorSQL
					replace id_ABM_Politica_de_Precios_Servicios WITH _id_ABM_Politica_de_Precios_Servicios IN &_ocursorSQL
*					replace plan_de_fidelizacion WITH _ IN &_ocursorSQL
&&& HASTA ACA
*					replace  WITH _ IN &_ocursorSQL

					replace activo WITH _activo IN &_ocursorSQL
					replace observaciones WITH _observaciones IN &_ocursorSQL
					replace datetime WITH _datetime IN &_ocursorSQL
					replace ultimo_cambio WITH _ultimo_cambio IN &_ocursorSQL
					replace eliminado WITH _eliminado IN &_ocursorSQL
					replace ui WITH _ui IN &_ocursorSQL
					replace sincronizacion WITH _sincronizacion IN &_ocursorSQL
					replace version WITH version + 1 IN &_ocursorSQL			
					replace id_ABM_empresas WITH _xempresa IN &_ocursorSQL
					replace id_ABM_regiones WITH _xregion IN &_ocursorSQL
					replace id_ABM_usuarios WITH _xusuario IN &_ocursorSQL
					replace id_ABM_ultimo_usuario WITH _xusuario IN &_ocursorSQL
			**		replace  WITH _
						conta_nuevos = conta_nuevos + 1
	ELSE
						conta_ya_existentes	= conta_ya_existentes + 1			
	ENDIF 

	IF osinmensajes = 0	
	WAIT windows 'Procesando tabla: ' +  _otabla + CHR(13) +  'cantidad en DBF: ' + ALLTRIM(STR(_totales_en_dbf )) ;
	+ CHR(13) + 'cantidad en SQL: ' + ALLTRIM(STR(_totales_en_sql )) + CHR(13) + ; 
	'Procesando: ' + ALLTRIM(STR(conta)) + ' de ' + ALLTRIM(STR(_totales_en_dbf)) + CHR(13) + ;
	'Nuevos Cargados a SQL: ' + ALLTRIM(STR(conta_nuevos)) + CHR(13) + ;
	'Nuevos con error al grabar: ' + ALLTRIM(STR(conta_nuevos_error)) + chr(13) + ;
	'Ya existentes en SQL: ' + alltrim(STR(conta_ya_existentes)) + chr(13) + ;
	'Eliminados: ' + STR(conta_eliminados) + ' - Activos: ' + STR(conta_activos)  NOWAIT noclear
	endif
	SELECT &_otabla
ENDSCAN 

SELECT &_ocursorSQL
*browse

*&&&&&&&&&&&&&&&&&&&&&&&&&&& GUARDAR &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

		odb_connect()
		IF oDb.CursorChanges(_ocursorSQL)
**			* Obtener la clave del cliente (CODIGO UNICO CONSECUTIVO -  ESTO ES PARA NUMEROS DE FOLIO!!!!!!), para ello usaremos la función CODE() de FoxyDB
**			* Es muy importante recordar que primero se debe obtener el valor, luego remplazarlo en el campo
**			* y posteriormente actualizar la tabla, y todo esto se debe hacer al final ya cuando se va a guardar
**			* y no sea necesaria la intervención del usuario para que la transacción dure lo menos posible.
**			* Hay dos formas de obtener el valor, un usando una tabla global para todos las claves o
**			* la otra forma es usar un tabla especifica por cada catalogo que se requiera obtener una clave única consecutiva
**			* Usando una tabla llamada correlativos donde por registro actualizamos el consecutivo de clientes
**			
**			* No debe existir ningún MesaggeBox() o Wait, en el proceso de guardado de un registro
**			* para que la transacción dure muy poco, solo los pongo de ejemplo para que vean paso a paso.
**			
**			* Verificar que sea un registro nuevo
*				IF oDb_abm_provincias.id = 0
*					IF oDb.Code("correlativos","folio","tabla","'oDb_abm_provincias'",10)
*						MESSAGEBOX( ;
**							"Consecutivo Obtenido Correctamente: " + PadL(oDb.id_Code, 10, "0") ;
**							, 0+64 ;
**							, "Valor devuelto por Code(): " + ALLTRIM(STR(oDb.error_Code));
**							)
**						replace oDb_abm_provincias.cliente_clave WITH PadL(thisform.oDb.id_Code, 10, "0") in clientes
**					ELSE
**						MESSAGEBOX( ;
**								"Mensaje Personalizado: No se puedo Actualizar la Tabla Clientes"	;
**								+ CHR(13) + "Comando Sql Enviado: " + CHR(13) + thisform.oDb.sql_Send , ;
**								0+16, ;
**								"Codigo de Error devuelto por Code(): " + ALLTRIM(STR(thisform.oDb.error_Code)) ;
**								)
**						RETURN .f.
**				    ENDIF
**				ENDIF
**			* Actualizar Cursor en el Servidor		
				IF oDb.Update(_ocursorSQL,.t.)		&& .t. es para obtener el ultimo ID insertado
*					MESSAGEBOX( ;
							"Tabla " + _otabla + ", Actualizada Correctamente", ;
							0+64, ;
							"Valor devuelto por Update(): " + ALLTRIM(STR(oDb.error_Code));
							)
					* Guardar cambios en el servidor (Commit)
						IF oDb.Commit()
*							MESSAGEBOX( ;
									"Cambios Guardados en la Tabla " + _ocursorSQL + " Correctamente", ;
									0+64, ;
									"Valor devuelto por Commit(): " + ALLTRIM(STR(oDb.error_Code));
									)
*							* Refrescar Cursor Guardado, si es un registro nuevo el valor para 
*							* id_Last será el devuelto, pero si se está editando un registro será CERO
*							* La función .Refresh() tiene programado identificar esta situación y consultar
*							* el registro a partir del valor ID si no fue nuevo el registro.
*
								oDb.Refresh(_ocursorSQL,oDb.id_Last)
*
*							* Mostrar Datos y desactivar los Campos
*								thisform.m_Campos(.t.,.f.)
*							* No editar registro
*								thisform.p_editar = .f.
						ELSE
*							* Como Hubo un error es necesario cancelar la transacción que se activo y después 
*							* Mandar el mensaje, NUNCA enviar el mensaje y después cancelar la transacción.
								oDb.Rollback()
							IF osinmensajes = 0
							MESSAGEBOX( ;
									"Mensaje Personalizado: No se pudieron Guardar los cambios de la Tabla " + _otablasql, ;
									0+16, ;
									"Código de Error devuelto por Save(): " + ALLTRIM(STR(oDb.error_Code)) ;
									)			
							ENDIF 					
						ENDIF
				ELSE
					IF osinmensajes = 0
					MESSAGEBOX( ;
							"Mensaje Personalizado: No se pudo Actualizar la Tabla " + _otablasql, ;
							0+16, ;
							"Codigo de Error devuelto por Update(): " + ALLTRIM(STR(oDb.error_Code)) ;
							)
					ENDIF 		
				ENDIF
		ELSE
*			MESSAGEBOX(;
					"No ha realizado cambios en la tabla " + _otablasql ,0+64,	;
					"Sin Cambios!"	;
				)
			IF osinmensajes = 0	
			WAIT WINDOW "No ha realizado cambios en la tabla " + _otablasql NOWAIT 
			ENDIF 
		ENDIF
*	ELSE
*		MESSAGEBOX(;
*				"No hay registro para Guardar",0+64,	;
*				"Sin Cambios!"	;
*			)
*	ENDIF

&&&&&&&&&&&&&&&&&&&&&&&&&&& FIN GUARDAR &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	IF osinmensajes = 0
	WAIT windows 'Procesando tabla: ' +  _otabla + CHR(13) +  'cantidad en DBF: ' + ALLTRIM(STR(_totales_en_dbf )) ;
	+ CHR(13) + 'cantidad en SQL: ' + ALLTRIM(STR(_totales_en_sql )) + CHR(13) + ; 
	'Procesando: ' + ALLTRIM(STR(conta)) + ' de ' + ALLTRIM(STR(_totales_en_dbf)) + CHR(13) + ;
	'Nuevos Cargados a SQL: ' + ALLTRIM(STR(conta_nuevos)) + CHR(13) + ;
	'Nuevos con error al grabar: ' + ALLTRIM(STR(conta_nuevos_error)) + chr(13) + ;
	'Ya existentes en SQL: ' + alltrim(STR(conta_ya_existentes)) + chr(13) + ;
	'Eliminados: ' + STR(conta_eliminados) + ' - Activos: ' + STR(conta_activos) + CHR(13) + 'LISTO!' NOWAIT &&noclear
	ENDIF 
*	WAIT windows 'Procesando tabla: ' +  _otabla + CHR(13) +  'cantidad en DBF: ' + ALLTRIM(STR(_totales_en_dbf )) ;
*	+ CHR(13) + 'cantidad en SQL: ' + ALLTRIM(STR(_totales_en_sql )) + CHR(13) + ; 
*	'Procesando: ' + ALLTRIM(STR(conta)) + ' de ' + ALLTRIM(STR(_totales_en_dbf)) + CHR(13) + ;
*	'Nuevos Cargados a SQL: ' + ALLTRIM(STR(conta_nuevos)) + CHR(13) + ;
*	'Nuevos con error al grabar: ' + ALLTRIM(STR(conta_nuevos_error)) + chr(13) + ;
*	'Ya existentes en SQL: ' + alltrim(STR(conta_ya_existentes)) + CHR(13) + 'LISTO!' NOWAIT &&noclear


	ca_log_pasar_datos_de_empresa_a_sql('Finalizado - Tabla ' + _otabla)
	ca_log_pasar_datos_de_empresa_a_sql('cantidad en DBF: ' + ALLTRIM(STR(_totales_en_dbf )))
	ca_log_pasar_datos_de_empresa_a_sql('cantidad en SQL: ' + ALLTRIM(STR(_totales_en_sql )))
	ca_log_pasar_datos_de_empresa_a_sql('Nuevos Cargados a SQL: ' + ALLTRIM(STR(conta_nuevos)))
	ca_log_pasar_datos_de_empresa_a_sql('Nuevos con error al grabar: ' + ALLTRIM(STR(conta_nuevos_error)))
	ca_log_pasar_datos_de_empresa_a_sql('Ya existentes en SQL: ' + alltrim(STR(conta_ya_existentes)))
	ca_log_pasar_datos_de_empresa_a_sql('***')

	oDb.Disconnect()
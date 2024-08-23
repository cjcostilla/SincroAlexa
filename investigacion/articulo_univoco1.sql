LPARAMETERS osinmensajes

  SET TABLEPROMPT OFF 
  SET CPDIALOG OFF
  SET DELETED OFF
  
*_xrutadato*_xempresa*_xusuario *_xregion*_xrubro*_xmoneda*_xexportado 

RELEASE _otabla
PUBLIC _otabla
RELEASE _otabla1
PUBLIC _otabla1
RELEASE _otablaSQL
PUBLIC _otablaSQL
RELEASE _ocursorSQL
PUBLIC _ocursorSQL

_otabla = 'articulo_univoco1'
_otablaSQL = 'abm_articulo_univoco'
_ocursorSQL = 'SQL_abm_articulo_univoco'
_otabla1 = 'depósitos'

IF USED(_otabla)
	USE IN &_otabla
ENDIF
IF USED(_otabla1)
	USE IN &_otabla1
ENDIF
IF USED(_ocursorSQL)
	USE IN &_ocursorSQL
ENDIF

SET DEFAULT TO SYS(5) + CURDIR()
Set Path To oDbsql,forms,class,menu,graphics,data,execute,Execute,Informes,PRG,System,Wizards  ADDITIVE
SET DELETED off

IF !USED(_otabla) AND !USED(UPPER(_otabla))
	sql_oDb_abrir_tabla_dbf(_otabla)
ENDIF
IF !USED(_otabla1)
	sql_oDb_abrir_tabla_dbf(_otabla1)
ENDIF

IF osinmensajes = 0
WAIT windows 'Procesando tabla ' + _otabla + CHR(13) + '_xempresa: ' + ALLTRIM(STR(_xempresa)) NOWAIT noclear
SELECT articulo_univoco1
ENDIF 
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&	odb_connect()
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*_otabla = 'articulo_univoco1'
*_otablaSQL = 'abm_articulo_univoco'
*_ocursorSQL = 'SQL_abm_articulo_univoco'
*ca_log_pasar_datos_de_empresa_a_sql('Procesando tabla: ' + _otabla)
	*dd = oDb.Query("Select * from " + _otablaSQL, _ocursorSQL, _otablaSQL)
	oDb.Query("Select * from " + _otablaSQL + " where id_ABM_empresas = " + ALLTRIM(STR(_xempresa)), _ocursorSQL,  _otablaSQL)		
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
*BROWSE
*
*RETURN

SELECT &_otabla
COUNT TO _totales_en_dbf 

SELECT &_ocursorSQL
COUNT TO _totales_en_sql FOR id_ABM_empresas = _xempresa
*BROWSE

*IF _xvaciar_tablas = 1 AND _totales_en_sql > 0
	SELECT &_ocursorSQL
	DELETE ALL for id_ABM_empresas = _xempresa
		odb_connect()
*	oDb.Update(_ocursorSQL)
	oDb.Commit()
* 	=TABLEUPDATE(.t., .t.)	
*ENDIF 

IF osinmensajes = 0
WAIT windows 'Procesando tabla: ' +  _otabla + CHR(13) +  'cantidad en DBF = ' + ALLTRIM(STR(_totales_en_dbf )) ;
+ CHR(13) + 'cantidad en SQL = ' + ALLTRIM(STR(_totales_en_sql )) NOWAIT noclear
ENDIF 
*ca_log_pasar_datos_de_empresa_a_sql('Procesando tabla ' + _ocursorSQL)

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

IIF(LEN(ALLTRIM(stock1.rubro)) = 0, 0, SQL_oDb_funcion_ID('ABM_Rubros', ALLTRIM(stock1.rubro)))                                                       
SCAN 

	conta = conta + 1
	_codigoX_automatico = _codigoX_automatico + 1
		
		_ids = ids
		_serial = ALLTRIM(serial)
		_rfid = alltrim(rfid)
		_codbar = ALLTRIM(codbar)
		_id_ABM_Depositos = numdep
		_id_ABM_Depositos_ACTUAL = numdep_actual 
		_id_ABM_Articulos = numartic
		_identificados = identificados
		_id_ABM_Empleados_del_cliente = id_usuario
		&& averiguar idcliente
		_numdep = numdep
		SELECT &_otabla1 && depósitos
		IF SEEK(_numdep, _otabla1, "num")
			_id_ABM_Clientes = idcliente 	
			_articulo_propio = propio
		ELSE
			_id_ABM_Clientes = 0
			_articulo_propio = 1
		ENDIF 
		SELECT &_otabla && articulo_univoco
		&& 
		_id_ABM_Tipos_de_comprobante_ULTIMO = tipo_comprobante_ultimo 
		_numero_comprobante_ultimo = numero_comprobante_ultimo
		_ultima_lectura = ultima_lectura
		_Sincronizar = 1
		_observaciones = observaciones
		_datetime = iddt
		_ultimo_cambio = DATETIME()
		_ui = odb.uuid()
		SELECT &_otabla && articulo_univoco
		_sincronizacion = ids

	IF DELETED()	
		conta_eliminados = conta_eliminados + 1 
		_eliminado = 1
		_activo = 1
	ELSE
		conta_activos = conta_activos + 1		
		_eliminado = 0
		_activo = 0
	ENDIF 

	_CODIGOQ = PADL(ALLTRIM(str(_codigoX_automatico)),4, '0')
*	_id_ABM_localidad = oDb_funcion_ID('ABM_localidades', ALLTRIM(localidad))
*	_id_ABM_Provincia = oDb_funcion_ID('ABM_provincias', ALLTRIM(provincia))


*	SELECT oDb_abm_BANCOS.nombre FROM oDb_abm_BANCOS ;
*	WHERE ALLTRIM(UPPER(oDb_abm_BANCOS.nombre)) = _denominacion AND id_ABM_empresas = _xempresa ;	
*	INTO CURSOR oDb_abm_BANCOS_cursor
*	COUNT TO _cuantos 
*	
*	IF _cuantos = 0
		SELECT 	&_ocursorSQL
		APPEND BLANK
		replace serial WITH _serial IN &_ocursorSQL
		replace rfid WITH _rfid IN &_ocursorSQL
		replace codbar WITH _codbar IN &_ocursorSQL
		replace id_ABM_Depositos WITH _id_ABM_Depositos IN &_ocursorSQL
		replace id_ABM_Depositos_ACTUAL WITH _id_ABM_Depositos_ACTUAL IN &_ocursorSQL
		replace id_ABM_Articulos WITH _id_ABM_Articulos IN &_ocursorSQL
		replace activo WITH _activo IN &_ocursorSQL
		replace identificados WITH _identificados IN &_ocursorSQL
		replace id_ABM_Empleados_del_cliente WITH _id_ABM_Empleados_del_cliente IN &_ocursorSQL
		replace id_ABM_Clientes WITH _id_ABM_Clientes IN &_ocursorSQL
		replace articulo_propio WITH _articulo_propio IN &_ocursorSQL
		replace id_ABM_Tipos_de_comprobante_ULTIMO WITH _id_ABM_Tipos_de_comprobante_ULTIMO IN &_ocursorSQL
		replace numero_comprobante_ultimo WITH _numero_comprobante_ultimo IN &_ocursorSQL
		replace ultima_lectura WITH _ultima_lectura IN &_ocursorSQL
		replace Sincronizar WITH _Sincronizar IN &_ocursorSQL
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
*		replace nombre WITH _denominacion IN &_ocursorSQL
*		replace observaciones WITH '' IN &_ocursorSQL &&_CIUDAD  		ojo, hay que hacer toda la rutina
**		replace  WITH _
			conta_nuevos = conta_nuevos + 1
*	ELSE
*			conta_ya_existentes	= conta_ya_existentes + 1			
*	ENDIF 
	IF osinmensajes = 0
	WAIT windows 'Procesando tabla: ' +  _otabla + CHR(13) +  'cantidad en DBF: ' + ALLTRIM(STR(_totales_en_dbf )) ;
	+ CHR(13) + 'cantidad en SQL: ' + ALLTRIM(STR(_totales_en_sql )) + CHR(13) + ; 
	'Procesando: ' + ALLTRIM(STR(conta)) + ' de ' + ALLTRIM(STR(_totales_en_dbf)) + CHR(13) + ;
	'Nuevos Cargados a SQL: ' + ALLTRIM(STR(conta_nuevos)) + CHR(13) + ;
	'Nuevos con error al grabar: ' + ALLTRIM(STR(conta_nuevos_error)) + chr(13) + ;
	'Ya existentes en SQL: ' + alltrim(STR(conta_ya_existentes)) + chr(13) + ;
	'Eliminados: ' + STR(conta_eliminados) + ' - Activos: ' + STR(conta_activos)  NOWAIT noclear
	ENDIF 
	
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
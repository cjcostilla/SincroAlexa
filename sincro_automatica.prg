FUNCTION Sincro_Automatica_Dbf_Sql(cTablaSincro)
	* Configurar FoxyDB para la conexi�n a la base de datos MySQL
	LOCAL lbEsClave
	odb = NEWOBJECT("foxydb", "d:\borrar\foxydb\foxydb.prg")
	IF odb.CONNECTION("{MySQL ODBC 5.1 Driver}","localhost","root","alexa","alexa","3306")
		* conexi�n fue exitosa
	ELSE
		= MESSAGEBOX("NO Conectado",16,"ERROR")
	ENDIF
	*************************************

	*!*		_oconectar_250516 = .T.
	*!*		TRY
	*!*			IF odb.Connected()
	*!*				_oconectar_250516 = .F
	*!*			ENDIF
	*!*		CATCH TO oex
	*!*		ENDTRY

	*!*		IF _oconectar_250516 = .T.
	*!*			DO SYS(5) + 'oDbsql/odb_connect'
	*!*		ENDIF
	*************************************
	=ObtenerEmpresa()
	* Consultar la tabla de auditor�a para obtener los cambios pendientes
	SELECT * FROM auditoria ;
		WHERE RTRIM(UPPER(tabla))=RTRIM(UPPER(cTablaSincro)) AND procesado = .F. ;
		INTO CURSOR cursorAuditoria
	SELECT cursorAuditoria
	SCAN
		cSetMySQL = ""
		cWhereMySQL = ""
		lcCampoPer = ""
		lcValorPer = ""
		* Obtener detalles del cambio
		cTablaVFP = RTRIM(UPPER(cursorAuditoria.tabla))
		cAccion = RTRIM(cursorAuditoria.operacion)
		cCampos = cursorAuditoria.campos
		nId = cursorAuditoria.ID
		* Convertir cCampos a un formato utilizable (JSON)
		LOCAL ARRAY aCampos[1,1]
		ParseJson(cCampos,@aCampos)
		* Obtener el nombre de la tabla mapeada en MySQL
		cTablaMySQL = ObtenerMapeo(cTablaVFP, "", "tabla")
		* Construir la sentencia SQL correspondiente
		DO CASE
			CASE cAccion == "INSERT"
				* Crear listas de campos y valores mapeados
				cCamposMySQL = ""
				cValoresMySQL = ""
				FOR i = 1 TO ALEN(aCampos,1)
					cCampoVFP = aCampos[i, 1]
					cCampoMySQL = ObtenerMapeo(cTablaVFP, cCampoVFP, "campo")
					IF EMPTY(cCampoMySQL)
						LOOP
					ENDIF
					cValorMySQL = aCampos[i, 2]
					IF VARTYPE(cValorMySQL) <> "N"
						IF (cValorMySQL = "TRUE" OR cValorMySQL = "FALSE")
							cValorMySQL =  IIF(cValorMySQL="TRUE",1,0)
						ELSE
							cValorMySQL = "'" + cValorMySQL + "'"
						ENDIF
					ENDIF
					cCamposMySQL = cCamposMySQL + cCampoMySQL + ","
					cValoresMySQL = cValoresMySQL + TRANSFORM(cValorMySQL) + ","
				ENDFOR
				_sincroaui = odb.uuid()
				ObtenerMapeoPersonalizado(cTablaVFP, @lcCampoPer, @lcValorPer, "I")
				cCamposMySQL = cCamposMySQL + lcCampoPer
				cValoresMySQL = cValoresMySQL + lcValorPer
				* Remover la �ltima coma
				cCamposMySQL = LEFT(cCamposMySQL, LEN(cCamposMySQL) - 1)
				cValoresMySQL = LEFT(cValoresMySQL, LEN(cValoresMySQL) - 1)
				cSQL = "INSERT INTO " + cTablaMySQL + " (" + cCamposMySQL + ") VALUES (" + cValoresMySQL + ")"
			CASE cAccion == "UPDATE"
				* Crear lista de campos y valores mapeados para el SET
				FOR i = 1 TO ALEN(aCampos,1)
					cCamposMySQL = ObtenerMapeo(cTablaVFP, aCampos[i, 1], "campo", @lbEsClave)
					cValoresClaveMySQL = aCampos[i, 2]
					IF EMPTY(cCamposMySQL)
						LOOP
					ENDIF
					cValoresMySQL = aCampos[i, 2]
					IF VARTYPE(cValoresMySQL) <> "N"
						IF (cValoresMySQL = "TRUE" OR cValoresMySQL = "FALSE")
							cValoresMySQL =  IIF(cValoresMySQL="TRUE",1,0)
						ELSE
							cValoresMySQL = "'" + cValoresMySQL + "'"
						ENDIF
					ENDIF
					cSetMySQL = cSetMySQL + cCamposMySQL + " = " + TRANSFORM(cValoresMySQL) + ","
					IF lbEsClave
						IF VARTYPE(cValoresClaveMySQL) <> "N"
							IF (cValoresClaveMySQL = "TRUE" OR cValoresClaveMySQL = "FALSE")
								cValoresClaveMySQL =  IIF(cValoresClaveMySQL = "TRUE",1,0)
							ELSE
								cValoresClaveMySQL = "'" + cValoresClaveMySQL + "'"
							ENDIF
						ENDIF
						cWhereMySQL = cWhereMySQL + cCamposMySQL + " = " + TRANSFORM(cValoresClaveMySQL) + " AND "
					ENDIF
				ENDFOR
				_sincroaui= odb.uuid()
				ObtenerMapeoPersonalizado(cTablaVFP, @lcCampoPer, @lcValorPer, "U")
				cSetMySQL = cSetMySQL + lcCampoPer
				* Remover la �ltima coma
				cWhereMySQL = LEFT(cWhereMySQL, LEN(cWhereMySQL) - 4)
				cSetMySQL = LEFT(cSetMySQL, LEN(cSetMySQL) - 1)
				cSQL = "UPDATE " + cTablaMySQL + " SET " + cSetMySQL + " WHERE " + cWhereMySQL
			CASE cAccion == "DELETE"
				FOR i = 1 TO ALEN(aCampos,1)
					cCampoVFP = aCampos[i, 1]
					cCampoMySQL = ObtenerMapeo(cTablaVFP, cCampoVFP, "campo", @lbEsClave)
					IF !lbEsClave
						LOOP
					ENDIF
					cValorMySQL = aCampos[i, 2]
					IF VARTYPE(cValorMySQL) <> "N"
						IF (cValorMySQL = "TRUE" OR cValorMySQL = "FALSE")
							cValorMySQL =  IIF(cValorMySQL="TRUE",1,0)
						ENDIF
					ENDIF

					IF VARTYPE(cValorMySQL) == "C"
						cValorMySQL = "'" + cValorMySQL + "'"
					ENDIF
					cWhereMySQL = cWhereMySQL + cCampoMySQL + " = " + TRANSFORM(cValorMySQL) + " AND "
				ENDFOR
				cWhereMySQL = LEFT(cWhereMySQL, LEN(cWhereMySQL) - 4)
				cSQL = "DELETE FROM " + cTablaMySQL + " WHERE " + cWhereMySQL
		ENDCASE
		* Ejecutar la sentencia SQL en MySQL
		**************************
		curTablaSql = cTablaMySQL
		cEjecutar = "Select * from " + cTablaMySQL + " where " + IIF(EMPTY(cWhereMySQL), " 2 = 1", cWhereMySQL)
		_CLIPTEXT=cSQL
		odb.QUERY(cEjecutar, curTablaSql,cTablaMySQL)
		IF odb.CursorOpen(curTablaSql)
			IF odb.CursorEdit(curTablaSql)
				&cSQL
				IF odb.CursorChanges(curTablaSql)
					IF odb.UPDATE(curTablaSql,.T.)
						IF odb.Commit()
							UPDATE auditoria SET procesado = .T. WHERE ID = nId
						ELSE
							MESSAGEBOX("Error en el COMMIT de la tabla: "+ curTablaSql)
						ENDIF
					ELSE
						MESSAGEBOX("Error en el UPDATE de la tabla: "+ curTablaSql)
					ENDIF
				ELSE
					MESSAGEBOX("Error en el CURSORCHANGES de la tabla: "+ curTablaSql)
				ENDIF
			ELSE
				MESSAGEBOX("No esta Editable la tabla: "+ curTablaSql)
			ENDIF
		ELSE
			MESSAGEBOX("No esta Abierto el cursor: "+ curTablaSql)
		ENDIF
	ENDSCAN
	* Cerrar la conexi�n a MySQL
	RELEASE _sincroaempresa, _sincroaregion, _sincroausuario, _sincroarutadato, _sincroaui
	USE IN cursorAuditoria
	USE IN auditoria 
	USE IN &curTablaSql
	USE IN dbcursor
	odb.Disconnect()
	RETURN .T.
ENDFUNC

FUNCTION CodigoAutomatico(cTablaVFP)
	LOCAL cCodigo, nUltimoCodigo
	LOCAL cSeteoActual
	* Guardar el valor actual de SET DELETE
	cSeteoActual = SET("DELETE")
	* Cambiar el valor de SET DELETE
	SET DELETE OFF
	* Busca el �ltimo c�digo registrado en la tabla
	SELECT COUNT(*) AS UltimoCodigo;
		FROM &cTablaVFP INTO CURSOR curCodigoAuto
	* Si no hay registros, comienza desde 1
	IF ISNULL(curCodigoAuto.UltimoCodigo)
		cCodigo = "0001"
	ELSE
		* Incrementa el �ltimo c�digo en 1
		nUltimoCodigo = curCodigoAuto.UltimoCodigo + 1
		* Formatea el c�digo a 4 d�gitos con ceros a la izquierda
		cCodigo = PADL(ALLTRIM(STR(nUltimoCodigo)), 4, "0")
	ENDIF
	* Restaurar el valor anterior de SET DELETE
	SET DELETE &cSeteoActual
	USE IN curCodigoAuto
	RETURN cCodigo
ENDFUNC

FUNCTION ObtenerEmpresa()
	PUBLIC _sincroaempresa, _sincroaregion, _sincroausuario, _sincroarutadato, _sincroaui
	*Db_abrir_tabla_dbf(_otabla)
	IF !USED("EMPRESAS")
		SELECT 0
		USE EMPRESAS
	ENDIF
	SELECT EMPRESAS
	LOCATE FOR ATC('SINCRO',nombre) > 0
	_sincroaempresa = EMPRESAS.IDS
	_xempresa = _sincroaempresa
	_sincroausuario = 999
	_xusuario = _sincroausuario
	_xexportado = .T.
	_sincroaui=''
	_xrutadato = ALLTRIM(UPPER(EMPRESAS.DIRECTORIO))
	_xrutalog = UPPER('c:\aplicaciones\programas\nuevossistemas\')
	DO CASE
		CASE ALLTRIM(EMPRESAS.NUM3) = "ARGENTINA"
			_sincroaregion = 1
			_xmoneda = 1
			Xcadenamoneda = 'PESO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "M�XICO"
			_sincroaregion = 2
			_xmoneda = 10
			Xcadenamoneda = 'PESO MEXICANO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "COLOMBIA"
			_sincroaregion = 3
			_xmoneda = 12
			Xcadenamoneda = 'PESO COLOMBIANO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "VENEZUELA"
			_sincroaregion = 4
			_xmoneda = 4
			Xcadenamoneda = 'BOLIVAR'
		CASE ALLTRIM(EMPRESAS.NUM3) = "E.E.U.U."
			_sincroaregion = 5
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(EMPRESAS.NUM3) = "CHILE"
			_sincroaregion = 6
			_xmoneda = 11
			Xcadenamoneda = 'PESO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "BRASIL"
			_sincroaregion = 7
			_xmoneda = 3
			Xcadenamoneda = 'REAL'
		CASE ALLTRIM(EMPRESAS.NUM3) = "COSTA RICA"
			_sincroaregion = 8
			_xmoneda = 5
			Xcadenamoneda = 'COLON'
		CASE ALLTRIM(EMPRESAS.NUM3) = "PARAGUAY"
			_sincroaregion = 9
			_xmoneda = 6
			Xcadenamoneda = 'GUARANI'
		CASE ALLTRIM(EMPRESAS.NUM3) = "PERU"
			_sincroaregion = 10
			_xmoneda = 7
			Xcadenamoneda = 'SOL'
		CASE ALLTRIM(EMPRESAS.NUM3) = "PANAM�"
			_sincroaregion = 11
			_xmoneda = 8
			Xcadenamoneda = 'BALBOA'
		CASE ALLTRIM(EMPRESAS.NUM3) = "URUGUAY"
			_sincroaregion = 12
			_xmoneda = 9
			Xcadenamoneda = 'PESO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "BOLIVIA"
			_sincroaregion = 13
			_xmoneda = 13
			Xcadenamoneda = 'BOLIVIANO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "PUERTO RICO"
			_sincroaregion = 14
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(EMPRESAS.NUM3) = "HONDURAS"
			_sincroaregion = 15
			_xmoneda = 14
			Xcadenamoneda = 'LEMPIRA'
		CASE ALLTRIM(EMPRESAS.NUM3) = "NICARAGUA"
			_sincroaregion = 16
			_xmoneda = 15
			Xcadenamoneda = 'CORDOBA'
		CASE ALLTRIM(EMPRESAS.NUM3) = "ECUADOR"
			_sincroaregion = 17
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(EMPRESAS.NUM3) = "GUATEMALA"
			_sincroaregion = 18
			_xmoneda = 16
			Xcadenamoneda = 'QUETZAL'
		CASE ALLTRIM(EMPRESAS.NUM3) = "ESPA�A"
			_sincroaregion = 19
			_xmoneda = 17
			Xcadenamoneda = 'EURO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "REPUBLICA DOMINICANA"
			_sincroaregion = 20
			_xmoneda = 18
			Xcadenamoneda = 'PESO DOMINICANO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "BAHAMAS"
			_sincroaregion = 21
			_xmoneda = 19
			Xcadenamoneda = 'DOLAR BAHAME�O'
		CASE ALLTRIM(EMPRESAS.NUM3) = "EL SALVADOR"
			_sincroaregion = 22
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(EMPRESAS.NUM3) = "JAMAICA"
			_sincroaregion = 23
			_xmoneda = 20
			Xcadenamoneda = 'DOLAR JAMAIQUINO'
		CASE ALLTRIM(EMPRESAS.NUM3) = "CANADA"
			_sincroaregion = 24
			_xmoneda = 21
			Xcadenamoneda = 'DOLAR CANADIENSE'
		CASE ALLTRIM(EMPRESAS.NUM3) = "TRINIDAD Y TOBAGO"
			_sincroaregion = 25
			_xmoneda = 22
			Xcadenamoneda = 'DOLAR TRINITENSE'
		CASE ALLTRIM(EMPRESAS.NUM3) = "BELICE"
			_sincroaregion = 26
			_xmoneda = 23
			Xcadenamoneda = 'DOLAR BELICE�O'
		CASE ALLTRIM(EMPRESAS.NUM3) = "GUYANA"
			_sincroaregion = 27
			_xmoneda = 24
			Xcadenamoneda = 'DOLAR GUYANES'
		CASE ALLTRIM(EMPRESAS.NUM3) = "SURINAM"
			_sincroaregion = 28
			_xmoneda = 25
			Xcadenamoneda = 'DOLAR SURINAMES'
		CASE ALLTRIM(EMPRESAS.NUM3) = "HAITI"
			_sincroaregion = 29
			_xmoneda = 26
			Xcadenamoneda = 'GOURDE'
		OTHERWISE
			_sincroaregion = 99
			_xmoneda = 1
			Xcadenamoneda = 'PESO'
	ENDCASE

	DO CASE
		CASE ALLTRIM(EMPRESAS.OTROSIMP3) = "PUNTO DE VENTA"
			_xrubro = 0
		CASE ALLTRIM(EMPRESAS.OTROSIMP3) = "SEDE ADMINISTRATIVA"
			_xrubro = 1
		OTHERWISE
			_xrubro = 99
	ENDCASE
	USE IN EMPRESAS 
	RETURN .T.
ENDFUNC

FUNCTION ParseJson(tcJSON,aCampos)
	LOCAL lcKey, lcValue, lcJSON, lnPos, lnColonPos, lnCommaPos
	LOCAL ARRAY aCampos[1, 2]
	LOCAL lnIndex
	lnIndex = 1
	* Limpiar el JSON (quitar llaves y espacios)
	lcJSON = STRTRAN(STRTRAN(tcJSON, "{", ""), "}", "")
	DO WHILE !EMPTY(lcJSON)
		* Encontrar la posici�n de los delimitadores (dos puntos y coma)
		lnColonPos = AT(":", lcJSON)
		lnCommaPos = AT(",", lcJSON)
		* Extraer clave y valor
		lcKey = RTRIM(SUBSTR(lcJSON, 1, lnColonPos - 1))
		IF lnCommaPos > 0
			lcValue = RTRIM(SUBSTR(lcJSON, lnColonPos + 1, lnCommaPos - lnColonPos - 1))
			lcJSON = SUBSTR(lcJSON, lnCommaPos + 1)
		ELSE
			lcValue = RTRIM(SUBSTR(lcJSON, lnColonPos + 1))
			lcJSON = ""
		ENDIF
		* Quitar comillas de las claves y valores
		lcKey = STRTRAN(lcKey, '"', "")
		lcValue = STRTRAN(lcValue, '"', "")
		* Almacenar en el array
		lcTipoDato = TYPE(lcValue)
		DO CASE
			CASE lcTipoDato = "C"  && Car�cter
				lcValue = lcValue
			CASE lcTipoDato = "N"  && Num�rico
				lcValue = VAL(lcValue)
			CASE lcTipoDato = "D"  && Fecha
				lcValue = CTOD(lcValue)
			CASE lcTipoDato = "T"  && DateTime
				lcValue = CTOT(lcValue)
			CASE lcTipoDato = "L"  && L�gico
				lcValue = IIF(lcValue = "T", .T., .F.)
			CASE lcTipoDato = "M"  && Memo
				lcValue = MEMLINES(lcValue)
			OTHERWISE  && Otros tipos de datos
				lcValue = TRANSFORM(lcValue)
		ENDCASE
		DIMENSION aCampos[lnIndex, 2]
		aCampos[lnIndex, 1] = lcKey
		aCampos[lnIndex, 2] = lcValue
		lnIndex = lnIndex + 1
	ENDDO

	RETURN aCampos
ENDFUNC


FUNCTION ObtenerMapeo(tcTablaVFP, tcCampoVFP, tcTipo, lbEsClave)
	LOCAL lcMappedName
	* Buscar el nombre mapeado en la tabla de mapeo
	SELECT tabla_mysql, campo_mysql, clave;
		FROM mapeo ;
		WHERE UPPER(tabla_vfp) = tcTablaVFP AND UPPER(campo_vfp) = tcCampoVFP ;
		INTO CURSOR cursorMap

	* Inicializar el valor de retorno de es_clave
	lbEsClave = .F.
	* Devolver el nombre mapeado
	IF tcTipo == "tabla"
		lcMappedName = IIF(EOF(), tcTablaVFP, RTRIM(cursorMap.tabla_mysql))
	ELSE
		lcMappedName = IIF(EOF(), "", RTRIM(cursorMap.campo_mysql)) &&tcCampoVFP
		* Verificar si es clave
		IF NOT EOF()
			lbEsClave = cursorMap.clave
		ENDIF
	ENDIF
	USE IN CURSORMAP
	USE IN MAPEO
	RETURN lcMappedName
ENDFUNC


FUNCTION ObtenerMapeoPersonalizado(tcTablaVFP, lcCampoPer, lcValorPer, lcOperacion)
	LOCAL lcMappedName, lcPonerValor, lcPonerFuncion, lcResultadoFuncion
	lcCampoPer=''
	lcValorPer=''
	* Buscar el nombre mapeado, si es clave, y otros detalles en la tabla de mapeo
	SELECT tabla_mysql, campo_mysql, clave, poner_valor, poner_funcion;
		FROM mapeo ;
		WHERE ALLTRIM(UPPER(tabla_vfp)) = ALLTRIM(UPPER(tcTablaVFP));
		AND EMPTY(campo_vfp) ;
		INTO CURSOR cursorMap

	* Verificar si hay un registro encontrado
	SELECT cursorMap
	IF NOT EOF()
		SCAN
			lcMappedName = ""
			* Verificar si campo_vfp est� vac�o y campo_mysql tiene valor
			IF NOT EMPTY(cursorMap.campo_mysql)
				DO CASE
					CASE ALLTRIM(UPPER(cursorMap.campo_mysql)) == 'ID' AND lcOperacion = 'U'
						LOOP
					CASE ATC('CODIGOAUTOMATICO',ALLTRIM(UPPER(cursorMap.poner_funcion))) > 0 AND lcOperacion = 'U'
						LOOP
				ENDCASE
				* Intentar asignar valor de poner_valor
				lcPonerValor = cursorMap.poner_valor
				lcPonerFuncion = cursorMap.poner_funcion
				* Si poner_valor tiene contenido, usarlo
				IF NOT EMPTY(lcPonerValor)
					lcMappedName = lcPonerValor
				ELSE
					* Si poner_funcion tiene contenido, ejecutarla
					IF NOT EMPTY(lcPonerFuncion)
						lcResultadoFuncion = EVAL(lcPonerFuncion)
						lcMappedName = lcResultadoFuncion
					ENDIF
				ENDIF
				lcTipoDato = VARTYPE(lcMappedName)
				DO CASE
					CASE lcTipoDato = "C"  && Car�cter
						IF LEFT(lcMappedName,1) == '='
							lcMappedName = ALLTRIM(SUBSTR(lcMappedName,2))
						ELSE
							IF lcMappedName == "''" OR lcMappedName == '""'
								lcMappedName = "''"
							ELSE
								lcMappedName = "'" + ALLTRIM(lcMappedName) + "'"
							ENDIF
						ENDIF
					CASE lcTipoDato = "N"  && Num�rico
						lcMappedName = STR(lcMappedName)
					CASE lcTipoDato = "D"  && Fecha
						lcMappedName = "'" + RTRIM(DTOC(lcMappedName)) + "'"
					CASE lcTipoDato = "T"  && DateTime
						lcMappedName = "'" + RTRIM(TTOC(lcMappedName,3)) + "'"
					CASE lcTipoDato = "L"  && L�gico
						lcMappedName = IIF(lcMappedName , 1, 0)
					CASE lcTipoDato = "M"  && Memo
						lcMappedName = "'" + MEMLINES(lcMappedName) + "'"
					OTHERWISE  && Otros tipos de datos
						lcMappedName = TRANSFORM(lcMappedName)
				ENDCASE
				DO CASE
					CASE lcOperacion = "I"
						lcCampoPer = lcCampoPer + RTRIM(cursorMap.campo_mysql) + ','
						lcValorPer = lcValorPer + ALLTRIM(TRANSFORM(lcMappedName)) + ","
					CASE lcOperacion = "U"
						lcCampoPer = lcCampoPer + ;
							RTRIM(cursorMap.campo_mysql) + ' = ' + ALLTRIM(TRANSFORM(lcMappedName)) + ","
						IF cursorMap.clave
							cWhereMySQL = cWhereMySQL + RTRIM(cursorMap.campo_mysql) + ' = ' + ALLTRIM(TRANSFORM(lcMappedName)) + " AND "
						ENDIF
				ENDCASE
			ENDIF
		ENDSCAN
	ENDIF
	USE IN mapeo
	USE IN cursorMap
	RETURN lcMappedName
ENDFUNC

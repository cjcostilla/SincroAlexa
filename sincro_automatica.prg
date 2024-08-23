FUNCTION Sincro_Automatica_Dbf_Sql(cTablaDir)
	* Configurar FoxyDB para la conexi�n a la base de datos MySQL
	LOCAL lbEsClave
	odb = NEWOBJECT("foxydb", "foxydb.prg")
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
	* Consultar la tabla de auditor�a para obtener los cambios pendientes
	cTablaAuditoria = cTablaDir+"auditoria"
	
	SELECT * FROM &cTablaAuditoria WHERE procesado = .F. INTO CURSOR cursorAuditoria

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
		* Obtener el registro y abrir la tabla para obtener los datos
		xclave = ObtenerClaveTabla(cTablaVFP,cCampos)
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
							=GenerarBackup()
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
		SELECT cursorAuditoria
	ENDSCAN
	* Cerrar la conexi�n a MySQL
	RELEASE _sincroaempresa, _sincroaregion, _sincroausuario, _sincroarutadato, _sincroaui
	USE IN cursorAuditoria
	USE IN auditoria
	*USE IN &curTablaSql
	*USE IN dbcursor
	odb.Disconnect()
	RETURN .T.
ENDFUNC

FUNCTION ObtenerClaveTabla(cTablaVfp, cJason)
	cTabla=ALLTRIM(UPPER(cTablaVfp))
	lcJson = ALLTRIM(cJason)
	SELECT * FROM mapeo ;
		WHERE ALLTRIM(UPPER(tabla_vfp)) == cTabla;
		AND clave = .T.;
		AND ALLTRIM(UPPER(campo_mysql)) = "SINCRONIZACION" ;
		INTO CURSOR csrClave
	* Definir la clave que deseas buscar
	lcClave = '"'+ALLTRIM(UPPER(campo_vfp))+'":'
	* Buscar la posici�n de la clave en la cadena JSON
	lnPosClave = AT(lcClave, lcJson)
	lcValor = ''
	IF lnPosClave > 0
		* Extraer la parte de la cadena que contiene el valor de la clave
		lcSubcadena = SUBSTR(lcJson, lnPosClave + LEN(lcClave))
		* Extraer el valor entre el separador ":" y la coma siguiente
		lcValor = STREXTRACT(lcSubcadena, ":", ",", 1)
		* Si es el �ltimo elemento y no hay coma, buscamos hasta el cierre de llave
		IF EMPTY(lcValor)
			lcValor = STREXTRACT(lcSubcadena, ":", "}", 1)
		ENDIF
		* Eliminar posibles espacios en blanco o comillas
		lcValor = ALLTRIM(STRTRAN(lcValor, '"', ''))
		lcClave = ALLTRIM(STRTRAN(STRTRAN(lcClave, '"', ''), ':', ''))
		lcValor = lcClave + " = " + lcValor
	ENDIF
	RETURN lcValor
ENDFUNC

FUNCTION GenerarBackup
	LOCAL lnFechaUltimoBackup
	LOCAL lc_RutaBackup, lc_NombreArchivoBackup
	SELECT MIN(TTOD(fecha)) AS fecha;
		FROM auditoria INTO CURSOR curFechaBackup
	lnFechaUltimoBackup = curFechaBackup.fecha
	IF DATE() > lnFechaUltimoBackup AND !ISNULL(lnFechaUltimoBackup)
		* Definir la ruta y nombre de la carpeta y archivo de backup
		lc_RutaBackup = ALLTRIM(UPPER(EMPRESAS.DIRECTORIO)) + "AUDITORIAS\"
		lc_NombreArchivoBackup = "Auditoria" + ALLTRIM(STR(YEAR(lnFechaUltimoBackup)));
			+ ALLTRIM(STR(MONTH(lnFechaUltimoBackup)));
			+ ALLTRIM(STR(DAY(lnFechaUltimoBackup)));
			+ ALLTRIM(SUBSTR(EMPRESAS.NOMBRE,1,20)) + ".dbf"
		* Crear la carpeta de backup si no existe
		IF !DIRECTORY(lc_RutaBackup)
			MKDIR(lc_RutaBackup)
		ENDIF
		* Copiar la tabla de auditor�a a la carpeta de backup
		lcTablaBkp = lc_RutaBackup+lc_NombreArchivoBackup
		SELECT * FROM auditoria WHERE TTOD(fecha) < DATE() INTO TABLE (EVALUATE('lcTablaBkp'))
		* Vaciar la tabla original de auditor�a
		IF FLOCK("auditoria")
			USE IN auditoria
			USE auditoria EXCLUSIVE
			DELETE FROM auditoria WHERE fecha < DATE() AND procesado = .T.
			PACK
			USE auditoria SHARED
		ENDIF
		STRTOFILE(DTOC(DATE()) + " " + TIME() + " - Backup de Auditoria Realizado como: " + lcTablaBkp + CHR(13) + ;
			, "error_log.txt", .T.)
	ENDIF
	USE IN curFechaBackup
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
*	USE IN curCodigoAuto
	RETURN cCodigo
ENDFUNC

FUNCTION ObtenerEmpresa()
	PUBLIC _sincroaempresa, _sincroaregion, _sincroausuario, _sincroarutadato, _sincroaui
	SELECT csrEmpresas
	_sincroaempresa = csrEmpresas.IDS
	*_xempresa = _sincroaempresa
	_sincroausuario = 999
	*_xusuario = _sincroausuario
	*_xexportado = .T.
	_sincroaui=''
	*_xrutadato = ALLTRIM(UPPER(EMPRESAS.DIRECTORIO))
	*_xrutalog = UPPER('c:\aplicaciones\programas\nuevossistemas\')
	DO CASE
		CASE ALLTRIM(csrEmpresas.NUM3) = "ARGENTINA"
			_sincroaregion = 1
			_xmoneda = 1
			Xcadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "M�XICO"
			_sincroaregion = 2
			_xmoneda = 10
			Xcadenamoneda = 'PESO MEXICANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "COLOMBIA"
			_sincroaregion = 3
			_xmoneda = 12
			Xcadenamoneda = 'PESO COLOMBIANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "VENEZUELA"
			_sincroaregion = 4
			_xmoneda = 4
			Xcadenamoneda = 'BOLIVAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "E.E.U.U."
			_sincroaregion = 5
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "CHILE"
			_sincroaregion = 6
			_xmoneda = 11
			Xcadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BRASIL"
			_sincroaregion = 7
			_xmoneda = 3
			Xcadenamoneda = 'REAL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "COSTA RICA"
			_sincroaregion = 8
			_xmoneda = 5
			Xcadenamoneda = 'COLON'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PARAGUAY"
			_sincroaregion = 9
			_xmoneda = 6
			Xcadenamoneda = 'GUARANI'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PERU"
			_sincroaregion = 10
			_xmoneda = 7
			Xcadenamoneda = 'SOL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PANAM�"
			_sincroaregion = 11
			_xmoneda = 8
			Xcadenamoneda = 'BALBOA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "URUGUAY"
			_sincroaregion = 12
			_xmoneda = 9
			Xcadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BOLIVIA"
			_sincroaregion = 13
			_xmoneda = 13
			Xcadenamoneda = 'BOLIVIANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PUERTO RICO"
			_sincroaregion = 14
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "HONDURAS"
			_sincroaregion = 15
			_xmoneda = 14
			Xcadenamoneda = 'LEMPIRA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "NICARAGUA"
			_sincroaregion = 16
			_xmoneda = 15
			Xcadenamoneda = 'CORDOBA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "ECUADOR"
			_sincroaregion = 17
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "GUATEMALA"
			_sincroaregion = 18
			_xmoneda = 16
			Xcadenamoneda = 'QUETZAL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "ESPA�A"
			_sincroaregion = 19
			_xmoneda = 17
			Xcadenamoneda = 'EURO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "REPUBLICA DOMINICANA"
			_sincroaregion = 20
			_xmoneda = 18
			Xcadenamoneda = 'PESO DOMINICANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BAHAMAS"
			_sincroaregion = 21
			_xmoneda = 19
			Xcadenamoneda = 'DOLAR BAHAME�O'
		CASE ALLTRIM(csrEmpresas.NUM3) = "EL SALVADOR"
			_sincroaregion = 22
			_xmoneda = 2
			Xcadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "JAMAICA"
			_sincroaregion = 23
			_xmoneda = 20
			Xcadenamoneda = 'DOLAR JAMAIQUINO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "CANADA"
			_sincroaregion = 24
			_xmoneda = 21
			Xcadenamoneda = 'DOLAR CANADIENSE'
		CASE ALLTRIM(csrEmpresas.NUM3) = "TRINIDAD Y TOBAGO"
			_sincroaregion = 25
			_xmoneda = 22
			Xcadenamoneda = 'DOLAR TRINITENSE'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BELICE"
			_sincroaregion = 26
			_xmoneda = 23
			Xcadenamoneda = 'DOLAR BELICE�O'
		CASE ALLTRIM(csrEmpresas.NUM3) = "GUYANA"
			_sincroaregion = 27
			_xmoneda = 24
			Xcadenamoneda = 'DOLAR GUYANES'
		CASE ALLTRIM(csrEmpresas.NUM3) = "SURINAM"
			_sincroaregion = 28
			_xmoneda = 25
			Xcadenamoneda = 'DOLAR SURINAMES'
		CASE ALLTRIM(csrEmpresas.NUM3) = "HAITI"
			_sincroaregion = 29
			_xmoneda = 26
			Xcadenamoneda = 'GOURDE'
		OTHERWISE
			_sincroaregion = 99
			_xmoneda = 1
			Xcadenamoneda = 'PESO'
	ENDCASE

	DO CASE
		CASE ALLTRIM(csrEmpresas.OTROSIMP3) = "PUNTO DE VENTA"
			_xrubro = 0
		CASE ALLTRIM(csrEmpresas.OTROSIMP3) = "SEDE ADMINISTRATIVA"
			_xrubro = 1
		OTHERWISE
			_xrubro = 99
	ENDCASE
	RETURN .T.
ENDFUNC

FUNCTION ParseJson(tcJSON,aCampos)
	LOCAL lcKey, lcValue, lcJson, lnPos, lnColonPos, lnCommaPos
	LOCAL ARRAY aCampos[1, 2]
	LOCAL lnIndex
	lnIndex = 1
	* Limpiar el JSON (quitar llaves y espacios)
	lcJson = STRTRAN(STRTRAN(tcJSON, "{", ""), "}", "")
	DO WHILE !EMPTY(lcJson)
		* Encontrar la posici�n de los delimitadores (dos puntos y coma)
		lnColonPos = AT(":", lcJson)
		lnCommaPos = AT(",", lcJson)
		* Extraer clave y valor
		lcKey = RTRIM(SUBSTR(lcJson, 1, lnColonPos - 1))
		IF lnCommaPos > 0
			lcValue = RTRIM(SUBSTR(lcJson, lnColonPos + 1, lnCommaPos - lnColonPos - 1))
			lcJson = SUBSTR(lcJson, lnCommaPos + 1)
		ELSE
			lcValue = RTRIM(SUBSTR(lcJson, lnColonPos + 1))
			lcJson = ""
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
	USE IN cursorMap
	USE IN mapeo
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
			SELECT cursorMap
		ENDSCAN
	ENDIF
	USE IN mapeo
	USE IN cursorMap
	RETURN lcMappedName
ENDFUNC


FUNCTION SQL_oDb_funcion_ID(otabla, onombre, ofiltro)

	SET TABLEPROMPT OFF
	SET CPDIALOG OFF
	SET DELETED OFF
	SET TALK OFF
	SET CONSOLE OFF
	SET SAFETY OFF
	SET CONSOLE OFF
	TRY
		IF ofiltro = .F.
			_ofiltro = 0
		ENDIF
	CATCH TO oex
		_ofiltro = ofiltro
	FINALLY
	ENDTRY

	*WAIT WINDOW '_ofiltro: ' + STR(_ofiltro)

	IF LEN(ALLTRIM(onombre)) = 0
		RETURN 0
	ENDIF

	* WAIT WINDOW 'FUNCION - ' + 'otabla: ' + otabla + CHR(13) + 'onombre: ' + onombre

	_alias_funcion = ALIAS()

	*_otablaSQL_funcion = '_otablaSQL_funcion' + '_' + otabla

	RELEASE _otablaSQL_funcion
	PUBLIC _otablaSQL_funcion
	RELEASE _ocursorSQL_funcion
	PUBLIC _ocursorSQL_funcion
	RELEASE _codigomasaltoSQL
	PUBLIC _codigomasaltoSQL
	RELEASE _idsqlmasaltoSQL
	PUBLIC _idsqlmasaltoSQL

	*WAIT WINDOW '1 - otabla: ' + o tabla + CHR(13) + 'onombre: ' + onombre

	_otablaSQL_funcion = otabla
	_ocursorSQL_funcion = 'oDb_' + otabla
	_codigomasaltoSQL = 'Codigo_' + otabla
	_idsqlmasaltoSQL = 'Idsql_' + otabla
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&	odb_connect()
	_oresult = 0
	*************************************
	_onombre = UPPER(onombre)

	IF _ofiltro = 0
		DO CASE
			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_REGIONES"))
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onombre)) ", _ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 1" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_clientes"))
				_IDCLIENTEq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL IDCLIENTE
				_otablax = 'clientes'
				IF !USED(_otablax) AND !USED(UPPER(_otablax))
					oDb_abrir_tabla_dbf(_otablax)
				ENDIF
				SELECT &_otablax
				*			BROWSE
				GO TOP
				LOCATE FOR idcliente = _IDCLIENTEq
				IF FOUND()
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
					*WAIT WINDOW '_IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'APARECIO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF' + CHR(13) + '_onmbrex: ' + _onmbrex

				ELSE
					WAIT WINDOW '_IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'NO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF' TIMEOUT 1
					ca_log_pasar_datos_de_empresa_a_sql('ERROR. odb_funcion_id. _IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'NO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF')
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					SELECT &_alias_funcion
					RETURN _oresult
				ENDIF
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onmbrex)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 2" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_proveedores"))
				_NUMPROVEEDq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL NUM DEL PROVEEDOR
				_otablax = 'PROVEED'
				IF !USED(_otablax) AND !USED(UPPER(_otablax))
					oDb_abrir_tabla_dbf(_otablax)
				ENDIF
				SELECT &_otablax
				GO TOP
				LOCATE FOR NUM = _NUMPROVEEDq
				IF FOUND()
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
					*WAIT WINDOW '_IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'APARECIO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF' + CHR(13) + '_onmbrex: ' + _onmbrex

				ELSE
					WAIT WINDOW '_IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'NO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF' TIMEOUT 1
					ca_log_pasar_datos_de_empresa_a_sql('ERROR. odb_funcion_id. _IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'NO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF')
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					SELECT &_alias_funcion
					RETURN _oresult
				ENDIF
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onmbrex)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)


			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_tipos_de_comprobante"))

				_TIPOCOMPROBANTEq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL TIPO_COMPROBANTE
				_otablax = 'tipocomprobantes'
				IF !USED(_otablax) AND !USED(UPPER(_otablax))
					oDb_abrir_tabla_dbf(_otablax)
				ENDIF
				SELECT &_otablax
				GO TOP
				LOCATE FOR filtro = _TIPOCOMPROBANTEq
				IF FOUND()
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
				ELSE
					WAIT WINDOW '_TIPOCOMPROBANTEq: ' + STR(_TIPOCOMPROBANTEq) + CHR(13) + '_onombre: ' + _onombre + CHR(13) + 'NO SE ENCUENTRA EL TIPO DE COMPROBANTE EN LA TABLA DBF' TIMEOUT 1
					ca_log_pasar_datos_de_empresa_a_sql('ERROR. odb_funcion_id. _TIPOCOMPROBANTEq: ' + STR(_TIPOCOMPROBANTEq) + CHR(13) + 'NO SE ENCUENTRA EL TIPO DE COMPROBANTE EN LA TABLA DBF')
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					SELECT &_alias_funcion
					RETURN _oresult
				ENDIF
				*WAIT WINDOW 'ANTES DEL QUERY: ' + CHR(13) + '_otablaSQL_funcion: ' + _otablaSQL_funcion + CHR(13) + '_onmbrex: ' + _onmbrex
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onmbrex)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 3" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_depositos"))
				_depositosq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL num del deposito
				_otablax = 'dep�sitos'
				IF !USED(_otablax) AND !USED(UPPER(_otablax))
					oDb_abrir_tabla_dbf(_otablax)
				ENDIF
				SELECT &_otablax
				GO TOP
				LOCATE FOR NUM = _depositosq
				IF FOUND()
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
				ELSE

					*				WAIT WINDOW '_depositosq: ' + STR(_depositosq) + CHR(13) + 'NO SE ENCUENTRA EL DEP�SITO EN LA TABLA DBF' TIMEOUT 1
					*browse
					ca_log_pasar_datos_de_empresa_a_sql('ERROR. odb_funcion_id. _depositosq: ' + STR(_depositosq) + CHR(13) + 'NO SE ENCUENTRA EL DEP�SITO EN LA TABLA DBF')
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					SELECT &_alias_funcion
					RETURN _oresult
				ENDIF
				*WAIT WINDOW 'ANTES DEL QUERY: ' + CHR(13) + '_otablaSQL_funcion: ' + _otablaSQL_funcion + CHR(13) + '_onmbrex: ' + _onmbrex
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onmbrex)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)),_ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 4" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

				*BROWSE
			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_regiones_moneda")) && necesito saber la moneda de cierto pais: (_xregion)
				RELEASE _ocursorSQL_1709
				PUBLIC _ocursorSQL_1709
				_ocursorSQL_funcion = 'oDb_' + 'ABM_regiones'
				_ocursorSQL_13092016 = 'ABM_regiones_cursor'
				_otablaSQL_1709 = 'ABM_regiones'
				_oconectar_250516 = .T.

				*!*					TRY
				*!*						IF oDb.Connected()
				*!*							_oconectar_250516 = .f
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					TRY
				*!*						IF _oconectar_250516 = .t.
				*!*							IF oDb.Reconnection()
				*!*								_oconectar_250516 = .f.
				*!*							ENDIF
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					IF _oconectar_250516 = .t.
				*!*						DO SYS(5) + 'oDbsql/odb_connect'
				*!*					ENDIF
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - CONECTED - 1" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*************************************
				&& abro 'ABM_regiones'
				*WAIT WINDOW '1 - _otablaSQL_1709: ' + _otablaSQL_1709 + CHR(13) + '_ocursorSQL_funcion: ' + _ocursorSQL_funcion + CHR(13) + "Select * from " + _otablaSQL_1709 + " where id = " + STR(_xregion)
				odb.QUERY("Select * from " + _otablaSQL_1709 + " where id = " + ALLTRIM(STR(_xregion)), _ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 5" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

				*WAIT WINDOW '2 - _otablaSQL_1709: ' + _otablaSQL_1709 + CHR(13) + '_ocursorSQL_funcion: '+ _ocursorSQL_funcion + CHR(13) + "Select * from " + _otablaSQL_1709 + " where id = " + STR(_xregion)
				SELECT &_ocursorSQL_funcion

			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_usuarios_cabecera")) && necesito saber la moneda de cierto pais: (_xregion)
				RELEASE _ocursorSQL_1709
				PUBLIC _ocursorSQL_1709
				_ocursorSQL_funcion = 'oDb_' + 'ABM_usuarios_cabecera'
				_ocursorSQL_13092016 = 'ABM_usuarios_cabecera_cursor'
				_otablaSQL_1709 = 'ABM_usuarios_cabecera'
				_oconectar_250516 = .T.
				*!*					TRY
				*!*						IF oDb.Connected()
				*!*							_oconectar_250516 = .f
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					TRY
				*!*						IF _oconectar_250516 = .t.
				*!*							IF oDb.Reconnection()
				*!*								_oconectar_250516 = .f.
				*!*							ENDIF
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					IF _oconectar_250516 = .t.
				*!*						DO SYS(5) + 'oDbsql/odb_connect'
				*!*					ENDIF
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - CONECTED - 2" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*************************************
				&& abro 'ABM_regiones'
				*WAIT WINDOW '1 - _otablaSQL_1709: ' + _otablaSQL_1709 + CHR(13) + '_ocursorSQL_funcion: ' + _ocursorSQL_funcion + CHR(13) + "Select * from " + _otablaSQL_1709 + " where id = " + STR(_xregion)
				*				oDb.Query("Select * from " + _otablaSQL_1709 + " where id = " + ALLTRIM(STR(_xregion)), _ocursorSQL_funcion)
				&& veo si existe el usuario con ID de la empresa en curso
				odb.QUERY("select * from " + _otablaSQL_1709 + " WHERE TRIM(UPPER(nombre)) + ' ' + TRIM(UPPER(apellido)) = ?TRIM(UPPER(_onombre)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 6" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

				SELECT &_ocursorSQL_funcion
				COUNT TO cuantosq
				&& si no existe el usuario con ID de la empresa en curso, vuelvo a generar la consulta para usuarios de cualquier
				IF cuantosq = 0
					odb.QUERY("select * from " + _otablaSQL_1709 + " WHERE TRIM(UPPER(nombre)) + ' ' + TRIM(UPPER(apellido)) = ?TRIM(UPPER(_onombre))", _ocursorSQL_funcion, _otablaSQL_funcion)

					*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
					*WAIT WINDOW "odb_funcion_id - SELECT - 7" nowait noclear
					*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

				ENDIF

				*WAIT WINDOW '2 - _otablaSQL_1709: ' + _otablaSQL_1709 + CHR(13) + '_ocursorSQL_funcion: '+ _ocursorSQL_funcion + CHR(13) + "Select * from " + _otablaSQL_1709 + " where id = " + STR(_xregion)
				SELECT &_ocursorSQL_funcion
				&&
			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_servicios_de_venta"))
				_numservq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL numserv
				RELEASE _ocursorSQL_1709
				PUBLIC _ocursorSQL_1709
				_ocursorSQL_funcion = 'oDb_' + 'ABM_servicios_de_venta'
				_ocursorSQL_13092016 = 'ABM_servicios_de_venta_cursor'
				_otablaSQL_1709 = 'ABM_servicios_de_venta'
				_oconectar_250516 = .T.
				*!*					TRY
				*!*						IF oDb.Connected()
				*!*							_oconectar_250516 = .f
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					TRY
				*!*						IF _oconectar_250516 = .t.
				*!*							IF oDb.Reconnection()
				*!*								_oconectar_250516 = .f.
				*!*							ENDIF
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					IF _oconectar_250516 = .t.
				*!*						DO SYS(5) + 'oDbsql/odb_connect'
				*!*					ENDIF
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - CONECTED - 3" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*************************************
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE version = " +  ALLTRIM(STR(_numservq)) + " AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 8" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

				SELECT &_ocursorSQL_funcion
			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_articulos"))
				_numarticq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL _numartic
				RELEASE _ocursorSQL_1709
				PUBLIC _ocursorSQL_1709
				_ocursorSQL_funcion = 'oDb_' + 'ABM_articulos'
				_ocursorSQL_13092016 = 'ABM_articulos_cursor'
				_otablaSQL_1709 = 'ABM_articulos'
				_oconectar_250516 = .T.
				*!*					TRY
				*!*						IF oDb.Connected()
				*!*							_oconectar_250516 = .f
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					TRY
				*!*						IF _oconectar_250516 = .t.
				*!*							IF oDb.Reconnection()
				*!*								_oconectar_250516 = .f.
				*!*							ENDIF
				*!*						ENDIF
				*!*					CATCH TO oex
				*!*					ENDTRY
				*!*					IF _oconectar_250516 = .t.
				*!*						DO SYS(5) + 'oDbsql/odb_connect'
				*!*					ENDIF
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - CONECTED - 4" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*************************************
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE version = " +  ALLTRIM(STR(_numarticq)) + " AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _otablaSQL_funcion, _ocursorSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 9" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

				SELECT &_ocursorSQL_funcion

			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("abm_plantas_de_proceso_cabecera"))
				RELEASE _ocursorSQL_1709
				PUBLIC _ocursorSQL_1709
				_ocursorSQL_funcion = 'oDb_' + 'abm_plantas_de_proceso_cabecera'
				_ocursorSQL_13092016 = 'abm_plantas_de_proceso_cabecera_cursor'
				_otablaSQL_1709 = 'abm_plantas_de_proceso_cabecera'

				*odb_connect()
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - CONECTED - 5" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*************************************
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onombre)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 10" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				SELECT &_ocursorSQL_funcion
			OTHERWISE
				*odb_connect()
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onombre)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 11" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		ENDCASE
	ELSE  &&& tabla comentarios
		odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(nombre) = ?TRIM(_onombre) AND id_ABM_Tipos_de_descriptores = ?_ofiltro AND id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)
		*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		*WAIT WINDOW "odb_funcion_id - SELECT - 12" nowait noclear
		*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	ENDIF
	IF odb.CursorOpen(_ocursorSQL_funcion)
	ELSE
		WAIT WINDOW 'El cursor ' + _ocursorSQL_funcion +  ' no est� abierto -1' TIMEOUT 5
		ca_log_pasar_datos_de_empresa_a_sql('ALERTA - El cursor ' + _ocursorSQL_funcion +  ' no est� abierto')
		RELEASE &_ocursorSQL_funcion
		SELECT &_alias_funcion
		RETURN 0
	ENDIF

	IF odb.CursorOpen(_ocursorSQL_funcion)
		IF odb.CursorEdit(_ocursorSQL_funcion)
		ELSE
			WAIT WINDOW 'FUNCION - El cursor ' + _ocursorSQL_funcion + ' no es editable' TIMEOUT 5
		ENDIF
	ELSE
		WAIT WINDOW 'FUNCION - El cursor ' + _ocursorSQL_funcion +  ' no est� abierto' TIMEOUT 5
	ENDIF

	SELECT &_ocursorSQL_funcion
	COUNT TO _cuantos_funcion
	IF _cuantos_funcion > 0   && lo encontr�
		GO 1
		_oresult = sincronizacion&&id

	ELSE   &&& no lo encontr�
		_oresult = 0
	ENDIF &&& no lo encontr�

	RELEASE &_ocursorSQL_funcion
	SELECT &_alias_funcion
	RETURN _oresult
ENDFUNC

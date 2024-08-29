*Sincro_Automatica_Sql_Dbf(cTablaDir)

FUNCTION Sincro_Automatica_Sql_Dbf(cTablaDir)
	m.xEmpresa=440
	odb = NEWOBJECT("foxydb", "foxydb.prg")
	IF odb.CONNECTION("{MySQL ODBC 5.1 Driver}","localhost","root","alexa","alexa","3306")
		* conexi�n fue exitosa
	ELSE
		= MESSAGEBOX("NO Conectado",16,"ERROR")
	ENDIF

	SELECT DISTINC(tabla_mysql) AS tabla_mysql FROM mapeo;
		WHERE !EMPTY(campo_vfp) ;
		ORDER BY tabla_mysql INTO CURSOR curProcesoInverso

	SCAN
		* Obtener Tablas para el cambio
		cTablaSQL = RTRIM(UPPER(curProcesoInverso.tabla_mysql))
		curTablaSQL = "cur"+cTablaSQL
		cEjecutar = "select * from " + cTablaSQL +" where date(ultimo_cambio) = curdate() and id_abm_empresas = "+ ALLTRIM(STR(m.xEmpresa))
		_CLIPTEXT=cEjecutar
		odb.QUERY(cEjecutar, curTablaSQL,cTablaSQL)
		IF odb.CursorOpen(curTablaSQL)
			SELECT &curTablaSQL
			IF RECCOUNT() > 0
				BROWSE
			ENDIF
		ENDIF
		USE IN &curTablaSQL
	ENDSCAN
	USE IN curProcesoInverso
	USE IN DBcursor
	USE IN mapeo
	RETURN .T.
ENDFUNC

FUNCTION Sincro_Automatica_Dbf_Sql(cTablaDir)
	* Configurar FoxyDB para la conexi�n a la base de datos MySQL
	LOCAL lbEsClave
	PUBLIC _sincroIdClave, cJson
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
		cJason = cCampos
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
					SET STEP ON 
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
				* Remover el ultimo AND
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
				cSQL = "UPDATE " + cTablaMySQL + " SET eliminado = 1 WHERE " + cWhereMySQL
		ENDCASE
		* Ejecutar la sentencia SQL en MySQL
		**************************
		curTablaSQL = cTablaMySQL
		cEjecutar = "Select * from " + cTablaMySQL + " where " + IIF(EMPTY(cWhereMySQL), " 2 = 1", cWhereMySQL)
		odb.QUERY(cEjecutar, curTablaSQL,cTablaMySQL)
		IF odb.CursorOpen(curTablaSQL)
			IF odb.CursorEdit(curTablaSQL)
				_CLIPTEXT=cSQL
				SET STEP ON 
				&cSQL
				IF odb.CursorChanges(curTablaSQL)
					IF odb.UPDATE(curTablaSQL,.T.)
						IF odb.Commit()
							UPDATE auditoria SET procesado = .T. WHERE ID = nId
						ELSE
							MESSAGEBOX("Error en el COMMIT de la tabla: "+ curTablaSQL)
						ENDIF
					ELSE
						MESSAGEBOX("Error en el UPDATE de la tabla: "+ curTablaSQL)
					ENDIF
				ELSE
					MESSAGEBOX("Error en el CURSORCHANGES de la tabla: "+ curTablaSQL)
				ENDIF
			ELSE
				MESSAGEBOX("No esta Editable la tabla: "+ curTablaSQL)
			ENDIF
		ELSE
			MESSAGEBOX("No esta Abierto el cursor: "+ curTablaSQL)
		ENDIF
		SELECT cursorAuditoria
	ENDSCAN
	* Cerrar la conexi�n a MySQL
	RELEASE _sincroaempresa, _sincroaregion, _sincroausuario, _sincroarutadato, _sincroaui
	USE IN cursorAuditoria
	USE IN auditoria
	*USE IN &curTablaSql
	*USE IN dbcursor
	GenerarBackup()
	odb.Disconnect()
	RETURN .T.
ENDFUNC

FUNCTION ObtenerValorClave(cTablaVFP, cJason, cClave)
	cTabla=ALLTRIM(UPPER(cTablaVFP))
	lcJson = ALLTRIM(cJason)
	* Definir la clave que deseas buscar
	lcClave = '"'+ALLTRIM(UPPER(cClave))+'":'
	* Buscar la posici�n de la clave en la cadena JSON
	lnPosClave = AT(lcClave, lcJson)
	lcValor = ''
	IF lnPosClave > 0
		* Extraer la parte de la cadena que contiene el valor de la clave
		lcSubcadena = SUBSTR(lcJson, lnPosClave + LEN(lcClave) - 1)
		* Extraer el valor entre el separador ":" y la coma siguiente
		lcValor = STREXTRACT(lcSubcadena, ":", ",", 1)
		* Si es el �ltimo elemento y no hay coma, buscamos hasta el cierre de llave
		IF EMPTY(lcValor)
			lcValor = STREXTRACT(lcSubcadena, ":", "}", 1)
		ENDIF
		* Eliminar posibles espacios en blanco o comillas

		lcValor = ALLTRIM(STRTRAN(lcValor, '"', ''))
		IF lcValor=="FALSE"
			lcValor='0'
		ENDIF 
		IF lcValor=="TRUE"
			lcValor='1'
		ENDIF 
		lcClave = ALLTRIM(STRTRAN(STRTRAN(lcClave, '"', ''), ':', ''))
	ENDIF
	RETURN lcValor
ENDFUNC


FUNCTION ObtenerClaveTabla(cTablaVFP, cJason)
	cTabla=ALLTRIM(UPPER(cTablaVFP))
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
			+ ALLTRIM(SUBSTR(EMPRESAS.NOMBRE,1,20))

		* Crear la carpeta de backup si no existe
		IF !DIRECTORY(lc_RutaBackup)
			MKDIR(lc_RutaBackup)
		ENDIF
		* Chequear si la tabla ya existe le pone prefijo
		lc_NombreArchivoBackup = NombreTabla(lc_RutaBackup, lc_NombreArchivoBackup)
		* Copiar la tabla de auditor�a a la carpeta de backup
		lcTablaBkp = lc_RutaBackup+lc_NombreArchivoBackup
		SELECT * FROM auditoria WHERE TTOD(fecha) < DATE() INTO TABLE (EVALUATE('lcTablaBkp'))

		* Vaciar la tabla original de auditor�a
		DELETE FROM auditoria WHERE fecha < DATE() AND procesado = .T.
		STRTOFILE(DTOC(DATE()) + " " + TIME() + " - Backup de Auditoria Realizado como: " + lc_NombreArchivoBackup+ ".dbf" + CHR(13);
			+ SPACE(18) + " - En el Directorio: " + lc_RutaBackup + CHR(13), "error_log.txt", .T.)
		USE IN &lc_NombreArchivoBackup
	ENDIF
	USE IN curFechaBackup
	RETURN .T.
ENDFUNC

FUNCTION NombreTabla(cDirectorio, cTabla)
	LOCAL lcTabla, lnExiste
	lnExiste = FILE(cDirectorio+cTabla + ".dbf")
	IF lnExiste
		&& la tabla ya existe, agregar sufijo num�rico
		LOCAL lnSufijo
		lnSufijo = 1
		DO WHILE FILE(cDirectorio+cTabla + "_" + ALLTRIM(STR(lnSufijo)) + ".dbf")
			lnSufijo = lnSufijo + 1
		ENDDO
		cTabla = cTabla + "_" + ALLTRIM(STR(lnSufijo))
	ENDIF
	RETURN cTabla
ENDFUNC

FUNCTION CodigoAutomatico(cTablaVFP)
	LOCAL lcProximo, lcCursorSQL
	lcProximo = ''
	lcCursorSQL = 'curSql'+ALLTRIM(UPPER(cTablaVFP))
	odb.CONNECT()
	odb.QUERY("SELECT LPAD(IFNULL(MAX(codigo) + 1, 1), 4, '0') AS proximo FROM " + cTablaVFP +;
		" WHERE id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)) ,lcCursorSQL ,cTablaVFP)
	IF odb.CursorOpen(lcCursorSQL )
		SELECT &lcCursorSQL
		lcProximo = proximo && Codigo Generado
	ENDIF
	RELEASE &lcCursorSQL
	RETURN lcProximo
ENDFUNC

FUNCTION ObtenerEmpresa()
	PUBLIC _sincroaempresa, _sincroaregion, _sincroausuario, _sincroarutadato
	PUBLIC _sincroaui, _sincromoneda, _sincrocadenamoneda 
	SELECT csrEmpresas
	_sincroaempresa = csrEmpresas.IDS
	_sincroarutadato = ALLTRIM(csrEmpresas.Directorio)
	_sincroausuario = 999
	_sincroaui = ''
	_sincromoneda = 0
	_sincrocadenamoneda = ''
	DO CASE
		CASE ALLTRIM(csrEmpresas.NUM3) = "ARGENTINA"
			_sincroaregion = 1
			_sincromoneda = 1
			_sincrocadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "M�XICO"
			_sincroaregion = 2
			_sincromoneda = 10
			_sincrocadenamoneda = 'PESO MEXICANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "COLOMBIA"
			_sincroaregion = 3
			_sincromoneda = 12
			_sincrocadenamoneda = 'PESO COLOMBIANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "VENEZUELA"
			_sincroaregion = 4
			_sincromoneda = 4
			_sincrocadenamoneda = 'BOLIVAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "E.E.U.U."
			_sincroaregion = 5
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "CHILE"
			_sincroaregion = 6
			_sincromoneda = 11
			_sincrocadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BRASIL"
			_sincroaregion = 7
			_sincromoneda = 3
			_sincrocadenamoneda = 'REAL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "COSTA RICA"
			_sincroaregion = 8
			_sincromoneda = 5
			_sincrocadenamoneda = 'COLON'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PARAGUAY"
			_sincroaregion = 9
			_sincromoneda = 6
			_sincrocadenamoneda = 'GUARANI'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PERU"
			_sincroaregion = 10
			_sincromoneda = 7
			_sincrocadenamoneda = 'SOL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PANAM�"
			_sincroaregion = 11
			_sincromoneda = 8
			_sincrocadenamoneda = 'BALBOA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "URUGUAY"
			_sincroaregion = 12
			_sincromoneda = 9
			_sincrocadenamoneda = 'PESO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BOLIVIA"
			_sincroaregion = 13
			_sincromoneda = 13
			_sincrocadenamoneda = 'BOLIVIANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "PUERTO RICO"
			_sincroaregion = 14
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "HONDURAS"
			_sincroaregion = 15
			_sincromoneda = 14
			_sincrocadenamoneda = 'LEMPIRA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "NICARAGUA"
			_sincroaregion = 16
			_sincromoneda = 15
			_sincrocadenamoneda = 'CORDOBA'
		CASE ALLTRIM(csrEmpresas.NUM3) = "ECUADOR"
			_sincroaregion = 17
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "GUATEMALA"
			_sincroaregion = 18
			_sincromoneda = 16
			_sincrocadenamoneda = 'QUETZAL'
		CASE ALLTRIM(csrEmpresas.NUM3) = "ESPA�A"
			_sincroaregion = 19
			_sincromoneda = 17
			_sincrocadenamoneda = 'EURO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "REPUBLICA DOMINICANA"
			_sincroaregion = 20
			_sincromoneda = 18
			_sincrocadenamoneda = 'PESO DOMINICANO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BAHAMAS"
			_sincroaregion = 21
			_sincromoneda = 19
			_sincrocadenamoneda = 'DOLAR BAHAME�O'
		CASE ALLTRIM(csrEmpresas.NUM3) = "EL SALVADOR"
			_sincroaregion = 22
			_sincromoneda = 2
			_sincrocadenamoneda = 'DOLAR'
		CASE ALLTRIM(csrEmpresas.NUM3) = "JAMAICA"
			_sincroaregion = 23
			_sincromoneda = 20
			_sincrocadenamoneda = 'DOLAR JAMAIQUINO'
		CASE ALLTRIM(csrEmpresas.NUM3) = "CANADA"
			_sincroaregion = 24
			_sincromoneda = 21
			_sincrocadenamoneda = 'DOLAR CANADIENSE'
		CASE ALLTRIM(csrEmpresas.NUM3) = "TRINIDAD Y TOBAGO"
			_sincroaregion = 25
			_sincromoneda = 22
			_sincrocadenamoneda = 'DOLAR TRINITENSE'
		CASE ALLTRIM(csrEmpresas.NUM3) = "BELICE"
			_sincroaregion = 26
			_xmoneda = 23
			_sincrocadenamoneda = 'DOLAR BELICE�O'
		CASE ALLTRIM(csrEmpresas.NUM3) = "GUYANA"
			_sincroaregion = 27
			_sincromoneda = 24
			_sincrocadenamoneda = 'DOLAR GUYANES'
		CASE ALLTRIM(csrEmpresas.NUM3) = "SURINAM"
			_sincroaregion = 28
			_sincromoneda = 25
			_sincrocadenamoneda = 'DOLAR SURINAMES'
		CASE ALLTRIM(csrEmpresas.NUM3) = "HAITI"
			_sincroaregion = 29
			_sincromoneda = 26
			_sincrocadenamoneda = 'GOURDE'
		OTHERWISE
			_sincroaregion = 99
			_sincromoneda = 1
			_sincrocadenamoneda = 'PESO'
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
	SET DELETED ON
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

	IF LEN(ALLTRIM(onombre)) = 0
		RETURN 0
	ENDIF
	_alias_funcion = ALIAS()

	RELEASE _otablaSQL_funcion
	PUBLIC _otablaSQL_funcion
	RELEASE _ocursorSQL_funcion
	PUBLIC _ocursorSQL_funcion
	RELEASE _codigomasaltoSQL
	PUBLIC _codigomasaltoSQL
	RELEASE _idsqlmasaltoSQL
	PUBLIC _idsqlmasaltoSQL

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
				cConsulta = "SELECT ALLTRIM(UPPER(nombre)) AS NOMBRE FROM clientes WHERE idcliente = " + ALLTRIM(STR(_IDCLIENTEq));
				+" INTO CURSOR cNomCli"
				&cConsulta
				SELECT cNomCli
				IF RECCOUNT() > 0
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
				ELSE
					*WAIT WINDOW '_IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'NO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF' TIMEOUT 1
					ca_log_pasar_datos_de_empresa_a_sql='ERROR. odb_funcion_id. _IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'NO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF'
					STRTOFILE(DTOC(DATE()) + " " + TIME() + " - "+ca_log_pasar_datos_de_empresa_a_sql+CHR(13), "error_log.txt", .T.)
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					USE IN cNomCli
					SELECT &_alias_funcion
					RETURN _oresult
				ENDIF
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onmbrex)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 2" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_proveedores"))
				_NUMPROVEEDq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL NUM DEL PROVEEDOR
				cConsulta = "SELECT ALLTRIM(UPPER(nombre)) AS NOMBRE FROM tipocomprobantes WHERE NUM = " + ALLTRIM(STR(_NUMPROVEEDq));
				+" INTO CURSOR cNomPro"
				&cConsulta
				SELECT cNomPro
				IF RECCOUNT() > 0
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
				ELSE
					ca_log_pasar_datos_de_empresa_a_sql='ERROR. odb_funcion_id. _IDCLIENTEq: ' + STR(_IDCLIENTEq) + CHR(13) + 'NO SE ENCUENTRA EL CLIENTE EN LA TABLA DBF'
					STRTOFILE(DTOC(DATE()) + " " + TIME() + " - "+ca_log_pasar_datos_de_empresa_a_sql+CHR(13), "error_log.txt", .T.)
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					USE IN cNomPro
					SELECT &_alias_funcion
					RETURN _oresult
				ENDIF
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onmbrex)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)), _ocursorSQL_funcion, _otablaSQL_funcion)


			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_tipos_de_comprobante"))
				_TIPOCOMPROBANTEq = VAL(ALLTRIM(_onombre)) && AQUI TENGO EL TIPO_COMPROBANTE
				cConsulta = "SELECT ALLTRIM(UPPER(nombre)) AS NOMBRE FROM tipocomprobantes WHERE filtro = " + ALLTRIM(STR(_TIPOCOMPROBANTEq));
				+" INTO CURSOR cNomComp"
				&cConsulta
				SELECT cNomComp
				IF RECCOUNT() > 0
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
				ELSE
					ca_log_pasar_datos_de_empresa_a_sql = 'ERROR. odb_funcion_id. _TIPOCOMPROBANTEq: ' + STR(_TIPOCOMPROBANTEq) + CHR(13) + 'NO SE ENCUENTRA EL TIPO DE COMPROBANTE EN LA TABLA DBF'
					STRTOFILE(DTOC(DATE()) + " " + TIME() + " - "+ca_log_pasar_datos_de_empresa_a_sql+CHR(13), "error_log.txt", .T.)
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					USE IN cNomComp
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
				cConsulta = "SELECT ALLTRIM(UPPER(nombre)) AS NOMBRE FROM dep�sitos WHERE num = " + ALLTRIM(STR(_depositosq));
				+" INTO CURSOR cNomDep"
				&cConsulta
				SELECT cNomDep
				IF RECCOUNT() > 0
					_onmbrex = ALLTRIM(UPPER(NOMBRE))
				ELSE
					ca_log_pasar_datos_de_empresa_a_sql = 'ERROR. odb_funcion_id. _depositosq: ' + STR(_depositosq) + CHR(13) + 'NO SE ENCUENTRA EL DEP�SITO EN LA TABLA DBF'
					STRTOFILE(DTOC(DATE()) + " " + TIME() + " - "+ca_log_pasar_datos_de_empresa_a_sql+CHR(13), "error_log.txt", .T.)
					_oresult = 0
					RELEASE &_ocursorSQL_funcion
					USE IN cNomDep
					SELECT &_alias_funcion
					RETURN _oresult
				ENDIF
				odb.QUERY("select * from " + _otablaSQL_funcion + " WHERE TRIM(UPPER(nombre)) = ?TRIM(UPPER(_onmbrex)) AND  id_ABM_empresas = " + ALLTRIM(STR(_sincroaempresa)),_ocursorSQL_funcion, _otablaSQL_funcion)

				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				*WAIT WINDOW "odb_funcion_id - SELECT - 4" nowait noclear
				*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

				*BROWSE
			CASE ALLTRIM(UPPER(_otablaSQL_funcion)) == 	ALLTRIM(UPPER("ABM_regiones")) && necesito saber la moneda de cierto pais: (_xregion)
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
				odb.QUERY("Select * from " + _otablaSQL_1709 + " where id = " + ALLTRIM(STR(_sincroaregion)), _ocursorSQL_funcion, _otablaSQL_funcion)

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
				odb.CONNECT()
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
		ca_log_pasar_datos_de_empresa_a_sql = 'ALERTA - El cursor ' + _ocursorSQL_funcion +  ' no est� abierto'
		STRTOFILE(DTOC(DATE()) + " " + TIME() + " - "+ca_log_pasar_datos_de_empresa_a_sql+CHR(13), "error_log.txt", .T.)
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

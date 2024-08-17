FUNCTION Sincro_Automatica_Dbf_Sql(cTablaSincro)
	* Configurar FoxyDB para la conexi�n a la base de datos MySQL
	LOCAL lbEsClave
	LOCAL odb
*!*		odb = NEWOBJECT("foxydb", "d:\borrar\foxydb\foxydb.prg")
*!*		IF odb.CONNECTION("{MySQL ODBC 5.1 Driver}","localhost","root","alexa","alexa","3306")
*!*			* conexi�n fue exitosa
*!*		ELSE
*!*			= MESSAGEBOX("NO Conectado",16,"ERROR")
*!*		ENDIF
	*************************************
	_oconectar_250516 = .t.
	TRY 
		IF oDb.Connected()
			_oconectar_250516 = .f
		ENDIF 
	CATCH TO oex
	ENDTRY 	

	IF _oconectar_250516 = .t.
		DO SYS(5) + 'oDbsql/odb_connect'
	ENDIF 
	*************************************

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
				_xui = odb.uuid()
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
				_xui= odb.uuid()
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
		ODB.QUERY(cEjecutar, curTablaSQL,cTablaMySQL)
		IF ODB.CursorOpen(curTablaSQL)
			IF ODB.CursorEdit(curTablaSQL)
				&cSQL
				IF ODB.CursorChanges(curTablaSQL)
					IF ODB.UPDATE(curTablaSQL,.t.)
		 				IF ODB.Commit()
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
	ENDSCAN
	* Cerrar la conexi�n a MySQL
	ODB.Disconnect()
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
		SET STEP ON 
	* Verificar si hay un registro encontrado
	SELECT cursorMap
	IF NOT EOF()
		SCAN
			lcMappedName = ""
			* Verificar si campo_vfp est� vac�o y campo_mysql tiene valor
			IF NOT EMPTY(cursorMap.campo_mysql)
				IF ALLTRIM(UPPER(cursorMap.campo_mysql)) = 'ID' AND lcOperacion = 'U'
					LOOP
				ENDIF 
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
				ENDCASE 
			ENDIF
		ENDSCAN
	ENDIF
	RETURN lcMappedName
ENDFUNC

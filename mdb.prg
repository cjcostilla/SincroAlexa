*Sincro_Automatica_Dbf_Sql("dep�sitos")

FUNCTION Sincro_Automatica_Dbf_Sql(cTablaSincro)
	* Configurar FoxyDB para la conexi�n a la base de datos MySQL
	LOCAL oConn, lbEsClave

	oConn = NEWOBJECT("foxydb", "d:\borrar\foxydb\foxydb.prg")
	IF oConn.CONNECTION("{MySQL ODBC 5.1 Driver}","localhost","root","alexa","alexa","3306")
		* conexi�n fue exitosa
	ELSE
		= MESSAGEBOX("NO Conectado",16,"ERROR")
	ENDIF

	* Consultar la tabla de auditor�a para obtener los cambios pendientes
	SELECT * FROM auditoria ;
		WHERE RTRIM(UPPER(tabla))=RTRIM(UPPER(cTablaSincro)) AND procesado = .F. ;
		INTO CURSOR cursorAuditoria

	SELECT cursorAuditoria
	SCAN
		cSetMySQL = ""
		cWhereMySQL = ""
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
				* Remover la �ltima coma
				cCamposMySQL = LEFT(cCamposMySQL, LEN(cCamposMySQL) - 1)
				cValoresMySQL = LEFT(cValoresMySQL, LEN(cValoresMySQL) - 1)
				cSQL = "INSERT INTO " + cTablaMySQL + " (" + cCamposMySQL + ") VALUES (" + cValoresMySQL + ")"
			CASE cAccion == "UPDATE"
				* Crear lista de campos y valores mapeados para el SET
				FOR i = 1 TO ALEN(aCampos,1)
					cCampoMySQL = ObtenerMapeo(cTablaVFP, aCampos[i, 1], "campo", @lbEsClave)
					cValorClaveMySQL = aCampos[i, 2]
					IF EMPTY(cCampoMySQL)
						LOOP
					ENDIF
					cValorMySQL = aCampos[i, 1]
					IF VARTYPE(cValorMySQL) == "C"
						cValorMySQL = "'" + cValorMySQL + "'"
					ENDIF
					cSetMySQL = cSetMySQL + cCampoMySQL + " = " + cValorMySQL + ","
					IF lbEsClave
						IF VARTYPE(cValorClaveMySQL) <> "N"
							IF (cValorClaveMySQL = "TRUE" OR cValorClaveMySQL = "FALSE")
								cValorClaveMySQL =  IIF(cValorClaveMySQL = "TRUE",1,0)
							ELSE
								cValorClaveMySQL = "'" + cValorClaveMySQL + "'"
							ENDIF
						ENDIF
						cWhereMySQL = cWhereMySQL + cCampoMySQL + " = " + TRANSFORM(cValorClaveMySQL) + " AND "
					ENDIF
				ENDFOR
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
		curTablaSql = "cur"+cTablaMySQL
		cEjecutar = "Select * from " + cTablaMySQL + " where " + IIF(EMPTY(cWhereMySQL), " 2 = 1", cWhereMySQL)
		SET STEP ON
		oConn.QUERY(cEjecutar, cTablaMySQL,cTablaMySQL)
		IF oConn.CursorOpen(cTablaMySQL)
			IF oConn.CursorEdit(cTablaMySQL)
				*			MESSAGEBOX("Ya esta para ejecutar la consulta enla tabla: "+cTablaMySQL +CHR(13);
				+"Con la siguiente sentencia"+CHR(13)+cSQL )
				&cSQL
				oConn.UPDATE(cTablaMySQL)
				oConn.Commit()
				UPDATE auditoria SET procesado = .T. WHERE ID = nId
			ELSE
				MESSAGEBOX("No esta Editable la tabla: "+ cTablaMySQL)
			ENDIF
		ELSE
			MESSAGEBOX("No esta Abierto el cursor: "+ cTablaMySQL)
		ENDIF
	ENDSCAN
	* Cerrar la conexi�n a MySQL
	oConn.Disconnect()
	RETURN .T.
ENDFUNC

*
*
FUNCTION ParseJson(tcJSON,aCampos)
	LOCAL lcKey, lcValue, lcJSON, lnPos, lnColonPos, lnCommaPos
	LOCAL ARRAY aCampos[1, 2]
	LOCAL lnIndex
	lnIndex = 1
	* Limpiar el JSON (quitar llaves y espacios)
	lcJSON = STRTRAN(STRTRAN(tcJSON, "{", ""), "}", "")
	lcJSON = STRTRAN(lcJSON, " ", "")  && Quitar espacios innecesarios
	DO WHILE !EMPTY(lcJSON)
		* Encontrar la posici�n de los delimitadores (dos puntos y coma)
		lnColonPos = AT(":", lcJSON)
		lnCommaPos = AT(",", lcJSON)
		* Extraer clave y valor
		lcKey = TRIM(SUBSTR(lcJSON, 1, lnColonPos - 1))
		IF lnCommaPos > 0
			lcValue = TRIM(SUBSTR(lcJSON, lnColonPos + 1, lnCommaPos - lnColonPos - 1))
			lcJSON = SUBSTR(lcJSON, lnCommaPos + 1)
		ELSE
			lcValue = TRIM(SUBSTR(lcJSON, lnColonPos + 1))
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

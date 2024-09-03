CLOSE TABLES ALL 
SET DELETED ON
m.xEmpresa=440
*SELECT curArmarSentencia
odb = NEWOBJECT("foxydb", "foxydb.prg")
IF odb.CONNECTION("{MySQL ODBC 5.1 Driver}","localhost","root","alexa","alexa","3306")
	* conexión fue exitosa
ELSE
	= MESSAGEBOX("NO Conectado",16,"ERROR")
ENDIF

SELECT DISTINC(tabla_mysql) AS tabla_mysql FROM mapeo;
	WHERE !EMPTY(campo_vfp) ;
	ORDER BY tabla_mysql INTO CURSOR curProcesoInverso
SELECT curProcesoInverso
SCAN
	SET STEP ON 
	cTablaSQL = ALLTRIM(tabla_mysql)
	cTablaVFP = '' &&ObtenerMapeo(cTablaSQL, "", "tabla")
	curTablaSQL = "cur"+cTablaSQL
	cEjecutar = "select * from " + cTablaSQL +" where date(ultimo_cambio) = curdate() ";
		+ " and id_abm_empresas = "+ ALLTRIM(STR(m.xEmpresa))
	_CLIPTEXT=cEjecutar
	odb.QUERY(cEjecutar, curTablaSQL,cTablaSQL)
	IF odb.CursorOpen(curTablaSQL)
		SELECT &curTablaSQL
		SET STEP ON 
		SCAN FOR eliminado = 0
			cConsulta = GenerarConsultaVFP(cTablaSQL,'C',@cTablaVFP)
			&cConsulta
			SELECT cur_resultado
			IF RECCOUNT()> 0
				cConsulta = GenerarConsultaVFP(cTablaSQL,'U',@cTablaVFP)
			ELSE
				cConsulta = GenerarConsultaVFP(cTablaSQL,'I',@cTablaVFP)
			ENDIF
			_CLIPTEXT = cConsulta
			&cConsulta
			SELECT &curTablaSQL
		ENDSCAN
		SCAN FOR eliminado = 1
			cConsulta = GenerarConsultaVFP(cTablaSQL,'C',@cTablaVFP)
			&cConsulta
			SELECT cur_resultado
			IF RECCOUNT()> 0
				cConsulta = GenerarConsultaVFP(cTablaSQL,'D',@cTablaVFP)
			ENDIF
			_CLIPTEXT = cConsulta
			&cConsulta
			SELECT &curTablaSQL
		ENDSCAN
		IF USED(cTablaVFP)
			USE IN &cTablaVFP
		ENDIF 
	ENDIF
	SELECT curProcesoInverso
	USE IN &curTablaSQL 
ENDSCAN
USE IN cur_resultado
USE IN curProcesoInverso

FUNCTION GenerarConsultaVFP(cTablaSQL,cTipoConsulta,pTablaVFP)
	LOCAL pTablaVFP
	SELECT * FROM mapeo WHERE !EMPTY(campo_vfp) AND ALLTRIM(tabla_mysql) = ALLTRIM(cTablaSQL);
		INTO CURSOR curArmarSentencia
	SELECT curArmarSentencia
	cConsulta = 'Select * From ' + ALLTRIM(Tabla_vfp) + " Where ultimo_cambio < cur" + ALLTRIM(tabla_mysql) + ".ultimo_cambio AND "
	cInsert = 'Insert into ' + ALLTRIM(Tabla_vfp) + "("
	cValues = ' Values ('
	cUpdate = 'Update ' + ALLTRIM(Tabla_vfp) + " Set "
	cDelete = 'Delete From ' + ALLTRIM(Tabla_vfp) + " Where "
	cCampos = ''
	cClaves = ''
	SCAN
		cCampoVFP = ALLTRIM(campo_vfp)
		cValorSQL = "cur"+ALLTRIM(tabla_mysql) + "." + ALLTRIM(campo_mysql)
		pTablaVFP = ALLTRIM(curArmarSentencia.tabla_vfp)
		DO CASE
			CASE cTipoConsulta='C'
				IF clave
					cClaves = cClaves + cCampoVFP + " = " + cValorSQL + " AND "
				ENDIF
			CASE cTipoConsulta='I'
				cCampos = cCampos + cCampoVFP + ", "
				cValues = cValues + cValorSQL + ", "
			CASE cTipoConsulta='U'
				IF clave
					cClaves = cClaves + cCampoVFP + " = " + cValorSQL + " AND "
				ELSE
					cCampos = cCampos + cCampoVFP + " = " + cValorSQL + ", "
				ENDIF
			CASE cTipoConsulta='D'
				IF clave
					cClaves = cClaves + cCampoVFP + " = " + cValorSQL + " AND "
				ENDIF
		ENDCASE
	ENDSCAN
	DO CASE
		CASE cTipoConsulta='C'
			cClaves = LEFT(cClaves, LEN(cClaves) - 4)
			cConsulta = cConsulta + cClaves + " Into Cursor cur_Resultado"
		CASE cTipoConsulta='I'
			cCampos = LEFT(cCampos, LEN(cCampos) - 2)
			cValues = LEFT(cValues, LEN(cValues) - 2)
			cConsulta = cInsert + cCampos + ")" + cValues + ")"
		CASE cTipoConsulta='U'
			cCampos = LEFT(cCampos, LEN(cCampos) - 2)
			cClaves = LEFT(cClaves, LEN(cClaves) - 4)
			cConsulta = cUpdate + cCampos + " where " + cClaves
		CASE cTipoConsulta='D'
			cClaves = LEFT(cClaves, LEN(cClaves) - 4)
			cConsulta = cDelete + cClaves
	ENDCASE
	USE IN curArmarSentencia
	RETURN cConsulta
ENDFUNC

FUNCTION ObtenerMapeo(tcTablaVFP, tcCampoVFP, tcTipo, lbEsClave)
	LOCAL lcMappedName
	* Buscar el nombre mapeado en la tabla de mapeo
	SELECT tabla_mysql, campo_mysql, clave;
		FROM mapeo ;
		WHERE UPPER(Tabla_vfp) = tcTablaVFP AND UPPER(campo_vfp) = tcCampoVFP ;
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












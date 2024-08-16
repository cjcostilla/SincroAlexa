PUBLIC _xempresa
SET LIBRARY TO sincro_funciones.prg

_xempresa='Javy'
tcTablaVFP='rubro'
tcTipo='campo'

SELECT tabla_mysql, campo_mysql, clave, poner_valor, poner_funcion;
	FROM mapeo ;
	WHERE ALLTRIM(UPPER(tabla_vfp)) = ALLTRIM(UPPER(tcTablaVFP));
	AND EMPTY(campo_vfp) ;
	INTO CURSOR cursorMap
* Verificar si hay un registro encontrado
SELECT cursorMap
IF NOT EOF()
	* Si es un campo (no una tabla)
	lcCampoPer=''
	lcValorPer=''
	SCAN
		* Verificar si campo_vfp está vacío y campo_mysql tiene valor
		IF NOT EMPTY(cursorMap.campo_mysql)&& AND ALLTRIM(cursorMap.campo_mysql)="eliminado"
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
				CASE lcTipoDato = "C"  && Carácter
					lcMappedName = "'" + ALLTRIM(lcMappedName) + "'"
				CASE lcTipoDato = "N"  && Numérico
					lcMappedName = STR(lcMappedName)
				CASE lcTipoDato = "D"  && Fecha
					lcMappedName = "'" + RTRIM(DTOC(lcMappedName)) + "'"
				CASE lcTipoDato = "T"  && DateTime
					lcMappedName = "'" + RTRIM(TTOC(lcMappedName)) + "'"
				CASE lcTipoDato = "L"  && Lógico
					lcMappedName = IIF(lcMappedName , 1, 0)
				CASE lcTipoDato = "M"  && Memo
					lcMappedName = "'" + MEMLINES(lcMappedName) + "'"
				OTHERWISE  && Otros tipos de datos
					lcMappedName = TRANSFORM(lcMappedName)
			ENDCASE
			lcCampoPer = lcCampoPer + RTRIM(cursorMap.campo_mysql) + ', '
			lcValorPer = lcValorPer + ALLTRIM(TRANSFORM(lcMappedName)) + ","
		ENDIF
	ENDSCAN
ENDIF

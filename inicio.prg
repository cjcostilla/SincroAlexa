*_SCREEN.VISIBLE = .F.
*SET SYSMENU TO
SET TALK OFF
SET NOTIFY OFF
SET CURSOR OFF
SET EXCLUSIVE OFF 
SET DELETED ON 

SET PROCEDURE TO sincro_automatica.prg, foxydb.prg ADDITIVE

* Manejo global de errores
ON ERROR DO HandleError WITH ERROR(), MESSAGE(), PROCEDURE(), DETAILS(), LINECONTENTS()

archivo = 1
lcExit = .F.  && Bandera para controlar la salida de los bucles
* Bucle externo para asegurar la continuidad
DO WHILE .T.
	* Si la bandera indica que se debe salir, romper el bucle externo
	IF lcExit
		STRTOFILE(DTOC(DATE()) + " " + TIME() + ">>> ME FUI ", "error_log.txt"+CHR(13), .T.)
		EXIT
	ENDIF
	TRY
		DO WHILE .T.
			* Verificar si existe un archivo de detención
			IF FILE("stop.txt")
				* Activar la bandera para salir de ambos bucles
				lcExit = .T.
				* Salir del bucle
				EXIT
			ENDIF
			SELECT * FROM empresas WHERE !EMPTY(directorio) INTO CURSOR csrEmpresas
			SELECT csrEmpresas
			SCAN
				ObtenerEmpresa()
				IF !DIRECTORY(ALLTRIM(directorio))
					LOOP
				ENDIF
				Sincro_Automatica_Dbf_Sql(ALLTRIM(localidad))
				SELECT csrEmpresas
			ENDSCAN
			* Pausa antes de la siguiente verificación
*			lcExit = .T.
*			EXIT
			INKEY(5) && Espera 10 segundos
		ENDDO
	CATCH TO loError
		* Registrar el error y continuar con la siguiente iteración externa
		STRTOFILE(DTOC(DATE()) + " " + TIME() + " - Error: " + loError.MESSAGE + CHR(13) + ;
			SPACE(18)+ " - Procedimiento: " + TRANSFORM(loError.PROCEDURE) + CHR(13) +;
			SPACE(18)+ " - Contexto: " + TRANSFORM(loError.LINECONTENTS) + CHR(13) +;
			SPACE(18)+ " - Detalle: " + TRANSFORM(loError.DETAILS) + CHR(13);
			, "error_log.txt", .T.)
		* Reiniciar el bucle interno
		INKEY(5) && Espera 10 segundos
	ENDTRY
ENDDO

* Código de limpieza antes de salir
IF FILE("stop.txt")
	ERASE "stop.txt"
ENDIF

* Salir del programa
CLOSE TABLES all

*QUIT

PROCEDURE HandleError
	PARAMETERS nError, cMessage, cProcedure, cDetails, cLinecontents
	* Registrar el error en un archivo de log
	STRTOFILE(DTOC(DATE()) + " " + TIME() + " - Error: " + cMessage + CHR(13) + ;
		SPACE(18)+ " - Procedimiento: " + TRANSFORM(cProcedure) + CHR(13) +;
		SPACE(18)+ " - Contexto: " + TRANSFORM(cLinecontents) + CHR(13) +;
		SPACE(18)+ " - Detalle: " + TRANSFORM(cDetails) + CHR(13);
		, "error_log.txt", .T.)
	* Continuar con la siguiente iteración externa
	RETURN
ENDPROC


* JSON de ejemplo
lcJson = '{"ANULADA": "FALSE", "CONFORMAR": "  /  /    ", "ENTREGA": "  /  /       :  :   AM", ' + ;
	'"ENTREGA1": "01/10/22", "FTP": "  /  /    ", "VENDEDOR1": "A A", "FECHAHORA": "10/01/2022 01:42:53 AM", ' + ;
	'"IVA1": 0, "NETO": 21033, "IMP1": 0, "IMP2": 0, "BONIF": 0}'

* Eliminar las llaves del JSON
lcJson = STRTRAN(STRTRAN(lcJson, '{', ''), '}', '')
cClave="Anulada"
lcClave = '"'+ALLTRIM(UPPER(cClave))+'":'
* Buscar la posición de la clave en la cadena JSON
lnPosClave = AT(lcClave, lcJson)
lcValor = ''
IF lnPosClave > 0
	* Extraer la parte de la cadena que contiene el valor de la clave
	lcSubcadena = SUBSTR(lcJson, lnPosClave + LEN(lcClave) - 1)
	* Extraer el valor entre el separador ":" y la coma siguiente
	lcValor = STREXTRACT(lcSubcadena, ":", ",", 1)
	* Si es el último elemento y no hay coma, buscamos hasta el cierre de llave
	IF EMPTY(lcValor)
		lcValor = STREXTRACT(lcSubcadena, ":", "}", 1)
	ENDIF
	* Eliminar posibles espacios en blanco o comillas

	lcValor = ALLTRIM(STRTRAN(lcValor, '"', ''))

	lcClave = ALLTRIM(STRTRAN(STRTRAN(lcClave, '"', ''), ':', ''))
ENDIF
SET STEP ON
DO CASE
	CASE ISDATE(lcValor)
		MESSAGEBOX(lcClave + " es una fecha: " + lcValor)

	CASE ISDATETIME(lcValor)
		MESSAGEBOX(lcClave + " es una fecha/hora: " + lcValor)

	CASE ISEMPTYDATETIME(lcValor)
		MESSAGEBOX(lcClave + " es una fecha/hora vacía.")

	CASE ISNUMERIC(lcValor)
		MESSAGEBOX(lcClave + " es un número: " + lcValor)

	OTHERWISE
		MESSAGEBOX(lcClave + " es una cadena de texto: " + lcValor)
ENDCASE

* Funciones de ayuda
FUNCTION ISDATE(lcValor)
	LOCAL lnDate, Bandera
	Bandera = .F.
	TRY
		lnDate = CTOD(lcValor)
		Bandera =  .T.
	CATCH TO oError
	ENDTRY
	RETURN Bandera
ENDFUNC

FUNCTION ISDATETIME(lcValor)
	LOCAL lnDateTime, Bandera
	Bandera=.F.
	TRY
		lnDateTime = DATETIME(VAL(SUBSTR(lcValor, 7, 4)), ;
			VAL(SUBSTR(lcValor, 1, 2)), ;
			VAL(SUBSTR(lcValor, 4, 2)), ;
			VAL(SUBSTR(lcValor, 12, 2)), ;
			VAL(SUBSTR(lcValor, 15, 2)), ;
			VAL(SUBSTR(lcValor, 18, 2))))
		Bandera = .T.
	CATCH TO oError
	ENDTRY
	RETURN Bandera
ENDFUNC

FUNCTION ISEMPTYDATETIME(lcValor)
	RETURN lcValor == "  /  /       :  :   AM" OR lcValor == "  /  /    "
ENDFUNC

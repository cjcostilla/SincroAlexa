
* JSON de ejemplo
lcJson = '{"ANULADA": false, "CONFORMAR": "  /  /    ", "ENTREGA": "  /  /       :  :   AM", ' + ;
	'"ENTREGA1": "01/10/22", "FTP": "  /  /    ", "VENDEDOR1": "A A", "FECHAHORA": "10/01/2022 01:42:53 AM", ' + ;
	'"IVA1": 0, "NETO": 21033, "IMP1": 0.25, "IMP2": 0, "BONIF": 0}'

* Eliminar las llaves del JSON
lcJson = STRTRAN(STRTRAN(lcJson, '{', ''), '}', '')
cClave="imp1"
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

	lcClave = ALLTRIM(STRTRAN(STRTRAN(lcClave, '"', ''), ':', ''))
*!*		IF lcValor=="FALSE"
*!*			lcValor='0'
*!*		ENDIF
*!*		IF lcValor=="TRUE"
*!*			lcValor='1'
*!*		ENDIF
ENDIF

DO CASE
	CASE ISNUMERIC(lcValor)
		MESSAGEBOX(lcClave + " es un n�mero: " + lcValor)

	CASE ContainsDateTime(lcValor)
		MESSAGEBOX(lcClave + " es una fecha/hora: " + lcValor)

	CASE ContainsEmptyDateTime(lcValor)
		MESSAGEBOX(lcClave + " es una fecha/hora vac�a.")

	CASE ContainsDate(lcValor)
		MESSAGEBOX(lcClave + " es una fecha: " + lcValor)

	CASE ContainsEmptyDate(lcValor)
		MESSAGEBOX(lcClave + " es una fecha vac�a.")

	OTHERWISE
		MESSAGEBOX(lcClave + " es una cadena de texto: " + lcValor)
ENDCASE

FUNCTION ContainsDate(lcText)
    LOCAL lnPos, lcDate
    FOR lnPos = 1 TO LEN(lcText) &&- 9
        lcDate = SUBSTR(lcText, lnPos, 10)
        IF ISDATE(lcDate)
            RETURN .T.
        ENDIF
    ENDFOR
    RETURN .F.
ENDFUNC

FUNCTION ISDATE(lcDate)
    LOCAL lnDate
    lnDate = CTOD(lcDate)
    RETURN !EMPTY(lnDate)
ENDFUNC

FUNCTION ContainsDateTime(lcText)
    LOCAL lnPos, lcDateTime
    FOR lnPos = 1 TO LEN(lcText) &&- 18
        lcDateTime = SUBSTR(lcText, lnPos, 19)
        IF ISDATETIME(lcDateTime)
            RETURN .T.
        ENDIF
    ENDFOR
    RETURN .F.
ENDFUNC

FUNCTION ISDATETIME(lcDateTime)
	LOCAL lnDateTime
	lnDateTime = CTOT(lcDateTime)
	RETURN !EMPTY(lnDateTime)
ENDFUNC

FUNCTION ContainsEmptyDate(lcText)
    RETURN AT("/  /", lcText) > 0
ENDFUNC

FUNCTION ContainsEmptyDateTime(lcText)
    RETURN AT("/  /       :  :   AM", lcText) > 0
ENDFUNC

FUNCTION IsNumeric(lcValue)
    LOCAL lcTemp, i
    lcTemp = ALLTRIM(lcValue)

    * Si la cadena est� vac�a, no es un n�mero
    IF EMPTY(lcTemp)
        RETURN .F.
    ENDIF
    
    * Verificar si la cadena contiene solo d�gitos y opcionalmente un punto decimal
    FOR i = 1 TO LEN(lcTemp)
        IF NOT (SUBSTR(lcTemp, i, 1) >= '0' AND SUBSTR(lcTemp, i, 1) <= '9') AND ;
           NOT (SUBSTR(lcTemp, i, 1) == '.')
            RETURN .F.
        ENDIF
    ENDFOR

    RETURN .T.
ENDFUNC

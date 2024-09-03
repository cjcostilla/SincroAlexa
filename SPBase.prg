FUNCTION GenerateJSON(tcTabla, tcAccion, taCamposValores)
	LOCAL lcJSON, lcKey, lcValue, lcPair, i, lcTipoDato
	* Iniciar la cadena JSON
	lcJSON = "{"
	* Recorrer el array de campos y valores
	FOR i = 1 TO ALEN(taCamposValores, 1)
		lcKey = LTRIM(taCamposValores[i, 1])
		lcValue = taCamposValores[i, 2]
		* Agregar comillas a los valores de texto
		lcTipoDato = VARTYPE(lcValue)
		DO CASE
			CASE lcTipoDato = "C"  && Carácter
				lcValue = '"' + RTRIM(lcValue) + '"'
			CASE lcTipoDato = "N"  && Numérico
				lcValue = RTRIM(STR(lcValue))
			CASE lcTipoDato = "D"  && Fecha
				lcValue = '"' + DTOC(lcValue) + '"'
			CASE lcTipoDato = "T"  && DateTime
				lcValue = '"' + TTOC(lcValue)+ '"'
			CASE lcTipoDato = "L"  && Lógico
				lcValue = IIF(lcValue, 'true', 'false')
			CASE lcTipoDato = "M"  && Memo
				lcValue = '"' + MEMLINES(lcValue) + '"'
			OTHERWISE  && Otros tipos de datos
				lcValue = '"' + RTRIM(TRANSFORM(lcValue)) + '"'
		ENDCASE
		* Crear el par clave-valor
		lcPair = '"' + lcKey + '":' + lcValue
		* Agregar el par a la cadena JSON
		lcJSON = lcJSON + lcPair
		* Agregar una coma si no es el último par
		IF i < ALEN(taCamposValores, 1)
			lcJSON = lcJSON + ","
		ENDIF
	ENDFOR
	* Cerrar la cadena JSON
	lcJSON = lcJSON + "}"
	RETURN lcJSON
ENDFUNC



FUNCTION ObtenerCamposyValores(laFieldValues) 
	LOCAL laFields[1], laValues[1], laFieldValues[1,2], lnFieldCount, i
	* Obtener los nombres de los campos
	lnFieldCount = AFIELDS(laFields)
	DIMENSION laFieldValues[lnFieldCount, 2]
	FOR i = 1 TO lnFieldCount
		laFieldValues[i, 1] = laFields[i, 1]  && Nombre del campo
		laFieldValues[i, 2] = EVALUATE(laFields[i, 1])  && Valor del campo
	ENDFOR

    RETURN laFieldValues
ENDFUNC

FUNCTION SincroInsert
	* Definir los campos y valores para una inserción
	LOCAL laCamposTabla[1,1]
	tcTabla = ALIAS()
	ObtenerCamposyValores(@laCamposTabla)
	lcJSON = GenerateJSON(tcTabla, "INSERT", @laCamposTabla)
	INSERT INTO Auditoria (Tabla, operacion, campos) VALUES (tcTabla, "INSERT", lcJSON)
	RETURN .T.
ENDFUNC

FUNCTION SincroUpdate
	* Definir los campos y valores para una inserción
	LOCAL laCamposTabla[1,1]
	tcTabla = ALIAS()
	ObtenerCamposyValores(@laCamposTabla)
	lcJSON = GenerateJSON(tcTabla, "UPDATE", @laCamposTabla)
	INSERT INTO Auditoria (Tabla, operacion, campos) VALUES (tcTabla, "UPDATE", lcJSON)
	RETURN .T.
ENDFUNC

FUNCTION SincroDelete
	LOCAL laCamposTabla[1,1]
	tcTabla = ALIAS()
	ObtenerCamposyValores(@laCamposTabla)
	lcJSON = GenerateJSON(tcTabla, "DELETE", @laCamposTabla)
	INSERT INTO Auditoria (Tabla, operacion, campos) VALUES (tcTabla, "DELETE", lcJSON)
	RETURN .T.
ENDFUNC

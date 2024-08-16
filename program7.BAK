* Definir los campos y valores para una inserción
DIMENSION aCamposValores[3, 2]
aCamposValores[1, 1] = "nombre"
aCamposValores[1, 2] = "Juan Perez"
aCamposValores[2, 1] = "email"
aCamposValores[2, 2] = "juan.perez@example.com"
aCamposValores[3, 1] = "telefono"
aCamposValores[3, 2] = "123456789"

* Generar el JSON
lcJSON = GenerateJSON("clientes_vfp", "INSERT", aCamposValores)
SET STEP ON 
* Insertar en la tabla de auditoría
INSERT INTO auditoria (tabla, operacion, campo) VALUES ("clientes_vfp", "INSERT", lcJSON)


FUNCTION GenerateJSON(tcTabla, tcAccion, taCamposValores)
    LOCAL lcJSON, lcKey, lcValue, lcPair, i

    * Iniciar la cadena JSON
    lcJSON = "{"

    * Recorrer el array de campos y valores
    FOR i = 1 TO ALEN(taCamposValores, 1)
        lcKey = taCamposValores[i, 1]
        lcValue = taCamposValores[i, 2]
        
        * Agregar comillas a los valores de texto
        IF VARTYPE(lcValue) == "C"
            lcValue = '"' + lcValue + '"'
        ENDIF

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


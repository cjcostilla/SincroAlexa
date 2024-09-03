* Definir la ruta del archivo de texto de salida
lcOutputFile = "Tabla_sincro.sql"

* Crear o limpiar el archivo de texto
STRTOFILE("", lcOutputFile, 0)

* Listar las tablas que necesitas procesar
LOCAL ARRAY aTablas[1]
aTablas[1] = "unidmedida"  && 
*aTablas[2] = "mapeo"  && 
*aTablas[1] = "tipocomprobantes"  && 
*!*	aTablas[1] = "articulo_univoco1"  && abm_articulo_univoco
*!*	aTablas[2] = "depósitos"  && abm_depositos
*!*	aTablas[3] = "empleados_cliente"  && abm_empleados_del_cliente
*!*	aTablas[4] = "clientes"  && abm_clientes
*!*	aTablas[5] = "unidadmedida"  && abm_unidades_de_medida
*!*	aTablas[6] = "rubro"  && abm_rubros
*!*	aTablas[7] = "subrubro"  && abm_subrubros
*!*	aTablas[8] = "unidadmedida"  && abm_unidades_de_medida
*!*	aTablas[9] = "colores"  && abm_colores
* Más nombres de tablas si es necesario

* Iterar sobre las tablas
FOR lnTabla = 1 TO ALEN(aTablas, 1)
	lcTabla = aTablas[lnTabla]
	IF FILE(lcTabla+".dbf")
		IF !USED(lcTabla)
	 		USE &lcTabla
	 	ENDIF 

		* Obtener la estructura de la tabla
		LOCAL ARRAY aEstructura[1]
		AFIELDS(aEstructura, lcTabla)

		* Comenzar la sentencia CREATE TABLE
		lcCreateTable = "CREATE TABLE " + lcTabla + " (" + CHR(13) + CHR(10)

		* Añadir cada campo a la sentencia CREATE TABLE
		FOR lnCampo = 1 TO ALEN(aEstructura, 1)
			lcCampoNombre = aEstructura[lnCampo, 1]
			lcCampoTipo = aEstructura[lnCampo, 2]
			lnCampoTamano = aEstructura[lnCampo, 3]
			lnCampoDecimales = aEstructura[lnCampo, 4]

			DO CASE
				CASE lcCampoTipo = "C"
					lcTipoSQL = "CHAR(" + TRANSFORM(lnCampoTamano) + ")"
				CASE lcCampoTipo = "N"
					lcTipoSQL = "NUMERIC(" + TRANSFORM(lnCampoTamano) + "," + TRANSFORM(lnCampoDecimales) + ")"
				CASE lcCampoTipo = "D"
					lcTipoSQL = "DATE"
				CASE lcCampoTipo = "T"
					lcTipoSQL = "DATETIME"
				CASE lcCampoTipo = "L"
					lcTipoSQL = "LOGICAL"
				CASE lcCampoTipo = "M"
					lcTipoSQL = "MEMO"
				CASE lcCampoTipo = "F"
					lcTipoSQL = "FLOAT"
				OTHERWISE
					lcTipoSQL = lcCampoTipo + "(" + TRANSFORM(lnCampoTamano) + ")"
			ENDCASE

			lcLinea = "    " + lcCampoNombre + " " + lcTipoSQL

			* Añadir coma si no es el último campo
			IF lnCampo < ALEN(aEstructura, 1)
				lcLinea = lcLinea + ","
			ENDIF

			lcLinea = lcLinea + CHR(13) + CHR(10)
			lcCreateTable = lcCreateTable + lcLinea
		ENDFOR

		* Finalizar la sentencia CREATE TABLE
		lcCreateTable = lcCreateTable + ");" + CHR(13) + CHR(10) + CHR(13) + CHR(10)

		* Escribir la sentencia CREATE TABLE en el archivo de texto
		STRTOFILE(lcCreateTable, lcOutputFile, 1)

		* Obtener los registros y crear sentencias INSERT INTO
		SELECT (lcTabla)
		SCAN &&RECNO() < 11
			lcInsertInto = "INSERT INTO " + lcTabla + " VALUES ("

			FOR lnCampo = 1 TO ALEN(aEstructura, 1)
				lcCampoNombre = aEstructura[lnCampo, 1]
				lcCampoTipo = aEstructura[lnCampo, 2]
				lcValor = EVALUATE(lcCampoNombre)

				DO CASE
					CASE lcCampoTipo = "C" OR lcCampoTipo = "M"
						lcValorSQL = "'" + ALLTRIM(lcValor) + "'"
					CASE lcCampoTipo = "D"
						lcValorSQL = "'" + DTOC(lcValor) + "'"
					CASE lcCampoTipo = "T"
						lcValorSQL = "'" + TTOC(lcValor) + "'"
					CASE lcCampoTipo = "L"
						lcValorSQL = IIF(lcValor, ".T.", ".F.")
					OTHERWISE
						lcValorSQL = TRANSFORM(lcValor)
				ENDCASE

				lcInsertInto = lcInsertInto + lcValorSQL

				* Añadir coma si no es el último campo
				IF lnCampo < ALEN(aEstructura, 1)
					lcInsertInto = lcInsertInto + ", "
				ENDIF
			ENDFOR

			lcInsertInto = lcInsertInto + ")" + CHR(13) + CHR(10)

			* Escribir la sentencia INSERT INTO en el archivo de texto
			STRTOFILE(lcInsertInto, lcOutputFile, 1)
		ENDSCAN

		* Añadir un salto de línea entre tablas
		STRTOFILE(CHR(13) + CHR(10), lcOutputFile, 1)
		USE IN &lcTabla
	ENDIF
ENDFOR

MESSAGEBOX("El proceso ha finalizado.")

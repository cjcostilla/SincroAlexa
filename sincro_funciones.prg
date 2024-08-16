FUNCTION sumar(v1, v2)
	LOCAL liResultado
	liResultado = v1 + v2
	RETURN liResultado
ENDFUNC

FUNCTION Decir_mayor(v1, v2)
	LOCAL liResultado
	DO CASE
		CASE v1 > v2
			liResultado = "Valor 1 es  mayor"
		CASE v1 < v2
			liResultado = "Valor 2 es  mayor"
	OTHERWISE 
		liResultado = "Valores Iguales"
	ENDCASE 
	RETURN liResultado
ENDFUNC

* Supongamos que tu fecha está en formato 'MM-DD-YY HH:MM:SS'
lcOriginalDate = '08-14-24 06:00:43'

* Supongamos que tu fecha está en formato 'MM-DD-YY HH:MM:SS'
lcOriginalDate = '08/14/24 06:00:43'

* Extraer componentes de la fecha
lcMonth = LEFT(lcOriginalDate, 2)
lcDay = SUBSTR(lcOriginalDate, 4, 2)
lcYear = SUBSTR(lcOriginalDate, 7, 2)

* Convertir el año al formato completo
lcYear = "20" + lcYear

* Reunir la fecha en el formato 'YYYY-MM-DD'
lcFormattedDate = lcYear + "-" + lcMonth + "-" + lcDay + " " + SUBSTR(lcOriginalDate, 10, 8)

* Mostrar el resultado
MESSAGEBOX(lcFormattedDate)

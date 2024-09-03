CLOSE TABLES all
* Definir la lista de tablas
LOCAL laTablas[11]
laTablas[1] = "articulo_univoco1"
laTablas[2] = "depósitos"
laTablas[3] = "empleados_cliente"
laTablas[4] = "clientes"
laTablas[5] = "unidmedida"
laTablas[6] = "rubro"
laTablas[7] = "subrubro"
laTablas[8] = "colores"
laTablas[9] = "stock1"
laTablas[10] = "remi1"
laTablas[11] = "remi2"

SET STEP ON 
* Recorrer la lista de tablas y verificar/agregar los campos
FOR EACH lcTabla IN laTablas
    USE (lcTabla) IN 0 EXCLUSIVE  

    * Verificar y agregar el campo 'ultimo_cambio'
    IF EMPTY(FIELD("ultimo_cambio"))
        ALTER TABLE (lcTabla) ADD COLUMN ultimo_cambio DATETIME DEFAULT DATETIME()
    ENDIF
    
    IF EMPTY(FIELD("ultima_accion"))
        ALTER TABLE (lcTabla) ADD COLUMN ultima_accion CHAR(1) DEFAULT "A"
    ENDIF
    
    USE IN SELECT(lcTabla)  
ENDFOR

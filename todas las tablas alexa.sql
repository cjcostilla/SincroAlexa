setiniciales()
*CLOSE TABLES all

_otabla =  "PROVINCIA"

PUBLIC _xrutadato
_xrutadato = ALLTRIM(UPPER(thisform.text3.value))

PUBLIC _xempresa
_xempresa = thisform.spinner3.Value 

PUBLIC _xnombre_empresa
_xnombre_empresa = ALLTRIM(UPPER(thisform.text2.Value))
 
 PUBLIC _xusuario
 _xusuario = thisform.spinner2.Value
 
 PUBLIC _xregion
 _xregion = thisform.spinner1.Value
 
 PUBLIC _xrubro 
 _xrubro = thisform.spinner4.Value
 
 PUBLIC _xmoneda
 _xmoneda = thisform.spinner5.Value
 
 PUBLIC _xexportado
 _xexportado = thisform.combo1.Displayvalue 
 
 PUBLIC _xrutalog
_xrutalog =  ALLTRIM(UPPER(thisform.text4.value))

 PUBLIC _xvaciar_tablas
_xvaciar_tablas =  thisform.check1.value

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

*ca_dbf_a_sql_localidades()

_tablavfp = 0
_tablaSQL = 0

_tablasinconversion = 0
_tablasconvertidas = 0
_tablascondatos = 0
_tablassindatos = 0
nCount = 0
gnDbcnumber = adir(_Archivos, _xrutadato + '*.DBF') && Crea la matriz.
					******************** copiar los datos *****************	
set exclusive off

wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT


 
 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PAISES"   && CREADA A MANO - COMPARTIDA ENTRE TODOS LOS USUARIOS
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'PAISES'
		_otablaSQL = 'abm_regiones'


_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 SELECT TablasProcesadas
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ' /// creada a mano'
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ' /// creada a mano'
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()
 
 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "MONEDAS"   && CREADA A MANO - COMPARTIDA ENTRE TODOS LOS USUARIOS
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'MONEDAS'
		_otablaSQL = 'abm_monedas'


_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 SELECT TablasProcesadas
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ' /// creada a mano'
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ' /// creada a mano'
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PROVINCIA"

	nCount = nCount + 1
								
	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_provincia' &&&
			
		ENDIF 

_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 SELECT TablasProcesadas
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 thisform.grid1.Refresh()
 
 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "LOCALIDAD"   && INCLUYE MUNICIPIOS Y CIUDADES
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'LOCALIDAD'
		_otablaSQL = 'abm_localidades'
		_ocursorSQL = 'oDb_abm_localidades'

		_otablaSQL_1 = 'abm_municipios'
		_ocursorSQL_1 = 'oDb_abm_municipios'

		_otablaSQL_2 = 'abm_ciudades'
		_ocursorSQL_2 = 'oDb_abm_ciudades'

		_otablaSQL_3 = 'abm_provincias'
		_ocursorSQL_3 = 'oDb_abm_provincias'

	TRY 
		USE IN &_otabla
	CATCH TO OEX
	ENDTRY 
	
	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
*	BROWSE
	
	COUNT to _cuantos_25072015


			wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
			'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
			'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
			'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT

		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_localidades' &&&

		ELSE
			WAIT WINDOW 'no hay Localidades'								
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
_tablavfp = _tablavfp
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_2
 replace num WITH _tablavfp
*_tablavfp = _tablavfp + 1
*_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablasql WITH 'REPETIDO: ' + _otablasql_3
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()


*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "RUBRO"  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'RUBRO'
		_otablaSQL = 'abm_rubros'
		_ocursorSQL = 'oDb_abm_rubros'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_rubros' &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "SUBRUBRO"   
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'SUBRUBRO'
		_otablaSQL = 'abm_subrubros'
		_ocursorSQL = 'oDb_abm_subrubros'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_subrubros' &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
  replace num WITH _tablavfp
=TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()


*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "UNIDMEDIDA"  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'UNIDMEDIDA'
		_otablaSQL = 'abm_unidades_de_medida'
		_ocursorSQL = 'oDb_abm_unidades_de_medida'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_unidades_de_medida' &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
=TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "COMENTARIO1 "  && incluye: COMENTARIOS2 COMENTARIOS2_POLITICAS  &&& ABM_TIPOS_DE_DESCRIPTORES, ABM_DESCRIPTORES_CABECERA, ABM_DESCRIPTORES_CONTENIDO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'COMENTARIO1'  
		_otablaSQL = 'abm_tipos_de_descriptores'
		_ocursorSQL = 'oDb_abm_tipos_de_descriptores'

		_otabla_1 = 'COMENTARIO2'  
		_otablaSQL_1 = 'abm_descriptores_cabecera'
		_ocursorSQL_1 = 'oDb_abm_descriptores_cabecera'

		_otabla_2 = 'COMENTARIOS2_politicas'  
		_otablaSQL_2 = 'abm_descriptores_contenido'
		_ocursorSQL_2 = 'oDb_abm_descriptores_contenido'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_descriptores' &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_2
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_2
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "TALLES"  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'UNIDMEDIDA'
		_otablaSQL = 'abm_talles'
		_ocursorSQL = 'oDb_abm_talles'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		
		_otabla =  "TALLES"  

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_talles' &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH 'NO EXISTE: ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CLASE"  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CLASE'
		_otablaSQL = 'abm_categorias_impositivas'
		_ocursorSQL = 'oDb_abm_categorias_impositivas'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		

		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_categorias_impositivas' &&&
			
		ENDIF 
		
 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
=TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CONDCPRA"  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CONDCPRA'
		_otablaSQL = 'abm_condiciones_de_compra'
		_ocursorSQL = 'oDb_abm_condiciones_de_compra'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_condiciones_de_compra.prg'			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "AGRUPAC"  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'AGRUPAC'
		_otablaSQL = 'abm_agrupaciones_contables'
		_ocursorSQL = 'oDb_abm_agrupaciones_contables'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_agrupaciones.prg'			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CENTCOST"  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CENTCOST'
		_otablaSQL = 'abm_centros_de_costo'
		_ocursorSQL = 'oDb_abm_centros_de_costo'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_centros_de_costo.prg'	
		ENDIF 

 SELECT TablasProcesadas
 SET ORDER TO num descending
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
  replace num WITH _tablavfp
=TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "REGLAS"  && incluye: REGLAS2  
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'REGLAS'  
		_otablaSQL = 'ABM_Reglas_de_apropiacion_cabecera'
		_ocursorSQL = 'oDb_ABM_Reglas_de_apropiacion_cabecera'

		_otabla_1 = 'REGLAS2'  
		_otablaSQL_1 = 'ABM_Reglas_de_apropiacion_contenido'
		_ocursorSQL_1 = 'oDb_ABM_Reglas_de_apropiacion_contenido'


	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_reglas_de_apropiacion.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
 SET ORDER TO num descending
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
  replace num WITH _tablavfp
  =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CUENTAS"   
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CUENTAS'  
		_otablaSQL = 'ABM_cuentas_contables'
		_ocursorSQL = 'oDb_ABM_cuentas_contables'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_cuentas_ contables.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
 SET ORDER TO num descending
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "GRUPOS_DE_SERVICIOS"  && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "GRUPOS_DE_SERVICIOS" 
		_otablaSQL = 'ABM_grupos_de_servicios'
		_ocursorSQL = 'oDb_ABM_grupos_de_servicios'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_grupos_de_servicios.prg'  &&&
			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "STOCK1"  && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "STOCK1" 
		_otablaSQL = 'ABM_articulos'
		_ocursorSQL = 'oDb_ABM_articulos'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_articulos.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PROCESOS"  && FALTA PROCESOS2  /// ABM_PROCESOS_CABECERA Y FALTA PROCESOS_CONTENIDO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "PROCESOS" 
		_otablaSQL = 'ABM_procesos_cabecera'
		_ocursorSQL = 'oDb_ABM_procesos_cabecera'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_procesos_cabecera.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()
 
 
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "SUBPROCESOS"  && INCLUYE SUBPROCESOS_PROCESOS_VINCULADOS  /// ABM_SUBPROCESOS_CABECERA Y SUBPROCESOS_CONTENIDO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "SUBPROCESOS" 
		_otablaSQL = 'ABM_subprocesos_cabecera'
		_ocursorSQL = 'oDb_ABM_subprocesos_cabecera'

		_otabla_1 = "SUBPROCESOS_procesos_vinculados" 
		_otablaSQL_1 = 'ABM_subprocesos_contenido'
		_ocursorSQL_1 = 'oDb_ABM_subprocesos_contenido'
		
	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_subprocesos_cabecera_y_contenido.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()
 
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "UNIDADES DE EMPAQUE"  && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "UNIDMEDIDA" 
		_otablaSQL = 'ABM_unidades_de_empaque'
		_ocursorSQL = 'oDb_ABM_unidades_de_empaque'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_unidades_de_empaque.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PLANTAS"  && INCLUYE PLANTAS_PROCESOS // PLANTAS DE PROCESOCABECERA / PLANTAS DE PROCESO CONTENIDO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "PLANTAS" 
		_otablaSQL = 'ABM_plantas_de_proceso_cabecera'
		_ocursorSQL = 'oDb_ABM_plantas_de_proceso_cabecera'

		_otabla_1 = 'PLANTAS_PROCESOS'  
		_otablaSQL_1 = 'ABM_plantas_de_proceso_contenido'
		_ocursorSQL_1 = 'oDb_ABM_plantas_de_proceso_contenido'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_plantas_de_proceso_cabecera_y_contenido.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "UNIDADES DE EMPAQUE"  && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "UNIDMEDIDA" 
		_otablaSQL = 'ABM_unidades_de_empaque'
		_ocursorSQL = 'oDb_ABM_unidades_de_empaque'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_unidades_de_empaque.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()
 
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "LEYENDAS"  && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "REMI1" 
		_otablaSQL = 'ABM_leyendas'
		_ocursorSQL = 'oDb_ABM_leyendas'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_leyendas.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "SERVICIOS"  && INCLUYE SERVICIOS_ARTICULOS //  abm_servicios_de_venta / abm_servicios_de_venta_articulos_vinculados'  &&&
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "SERVICIOS" 
		_otablaSQL = 'ABM_servicios_de_venta'
		_ocursorSQL = 'oDb_ABM_servicios_de_venta'

		_otabla_1 = 'SERVICIOS_ARTICULOS'  
		_otablaSQL_1 = 'ABM_servicios_de_venta_articulos_vinculados'
		_ocursorSQL_1 = 'oDb_ABM_servicios_de_venta_articulos_vinculados'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_servicios_de_venta_y_servicios_de_venta_articulos_vinculados.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "POLPRECIOS"  && INCLUYE SERVICIOS_ARTICULOS //  abm_servicios_de_venta / abm_servicios_de_venta_articulos_vinculados'  &&&
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "POLPRECIOS" 
		_otablaSQL = 'abm_politicas_de_precios_de_servicios_cabecera'
		_ocursorSQL = 'oDb_abm_politicas_de_precios_de_servicios_cabecera'

		_otabla_1 = 'POLPRSERV2'  
		_otablaSQL_1 = 'abm_politicas_de_precios_de_servicios_contenido'
		_ocursorSQL_1 = 'oDb_abm_politicas_de_precios_de_servicios_contenido'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_politica_de_precios_de_servicios_de_venta_cabecera_y_contenido.prg'
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PROVEEDORES"  && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "PROVEED" 
		_otablaSQL = 'ABM_proveedores'
		_ocursorSQL = 'oDb_ABM_proveedores'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_proveedores.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()
 
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "ORDEN"   && CALIFICACIONES DE USUARIO &&  CREADA A MANO - LLENADA A MANO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'ORDEN'
		_otablaSQL = 'abm_calificacion_de_clientes'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_calificacion_de_clientes.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp


 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CONDVTA"   && CALIFICACIONES DE USUARIO &&  CREADA A MANO - LLENADA A MANO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CONDVTA'
		_otablaSQL = 'abm_condiciones_de_venta'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_condiciones_de_venta.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp


 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "RESULTADOS"   && CALIFICACIONES DE USUARIO &&  CREADA A MANO - LLENADA A MANO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'RESULTADOS'
		_otablaSQL = 'abm_crm_resultados'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_crm_resultados.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp


 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()
 
 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "ARGUMENTACIONES"   && CALIFICACIONES DE USUARIO &&  CREADA A MANO - LLENADA A MANO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'ARGUMENTACIONES'
		_otablaSQL = 'abm_crm_argumentaciones'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_crm_argumentaciones.prg'  &&&
			
		ENDIF 

 SELECT TablasProcesadas

_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp


 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "BASES DE DATOS CRM"   && CALIFICACIONES DE USUARIO &&  CREADA A MANO - LLENADA A MANO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'BASES DE DATOS CRM'
		_otablaSQL = 'abm_crm_bases_de_datos'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1
*
*			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_bases_de_datos.prg'  &&&
*			
*		ENDIF 

 SELECT TablasProcesadas

_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ' /// No existe'
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + '  /// No existe en DBF'
 replace num WITH _tablavfp


 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CATEGAGE"   
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CATEGAGE'
		_otablaSQL = 'abm_crm_categorias_de_agenda'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_crm_categorias_de_agenda.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PROXIMAS_ACCIONES"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'PROXIMAS_ACCIONES'
		_otablaSQL = 'abm_crm_proximas_acciones'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_crm_proximas_acciones.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "SITUACION-CONTACTO"   && NO EXISTE  /// CARGADO A MANO
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'SITUACION-CONTACTO'
		_otablaSQL = 'abm_crm_situacion_contacto'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_crm_situacion_contacto.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ' /// NO EXISTE'
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ' /// CARGADO A MANO'
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "VALORACIONES"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'VALORACIONES'
		_otablaSQL = 'abm_crm_valoraciones'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_crm_valoraciones.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()
 
 *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "TRANSPORTISTAS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'TRANSPORTISTAS'
		_otablaSQL = 'abm_TRANSPORTISTAS'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_transportistas.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "ZONA"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'ZONA'
		_otablaSQL = 'abm_ZONAS'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_ZONAS.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "VENDED"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'VENDED'
		_otablaSQL = 'abm_VENDEDORES'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_VENDEDORES.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CLIENTES"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CLIENTES'
		_otablaSQL = 'abm_CLIENTES'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_CLIENTES.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "TIPOS DE DEPOSITO"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'TIPOS DE DEPOSITO'
		_otablaSQL = 'abm_TIPOS_DE_DEPOSITO'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_TIPOS_DE_DEPOSITO.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "DEPÓSITOS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'DEPÓSITOS'
		_otablaSQL = 'abm_DEPOSITOS'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_DEPOSITOS.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

_otabla = 'SET_DE_PRENDAS_CABECERA'
_otablasql = 'abm_set_de_prendas_cabecera'
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

_otabla = 'SET_DE_PRENDAS'
_otablaSQL = 'abm_set_de_prendas_contenido'
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

_otabla = 'EMPLEADOS_CLIENTE'
_otablaSQL = 'abm_empleados_del_cliente'
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "ESTADOS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'ESTADOS'
		_otablaSQL = 'abm_ESTADOS'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_ESTADOS.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()
 
   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "TIPOCOMPROBANTES"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'TIPOCOMPROBANTES'
		_otablaSQL = 'abm_tipos_de_comprobante'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_tipos_de_comprobante.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()
  
  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CALIFICACIONES"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'PSS'
		_otablaSQL = 'ABM_calificaciones_de_usuario'

	PUBLIC _xrutadatoreal
	_xrutadatoreal = _xrutadato 
	_xrutadato = 'C:\APLICACIONES\PROGRAMAS\ALEXA\'  && esta es una tabla que está en la raíz de ALEXA
	oDb_abrir_tabla_dbf(_otabla)
	_xrutadato = _xrutadatoreal  && vuelvo a setear la ruta correcta a los datos
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_calificaciones_de_usuario.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh() 

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "DEPARTAMENTOS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'DEPARTAMENTOS'
		_otablaSQL = 'ABM_DEPARTAMENTOS'

	PUBLIC _xrutadatoreal
	_xrutadatoreal = _xrutadato 
	_xrutadato = 'C:\APLICACIONES\PROGRAMAS\ALEXA\'  && esta es una tabla que está en la raíz de ALEXA
	oDb_abrir_tabla_dbf(_otabla)
	_xrutadato = _xrutadatoreal  && vuelvo a setear la ruta correcta a los datos
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_DEPARTAMENTOS.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh() 

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PSS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'PSS'
		_otablaSQL = 'ABM_usuarios_cabecera'

	PUBLIC _xrutadatoreal
	_xrutadatoreal = _xrutadato 
	_xrutadato = 'C:\APLICACIONES\PROGRAMAS\ALEXA\'  && esta es una tabla que está en la raíz de ALEXA
	oDb_abrir_tabla_dbf(_otabla)
	_xrutadato = _xrutadatoreal  && vuelvo a setear la ruta correcta a los datos
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_usuarios_cabecera.prg'  &&&
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 
		_otabla = 'atribuciones_usuarios_2'
		_otablaSQL = 'ABM_usuarios_contenido'
		
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()


  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "MPAGO"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'MPAGO'
		_otablaSQL = 'abm_MEDIOS_DE_PAGO'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_medios_de_pago.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "justificaciones_movimientos_asimetricos"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'justificaciones_movimientos_asimetricos'
		_otablaSQL = 'abm_justificaciones_movimientos_asimetricos'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_justificaciones_movimientos_asimetricos.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "MUESTRAS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'MUESTRAS'
		_otablaSQL = 'abm_muestras'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

*			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_medios_de_pago.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ' /// NO EXISTE'
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ' /// NO SE CARGA'
 replace num WITH _tablavfp

 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "REMI1"  &&   &&&
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "REMI1" 
		_otablaSQL = 'documentos_cabecera'
		_ocursorSQL = 'oDb_documentos_cabecera'

		_otabla_1 = 'REMI2'  
		_otablaSQL_1 = 'documentos_contenido'
		_ocursorSQL_1 = 'oDb_documentos_contenido'

		_otabla_2 = 'documentos_logistica_interna'  && No existe en DBF
		_otablaSQL_2 = 'documentos_logistica_interna'
		_ocursorSQL_2 = 'oDb_documentos_logistica_interna'

		_otabla_3 = 'bajado_en_documento'  && No existe en DBF
		_otablaSQL_3 = 'bajado_en_documento'
		_ocursorSQL_3 = 'oDb_bajado_en_documento'

		_otabla_4 = 'tags_de_ropa'  && No existe en DBF
		_otablaSQL_4 = 'tags_de_ropa'
		_ocursorSQL_4 = 'oDb_tags_de_ropa'

		_otabla_5 = 'documentos_leyendas'  && No existe en DBF
		_otablaSQL_5 = 'documentos_leyendas'
		_ocursorSQL_5 = 'oDb_tags_de_ropa'
		
		_otabla_6 = 'documentos_descriptores'  && No existe en DBF
		_otablaSQL_6 = 'documentos_descriptores'
		_ocursorSQL_6 = 'oDb_documentos_descriptores'

		_otabla_7 = 'OTROS1'  && solo existe en DBF
		_otablaSQL_7 = 'OTROS1'
		_ocursorSQL_7 = 'oDb_OTROS1'

		_otabla_8 = 'OT122'  && solo existe en DBF
		_otablaSQL_8 = 'OT122'
		_ocursorSQL_8 = 'oDb_OT122'

		_otabla_8 = 'REMITO122'  && solo existe en DBF
		_otablaSQL_8 = 'REMITO122'
		_ocursorSQL_8 = 'oDb_REMITO122'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_documentos.prg'
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_2
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_2
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_3
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_3
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_4
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_4
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_5
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_5
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_6
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_6
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
*_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_7
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_7 + ' - No existe en SQL'
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
*_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_8
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_8 + ' - No existe en SQL'
 replace num WITH _tablavfp
*_tablavfp = _tablavfp + 1
**_tablaSQL = _tablaSQL + 1
* APPEND BLANK 
* replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_9
* replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_9 + ' - No existe en SQL'
* replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()
 
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "REMI1 -solo movimientos-"  &&   &&&
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "REMI1 -solo movimientos-" && no existe en DBF
		_otablaSQL = 'documentos_solo_movimiento_cabecera'
		_ocursorSQL = 'oDb_documentos_solo_movimiento_cabecera'

		_otabla_1 = 'REMI2 -solo movimientos-'  && no existe en DBF
		_otablaSQL_1 = 'documentos_solo_movimiento_contenido'
		_ocursorSQL_1 = 'oDb_documentos_solo_movimiento_contenido'


*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_documentos_solo_movimiento.prg'  &&&	
*		ENDIF 

 SELECT TablasProcesadas
*_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
*_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top

 thisform.grid1.Refresh()		

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "ARMADO1"  &&   &&&
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "ARMADO1" && 
		_otablaSQL = 'documentos_bultos_cabecera'
		_ocursorSQL = 'oDb_documentos_bultos_cabecera'

		_otabla_1 = 'ARMADO2'  && 
		_otablaSQL_1 = 'documentos_bultos_contenido'
		_ocursorSQL_1 = 'oDb_documentos_bultos_contenido'


	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_documentos_bultos.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
*_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
*_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "tipos_de_contenedor"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'tipos_de_contenedor'
		_otablaSQL = 'abm_tipos_de_contenedor'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_tipos_de_contenedor.prg'  &&&	
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

  *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "tipos_de_material"   && No existe en DBF
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'tipos_de_material - no existe en DBF'
		_otablaSQL = 'abm_tipos_de_material'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

*			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_medios_de_pago.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
*_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ' /// NO EXISTE'
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql 
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		
		
   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CONTENEDORES"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CONTENEDORES'
		_otablaSQL = 'abm_CONTENEDORES'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015

		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_contenedores.prg'  &&&			
		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CONTENEDORES1"  &&   &&&
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "CONTENEDORES1" && 
		_otablaSQL = 'documentos_contenedores_cabecera'
		_ocursorSQL = 'oDb_documentos_contenedores_cabecera'

		_otabla_1 = 'CONTENEDORES2'  && 
		_otablaSQL_1 = 'documentos_contenedores_contenido'
		_ocursorSQL_1 = 'oDb_documentos_contenedores_contenido'


	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_documentos_bultos.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
*_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
*_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "OPCIONES"  &&   &&&
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = "OPCIONES" && 
		_otablaSQL = 'OPCIONES'
		_ocursorSQL = 'oDb_OPCIONES'

	oDb_abrir_tabla_dbf(_otabla)
	SELECT &_otabla
	COUNT to _cuantos_25072015


		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
		
*		IF _cuantos_25072015 > 0
			_tablascondatos = _tablascondatos + 1
			_tablasconvertidas = _tablasconvertidas + 1
			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_OPCIONES.prg'  &&&
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "REMI1X"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'REMI1X'
		_otablaSQL = 'documentos_anulados'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_documentos_anulados.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "CAJA"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'CAJA'
		_otablaSQL = 'abm_CAJAS'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_cajas.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "BANCO"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'BANCO'
		_otablaSQL = 'abm_BANCOS'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_bancos.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "BANCOS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'BANCOS'
		_otablaSQL = 'abm_cuentas_bancarias'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_cuentas_bancarias.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "RECIBOS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'RECIBOS'
		_otablaSQL = 'MOVIMIENTOS_DE_CAJA_CABECERA'

		_otabla_1 = 'CAJAM'
		_otablaSQL_1 = 'MOVIMIENTOS_DE_CAJA_CONTENIDO'

		_otabla_2 = ''  &&& ORIGEN
		_otablaSQL_2 = 'ABM_MOVIMIENTOS_DE_CAJA'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_movimientos_de_caja.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_1 + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql_1 + ''
 replace num WITH _tablavfp
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla_2 + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasq_2 + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		


   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "DIAS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'DIAS'
		_otablaSQL = 'abm_tags_sincronizacion'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_tags_sincronizacion.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "DIAS_festivos"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'DIAS_festivos'
		_otablaSQL = 'abm_DIAS_festivos'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_dias_festivos.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "lenguaje"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'lenguaje'
		_otablaSQL = 'lenguaje'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_lenguaje.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "DESCUENTOS"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'DESCUENTOS'
		_otablaSQL = 'ABM_DESCUENTOS_PARAMETRIZADOS'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_DESCUENTOS_PARAMETRIZADOS.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		


   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "PL1000"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'PL1000'
		_otablaSQL = 'ABM_control_de_presentismo'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_control_de_presentismo.prg'
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		
			
   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
_otabla =  "REMI1XREIMPR"   && 
WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5

	nCount = nCount + 1
								
		_otabla = 'REMI1XREIMPR'
		_otablaSQL = 'documentos_reimpresos'

*	oDb_abrir_tabla_dbf(_otabla)
*	SELECT &_otabla
*	COUNT to _cuantos_25072015
*
*		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
*		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
*		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
*		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
*		
*		IF _cuantos_25072015 > 0
*			_tablascondatos = _tablascondatos + 1
*			_tablasconvertidas = _tablasconvertidas + 1

			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_documentos_reimpresos.prg'  &&&			
*		ENDIF 

 SELECT TablasProcesadas
_tablavfp = _tablavfp + 1
_tablaSQL = _tablaSQL + 1
 APPEND BLANK 
 replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
 replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
 replace num WITH _tablavfp
 =TABLEUPDATE(.t., .t.)
 SET ORDER TO num 
 GO top
 thisform.grid1.Refresh()		

*   *&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*_otabla =  "EMPRESAS"   && 
*WAIT WINDOW 'listo, Procesando ahora: ' + _otabla NOWAIT TIMEOUT 5
*
*	nCount = nCount + 1
*								
*		_otabla = 'EMPRESAS'
*		_otablaSQL = 'abm_empresas'
*
**	oDb_abrir_tabla_dbf(_otabla)
**	SELECT &_otabla
**	COUNT to _cuantos_25072015
**
**		wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
**		'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
**		'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
**		'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) NOWAIT
**		
**		IF _cuantos_25072015 > 0
**			_tablascondatos = _tablascondatos + 1
**			_tablasconvertidas = _tablasconvertidas + 1
*
*			DO SYS(5) + 'oDbsql/odb_dbf_a_sql_empresas.prg'  &&&			
**		ENDIF 
*
* SELECT TablasProcesadas
*_tablavfp = _tablavfp + 1
*_tablaSQL = _tablaSQL + 1
* APPEND BLANK 
* replace tablavfp WITH ALLTRIM(STR(_tablavfp)) + ') ' + _otabla + ''
* replace tablasql WITH ALLTRIM(STR(_tablaSQL)) + ') ' + _otablasql + ''
* replace num WITH _tablavfp
* =TABLEUPDATE(.t., .t.)
* SET ORDER TO num 
* GO top
* thisform.grid1.Refresh()		


 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
wait window _otabla + ' - ' + Caption('Archivo N°') + ALLTRIM(STR( nCount)) + ' ' + caption('de') + ' ' + ALLTRIM(STR(gnDbcnumber))+ CHR(13) + CAPTION('Upsizing SQL. Archivo: ') + chr(13) +  + CHR(13) + ;
'Tablas sin rutina de conversión: ' +  ALLTRIM(STR(_tablasinconversion)) + CHR(13) + ;
'Tablas con datos: ' +  ALLTRIM(STR(_tablascondatos)) + CHR(13) + ;
'Tablas sin datos: ' +  ALLTRIM(STR(_tablassindatos)) + CHR(13) + "LISTO!!" NOWAIT

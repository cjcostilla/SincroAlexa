**************************************************
*!* Librería: FoxyDb.prg
*!* Autor: Antonio Meza Pérez
*!* Date: 01/08/2014 01:35:08 AM
*!* Review: 18/12/2019
*!* Licencia: MIT
*!* Descripción: Librería de Acceso a Servidores de Bases de Datos para VFP 9 Sp 2
*!* Descripción: Soporta Mysql 5.6
*!* Descripción: Soporta MariaDb 10.1, 10.2, 10.3 y 10.4
*!* Descripción: Soporta FireBird 1.5, 2.0, 2.5, 3.0
*!* Descripción: Soporta SqlServer 2012, 2014 y 2016 (Beta)
*!* Descripción: Soporta PostGreSql 10, 11 y 12 (Beta)
*!* ------------------------------------------------------------------------------------

*!* ------------------------------------------------------------------------------------
*!* Ejemplo de Uso desde línea de Comandos
*!* Public oDb
*!* oDb = NEWOBJECT("foxydb","foxydb.prg")
*!* ? oDb.Version
*!* ------------------------------------------------------------------------------------

DEFINE CLASS foxydb AS custom

	* Constantes
		#define true 	.t.
		#define false 	.f.
		
	* Propiedades
		* Librería
			version					= "3.01"		&& Versión de la Librería
			review					= "18/12/2019"	&& Fecha de la última revisión
			stable					= true			&& Versión Estable
			application_Name		= "FoxyDb"		&& Nombre de la Aplicación
		* Motores de Bases de Datos	y Versiones Recomendadas
			mySql					= 1				&& Mysql 5.6 o posterior
			mariaDb					= 2				&& MariaDb   10.0  o posterior
			fireBird				= 3				&& Firebird   2.5  o posterior
			postgreSql				= 4				&& PostGreSql 9    o posterior
			sqlServer				= 5				&& SqlServer  2012 o posterior
			sqlLite					= 6				&& SqlLite    3    o posterior
			engine					= this.Mysql	&& Motor de Base de Datos por defecto
		* Drivers ODBC, Puertos y Parámetros Predeterminados
			* Mysql
				driver_Mysql_51  	= "{MySQL ODBC 5.1 Driver}"
				driver_Mysql_351 	= "{MySQL ODBC 3.51 Driver}"
				port_Mysql			= "3306"
				mysql_Compatibility = true			&& Compatibilidad con versión mysql 5.5 o menor
				mysql_Empty_Date	= "0000-00-00"	&& Para guardar Fechas vacías
			* MariaDb
				driver_MariaDb		= "{MariaDB ODBC 2.0 Driver}"
				port_MariaDb		= "3306"
				mariaDb_Empty_Date	= "0000-00-00"	&& Para guardar Fechas vacías
			* FireBird
				driver_FireBird		= "{Firebird/InterBase(r) driver};"
				port_FireBird		= "3050"
				fireBird_Empty_Date	= NULL			&& Para guardar Fechas vacías
			* Postgresql
				driver_Postgresql		= "{PostgreSQL ANSI}"
				port_Postgresql			= "5432"
				postGreSql_Empty_Date	= NULL 			&& Para guardar Fechas vacías
			* SqlServer
				driver_SqlServer	= "{ODBC Driver 11 for SQL Server}"
				port_SqlServer		= "1433"
				sqlServer_Empty_Date= NULL			&& Para guardar Fechas vacías
			* SqlLite
				driver_SqlLite		= "SQLite3 ODBC Driver"
				sqlLite_TimeOut 	= "1000"
				sqlLite_NoTXN		= "0"
				sqlLite_LongNames	= "0"
				sqlLite_SyncPragma  = "NORMAL"
				sqlLite_StepAPI     = "0"

		* Conexión
			handle					= 0				&& Manejador de Conexión al Servidor Devuelto por SQLCONNECT o SQLSTRINGCONNECT
			handle_Shared			= 0				&& Manejador de Conexión Compartido para usar en sesiones privadas de datos.
			handle_Reconnection		= false			&& Si se intenta reconectar al servidor
			handle_Network			= true			&& Si mantiene permanente la conexión
			handle_Verify			= false			&& Si Verifica el estado de la conexión al servidor
			handle_Transaction		= 0				&& Si existe una Transacción Activa
													&& 0 No hay transacción
													&& 1 Transacción Solo Lectura
													&& 2 Transacción Lectura y Escritura Local y Remota
													&& 3 Transacción Lectura y Escritura Remota
			handle_Transaction_Mode_Select_MySql		=	"READ ONLY"							&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_MySql		=	"ISOLATION LEVEL READ COMMITTED"	&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Transaction_Mode_Select_MariaDb		=	"READ ONLY"							&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_MariaDb		=	"ISOLATION LEVEL READ COMMITTED"	&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Transaction_Mode_Select_FireBird		=	"READ ONLY SNAPSHOT WAIT"			&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_FireBird		=	"READ WRITE READ COMMITTED WAIT"	&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Transaction_Mode_Select_PostgreSql	=	"READ ONLY"							&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_PostgreSql	=	"ISOLATION LEVEL READ COMMITTED"	&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Transaction_Mode_Select_SqlServer	=	"isolation level serializable"		&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_SqlServer	=	"isolation level serializable"		&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Driver			= ""			&& Driver Odbc
			handle_Server			= ""			&& Ip del servidor
			handle_User				= ""			&& Usuario del Servidor
			handle_Password			= ""			&& Password del servidor
			handle_Database 		= ""			&& Base de datos del servidor
			handle_Port				= ""			&& Puerto del Servidor
			handle_Parameters		= ""			&& Agregar parámetros adicionales a la Conexión del servidor
			DIMENSION handle_cursor[1]				&& Array con los nombres de los cursores devuelto por AUSED()
		* ID (Identificadores de Registro)
			id_last					= 0				&& Numero del Ultimo Id Registrado después de un Insert Into
			id_Active				= false			&& Si se solicita recuperar el Ultimo ID Insertado
			id_Code					= 0				&& Numero de código único generado por la función .CODE()
			id_name					= "id"			&& Nombre del Campo ID Autoincremental Primary Key
		* Errores
			error_Show				= false			&& Mostrar Errores SQL devueltos por Aerror()
			error_Code				= 0				&& Numero de Error devuelto por el procedimiento
			error_Id				= 0				&& Código de Error que se genera al obtener el Ultimo ID Insertado
			DIMENSION error_Array[10]				&& Array devuelto por Aerror()
			error_OdbcInSql			= false			&& Si hay un error ODBC en la Función .Sql()
			error_Odbc				= 0				&& Código de Error ODBC
		* Sql
			sql_Update				= ""			&& Contiene la última instrucción SQL enviada al servidor por .Update()
			sql_Send				= ""			&& Contiene la última instrucción SQL enviada al servidor por .Sql()
			sql_Records 			= 0				&& Cantidad de Registros afectados por SQLEXEC es decir
													&& devueltos por un Select, o actualizados por un Update, Delete
			sql_Command				= ""			&& Instrucción SQL generada con la función .Command()
			sql_CommandType			= 0				&& Saber qué tipo de Comando SQL se generó, 0 Nada, 1 Update, 2 Delete, 3 Insert
			sql_log					= .f.			&& Si se obtienen los cambios por Campo y Registro de una tabla
		* Cursores
			DIMENSION cursor_Array[1]				&& Almacena la cantidad y nombres de los Cursores en Memoria
			* DBCursor 								&& Alias del cursor creado para administrar los cursores en memoria
	* Funciones (Ordenadas por Grupos)
		* Conexión
			* Connect					Permite Conectarse a un servidor de base de datos o usar una conexión compartida
			* Connected					Saber si está Conectado al Servidor de base de datos y reconectar (opcional)
			* Connection				Conectar al Servidor con parámetros
			* Disconnect				Permite Desconectarse del Servidor de Base de datos
			* Reconnection				Permite Reconectarse al servidor

		* Cursores
			* Query						Abrir cursor por medio de una consulta SQL al servidor
			* Changes					Saber si hay Cambios en todos los cursores
			* Close						Cerrar todos los cursores abiertos
			* CursorChanges				Saber si hay Cambios en un Cursor
			* CursorClose				Cerrar un cursor abierto
			* CursorCount				Devuelve la Cantidad de Cursores abiertos y Array con Nombres
			* CursorEdit				Hacer Cursor editable (Aplica Buffering 5)
			* CursorOpen				Verificar si el Cursor está Abierto
			* Refresh					Actualizar (Refrescar) los datos del Cursor
			* DbCursor					Crea un Cursor temporal para administrar los cursores creados con Use(), Query() y New()
			
		* Base de datos
			* Sql						Enviar Comando Sql por medio de SqlExec al servidor de base de datos
			* Db						Cambiar Base de datos del Servidor
			* TableFields				Devuelve Cursor con Campos (estructura) de Tabla de la base de datos
			* Tables					Devuelve Cursor con listado de Tablas de la base de datos
			* TablesGoTop				Aplicar un Go Top a los cursores abiertos en memoria
			* DbTableName				Devuelve el nombre de la tabla asociada a un cursor
			* Engine_Version			Devuelve la Versión del Servidor de Base de datos
			* Command					Obtener el comando SQL del registro actual del cursor según los cambios hechos.
			* Update					Genera y Envía instrucciones Sql (Insert / Update / Delete) al servidor según los cambios hechos al cursor			

		* Transacciones
			* Begin						Iniciar una transacción
			* Commit					Aplica una transacción
			* RollBack					Cancelar una transacción
			* Undo						Deshacer Cambios en todos los Cursores (tableRevert) y aplicar RollBack a la transacción
			* End						Cerrar Transacción con RollBack, Cerrar todos los cursores, conexión al servidor y finalizar la librería

		* Identificadores
			* Id						Obtener el Ultimo ID al insertar un Registro Nuevo, el valor se obtiene en la propiedad id_Last
			* Code						Obtener Código Único (Correlativo), el valor se obtiene en la propiedad id_code
			* UUID						Generar valor UUID (Identificador Universal único)

		* Librería
			* Errors					Control de mensajes de Errores SQL (devueltos por Aerror)

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Init
				* Iniciar la Libreria
			ENDPROC 
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Connected
				LPARAMETERS __handleVerify as Boolean
				LOCAL __handleNotConnectedVerified, __handleNotConnected, __handleConnected, ;
					  __handleConnectedVerified, __commandSql, __cursorNameTemp, __errorCode, __return
				* Connected
					* Saber si está Conectado al Servidor de base de datos
					* Para Reconectar de forma automática revise la propiedad .handle_Reconnection
				* Parámetros
					* __handleVerify, Verificar si realmente se está Conectado al servidor
				* Valor devuelto 
					* true (Verdadero) Conectado
					* false (Falso) No Conectado
				* Error devuelto
					__handleNotConnectedVerified	= -2							&& No Conectado y Verificado
					__handleNotConnected			= -1							&& No Conectado
					__handleConnected				= 1								&& Conectado (sin verificar)
					__handleConnectedVerified		= 2								&& Conectado y Verificado
					__commandSql					= ""							&& Instrucción SQL para Verificar la conexión
					__cursorNameTemp				= "__foxyDB_CursorVerify__"		&& Nombre del Cursor Temporal para verificar conexión
					__errorCode						= 0								&& Codigo de error devuelto por la función
					__return						= false							&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__handleVerify) <> "L"
						__handleVerify = false
					ENDIF
				* Verificar si esta Conectado
					IF this.handle > 0
						IF __handleVerify = true
							* Comando Sql
								DO CASE
									CASE this.engine = this.mysql
										__commandSql = "SELECT NOW()"
									CASE this.engine = this.mariaDb
										__commandSql = "SELECT NOW()"
									CASE this.engine = this.fireBird
										__commandSql = "SELECT CURRENT_DATE FROM RDB$DATABASE"
									CASE this.engine = this.postgreSql
										__commandSql = "current_timestamp;"
									CASE this.engine = this.sqlServer
										__commandSql = "SELECT @@VERSION AS 'SqlVersion'"
								ENDCASE
							* Ejecutar Comando Sql para Veirificar Conexión
								IF SQLEXEC(this.handle, __commandSql,__cursorNameTemp) > 0
									USE IN (__cursorNameTemp)		&& Cerrar Cursor Temporal
									__errorCode = __handleConnectedVerified
									__return = true
								ELSE
									* No está conectado
									this.handle = 0
									__errorCode = __handleNotConnectedVerified
								ENDIF
						ELSE
							__errorCode = __handleConnected
							__return = true
						ENDIF
					ELSE
						__errorCode = __handleNotConnected
					ENDIF
					
				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Reconnection
				LOCAL __handleNotReconnected, __handleConnected, __handleReConnected, __errorCode, __return
				* Reconnection
					* Permite Reconectarse al servidor
				* Parámetros
					* No Requerido
				* Valor devuelto 
					* true (Verdadero) Reconectado
					* false (Falso) No Reconectado
				* Error devuelto
					__handleNotReconnected		= -1			&& No Reconectado
					__handleConnected			= 0				&& Ya Estaba Conectado
					__handleReConnected			= 1				&& Reconectado
					__errorCode					= 0				&& Codigo de error devuelto por la función
					__return					= false			&& Valor devuelto por la función
				* Reconectar
					IF this.Connect()
						DO CASE
							CASE this.error_Code = __handleConnected
								__errorCode = __handleConnected
								__return = true
							CASE this.error_Code = __handleReConnected
								__errorCode = __handleReConnected
								__return = true
						ENDCASE
					ELSE
						__errorCode = __handleNotReconnected
					ENDIF

				this.error_Code = __errorCode
				RETURN __return

			ENDPROC 
	**** --------------------------------------------------------------------------------------------
	
	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Errors
				LPARAMETERS _functionName as Character, _errorCode as Integer
				* Errors
					* Mensajes de Errores SQL (devueltos por Aerror)
				* Validar Parámetros
					* _functionName - Nombre de la función que retorno el error ODBC
					* _errorCode - Codigo de error devuelto
				* Valor devuelto
					* true - Verdadero
				IF VARTYPE(_functionName) <> "C"
					_functionName = ""
				ENDIF
				IF VARTYPE(_errorCode) <> "N"
					_errorCode = 0
				ENDIF

				* Mostrar Errores SQL
					IF this.error_Show
						IF NOT this.error_OdbcInSql
							* Capturar el Error ODBC
							AERROR(this.error_array)
						ENDIF
						IF VARTYPE(this.error_array) = "N"
							MESSAGEBOX( ;
								 "Codigo de Error: " + ALLTRIM(STR(_errorCode)) ;
								 + CHR(13) ;
								 + CHR(13) + "ODBC: " + ALLTRIM(STR(this.error_array[1])) ;
								 + CHR(13) + this.error_array[2] ;
								 + CHR(13) ;
								 + CHR(13) + this.error_array[3] ;
								 + CHR(13) ;
								 + CHR(13) + "Codigo de Error ODBC: " + ALLTRIM(STR(this.error_array[5])) ;
								 , (0+48), _functionName;
							)
						ENDIF
					ENDIF
					this.error_OdbcInSql = false
					RETURN true
			ENDPROC
	**** --------------------------------------------------------------------------------------------


	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Connection
				LPARAMETERS __driver as Character, __server as Character, __user as Character, __password as Character, __dataBase as Character, __port as Character
				LOCAL __handleNotConnected, __handleConnected, __errorCode, __return
				* Connection
					* Conectar al Servidor con parámetros
				* Validar Parámetros
					* __driver		Driver Odbc
					* __server		Ip del servidor
					* __user		Usuario del Servidor
					* __password	Password del servidor
					* __database 	Base de datos del servidor
					* __port		Puerto del Servidor
				* Valor devuelto 
					* true (Verdadero) Conectado
					* false (Falso) No Conectado
				* Error Devuelto
					__handleNotConnected	= -1		&& No Conectado
					__handleConnected		= 1			&& Conectado
					__errorCode				= 0			&& Codigo de error devuelto por la función
					__return				= false		&& Valor devuelto por la función
				* Validar Parámetros
					* Driver ODBC
						IF VARTYPE(__driver) <> "C"
							__driver = ""
						ENDIF
					* Servidor
						IF VARTYPE(__server) <> "C"
							__server = ""
						ENDIF
					* Usuario
						IF VARTYPE(__user) <> "C"
							__user = ""
						ENDIF
					* Password
						IF VARTYPE(__password) <> "C"
							__password = ""
						ENDIF
					* Base de Datos
						IF VARTYPE(__dataBase) <> "C"
							__dataBase = ""
						ENDIF
					* Puerto del servidor
						IF VARTYPE(__port) <> "C"
							__port = ""
						ENDIF
				* Asignar Propiedades
					this.handle_Driver		= __driver 
					this.handle_Server		= __server
					this.handle_User		= __user
					this.handle_Password	= __password
					this.handle_DataBase 	= __dataBase
					this.handle_Port		= __port
				* Conectar
					IF this.Connect()
						__errorCode = __handleConnected
						__return = true
					ELSE
						__errorCode = __handleNotConnected
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Connect
				LPARAMETERS __handleShare as Boolean
				LOCAL __handleNotConnected, __handleAlreadyConnected, __handleConneted, __handleStringConnect, __shareConnection, ;
					  __errorCode, __return
				* Connect
					* Permite Conectarse a un servidor de base de datos o usar una conexión compartida
				* Parámetros
					* __handleShare, Si se comparte la conexión
				* Valor devuelto 
					* true (Verdadero) Conectado
					* false (Falso) No Conectado
				* Error devuelto
					__handleNotConnected		= -1		&& No se puedo conectar al servidor
					__handleAlreadyConnected	= 0			&& Ya está conectado
					__handleConneted			= 1			&& Se ha Conectado correctamente
					__handleStringConnect		= ""		&& Cadena de Conexión al servidor
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF VARTYPE(__handleShare) <> "L"
						__handleShare = false
					ENDIF
				* Verificar si está Conectado
					IF this.handle > 0
						__errorCode = __handleAlreadyConnected
						__return = true
					ELSE
						* Usar Conexión Compartida
						IF this.handle_Shared > 0
							this.handle = SQLCONNECT(this.handle_Shared)			&& Conectar usando Conexión Compartida
						ELSE
							* Parámetros de Configuración antes de Conectar
						        SQLSETPROP(0, 'ConnectTimeOut', 15)					&& Tiempo de espera en conectar
						        SQLSETPROP(0,"DispLogin",3) 						&& No mostrar dialogo de Conexión ODBC al Servidor
						        CURSORSETPROP("MapBinary",.t.,0)					&& Convierte a campo Memo Campos mayores a 254 caracteres
							* Determinar Motor de Base de Datos
								DO CASE
									CASE this.engine = this.mySql
										__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
															  + "SERVER=" 	+ this.handle_Server	+ ";"	;
															  + "UID=" 		+ this.handle_User		+ ";"	;
															  + "PWD=" 		+ this.handle_Password 	+ ";"	;
															  + "DATABASE="	+ this.handle_Database	+ ";"	;
															  + "PORT=" 	+ this.handle_Port 		+ ";"	;
	  														  + this.handle_Parameters
									CASE this.engine = this.mariaDb
										__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
															  + "SERVER=" 	+ this.handle_Server	+ ";"	;
															  + "UID=" 		+ this.handle_User		+ ";"	;
															  + "PWD=" 		+ this.handle_Password 	+ ";"	;
															  + "DATABASE="	+ this.handle_Database	+ ";"	;
															  + "PORT=" 	+ this.handle_Port 		+ ";"	;
															  + this.handle_Parameters
									CASE this.engine = this.fireBird
										__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
															  + "SERVER=" 	+ this.handle_Server	+ ":" + this.handle_Port + ";"	;
															  + "UID=" 		+ this.handle_User		+ ";"	;
															  + "PWD=" 		+ this.handle_Password 	+ ";"	;
															  + "DATABASE="	+ this.handle_Database	+ ";"	;
															  + this.handle_Parameters
									CASE this.engine = this.postgreSql
										__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
															  + "SERVER=" 	+ this.handle_Server	+ ";"	;
															  + "PORT=" 	+ this.handle_Port 		+ ";"	;
															  + "DATABASE="	+ this.handle_Database	+ ";"	;
															  + "UID=" 		+ this.handle_User		+ ";"	;
															  + "PWD=" 		+ this.handle_Password 	+ ";"	;
															  + this.handle_Parameters
									CASE this.engine = this.sqlServer
										__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
															  + "SERVER=" 	+ this.handle_Server	+ ";"	;
															  + "UID=" 		+ this.handle_User		+ ";"	;
															  + "PWD=" 		+ this.handle_Password 	+ ";"	;
															  + "DATABASE="	+ this.handle_Database	+ ";"	;
															  + "PORT=" 	+ this.handle_Port 		+ ";"	;
	  														  + this.handle_Parameters
									CASE this.engine = this.sqlLite
										__handleStringConnect = "DRIVER=" 		+ this.handle_Driver 		+ ";"	;
															  + "DATABASE="		+ this.handle_Database		+ ";"   ;
															  + "UID=" 			+ this.handle_User			+ ";"	;
															  + "PWD=" 			+ this.handle_Password 		+ ";"	;
															  + "LongNames="	+ this.sqlLite_LongNames 	+ ";"	;
															  + "TimeOut"		+ this.sqlLite_TimeOut 		+ ";"	;
															  + "NoTXN"			+ this.sqlLite_NoTXN		+ ";"	;
															  + "SyncPragma" + this.sqlLite_SyncPragma		+ ";"	;
															  + "sqlLite_StepAPI" + this.sqlLite_StepAPI	+ ";"	;
															  + handle_Parameters
								ENDCASE
							* Conectar
								this.handle = SQLSTRINGCONNECT(__handleStringConnect, __handleShare)
						ENDIF

						* Verificar si se conecto y Preparar Conexión actual
							IF this.handle > 0
								* Habilitar Buffering
									SET MULTILOCKS ON
								* Habilitar Transacciones Manuales en VFP
									SQLSETPROP(this.handle, 'Transactions', 2)
								* Aplicar Rollback al desconectar
									SQLSETPROP(this.handle, 'DisconnectRollback', true)
								* Mostrar Errores sql nativos
									SQLSETPROP(this.handle, 'DispWarnings', false)
								* Conjuntos de resultado retornados sincrónicamente 
			 						SQLSETPROP(this.handle, 'Asynchronous', false)
								* SQLEXEC retorna los resultados en una sola vez
									SQLSETPROP(this.handle, 'BatchMode', true)
								* Tiempo en minutos para que una conexión no usada se desactive (0 = nunca)
							        SQLSETPROP(this.handle, 'IdleTimeout', 0)
								* Tamaño del paquete de datos usado por la conexión (4096)
									SQLSETPROP(this.handle, 'PacketSize', 4096)
								* El tiempo de espera, en segundos, antes de retornar un error general
									SQLSETPROP(this.handle, 'QueryTimeOut', 0)
								* El tiempo, en milisegundos, hasta que VFP verifique que la instrucción SQL se completó
									SQLSETPROP(this.handle, 'WaitTime', 100)
								__errorCode = __handleConneted
								__return = true
							ELSE
								__errorCode = __handleNotConnected
								this.Errors(PROGRAM(), __errorCode)
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------			
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Disconnect
				LOCAL __handleTransaction, __handleDisconnected, __handleNotConnect, __handleValue, ;
					  __transactionNotStarted, __errorCode, __return
				* Disconnect
					* Permite Desconectarse del Servidor de Base de datos
				* Parámetro
					* No requerido
				* Valor devuelto 
					* true (Verdadero) Desconectado
					* false (Falso) No se Desconecto
				* Error devuelto
					__handleTransaction			= -1		&& Hay Transacción Activa, no se puede desconectar
					__handleDisconnected		= 1			&& Se ah Desconectado
					__handleNotConnect			= 0			&& No estaba conectado
					__handleValue				= 0			&& Obtener el valor devuelto al desconectar 1, -1 y -2
					__transactionNotStarted		= 0			&& No hay una transacción Iniciada
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
				* Verificar que no haya una Transacción Activa
					IF this.handle_Transaction > __transactionNotStarted
						__errorCode = __handleTransaction
					ELSE
						* Desconectar
							IF this.handle >= 1
								__handleValue = SQLDISCONNECT(this.handle)
								this.handle = 0
								IF __handleValue = 1
									__errorCode = __handleDisconnected
									__return = true
								ELSE
									__errorCode = __handleValue
									this.Errors(PROGRAM(), __errorCode)
								ENDIF
							ELSE
								this.handle = 0
								__errorCode = __handleNotConnect
								__return = true
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Db
				LPARAMETERS __dataBaseName as Character
				LOCAL __dataBaseNameEmpty, __dataBaseNotChanged, __sqlCommandNotAvailable, ;
					  __dataBaseChanged, __commandSql, __errorCode, __return
				* Db
					* Cambiar Base de datos del Servidor
				* Parámetros
					* __dataBaseName, Nombre de la Base de datos a Cambiar
				* Valor devuelto 
					* true (Verdadero) Se cambió la base de datos
					* false (Falso) No se cambió la base de datos
				* Error devuelto
					__dataBaseNameEmpty			= -2		&& Falta nombre de la base de datos
					__dataBaseNotChanged		= -1		&& Base de datos Cambiada
					__sqlCommandNotAvailable	= 0			&& Comando Sql No disponible
					__dataBaseChanged			= 1			&& Base de datos Cambiada
					__commandSql				= ""		&& Comando Sql a ejecutar
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__dataBaseName) <> "C" OR EMPTY(ALLTRIM(__dataBaseName))
						__errorCode = __dataBaseNameEmpty
						__return = false
					ELSE
						* Comando SQL para cambiar de Base de Datos
							DO case
								CASE this.engine = this.mySql 
									__commandSql = "USE " + __dataBaseName 
								CASE this.engine = this.MariaDb
									__commandSql = "USE " + __dataBaseName 
								CASE this.engine = this.fireBird
									__commandSql = ""
								CASE this.engine = this.postgreSql
									__commandSql = "USE " + __dataBaseName 
								CASE this.engine = this.sqlServer
									__commandSql = "USE " + __dataBaseName 
							ENDCASE
						* Cambiar Base de datos
							IF EMPTY(ALLTRIM(__commandSql))
								__errorCode = __sqlCommandNotAvailable
							ELSE
								IF this.Sql(__commandSql, true, true)
									__errorCode = __dataBaseChanged
									__return = true
								ELSE
									__errorCode = __dataBaseNotChanged
									this.Errors(PROGRAM(), __errorCode)
								ENDIF
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC 
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Sql
				LPARAMETERS __commandSql as Character, __cursorName as Variant, __notErrorODBC as Boolean
				LOCAL __lockModeErrorCommit, __lockModeErrorTransaction, __commandSqlNotFinished, __commandSqlEmpty, ;
					__handleNotConnected, __commandSqlError, __commandSqlExecuted, __commandSqlSequence, ;
					__transactionReadOnly, __transactionNotStarted, __transactionReadOnlyAutomatic, ;
					__connected, __transaction, __errorCode, __return
				* Sql
					* Enviar Comando Sql por medio de SqlExec al servidor de base de datos
				* Parámetros
					* __commandSql, instrucción SQL a ejecutar en el servidor de base de datos
					* __CursorName, 
						* Carácter: Nombre del Cursor a Devolver de la Consulta
						* Lógico: Solo ejecutar instrucción y no devolver registros afectados 
					* __notErrorODBC, No mostrar Error ODBC, para uso interno de FoxyDb
				* Valor devuelto: Lógico
					* true Ejecutado correctamente
					* false Error en commando SQL
				* Error devuelto:
					__handleNotReconnected			= -7			&& No Reconectado
					__lockModeErrorCommit			= -6			&& Error al aplicar Commit en transacción de solo lectura
					__lockModeErrorTransaction		= -5			&& Error al preparar Transacción de solo lectura Automática
					__commandSqlNotFinished			= -4			&& Comando SQL se sigue ejecutando
					__commandSqlEmpty 				= -3			&& Falta instrucción SQL
					__handleNotConnected			= -2			&& No conectado al servidor
					__commandSqlError				= -1 			&& Error en Instrucción SQL
					__commandSqlExecuted			= 1				&& SQL ejecutado correctamente
					__commandSqlSequence			= false			&& Para no solicitar __sqlRecordsArray (Registros Afectados)
					__transactionReadOnly			= 1				&& Iniciar Transacción de Solo lectura
					__transactionNotStarted			= 0				&& No hay una transacción Iniciada
					__transactionReadOnlyAutomatic	= false			&& Transacción Automática de Solo Lectura
					__connected						= true			&& Si esta conectado
					__transaction					= true			&& Si hay una transacción
					__errorCode						= 0				&& Codigo de error devuelto por la función
					__return						= false			&& Valor devuelto por la función
					this.error_OdbcInSql			= false			&& Inicializa en false la propiedad de error SQL
					this.error_ODBC					= 0				&& Inicializa en 0 la propiedad de Código de Error ODBC
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__commandSql) <> "C" OR EMPTY(ALLTRIM(__commandSql))
						__errorCode = __commandSqlEmpty
					ELSE
						IF VARTYPE(__cursorName) = "L"
							__commandSqlSequence = __cursorName
							__cursorName = ""
						ELSE
							IF VARTYPE(__cursorName) <> "C"
								__commandSqlSequence = false
								__cursorName = ""
							ENDIF
						ENDIF

						IF VARTYPE(__notErrorODBC) <> "L"
							__notErrorODBC = false
						ENDIF

						* Verificar Conexión a la Base de Datos
							IF NOT this.Connected(this.handle_Verify)
								* Reconectar
									IF this.handle_Reconnection
										IF NOT this.Reconnection()
											__connected = false
											__errorCode = __handleNotReconnected
										ENDIF
									ELSE
										__connected = false
										__errorCode = __handleNotConnected
									ENDIF
							ENDIF

						* Preparar Transacción Automática de Solo Lectura si no hay una transacción abierta
							IF __connected = true
								IF NOT this.handle_Transaction > __transactionNotStarted
									IF this.Begin(__transactionReadOnly)
										__transactionReadOnlyAutomatic = true
									ELSE
										__transaction = false
										__errorCode = __lockModeErrorTransaction
									ENDIF
								ENDIF

								IF __transaction = true
									* Ultima Instrucción SQL enviada
										this.sql_Send = __commandSql
									* Ejecutar Consulta SQL en el Servidor de Base de Datos
										IF __commandSqlSequence
											__commandSqlResult = SQLEXEC(this.handle,__commandSql)
										ELSE
											__commandSqlResult = SQLEXEC(this.handle,__commandSql,__cursorName,__sqlRecordsArray)
											* Registros devueltos o afectados
												this.sql_Records = __sqlRecordsArray(2)
										ENDIF
										
										* Capturar Errores ODBC en SQL del último comando enviado
											AERROR(this.error_array)

									* Finalizar Transacción Automática de solo lectura aún si hubo error en el comando SQL
										IF this.handle_Transaction = __transactionReadOnly
											IF __transactionReadOnlyAutomatic
												IF NOT this.Commit()
													__transaction = false
													__errorCode = __lockModeErrorCommit
												ENDIF
											ENDIF
										ENDIF

									IF __transaction = true
										* Desconectar o Permanecer Conectado al servidor
											IF NOT this.handle_Network
												this.disconnect()
											ENDIF
										* Verificar Resultado
											DO CASE
												CASE __commandSqlResult = -1
													* Notificar que hubo error ODBC en el último comando SQL enviado
														this.error_OdbcInSql = true
														this.error_Odbc = this.error_array[5]
													__errorCode = __commandSqlError
													IF __notErrorODBC = true
														* No mostrar error ODBC
													ELSE
														this.Errors(PROGRAM(), __errorCode)
													ENDIF
												CASE __commandSqlResult = 0
													* Notificar que hubo error ODBC en el último comando SQL enviado
														this.error_OdbcInSql = true
														this.error_Odbc = this.error_array[5]
													__errorCode = __commandSqlNotFinished
													IF __notErrorODBC = true
														* No mostrar error ODBC
													ELSE
														this.Errors(PROGRAM(), __errorCode)
													ENDIF
												CASE __commandSqlResult = 1
													__errorCode = __commandSqlExecuted
													__return = true
											ENDCASE
									ENDIF
								ENDIF
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Begin
				LPARAMETERS __transactionType as Integer
				LOCAL __handleNotConnected, __transactionNotStarted, __transactionAlreadyInitiated, ;
					  __transactionInitiated, __transactionTypeReadOnly, __transactionTypeWrite, ;
					  __transactionTypeRemote, __transactionTypeInvalid, __handleNotReconnected, ;
					  __transaction, __connected, __errorCode, __return
				* Begin
					* Inicia una transacción de lectura y escritura, local y Remota
				* Parámetros	
					* __transactionType, determina el tipo de transacción
					* 1 Transacción Solo Lectura
					* 2 Transacción Lectura y Escritura Local y Remota
					* 3 Transacción Lectura y Escritura Remota
				* Valor devuelto
					* true	Transacción Iniciada
					* false	No se inició la Transacción
				* Error devuelto
					__handleNotReconnected			= -4			&& No Reconectado al servidor
					__transactionTypeInvalid		= -3			&& Tipo de Transacción no valido
					__handleNotConnected			= -2			&& No conectado al servidor
					__transactionErrorNotStarted	= -1			&& Transacción error no iniciada
					__transactionAlreadyInitiated	= 0				&& Transacción ya iniciada
					__transactionInitiated			= 1				&& Transacción Iniciada
					__transactionNotStarted			= 0				&& No hay una transacción Iniciada
					__transactionTypeReadOnly		= 1				&& Transacción de Solo Lectura
					__transactionTypeWrite			= 2				&& Transacción de Lectura y Escritura Local y Remota
					__transactionTypeRemote			= 3				&& Transacción de Lectura y Escritura Remota
					__transaction					= true			&& Si hay una transacción
					__connected						= true			&& Si esta conectado
					__errorCode						= 0				&& Codigo de error devuelto por la función
					__return						= false			&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0	
						__transactionType = __transactionTypeReadOnly
					ENDIF
					IF VARTYPE(__transactionType) <> "N" OR (__transactionType <= 0 OR __transactionType > 3)
						__errorCode = __transactionTypeInvalid
					ELSE
						* Verificar si no hay una transacción
							IF this.handle_Transaction > 0
								IF this.handle_Transaction = __transactionType 
									__transaction = false
									__errorCode = __transactionAlreadyInitiated
									__return = true
								ELSE
									__transaction = false
									__errorCode = __transactionAlreadyInitiated
								ENDIF
							ENDIF
						
						IF __transaction = true
							* Verificar Conexión a la Base de Datos
								IF NOT this.Connected(this.handle_Verify)
									* Reconectar
										IF this.handle_Reconnection
											IF NOT this.Reconnection()
												__connected = false
												__errorCode = __handleNotReconnected
											ENDIF
										ELSE
											__connected = false
											__errorCode = __handleNotConnected
										ENDIF
								ENDIF
								
							IF __connected = true
								* Preparar Transacción de Lectura y Escritura
									DO case
										CASE __transactionType = __transactionTypeReadOnly 		&& Solo Lectura
											DO CASE
												CASE this.engine = this.mySql
													IF this.mysql_Compatibility 	&& Compatibilidad con Mysql inferior a 5.6
														__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_MySql
													ELSE
														__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_MySql
													ENDIF
												CASE this.engine = this.mariaDb
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_MariaDb
												CASE this.engine = this.fireBird
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_FireBird
												CASE this.engine = this.postgreSql
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_PostgreSql
												CASE this.engine = this.sqlServer
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_SqlServer
												CASE this.engine = this.sqlLite
											ENDCASE
										CASE __transactionType		= __transactionTypeWrite ;			&& Lectura y Escritura
											 OR __transactionType	= __transactionTypeRemote			&& Remota
											DO CASE
												CASE this.engine = this.mySql
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_MySql
												CASE this.engine = this.mariaDb
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_MariaDb
												CASE this.engine = this.fireBird
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_FireBird
												CASE this.engine = this.postgreSql
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_PostgreSql
												CASE this.engine = this.sqlServer
													__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_SqlServer
											ENDCASE
									ENDCASE
								* Iniciar transacción
									IF SQLEXEC(this.handle,__commandSql,"") = __transactionInitiated
										* Iniciar transacción en Cursores locales
											IF __transactionType = __transactionTypeWrite
												BEGIN TRANSACTION
											ENDIF
										this.handle_Transaction = __transactionType
										__errorCode = __transactionInitiated
										__return = true

								 	ELSE
										this.handle_Transaction = __transactionNotStarted
										__errorCode = __transactionErrorNotStarted
										this.Errors(PROGRAM(), __errorCode)
									ENDIF
							ENDIF
						ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Commit
				LOCAL __transactionError, __transactionNotStarted, __transactionApplied, ;
					  __transactionTypeWrite, __errorCode, __return
				* Commit
					* Aplicar una transacción activa
				* Parámetros	
					* No requiere
				* Valor devuelto
					* true	Transacción Aplicada
					* false	No se aplicó la Transacción
				* Error devuelto
					__transactionError				= -1			&& No se Aplicó la transacción
					__transactionNotStarted			= 0				&& No hay una transacción Iniciada
					__transactionApplied			= 1				&& Transacción Aplicada
					__transactionTypeWrite			= 2				&& Transacción de Lectura y Escritura Local y Remota
					__errorCode						= 0				&& Codigo de error devuelto por la función
					__return						= false			&& Valor devuelto por la función
				* Verificar si hay una transacción Activa
					IF this.handle_Transaction > __transactionNotStarted
						IF SQLCOMMIT(this.handle) = __transactionApplied
							&& Commit VFP Guardar Cursores locales
								IF this.handle_Transaction = __transactionTypeWrite
									END TRANSACTION
								ENDIF
							this.handle_Transaction = __transactionNotStarted
							* Desconectar
								IF NOT this.handle_Network
									this.Disconnect()
								ENDIF
							__errorCode = __transactionApplied
							__return = true
						ELSE
							__errorCode = __transactionError
							this.Errors(PROGRAM(), __errorCode)
						ENDIF
					ELSE
						__errorCode = __transactionNotStarted
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Rollback
				LOCAL __transactionNotCanceled, __transactionNotStarted, __transactionCanceled, ;
				      __transactionTypeWrite, __errorCode, __return
				* Rollback
					* Cancelar una transacción activa
				* Parámetros	
					* No requiere
				* Valor devuelto
					* true	Transacción Cancelada
					* false	No se canceló la Transacción
				* Error devuelto
					__transactionNotCanceled	= -1		&& No se canceló la transacción
					__transactionNotStarted		= 0			&& No hay una transacción Iniciada
					__transactionCanceled		= 1			&& Transacción Cancelada
					__transactionTypeWrite		= 2			&& Transacción de Lectura y Escritura Local y Remota
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
				* Verificar si no hay una transacción
					IF this.handle_Transaction > __transactionNotStarted
						IF SQLROLLBACK(this.handle) = __transactionCanceled
							&& RollBack VFP Deshacer Cursores locales
								IF this.handle_Transaction = __transactionTypeWrite
									ROLLBACK
								ENDIF
							this.handle_Transaction = __transactionNotStarted
							* Desconectar
								IF NOT this.handle_Network
									this.Disconnect()
								ENDIF
							* Aplicar Go Top a los cursores locales
								this.TablesGoTop()
							__errorCode = __transactionCanceled
							__return = true
						ELSE
							__errorCode = __transactionError
							this.Errors(PROGRAM(), __errorCode)
						ENDIF
					ELSE
						__errorCode = __transactionNotStarted
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------
	
	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Engine_Version
			LOCAL __notAvailable, __versionGenerated, __currentVersion, __commandSql, ;
				  __errorCode, __return
				* Engine_Version
					* Devuelve la Versión del Servidor de Base de datos
				* Parámetros
					* No Requiere
				* Valor devuelto
					* Carácter, Versión del Servidor de Base de datos
				* Error Devuelto
					__notAvailable			= 0			&& No disponible
					__versionGenerated		= 1			&& Versión Obtenida
					__currentVersion		= ""		&& Versión Actual
					__commandSql 			= ""		&& Generar Comando según Servidor de Base de datos
					__errorCode				= 0			&& Codigo de error devuelto por la función
					__return				= ""		&& Valor devuelto por la función
				* Seleccionar Motor
					DO case
						CASE this.engine = this.mySql
							__commandSql = "SELECT VERSION() AS VERSION"
						CASE this.engine = this.mariaDb
							__commandSql = "SELECT VERSION() AS VERSION"
						CASE this.engine = this.fireBird
							__commandSql = "SELECT RDB$GET_CONTEXT('SYSTEM', 'ENGINE_VERSION') as version FROM RDB$DATABASE;"
						CASE this.engine = this.postgreSql
							__commandSql = "SHOW server_version;"
						CASE this.engine = this.sqlServer
							__commandSql = "SELECT @@VERSION AS 'Version'"
					ENDCASE
				* Obtener Versión
					IF this.Sql(__commandSql,"foxydb_version")
						__currentVersion = foxydb_version.version
						USE IN foxydb_version
						__errorCode = __versionGenerated
						__return = __currentVersion
				 	ELSE
						__errorCode = __commandSqlError
						__return = ""
						this.Errors(PROGRAM(), __errorCode)
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Uuid
			LOCAL __commandSqlError, __notAvailable, __generated, __uuidGenerated, __commandSql, ;
				  __errorCode, __return
				* UUID
					* Generar valor UUID (Identificador universalmente único)
				* Parámetros
					* No Requiere
				* Valor devuelto
					* Carácter, Código Único Universal o Vacío
				* Error Devuelto
					__commandSqlError	= -1		&& Error SQL al devolver UUID
					__notAvailable		= 0			&& No disponible
					__generated			= 1			&& Generado
					__uuidGenerated		= ""		&& UIID Generado
					__commandSql 		= ""		&& Generar Comando según Servidor de Base de datos
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= ""		&& Valor devuelto por la función
				* Seleccionar Motor
					DO case
						CASE this.engine = this.mySql
							__commandSql = "SELECT UUID() as UUID"
						CASE this.engine = this.mariaDb
							__commandSql = "SELECT UUID() as UUID"
						CASE this.engine = this.fireBird
							__commandSql = "SELECT UUID_TO_CHAR(GEN_UUID()) AS UUID FROM RDB$DATABASE"
						CASE this.engine = this.postgreSql
							* "CREATE extension IF NOT EXISTS 'uuid-ossp';"
							__commandSql = "SELECT uuid_generate_v4();"
						CASE this.engine = this.sqlServer
							__commandSql = "SELECT NEWID()"
					ENDCASE
				* Generar UUID
					IF this.Sql(__commandSql,"foxydb_uuid")
						__uuidGenerated = foxydb_uuid.uuid
						USE IN foxydb_uuid
						__errorCode = __generated
						__return = __uuidGenerated
				 	ELSE
						__errorCode = __commandSqlError
						__return = ""
						this.Errors(PROGRAM(), __errorCode)
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------


	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Undo
				LOCAL __cursorNotChanges, __CursorChangesReversed,__transactionRollBack, __cursorContainsChanges, ;
					  __cursorCount, __transactionError, __cursorName, __transaction, ;
					  __errorCode, __return
				* Undo
					* Deshacer Cambios en todos los Cursores y Finaliza una transacción activa 
				* Valor devuelto
					* true	Cambios Revertidos
					* false	No se pudieron Revertir los cambios
				* Error devuelto
					__cursorNotChanges			= 0			&& No hay Cambios para Deshacer
					__CursorChangesReversed		= 1			&& Cambios Revertidos
					__cursorContainsChanges	 	= false		&& Saber si se revirtieron cambios
					__transactionError			= -1		&& Error en transacción
					__cursorName				= ""		&& Nombre del cursor a deshacer cambios
					__transactionNotStarted		= 0			&& No hay una transacción Iniciada
					__transactionTypeReadOnly	= 1			&& Transacción de Solo Lectura
					__transactionTypeWrite		= 2			&& Transacción de Lectura y Escritura Local y Remota
					__transactionTypeRemote		= 3			&& Transacción de Lectura y Escritura Remota
					__transaction				= true		&& Si hay una transacción
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= ""		&& Valor devuelto por la función
				* Enviar RollBack a Transacción si hay una activa
					DO case
						CASE this.handle_Transaction = __transactionTypeReadOnly
							IF NOT this.Commit()
								__transaction = false
								__errorCode = __transactionError
								this.Errors(PROGRAM(), __errorCode)
							ENDIF
						CASE this.handle_Transaction = __transactionTypeWrite OR this.handle_Transaction = __transactionTypeRemote
							IF NOT this.RollBack()
								__transaction = false
								__errorCode = __transactionError
								this.Errors(PROGRAM(), __errorCode)
							ENDIF
					ENDCASE
				
				IF __transaction = true
					* Deshacer Cambios en Cursores agregados a DBCURSOR
						IF this.Changes()
							SELECT dbcursor
							SCAN
								IF this.CursorChanges(ALLTRIM(dbcursor.cursor))
									IF TABLEREVERT(true,ALLTRIM(dbcursor.cursor)) >= 1
										__cursorContainsChanges = true
									ENDIF
								ENDIF
							ENDSCAN
							IF __cursorContainsChanges
								__errorCode = __CursorChangesReversed
								__return = true
							ELSE
								__errorCode = __cursorNotChanges
								__return = true
							ENDIF
						ELSE
							__errorCode = __cursorNotChanges
							__return = true
						ENDIF
				ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE CursorOpen
				LPARAMETERS __cursorName as Character
				LOCAL __cursorNameEmpty, __cursorNotOpen, __cursorOpen, __errorCode, __return
			 	* CursorOpen
			 		* Verificar si el Cursor está Abierto
				* Parámetros
					* __cursorName, Nombre del Cursor a verificar si está abierto
				* Valor devuelto
					* true 	Cursor Abierto
					* false	Cursor no abierto
				* Error devuelto
					__cursorNameEmpty	= -2		&& Falta nombre del cursor
					__cursorNotOpen		= 0			&& Cursor No abierto
					__cursorOpen		= 1			&& Cursor Abierto
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
			 	* Verificar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
						* Cursor Abierto
						IF USED(__cursorName)
							__errorCode = __cursorOpen
							__return = true
						ELSE
							__errorCode = __cursorNotOpen
						ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE CursorEdit
				LPARAMETERS __cursorName as Character
				LOCAL __cursorNameEmpty , __cursorNotEditable, __cursorEditable, __errorCode, __return
				* CursorEdit
					* Hacer Cursor editable (Aplica Buffering 5)
				* Parámetros
			 		* __cursorName, Nombre del Cursor para hacer editable
				* Valor devuelto
					* true 	Cursor Editable
					* false	Cursor No Editable
				* Error devuelto
			 		__cursorNameEmpty 	= -2		&& Error falta nombre del cursor
					__cursorNotEditable = -1		&& Cursor No Editable (Error al Aplicar Buffering 5)
					__cursorEditable	= 1			&& Cursor Editable
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
						* Aplicar Buffering 5
						IF CURSORSETPROP("Buffering", 5,__cursorName)
							__errorCode = __cursorEditable
							__return = true
						ELSE
							__errorCode = __cursorNotEditable
						ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE CursorCount
				LOCAL __cursorsCounted, __errorCode, __return
				* CursorCount
					* Devuelve la Cantidad de Cursores abiertos y Array con Nombres
				* Parámetros
					* No requiere
				* Valor devuelto
					* Numérico, cantidad de cursores abiertos
				* Error devuelto
					__cursorsCounted	= 1			&& Cursores Contados
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
				* Contar
				this.error_Code = __cursorsCounted
				RETURN AUSED(this.cursor_Array)
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE CursorClose
				LPARAMETERS __cursorName as Character, __cursorClosingForce as Boolean
				LOCAL __cursorNameEmpty, __cursorClosed, __cursorContainsChanges, __cursorNameClosed, ;
					  __errorCode, __return
				* Close
					* Cerrar un cursor abierto
				* Parámetros
					* __CursorName, Nombre del Cursor a Cerrar
					* __cursorClosingForce, Forzar cierre aun cuando tengan cambios por confirmar
				* Valor devuelto
					* true 	Cerrado
					* false	No Cerrado
				* Error devuelto
					__cursorNameEmpty			= -1		&& Nombre del Cursor Vacío
					__cursorContainsChanges		= 0			&& Cursor Contiene Cambios Pendientes
					__cursorClosed				= 1			&& Cursor Cerrado
					__cursorNameDelete			= 2			&& Constante para Eliminar Cursor en DBCURSOR
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(__cursorName)
						__errorCode = __cursorNameEmpty
						__return = true
					ELSE
						IF VARTYPE(__cursorClosingForce) <> "L"
							__cursorClosingForce = false
						ENDIF
						
						IF __cursorClosingForce = true
							= TABLEREVERT(true,__cursorName)
						ENDIF

						IF this.CursorChanges(__cursorName)
							__errorCode = __cursorContainsChanges
						ELSE
							* Cerrar Cursor
								USE IN (__cursorName)
							* Quitar de dbCursor
								this.dbCursor(__cursorName,__cursorNameDelete)
							__errorCode = __cursorClosed
							__return = true
						ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------
	
	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE CursorChanges
				LPARAMETERS __cursorName as String
				LOCAL __cursorNotBuffering, __cursorNameEmpty, __cursorNotChanges, __cursorChanges, ;
					  __errorCode, __return
				* Changes
					* Saber si hay Cambios en un Cursor
				* Parámetros
					* __CursorName, Nombre del Cursor a Verificar Cambios
				* Valor devuelto
					* true 	Contiene Cambios
					* false	No Contiene Cambios
				* Error devuelto
					__cursorNotBuffering 		= -5		&& El cursor no es editable
					__cursorNameEmpty			= -1		&& Nombre del Cursor vació
					__cursorNotChanges 			= 0			&& El cursor no contiene cambios
					__cursorChanges				= 1			&& El cursor contiene cambios
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
						* Verificar cambios
							IF CURSORGETPROP("Buffering",__cursorName) = 5
								IF GETNEXTMODIFIED(0,__cursorName) <> 0
									__errorCode = __cursorChanges
									__return = true
								ELSE
									__errorCode = __cursorNotChanges
								ENDIF
							ELSE
								__errorCode = __cursorNotBuffering
							ENDIF
					ENDIF
				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------
	
	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Changes
				LOCAL __cursorNotChanges, __cursorChanges, __cursorCount, __changes as Boolean, ;
				      __errorCode, __return
				* Changes
					* Saber si hay Cambios en los cursores abiertos en DbCursor
				* Parámetros
					* No requeridos
				* Valor devuelto
					* true 	(Hay Cambios en los cursores)
					* false	(No hay Cambios)
				* Error devuelto
					__cursorNotChanges 	= 0			&& No hay Cambios
					__cursorChanges		= 1			&& Hay Cambios
					__changes			= false		&& Si encontro cambios
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
				* Verificar cambios en Cursores
					IF USED("dbcursor")
						SELECT dbcursor
						SCAN
							IF this.CursorChanges(ALLTRIM(dbcursor.cursor))
								__changes = true
								EXIT
							ENDIF
						ENDSCAN
					ENDIF
					
					IF __changes = true
						__errorCode = __cursorChanges
						__return = true
					ELSE
						__errorCode = __cursorNotChanges
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
		 	PROCEDURE Query
		 		LPARAMETERS __commandSql as Character, __cursorName as Character, __tableName as Character
		 		LOCAL __commandSqlEmpty, __cursorNameEmpty, __commandSqlError, __cursorReadyToUse, ;
					  __cursorAddDbCursor, __parameters, __errorCode, __return
		 		* Query
					* Abrir cursor por medio de una consulta SQL al servidor
				* Parámetros
					* __commandSql, Instrucción SQL para generar la consulta al servidor y obtener el Cursor
					* __cursorName, Nombre del Cursor que será devuelto por la consulta
					* __tableName,  Nombre de la Tabla Real en el servidor de base de datos,
					*				se puede indicar adicionalmente el nombre de la base de datos
					*				seguido de un punto y el nombre de la tabla, ejemplo:
					*				database.table (contabilidad.polizas)
				* Valor devuelto
					* true 	Consulta Realizada
					* false	Error en consulta
				* Error devuelto
					__tableNameEmpty		= -4		&& Falta el nombre de la tabla
					__cursorNameEmpty		= -3		&& Falta el nombre del cursor
					__commandSqlEmpty		= -2		&& Falta instrucción o comandos SQL
					__commandSqlError		= -1		&& Error en Instrucción SQL
					__cursorReadyForUse		= 1			&& Cursor listo para usar
					__cursorAddDbCursor		= 1			&& Agregar a DbCursor
					__notShowErrorsOdbcSql	= true		&& No mostrar Errores ODBC en Funcion Sql()
					__parameters			= true		&& Si los parametros son correctos
					__errorCode				= 0			&& Codigo de error devuelto por la función
					__return				= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__commandSql) <> "C" OR EMPTY(ALLTRIM(__commandSql))
						__parameters = false
						__errorCode = __commandSqlEmpty
					ELSE
						* Nombre del Cursor
							IF VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
								__parameters = false
								__errorCode = __cursorNameEmpty
							ELSE
								* Nombre de la Tabla
									IF VARTYPE(__tableName) <> "C" OR EMPTY(ALLTRIM(__tableName))
										__parameters = false
										__errorCode = __tableNameEmpty
									ENDIF
							ENDIF
					ENDIF

					IF __parameters = true
						* Abrir Cursor
							IF this.Sql(__commandSql,__cursorName, __notShowErrorsOdbcSql) = true
								* Agregar a dbCursor
									this.dbCursor(__cursorName, __cursorAddDbCursor, __commandSql, __tableName)
								* Seleccionar 
									SELECT (__cursorName)
								__errorCode = __cursorReadyForUse
								__return = true
						 	ELSE
								__errorCode = __commandSqlError
								this.Errors(PROGRAM(), __errorCode)
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
		 	ENDPROC
	**** --------------------------------------------------------------------------------------------
	
	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Close
				LPARAMETERS __cursorClosingForce as Boolean
				LOCAL __cursorClosed, __cursorNotClosed, __cursorCloasedAll, __cursorCount, ;
					  __errorCode, __return
				* Close
					* Cerrar todos los cursores abiertos en DbCursor
				* Parámetros
					* __cursorClosingForce, Forzar cierre de todos los cursores aun cuando tengan cambios por confirmar.
				* Valor devuelto
					* true 	Cerrados
					* false	No Cerrados
				* Error devuelto
					__cursorNotClosed	= 0			&& Algún Cursor no Cerrado
					__cursorClosed		= 1			&& Cursores Cerrados
					__cursorCloasedAll 	= true		&& Saber si se cerraron todos los cursores
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
				* Verificar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorClosingForce) <> "L"
						__cursorClosingForce = false
					ENDIF
				* Cerrar Cursores
					FOR __cursorCount = 1 TO this.CursorCount()
						IF NOT UPPER(this.cursor_Array(__cursorCount,1)) == "DBCURSOR"
							IF this.CursorClose(this.cursor_Array(__cursorCount,1),__cursorClosingForce) = true
								* Continuar Cerrando
							ELSE
								__cursorCloasedAll = false
							ENDIF
						ENDIF
					NEXT
				* Resultado
					IF __cursorCloasedAll = true
						__errorCode = __cursorClosed
						__return = true
					ELSE
						__errorCode = __cursorNotClosed
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Id
				LOCAL __idNotReturned, __notAvailable, __idReturned, __commandSql, __errorCode, __return
				* Id
					* Obtener el Ultimo ID al insertar un Registro Nuevo, el valor se obtiene en la propiedad .id_Last
				* Parámetros
					* No Requiere
				* Valor devuelto
					* true	Ultimo ID obtenido
					* false	No se pudo obtener el Ultimo ID
				* Error Devuelto
					__idNotReturned		= -1		&& ID no obtenido
					__notAvailable		= 0			&& No disponible
					__idReturned		= 1			&& ID Obtenido
					__commandSql		= ""		&& Comando SQL según el motor de base de datos
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
					this.Id_last 		= 0			&& Iniciar valor de Ultimo ID Insertando en Cero
				* Obtener Ultimo Id
					DO CASE
						CASE this.engine = this.mySql OR this.engine = this.mariaDb
							__commandSql = "SELECT LAST_INSERT_ID() as id"
							IF this.Sql(__commandSql, "foxydb_last_id", true)
								this.id_last = INT(VAL(foxydb_last_id.id))
								USE IN foxydb_last_id
								__errorCode = __idReturned
								__return = true
							ELSE
								__errorCode = __idNotReturned
								this.Errors(PROGRAM(), __errorCode)
							ENDIF

						CASE this.engine = this.fireBird OR this.engine = this.postgreSql
							IF USED("foxydb_last_id")
								this.id_last = foxydb_last_id.id
								USE IN foxydb_last_id
								__errorCode = __idReturned
								__return = true
							ELSE
								__errorCode = __idNotReturned
							ENDIF
						CASE this.engine = this.sqlServer
							IF USED("foxydb_last_id")
								this.id_last = foxydb_last_id.id
								USE IN foxydb_last_id
								__errorCode = __idReturned
								__return = true
							ELSE
								__errorCode = __idNotReturned
							ENDIF
					ENDCASE

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Tables
				LPARAMETERS __cursorName as Character, __tableTypes as Character
				LOCAL __cursorNameEmpty, __tablesReady, __commandSqlError, __errorCode, __return
				* Tables
					* Devuelve Cursor con listado de Tablas de la base de datos
				* Parámetros
					* __cursorName, Nombre del Cursor a devolver listado de tablas
					* __tableTypes, -opcional- Listado de Tipos de Tablas ejemplo: " 'TABLE,' 'VIEW,' 'SYSTEM TABLE,' "
				* Valor devuelto
					* true	Listado Correcto
					* false	No se pudo obtener el listado
				* Error devuelto
					__cursorNameEmpty	= -2			&& Nombre del cursor vacío
					__commandSqlError	= -1		&& Error al obtener el listado
					__tablesReady		= 1			&& Listado Listo
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
							IF VARTYPE(__tableTypes) <> "C" OR EMPTY(ALLTRIM(__tableTypes))
								__tableTypes = "TABLE"
							ENDIF
						* Obtener Campos de la tabla
							IF SQLTABLES(this.handle, __tableTypes, __cursorName) = 1
								__errorCode = __tablesReady
								__return = true
							ELSE
								__errorCode = __commandSqlError
								this.Errors(PROGRAM(), __errorCode)
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------
	
	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE TableFields
				LPARAMETERS __tableName as Character, __cursorName as Character, __structureNative as Boolean
				LOCAL __tableNameEmpty, __tableFieldsReady, __commandSqlError, __errorCode, __return
				* TableFields
					* Devuelve Cursor con Campos (estructura) de Tabla de la base de datos
				* Parámetros
					* __tableName, Nombre real de la Tabla de la base de datos
					* __cursorName, Nombre del Cursor a devolver información
					* __structureNative, si muestra la estructura Nativa del servidor o estilo VFP (default)
				* Valor devuelto
					* true	Listado Correcto
					* false	No se pudo obtener el listado
				* Error devuelto
					__tableNameEmpty		= -1
					__tableFieldsReady		= 1
					__commandSqlError		= 0
					__errorCode				= 0			&& Codigo de error devuelto por la función
					__return				= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__tableName) <> "C" OR EMPTY(ALLTRIM(__tableName))
						__errorCode = __tableNameEmpty
					ELSE
						IF VARTYPE(__cursorName) <> "C"
							__cursorName = __tableName
						ENDIF
						IF VARTYPE(__structureNative) <> "L"
							__structureNative = false
						ENDIF

						* Obtener Campos de la tabla
							IF SQLCOLUMNS(this.handle, __tableName, IIF(__structureNative,"NATIVE","FOXPRO"), __cursorName) = 1
								__errorCode = __tableFieldsReady
								__return = true
							ELSE
								__errorCode = __commandSqlError
								this.Errors(PROGRAM(), __errorCode)
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Command
				LPARAMETERS __cursorName as Character, __tableName as Character, ;
							__idFieldName as Character, __lastId as Boolean
				LOCAL __idFieldInvalidValue, __idFieldEmpty, __idFieldValueZero, __cursorNameEmpty, __recordNotChanges, __commandSqlReady, ;
					  __commandSql, __typeStateRecord, __updateRecord, __fieldsChangedNumber, __typeStateUpdate, __typeStateDelete, ;
					  __typeStateInsert, __typeStateInsertAndDelete, __fieldCurrent, __fieldsChanges, __fieldsValues, __stringFieldsChanged, ;
					  __fieldValue, __errorCode, __return
				* Command
					* Generar Comando SQL del registro actual del cursor según los cambios hechos, consultar la propiedad .sql_Command para
					* ver el comando SQL generado.
				* Parámetros
					* __tableName, Nombre real de la Tabla de la base de datos
					* __cursorName, Nombre del Cursor a devolver información
					* __idFieldName, Nombre del campo ID Primaty Key Autoincremental
					* __lastId,	Si se obtiene el Ultimo Id insertado
				* Valor devuelto
					* true	Commando Sql generado
					* false	Error al Generar comando Sql
				* Error devuelto
					__idFieldInvalidValue		= -5		&& Campo ID valor invalido
					__idFieldEmpty				= -4		&& Campo ID está vacío
					__idFieldValueZero			= -3		&& Campo ID valor cero			
					__cursorNameEmpty			= -2		&& Nombre del cursor vacío
					__recordNotChanges			= 0			&& No tiene cambios el registro
					__commandSqlReady			= 1			&& Comando SQL generado 
					__commandSql				= ""		&& Comando SQL a generar
					__typeStateRecord			= 0			&& Para obtener el Estado del Registro
					__updateRecord				= false		&& Para saber si hay cambios en el registro
					__fieldsChangedNumber		= 0			&& Para iniciar ciclo y recorrer los campos modificados
					__typeStateUpdate			= 1			&& Estado del registro Modificado
					__typeStateDelete			= 2			&& Estado del registro Eliminado
					__typeStateInsert			= 3			&& Estado del registro insertado
					__typeStateInsertAndDelete	= 4			&& Se agregó un registro nuevo pero fue eliminado
					__fieldCurrent 				= false		&& Campo Actual
					__fieldsChanges				= ""		&& Campos Modificados
					__fieldsValues				= ""		&& Valores de Campos
					__stringFieldsChanged		= ""		&& Obtener cadena de estado de los campos del cursor en el registro
					__idValid					= true		&& Si el Campo ID es valido
					__sqlGenerated				= true		&& Si se genero el comando Sql
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
					this.sql_Command			= ""		&& Instrucción SQL que se va a generar
					this.id_Active				= false		&& Desactivar solicitud de Ultimo ID Insertado
					this.sql_CommandType		= 0			&& Iniciar a 0 el tipo de Comando SQL que se retornara
					__bitacoraDb 				= .f.		&& Si se encuentra el registro de la bitacora
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
						IF VARTYPE(__tableName) <> "C" OR EMPTY(ALLTRIM(__tableName))
							__tableName = __cursorName
						ENDIF
						IF VARTYPE(__idFieldName) <> "C" OR EMPTY(ALLTRIM(__idFieldName))
							__idFieldName = ALLTRIM(this.id_name)
						ENDIF

						* Obtener Estado Global del Registro
							__typeStateRecord = GETFLDSTATE(0,__cursorName)
						* Campos del Cursor
							SELECT (__cursorName)
							nCampos = AFIELDS(arrayFieldList)
						* Campo ID autoincremental (Primary Key) de Tabla y Cursor
							__idFieldTableName = __tableName + "." + __idFieldName
							__fieldValue = __cursorName + "." + __idFieldName

						* Validar Cambios en el Registro
							DO case
								CASE __typeStateRecord = __typeStateUpdate OR __typeStateRecord = __typeStateInsert
									__stringFieldsChanged = GETFLDSTATE(-1,__cursorName)
									FOR a = 1 TO nCampos
										SELECT foxydb_TableFields
										SCAN FOR ALLTRIM(UPPER(ALLTRIM(foxydb_TableFields.field_name))) == ALLTRIM(UPPER((arrayFieldList(a,1))))
											SELECT (__cursorName)
											IF GETFLDSTATE(arrayFieldList(a,1)) = 2 OR GETFLDSTATE(arrayFieldList(a,1)) = 4
												__updateRecord = true
												EXIT
											ENDIF
											SELECT foxydb_TableFields
										ENDSCAN
									NEXT
								CASE __typeStateRecord = __typeStateDelete
									__updateRecord = true
							ENDCASE

						IF __updateRecord
							* Validar Campo ID AutoIncremental Primary Key del Cursor que no este vacío o sea CERO
								IF __typeStateRecord <> __typeStateInsert
									DO case
										CASE VARTYPE(EVALUATE(__fieldValue)) = "N"
											IF EVALUATE(__fieldValue) = 0
												__idValid = false
												__errorCode = __idFieldValueZero
											ENDIF
										CASE VARTYPE(EVALUATE(__fieldValue)) = "C"
											IF EMPTY(ALLTRIM(EVALUATE(__fieldValue)))
												__idValid = false
												__errorCode = __idFieldEmpty
											ENDIF
										OTHERWISE
											__idValid = false
											__errorCode = __idFieldInvalidValue
									ENDCASE
								ENDIF
								
							IF __idValid = true
								* Generar Comando Sql porque se encontraron Cambios
									DO CASE
										CASE __typeStateRecord = __typeStateUpdate
											__commandSql = "UPDATE " + __tableName + " SET "
											__fieldsChanges = ""
											FOR a = 1 TO nCampos
												SELECT foxydb_TableFields
												SCAN FOR ALLTRIM(UPPER(ALLTRIM(foxydb_TableFields.field_name))) == ALLTRIM(UPPER((arrayFieldList(a,1))))
													SELECT (__cursorName)
													IF GETFLDSTATE(arrayFieldList(a,1)) = 2 OR GETFLDSTATE(arrayFieldList(a,1)) = 4
														IF __fieldCurrent
															__commandSql = __commandSql + " , " 
														ENDIF
														* Bitacora
															this.log(__tableName, __cursorName, __typeStateRecord, arrayFieldList(a,1), EVALUATE(__fieldValue))
														* Validar Campos
														 DO case
														 	CASE arrayFieldList(a,2) = "C"
														 		* Eliminar Espacios a los Campos Carácter
																__commandSql = __commandSql + arrayFieldList(a,1) + "= ?ALLTRIM(" + __cursorName + "." + arrayFieldList(a,1) + ")"
															CASE arrayFieldList(a,2) $ "DT"
																* Validar Fechas vacías según Motor de base de datos
																	IF EMPTY(EVALUATE(__cursorName + "." + arrayFieldList(a,1)))
																		DO case
																			CASE this.engine = this.mySql
																				__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.mysql_Empty_Date "
																			CASE this.engine = this.mariaDb
																				__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.mariaDb_Empty_Date "
																			CASE this.engine = this.fireBird
																				__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.fireBird_Empty_Date "
																			CASE this.engine = this.postgreSql
																				__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.postGreSql_Empty_Date "
																			CASE this.engine = this.sqlServer
																				__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.sqlServer_Empty_Date "
																			CASE this.engine = this.sqlLite
																				__commandSql = __commandSql + arrayFieldList(a,1) + "= ?" + __cursorName + "." + arrayFieldList(a,1)
																		ENDCASE
																	ELSE
																		__commandSql = __commandSql + arrayFieldList(a,1) + "= ?" + __cursorName + "." + arrayFieldList(a,1)
																	ENDIF
															OTHERWISE
																__commandSql = __commandSql + arrayFieldList(a,1) + "= ?" + __cursorName + "." + arrayFieldList(a,1)
														ENDCASE								
														__fieldCurrent = true
														EXIT
													ENDIF
													SELECT foxydb_TableFields
												ENDSCAN
											NEXT
											__commandSql = __commandSql + " WHERE " + __idFieldTableName + " = ?" + __fieldValue
										CASE __typeStateRecord = __typeStateDelete
											IF DELETED()
												__commandSql = "DELETE FROM " + __tableName + " WHERE " + __idFieldTableName + " = ?" + __fieldValue
												* Bitacora
													FOR a = 1 TO nCampos
														SELECT foxydb_TableFields
														SCAN FOR ALLTRIM(UPPER(ALLTRIM(foxydb_TableFields.field_name))) == ALLTRIM(UPPER((arrayFieldList(a,1))))
															this.log(__tableName, __cursorName, __typeStateRecord, arrayFieldList(a,1), EVALUATE(__fieldValue))
														ENDSCAN
													NEXT
											ELSE
												__commandSql = ""
											ENDIF
										CASE __typeStateRecord = __typeStateInsert
											__commandSql = "INSERT INTO " + __tableName + " ("
											__fieldsChanges = ""
											__fieldsValues = ""
											FOR a = 1 TO nCampos
												SELECT foxydb_TableFields
												SCAN FOR ALLTRIM(UPPER(ALLTRIM(foxydb_TableFields.field_name))) == ALLTRIM(UPPER(arrayFieldList(a,1)))
													SELECT (__cursorName)
													IF GETFLDSTATE(arrayFieldList(a,1)) = 2 OR GETFLDSTATE(arrayFieldList(a,1)) = 4
														IF __fieldCurrent
															__fieldsChanges = __fieldsChanges + " , "
															__fieldsValues = __fieldsValues + " , "
														ENDIF
														__fieldsChanges = __fieldsChanges + LOWER(arrayFieldList(a,1))
														* Bitacora
															this.log(__tableName, __cursorName, __typeStateRecord, arrayFieldList(a,1), EVALUATE(__fieldValue))
														* Validar Campos
														 DO case
														 	CASE arrayFieldList(a,2) = "C"
														 		* Eliminar Espacios a los Campos Caracter
																__fieldsValues = __fieldsValues + "?ALLTRIM(" + __cursorName + "." + LOWER(arrayFieldList(a,1)) + ")"
															CASE arrayFieldList(a,2) $ "DT"
																* Validar Fechas vacias segun Motor de base de datos
																	IF EMPTY(EVALUATE(__cursorName + "." + arrayFieldList(a,1)))
																		DO case
																			CASE this.engine = this.mySql
																				__fieldsValues = __fieldsValues + "?this.mysql_Empty_Date"
																			CASE this.engine = this.mariaDb
																				__fieldsValues = __fieldsValues + "?this.mariaDb_Empty_Date"
																			CASE this.engine = this.fireBird
																				__fieldsValues = __fieldsValues + "?this.fireBird_Empty_Date"
																			CASE this.engine = this.postgreSql
																				__fieldsValues = __fieldsValues + "?this.postgreSql_Empty_Date"
																			CASE this.engine = this.sqlServer
																				__fieldsValues = __fieldsValues + "?this.sqlServer_Empty_Date "
																			CASE this.engine = this.sqlLite
																				__fieldsValues = __fieldsValues + "?" + __cursorName + "." + LOWER(arrayFieldList(a,1))
																		ENDCASE
																	ELSE
																		__fieldsValues = __fieldsValues + "?" + __cursorName + "." + LOWER(arrayFieldList(a,1))
																	ENDIF
															OTHERWISE
																__fieldsValues = __fieldsValues + "?" + __cursorName + "." + LOWER(arrayFieldList(a,1))
														ENDCASE								
														__fieldCurrent = true
														EXIT
													ENDIF
													SELECT foxydb_TableFields
												ENDSCAN
											NEXT
											__commandSql = __commandSql + __fieldsChanges + ") values (" + __fieldsValues + ")"
											* Verificar si se requiere obtener el Ultimo ID Insertado
												IF __lastId
													this.id_Active = true
													* Obtener Ultimo Id para FireBird y PostGreSql
														IF this.engine = this.fireBird OR this.engine = this.PostGreSql
															__commandSql = __commandSql + " RETURNING " + __idFieldTableName
														ENDIF
													* Obtener Ultimo Id para SqlServer
														IF this.engine = this.sqlServer
															__commandSql = __commandSql + ";SELECT SCOPE_IDENTITY() AS Id"
														ENDIF
												ELSE
													this.id_Active = false
												ENDIF
										CASE __typeStateRecord = __typeStateInsertAndDelete
											__sqlGenerated = false
											__errorCode = __recordNotChanges
											__return = true
									ENDCASE
									IF __sqlGenerated = true
										* Tipo de Commando SQL Generado
											this.sql_CommandType = __typeStateRecord
										* Comando Sql Generado
											this.sql_Command = __commandSql
										__errorCode = __commandSqlReady
										__return = true
									ENDIF
							ENDIF
						ELSE
							__errorCode = __recordNotChanges
							__return = true
						ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE log
				LPARAMETERS __tableName as Character, __cursorName as Character, __commandType as Integer, __fieldName as Character, __idValue as Integer
				LOCAL __log as Character, __fieldType as Character
				IF this.sql_Log = .t.
					* Localizar registro en DBCURSOR para Bitacora
						SELECT dbCursor
						LOCATE FOR ALLTRIM(UPPER(dbCursor.tabla)) == UPPER(ALLTRIM(__tableName)) AND ALLTRIM(UPPER(dbCursor.cursor)) == UPPER(ALLTRIM(__cursorName)) AND !DELETED()
						__log = ""
						__fieldType = VARTYPE(EVALUATE(__cursorName + "." + __fieldName))
						IF FOUND()
							DO case
								CASE __commandType = 1	&& Update
									DO CASE 
										CASE __fieldType = "C"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(EVALUATE(__cursorName + "." + __fieldName)) + "|" + ALLTRIM(OLDVAL(__fieldName, __cursorName))
										CASE __fieldType = "D"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(DTOC(EVALUATE(__cursorName + "." + __fieldName))) + "|" + ALLTRIM(DTOC(OLDVAL(__fieldName, __cursorName)))
										CASE __fieldType = "T"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(TTOC(EVALUATE(__cursorName + "." + __fieldName))) + "|" + ALLTRIM(TTOC(OLDVAL(__fieldName, __cursorName)))
										CASE __fieldType = "N"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(STR(EVALUATE(__cursorName + "." + __fieldName))) + "|" + ALLTRIM(STR(OLDVAL(__fieldName, __cursorName)))
									ENDCASE
								CASE __commandType = 2 	&& Delete
									DO CASE 
										CASE __fieldType = "C"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(EVALUATE(__cursorName + "." + __fieldName)) + "|" + ALLTRIM(OLDVAL(__fieldName, __cursorName))
										CASE __fieldType = "D"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(DTOC(EVALUATE(__cursorName + "." + __fieldName))) + "|" + ALLTRIM(DTOC(OLDVAL(__fieldName, __cursorName)))
										CASE __fieldType = "T"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(TTOC(EVALUATE(__cursorName + "." + __fieldName))) + "|" + ALLTRIM(TTOC(OLDVAL(__fieldName, __cursorName)))
										CASE __fieldType = "N"
											__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(STR(EVALUATE(__cursorName + "." + __fieldName))) + "|" + ALLTRIM(STR(OLDVAL(__fieldName, __cursorName)))
									ENDCASE
								CASE __commandType = 3	&& Insert
									IF __idValue = 0
										DO CASE 
											CASE __fieldType = "C"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + "#ID*CeRo#" + "|" + __fieldName + "|" + ALLTRIM(EVALUATE(__cursorName + "." + __fieldName))
											CASE __fieldType = "D"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + "#ID*CeRo#" + "|" + __fieldName + "|" + ALLTRIM(DTOC(EVALUATE(__cursorName + "." + __fieldName)))
											CASE __fieldType = "T"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + "#ID*CeRo#" + "|" + __fieldName + "|" + ALLTRIM(TTOC(EVALUATE(__cursorName + "." + __fieldName)))
											CASE __fieldType = "N"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + "#ID*CeRo#" + "|" + __fieldName + "|" + ALLTRIM(STR(EVALUATE(__cursorName + "." + __fieldName)))
										ENDCASE
									ELSE
										DO CASE 
											CASE __fieldType = "C"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(EVALUATE(__cursorName + "." + __fieldName))
											CASE __fieldType = "D"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(DTOC(EVALUATE(__cursorName + "." + __fieldName)))
											CASE __fieldType = "T"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(TTOC(EVALUATE(__cursorName + "." + __fieldName)))
											CASE __fieldType = "N"
												__log = "|" + ALLTRIM(STR(__commandType)) + "|" + ALLTRIM(STR(__idValue)) + "|" + __fieldName + "|" + ALLTRIM(STR(EVALUATE(__cursorName + "." + __fieldName)))
										ENDCASE
									ENDIF
							ENDCASE
							REPLACE dbCursor.log WITH dbCursor.log + __log + CHR(10) IN dbCursor
						ENDIF
				ENDIF
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Update
				LPARAMETERS __cursorName as Character, __idFieldName as Variant, __lastId as Boolean
				LOCAL __transactionError, __tableStructureError, __tableNameEmpty, __cursorNameEmpty, ;
					  __cursorNotUpdate, __cursorNoChanges, __cursorUpdate, __cursorUpdate, ;
					  __transactionEnabled, __transactionRollBack, __errorCode, __return
				* Update
					* Genera y Envia instrucciones Sql (Insert / Update / Delete) al servidor según los cambios hechos al cursor
				* Parámetros
					* __cursorName, Nombre del Cursor a Actualizar información en el servidor
					* __idFieldName, Acepta los siguiente valores
						* Lógico: true / false, para solicitar el Ultimo ID Insertado
						* Carácter, Nombre del campo Primary Key Autoincremental
					* __lastId, Para solicitar el Ultimo ID Insertado
				* Valor devuelto
					* true	Cursor Actualizado
					* false	Cursor No Actualizado
				* Error devuelto
					__transactionErrorType		= -6		&& Error Transaccion de Solo Lectura o Remota
					__transactionError			= -5		&& Error al iniciar una transacción
					__tableStructureError		= -4		&& Error al obtener la estructura de la tabla
					__tableNameEmpty 			= -3		&& Nombre de la tabla vacío
					__cursorNameEmpty 			= -2		&& Nombre del cursor vacío
					__cursorNotUpdate			= -1		&& No se puedo actualizar el cursor
					__cursorNoChanges 			= 0			&& Cursor sin Cambios
					__cursorUpdate				= 1			&& Cursor Actualizado en el servidor
					__transactionEnabled		= 1			&& Activar transacción
					__transactionNotStarted		= 0			&& No hay una transacción Iniciada
					__transactionTypeReadOnly	= 1			&& Transacción de Solo Lectura
					__transactionTypeWrite		= 2			&& Transacción de Lectura y Escritura Local y Remota
					__transactionTypeRemote		= 3			&& Transacción de Lectura y Escritura Remota
					__transaction				= true		&& Si hay una transacción
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
					this.id_Last				= 0			&& Iniciar en 0 el valor del Ultimo ID Insertado
					this.error_ODBC				= 0			&& Iniciar en 0 el valor de error ODBC
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
						IF VARTYPE(__idFieldName) = "L"
							__lastId = __idFieldName
						ENDIF
						IF VARTYPE(__idFieldName) <> "C" OR EMPTY(ALLTRIM(__idFieldName))
							__idFieldName = this.id_name
						ENDIF
						IF VARTYPE(__lastId) <> "L"
							__lastId = false
						ENDIF

						* Verificar Cambios en el Cursor
							IF NOT this.CursorChanges(__cursorName)
								__errorCode = __cursorNoChanges
								__return = true
							ELSE
								* Validar o Iniciar Transaccion
									IF this.handle_Transaction = __transactionTypeReadOnly OR this.handle_Transaction = __transactionTypeRemote
										__transaction = false
										__errorCode = __transactionErrorType
									ELSE
										IF this.handle_Transaction = __transactionNotStarted
											IF NOT this.Begin(__transactionTypeWrite)
												__transaction = false
												__errorCode = __transactionError
											ENDIF
										ENDIF
									ENDIF
								
								IF __transaction = true
									* Obtener Nombre de la Tabla Real
										__tableName = ALLTRIM(this.dbTableName(__cursorName))
										IF EMPTY(ALLTRIM(__tableName))
											__errorCode = __tableNameEmpty
										ELSE
											* Estructura de la tabla
												IF this.TableFields(__tableName,"foxydb_TableFields")
													* Recorrer Registros
														SELECT (__cursorName)
														SET DELETED OFF
														__UpdateRecord = true
														SCAN
															IF this.command(__cursorName, __tableName, __idFieldName, __lastId)
																IF NOT EMPTY(ALLTRIM(this.sql_Command))
																	* Enviar SQL para Actualizar
																		IF this.Sql(this.sql_Command, "foxydb_last_id", true)
																			* Ultimo comando SQL enviado por Update
																				this.Sql_Update = this.sql_Command
																			* Obtener Ultimo ID Insertado y Código de Error
																				IF this.id_Active
																					this.Id()
																					replace dbCursor.id WITH this.Id_last IN dbCursor
																					replace dbCursor.log WITH STRTRAN(dbCursor.log, '#ID*CeRo#', ALLTRIM(STR(dbCursor.id))) IN dbCursor
																					*this.log(__tableName, __cursorName, 3, __idFieldName, dbCursor.id)
																					this.error_Id = this.error_Code
																					this.id_Active = false
																				ENDIF
																		ELSE
																			* Hubo un Error
																			__UpdateRecord = false
																			this.Errors(PROGRAM(), __errorCode)
																			EXIT
																		ENDIF
																ENDIF
															ELSE
																* Hubo un Error
																__UpdateRecord = false
																EXIT
															ENDIF
															SELECT (__cursorName)
														ENDSCAN
														SET DELETED ON
													* Verificar que se haya actualizado el Cursor en el Servidor remoto
														IF __UpdateRecord = true
															* Regresar al Primer Registro
																SELECT (__cursorName)
																	IF EOF() OR BOF()
																		GO TOP
																	ENDIF
															* Cerrar tabla de Estrcutura de Campos
																IF USED("foxydb_TableFields")
																	USE IN foxydb_TableFields
																ENDIF
															* Aplicar TableUpdate al Cursor Local
																= TABLEUPDATE(true,false,__cursorName)
															__errorCode = __cursorUpdate
															__return = true
														ELSE
															* Enviar RollBack a Transacción
																IF this.RollBack()
																	__errorCode = __cursorNotUpdate
																ELSE
																	__errorCode = __transactionError
																	this.Errors(PROGRAM(), __errorCode)
																ENDIF
														ENDIF
												ELSE
													__errorCode = __tableStructureError
												ENDIF
										ENDIF
								ENDIF
							ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
		 	ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Refresh
		 		LPARAMETERS __cursorName as Character, __commandSql as Variant, __idFieldName as Character
		 		LOCAL __commandSqlError, __commandSqlEmpty, __tablaNameNotFound,__cursorNameEmpty, ;
		 			  __cursorRefresh, __lastValueId, __tablaNameRequery, __errorCode, __return
				* Refresh
					* Actualizar (Refrescar) los datos del Cursor
				* Parámetros
					* __cursorName, Nombre del Cursor a Refrescar datos
					* __commandSql, 
						* Carácter: Comando SQL a ejecutar en la consulta
						* Numérico: Valor del Campo Autoincremental
					* __idFieldName, Nombre del Campo Id Autoincremental
				* Valor devuelto
					* true	Cursor Refrescado
					* false	Cursor No refrescado
				* Error devuelto
					__commandSqlError			= -4		&& Comando SQL invalido
					__commandSqlEmpty			= -3		&& Comando SQL vacío
					__cursorNameEmpty 			= -2		&& Nombre del cursor vacío
					__tablaNameNotFound			= -1		&& Nombre de la tabla no registrada en DBCURSOR
					__cursorRefresh				= 1			&& Cursor Refrescado
					__lastValueId				= 0			&& Valor del Ultimo ID
					__tablaNameRequery			= ""		&& Nombre de la Tabla a Refrescar datos
					__errorCode					= 0			&& Codigo de error devuelto por la función
					__return					= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ENDIF
					* __commandSql 
						DO case
							CASE VARTYPE(__commandSql) = "L"
								__commandSql 	= ""
								__lastValueId 	= 0
							CASE VARTYPE(__commandSql) = "C"
								__lastValueId 	= 0
							CASE VARTYPE(__commandSql) = "N"
								__lastValueId 	= __commandSql 
								__commandSql 	= ""
							OTHERWISE
								__commandSql = ""
								__lastValueId = 0
						ENDCASE
					IF VARTYPE(__idFieldName) <> "C"
						__idFieldName = this.id_Name
					ENDIF
				* Obtener tabla en DbCursor
					__tablaNameRequery = this.DbTableName(__cursorName)
					IF EMPTY(ALLTRIM(__tablaNameRequery))
						__errorCode = __tablaNameNotFound
					ENDIF
				* Obtener Instrucción SQL
					IF __lastValueId > 0
						* Campo ID y valor
						__commandSql = "Select * from " + __tablaNameRequery + " Where " + __idFieldName + " = " + ALLTRIM(STR(__lastValueId))
					ELSE
						IF EMPTY(ALLTRIM(__commandSql))
							* Obtener Consulta
								IF EMPTY(ALLTRIM(dbcursor.sql))
									__errorCode = __commandSqlEmpty
								ELSE 
									__commandSql = dbcursor.sql
								ENDIF
						ENDIF
					ENDIF					
				* Refrescar Cursor
					IF this.Sql(__commandSql,__cursorName)
						* Actualizar comando SQL en DBCURSOR
							REPLACE dbcursor.sql WITH __commandSql IN DBCURSOR
							__errorCode = __cursorRefresh
							__return = true
				 	ELSE
					 	__errorCode = __commandSqlError
					ENDIF
		 	ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE DbCursor
				LPARAMETERS __cursorName as Character, __cursorTypeAction as Integer,__commandSql as Character ,__tablaName as Character
				LOCAL __cursorNameEmpty, __cursorCreate, __cursorDelete, __actionCompleted, __errorCode, __return
				* DbCursor
					* Crea un Cursor temporal para administrar los cursores creados con Use() y Query()
				* Parámetros
					* __cursorName, Nombre del Cursor a agregar o buscar
					* __cursorTypeAction, Acción a realizar 1 Crear, 2 Eliminar
					* __commandSql, Comando Sql con que se abrió el cursor
					* __tablaName, Nombre de la Tabla real en el servidor de base de datos
				* Valor devuelto
					* true	Acción Completada
					* false	Error no se completo
				* Error devuelto
					__cursorNameEmpty 	= -1		&& Nombre del cursor vacío
					__actionCompleted	= 1			&& Acción Completada
					__cursorCreate		= 1			&& Crear o editar Cursor
					__cursorDelete		= 2			&& Eliminar Cursor
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= false		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
						* Crear cursor temporal
							IF NOT USED("dbCursor")
								CREATE CURSOR dbCursor (tabla C(100), cursor C(100), sql Memo, log Memo, id n(11))
							ENDIF
							SELECT dbCursor
							DO CASE
								CASE __cursorTypeAction = __cursorCreate
									LOCATE FOR ALLTRIM(dbCursor.tabla) == ALLTRIM(__tablaName) AND ALLTRIM(dbCursor.cursor) == ALLTRIM(__cursorName) AND !DELETED()
									IF FOUND()
										REPLACE dbCursor.sql WITH __commandSql IN dbCursor
									ELSE
										INSERT INTO dbCursor (tabla,cursor,sql) values(__tablaName, __cursorName, __commandSql)
									ENDIF
									__errorCode = __actionCompleted
									__return = true
								CASE __cursorTypeAction = __cursorDelete
									DELETE FROM dbCursor WHERE ALLTRIM(dbCursor.cursor) == ALLTRIM(__cursorName)
									__errorCode = __actionCompleted
									__return = true
							ENDCASE
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE DbTableName
				LPARAMETERS __cursorName as Character
				LOCAL __cursorNameEmpty, __dbCursorUnCreated, __tableNameNotFound, __tableNameFound, ;
					  __errorCode, __return
				* DbCursorName
					* Devuelve el nombre de la tabla asociada a un cursor
				* Parámetros
					* __cursorName, Nombre del Cursor a buscar
				* Valor devuelto
					* Carácter, Nombre de la tabla o cadena vacía
				* Error devuelto
					__cursorNameEmpty 		= -2		&& Nombre del cursor vacío
					__dbCursorUnCreated		= -1		&& Cursor DbCursor no creado
					__tableNameNotFound		= 0			&& Nombre de la tabla No encontrado
					__tableNameFound		= 1			&& Nombre de la tabla encontrado
					__errorCode				= 0			&& Codigo de error devuelto por la función
					__return				= ""		&& Valor devuelto por la función
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						__errorCode = __cursorNameEmpty
					ELSE
						IF NOT USED("dbCursor")
							__errorCode = __dbCursorUnCreated
						ELSE
							* Obtener nombre de la tabla
								SELECT dbCursor
								LOCATE FOR ALLTRIM(dbCursor.cursor) == ALLTRIM(__cursorName) AND !DELETED()
								IF FOUND()
									__errorCode = __tableNameFound
									__return = ALLTRIM(dbCursor.tabla)
								ELSE
									__errorCode = __tableNameNotFound
								ENDIF
						ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------


	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE Code
				LPARAMETERS __tableName    as Character, __fieldNameToIncrease as Character, ;
							__fieldName    as Character, __fieldValue 		   as Character, ;
							__defaultValue as Integer,   __defaultValueChange  as Boolean

				LOCAL __transactionError, __transactionReadOnly, __multipleRecordsQuery, ;
					  __fieldNameAndFieldValueNotEqual, __fieldNameToIncreaseEmpty, __tableNameEmpty, ;
					  __commandSqlError, __generatedCode, __filter, __cursorName, __transactionNotStarted, ;
					  __transactionTypeReadOnly, __transactionTypeWrite, __commandSql, __filterValid, ;
					  __transaction, __code, __errorCode, __return

				* Code
					* Obtener Códigos Únicos (Correlativos)
				* Parámetros
					* __tableName, Nombre de la Tabla Real en el servidor
					* __fieldNameToIncrease, Nombre del campo a incrementar su valor
					* __fieldName, Lista de Campos para usar como filtro o agregar registro
					* __fieldValue, Lista de Valores para el filtro o agregar registro
					* __defaultValue, Valor inicial del contador
					* __defaultValueChange, Si remplaza el valor aun cuando ya existe
				* Valor devuelto
					* true 	Código Generado
					* false	Código NO Generado
				* Error devuelto
					__transactionError					= -8		&& Error al iniciar o terminar la transaccion
					__transactionReadOnly				= -7		&& Transaccion de solo lectura
					__multipleRecordsQuery				= -6		&& Error múltiples registros en la consulta
					__fieldNameAndFieldValueNotEqual	= -5		&& La cantidad de Campos no es igual a la cantidad de valores
					__fieldNameToIncreaseEmpty			= -4 		&& Falta Nombre del Campo que se incrementara
					__tableNameEmpty 					= -3 		&& Falta Nombre de la Tabla
					__commandSqlError					= -1		&& Error en comando SQL
					__generatedCode						= 1			&& Codigo Generado
					__filter							= ""
					__cursorName						= "__correlative__"
					__transactionNotStarted				= 0			&& No hay una transacción Iniciada
					__transactionTypeReadOnly			= 1			&& Transaccion de solo lectura
					__transactionTypeWrite				= 2			&& Transacción de Lectura y Escritura Local y Remota
					__commandSql 						= ""		&& Comando Sql Generado para enviar al servidor
					__filterValid						= true		&& Si el filtro es valido
					__transaction						= true		&& Si hay una transacción
					__code								= true		&& Si se obtiene el codigo
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= true		&& Valor devuelto por la función
					DIMENSION __fieldNameArray[1]
					DIMENSION __fieldValueArray[1]
					this.id_Code = 0
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__tableName) <> "C" OR EMPTY(ALLTRIM(__tableName))
						__errorCode = __tableNameEmpty
					ELSE
						IF VARTYPE(__fieldNameToIncrease) <> "C" OR EMPTY(ALLTRIM(__fieldNameToIncrease))
							__errorCode = __fieldNameToIncreaseEmpty
						ELSE
							IF VARTYPE(__fieldName) <> "C" 
								__fieldName = ""
							ENDIF
							IF VARTYPE(__fieldValue) <> "C"
								__fieldValue = ""
							ENDIF
							IF VARTYPE(__defaultValue) <> "N"
								__defaultValue = 0
							ENDIF
						
							* Generar Filtro
								IF EMPTY(ALLTRIM(__fieldName)) OR EMPTY(ALLTRIM(__fieldValue))
									__filter = ""
								ELSE
									IF ALINES(__fieldNameArray,UPPER(__fieldName),true,",") = ALINES(__fieldValueArray,UPPER(__fieldValue),true,",")
										FOR __fieldNameCount = 1 TO ALEN(__fieldNameArray)
											* Campo
												IF __fieldNameCount = 1
													__filter = __fieldNameArray(__fieldNameCount)
												ELSE
													__filter = __filter + " and " + __fieldNameArray(__fieldNameCount)
												ENDIF
											* Valor
												__filter = __filter + " = " + __fieldValueArray(__fieldNameCount)
										NEXT
									ELSE
										__filterValid = false
										__errorCode = __fieldNameAndFieldValueNotEqual
									ENDIF
								ENDIF
							
							IF __filterValid = true
								* Generar SQL según el motor
									DO CASE
										CASE this.engine = this.mySql
											IF EMPTY(ALLTRIM(__filter))
												__commandSql = "Select * From " + __tableName + " FOR UPDATE"
											ELSE
												__commandSql = "Select * From " + __tableName + " where " + __filter + " FOR UPDATE"
											ENDIF
										CASE this.engine = this.mariaDb
											IF EMPTY(ALLTRIM(__filter))
												__commandSql = "Select * From " + __tableName + " FOR UPDATE"
											ELSE
												__commandSql = "Select * From " + __tableName + " where " + __filter + " FOR UPDATE"
											ENDIF
										CASE this.engine = this.fireBird
											IF EMPTY(ALLTRIM(__filter))
												__commandSql = "Select * From " + __tableName + " WITH LOCK"
											ELSE
												__commandSql = "Select * From " + __tableName + " where " + __filter + " WITH LOCK"
											ENDIF
										CASE this.engine = this.postgreSql
											IF EMPTY(ALLTRIM(__filter))
												__commandSql = "Select * From " + __tableName + " FOR UPDATE"
											ELSE
												__commandSql = "Select * From " + __tableName + " where " + __filter + " FOR UPDATE"
											ENDIF
										CASE this.engine = this.sqlServer
											__commandSql = "Select * From " + __tableName + " WITH (HOLDLOCK)"
									ENDCASE

								* Iniciar Transacción
									DO case
										CASE this.handle_Transaction = __transactionNotStarted
											IF NOT this.Begin(__transactionTypeWrite)
												__transaction = false
												__errorCode = __transactionError
											ENDIF
										CASE this.handle_Transaction <= __transactionTypeReadOnly
											__transaction = false
											__errorCode = __transactionReadOnly
									ENDCASE

								IF __transaction = true
									* Obtener Código
										IF this.sql(__commandSql ,__cursorName, true)
											SELECT (__cursorName)
											DO case
												CASE this.sql_Records = 0				&& Agregar
													IF __defaultValue = 0
														this.id_Code = 1
													ELSE
														this.id_Code = __defaultValue
													ENDIF
													IF EMPTY(ALLTRIM(__filter))
														__commandSql = "INSERT INTO " + __tableName + " (" + __fieldNameToIncrease + ") values ( " + ALLTRIM(STR(this.id_Code)) + ")"
													ELSE
														__commandSql = "INSERT INTO " + __tableName + " (" + __fieldName + "," + __fieldNameToIncrease + ") values (" + __fieldValue + "," + ALLTRIM(STR(this.id_Code)) + ")"
													ENDIF
												CASE this.sql_Records = 1				&& Incrementar
													IF __defaultValueChange
														IF __defaultValue = 0
															this.id_Code = EVALUATE(__cursorName + "." + __fieldNameToIncrease) + 1
														ELSE
															this.id_Code = __defaultValue
														ENDIF
													ELSE
														this.id_Code = EVALUATE(__cursorName + "." + __fieldNameToIncrease) + 1
													ENDIF
													IF EMPTY(ALLTRIM(__filter))
														__commandSql = "update " + __tableName + " set " + __fieldNameToIncrease + " = " + ALLTRIM(STR(this.id_Code))
													ELSE
														__commandSql = "update " + __tableName + " set " + __fieldNameToIncrease + " = " + ALLTRIM(STR(this.id_Code)) + " where " + __filter
													ENDIF
												OTHERWISE								&& Error
													__code = false
													USE IN (__cursorName)
													IF this.handle_Transaction
														IF NOT this.Rollback()
															* Error en RollBack
															__errorCode = __transactionError
															this.Errors(PROGRAM(), __errorCode)
														ENDIF
													ELSE
														__errorCode = __multipleRecordsQuery
													ENDIF								
											ENDCASE
											
											IF __code = true
												* Cerrar Cursor
													USE IN (__cursorName)
												* Actualizar
													IF this.Sql(__commandSql ,true, true)
														__errorCode = __generatedCode
														__return = true
													ELSE
														__errorCode = __commandSqlError
														this.Errors(PROGRAM(), __errorCode)
													ENDIF
											ENDIF
										ELSE
											* Error en comando SQL, aplicar Rollback a Transacción
												IF this.handle_Transaction
													IF NOT this.Rollback()
														* Error en RollBack
														__errorCode = __transactionError
														this.Errors(PROGRAM(), __errorCode)
													ENDIF
												ELSE
													__errorCode = __commandSqlError
													this.Errors(PROGRAM(), __errorCode)
												ENDIF
										ENDIF
								ENDIF
							ENDIF
						ENDIF
					ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE TablesGoTop
				LOCAL __cursorsNotOpen, __goTopAplicate, __errorCode, __return
				* TablesGoTop
					* Aplicar un Go Top a los cursores abiertos en DbCursor
				* Parámetros
					* No requerido
				* Valor devuelto
					* true 	Go Top Aplicado
				* Error devuelto
					__cursorsNotOpen	= 0			&& No hay cursores abiertos
					__goTopAplicate		= 1			&& Go Top Aplicado
					__errorCode			= 0			&& Codigo de error devuelto por la función
					__return			= true		&& Valor devuelto por la función
				IF USED("dbcursor")
					SELECT dbcursor
					SCAN
						GO TOP IN (ALLTRIM(dbcursor.cursor))
					ENDSCAN
					__errorCode = __goTopAplicate
				ELSE
					__errorCode = __cursorsNotOpen
				ENDIF

				this.error_Code = __errorCode
				RETURN __return
			ENDPROC
	**** --------------------------------------------------------------------------------------------

	**** --------------------------------------------------------------------------------------------
	**** --------------------------------------------------------------------------------------------
			PROCEDURE End
				* End
					* Cerrar Transacción con RollBack, 
					* cerrar todos los cursores, 
					* conexión al servidor y finalizar la librería
				* Verificar Transacciones
					IF this.handle_Transaction > 0
						this.undo()
					ENDIF
				* Cerrar Todos los Cursores en la session
					this.Close(true)
				* Cerrar DbCursor
					IF USED("DBCURSOR")
						USE IN DBCURSOR
					ENDIF
				* Cerrar conexión 
					this.Disconnect()
				* Finalizar librería
					RETURN null
			ENDPROC
	**** --------------------------------------------------------------------------------------------


ENDDEFINE

**************************************************

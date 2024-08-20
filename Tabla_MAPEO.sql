CREATE TABLE mapeo (;
    TABLA_VFP CHAR(100),;
    CAMPO_VFP CHAR(100),;
    TABLA_MYSQL CHAR(100),;
    CAMPO_MYSQL CHAR(100),;
    CLAVE LOGICAL,;
    PONER_VALOR CHAR(150),;
    PONER_FUNCION CHAR(150);
);

INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'codigo', .F., '_codigo_automatico', '')
INSERT INTO mapeo VALUES ('rubro', 'rubro', 'abm_rubros', 'nombre', .F., '', '')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'observaciones', .F., '', '')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'version', .F., '', 'rubro.version + 1')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'id_abm_empresas', .T., '', '_sincroaempresa')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'id_abm_regiones', .F., '', '_sincroaregion')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'id_abm_usuarios', .F., '', '_sincroausuario')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'id_abm_ultimo_usuario', .F., '', '_sincroausuario')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'ui', .F., '', '_sincroaui')
INSERT INTO mapeo VALUES ('rubro', 'ids', 'abm_rubros', 'sincronizacion', .T., '', '')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'datetime', .F., '=DATETIME()', '')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'ultimo_cambio', .F., '=DATETIME()', '')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'eliminado', .F., '', 'IIF(DELETE("rubro"),1,0)')
INSERT INTO mapeo VALUES ('rubro', '', 'abm_rubros', 'id', .F., '', '_sincroaempresa')



INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (355, 'LACAR', 'I89', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\Lacar\Principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (358, 'QA LEBLANC', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\LeBlanc\prueba\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (370, 'SAN SEBASTIAN', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\SanSebastian\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (431, 'QA LAVAYA', '', '', '', '', '', '', '', '', '', '', '', '', '', 'PUNTO DE VENTA', 'BOLIVIA', 'C:\Program Files\Temp\Lavaya\QA\Principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (432, 'GRUPO APH', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\Alexa\Palace\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (433, 'QACOLORES', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\PlazaSH\QA\Principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (434, 'PRUEBAS SEBASTIAN', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\SanSebastian\QA\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (435, 'DEMO MINERIA', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\Alexa\Uniformes\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (436, 'LYON', '', 'C:\Program Files\Temp\Alexa\principal\', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\Lyon\principal\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (437, 'DEMO SANIDAD', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\Alexa\Sanidad2024\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES (438, 'LEBLANC NO USAR', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\LeBlanc\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas (NOMBRE, DOMICILIO, LOCALIDAD, PROVINCIA, CODPOSTAL,TELEFONOS, MAIL, IVA, CUIT, CAJAPREV, OTROSIMP1, NUM1, OTROSIMP2,    NUM2,OTROSIMP3, NUM3, DIRECTORIO, CARPETA, FTP, PA, PB, RB, RS );
VALUES ('PRUEBA SINCRO', '', 'C:\Program Files\Temp\Alexa\principal\', '', '', '', '', '', '', '','', '', '', '', 'SEDE DESARROLLO', 'ARGENTINA', 'C:\Program Files\Temp\Lyon\principal\principal\','PRINCIPAL', date(), '', '', '', '')





INSERT INTO empresas ;
VALUES (355, 'LACAR', 'I89', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\Lacar\Principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (358, 'QA LEBLANC', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\LeBlanc\prueba\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (370, 'SAN SEBASTIAN', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\SanSebastian\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (431, 'QA LAVAYA', '', '', '', '', '', '', '', '', '', '', '', '', '', 'PUNTO DE VENTA', 'BOLIVIA', 'C:\Program Files\Temp\Lavaya\QA\Principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (432, 'GRUPO APH', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\Alexa\Palace\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (433, 'QACOLORES', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\PlazaSH\QA\Principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (434, 'PRUEBAS SEBASTIAN', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\SanSebastian\QA\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (435, 'DEMO MINERIA', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\Alexa\Uniformes\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (436, 'LYON', '', 'C:\Program Files\Temp\Alexa\principal\', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\Lyon\principal\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (437, 'DEMO SANIDAD', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'ARGENTINA', 'C:\Program Files\Temp\Alexa\Sanidad2024\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (438, 'LEBLANC NO USAR', '', '', '', '', '', '', '', '', '', '', '', '', '', 'SEDE ADMINISTRATIVA', 'CHILE', 'C:\Program Files\Temp\LeBlanc\principal\', 'PRINCIPAL', date(), '', '', '', '')
INSERT INTO empresas ;
VALUES (440,'PRUEBA SINCRO', '', 'C:\Program Files\Temp\Alexa\principal\', '', '', '', '', '', '', '','', '', '', '', 'SEDE DESARROLLO', 'ARGENTINA', 'C:\Program Files\Temp\Lyon\principal\principal\','PRINCIPAL', date(), '', '', '', '')
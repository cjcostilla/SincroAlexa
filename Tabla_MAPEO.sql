CREATE TABLE mapeo (
    TABLA_VFP CHAR(100),
    CAMPO_VFP CHAR(100),
    TABLA_MYSQL CHAR(100),
    CAMPO_MYSQL CHAR(100),
    CLAVE LOGICAL,
    PONER_VALOR CHAR(150),
    PONER_FUNCION CHAR(150)
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


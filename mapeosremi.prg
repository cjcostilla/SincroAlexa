oDb_funcion_ID('ABM_estados', ALLTRIM(estado))
SQL_oDb_funcion_ID('ABM_estados', ObtenerValorClave(cTablaVfp, cJason, "ESTADO"))

oDb_funcion_ID('ABM_regiones_moneda',ALLTRIM(STR(_sincroaregion)))
SQL_oDb_funcion_ID('ABM_regiones_moneda', ALLTRIM(STR(_sincroaregion)))

oDb_funcion_ID('ABM_clientes', ALLTRIM(STR(idcliente)))
SQL_oDb_funcion_ID('ABM_clientes', ObtenerValorClave(cTablaVfp, cJason, "IDCLIENTE"))

oDb_funcion_ID('ABM_usuarios_cabecera', ALLTRIM(UPPER((remi1.vendedor))))
SQL_oDb_funcion_ID('ABM_usuarios_cabecera', ObtenerValorClave(cTablaVfp, cJason, "VENDEDOR"))

oDb_funcion_ID('ABM_usuarios_cabecera', ALLTRIM(UPPER(remi1.mtoentrega)))
SQL_oDb_funcion_ID('ABM_usuarios_cabecera', ObtenerValorClave(cTablaVfp, cJason, "MTOENTREGA"))
CONDVTA
SQL_oDb_funcion_ID('ABM_Rubros', ObtenerValorClave(cTablaVfp, cJason, "RUBRO"))
SELECT COUNT(*) FROM MAPEO WHERE TABLA_VFP='remi1 '

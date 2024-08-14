	/*** COSAS IMPORTANTES PARA MYSQL ***/
**
	"Lista los campos segun la condicion segun un parametro lleno o no"
	SET @param = '';
	SELECT * FROM personas
	WHERE (@param IS NULL OR @param = '') OR (id = @param);
**
	"Me genera el create de la tabla"
	SET @query = CONCAT('SHOW CREATE TABLE ', 'alexa', '.', 'cosas');
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
**


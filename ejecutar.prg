SET ECHO OFF
SET STATUS OFF
SET NOTIFY OFF
SET NOTIFY CURSOR OFF 
SET TALK OFF
SET CONSOLE OFF
*SET SAFETY OFF 
set step off
*set echo off
set scoreboard off
SET TEXTMERGE ON 
SET NULL ON 
SET SEPARATOR TO "." 
SET POINT TO "," 

  set bell       OFF
*  set century    ON
  set confirm    OFF
*  set console    ON
  set cursor     ON
*  set deleted    ON
*  set exclusive  ON      && Todas las tablas de VFP se deben abrir en modo exclusivo para poder hacerles un ZAP
  set escape     ON     && Si se presiona la tecla ESC, no interrumpe la acción que estaba realizando
  set exact      ON
  set multilocks ON
  set printer    OFF
  
*  set date BRITISH
   SET DATE TO DMY 
  
  set decimals   to 10
*  set point      to ","
*  set separator  to "."
 
  SET REPROCES TO 0 automatic
  SET CENTURY OFF
  SET CENTURY TO 19 ROLLOVER 60
  SET DATE TO DMY
  SET DELETED ON
  SET ECHO OFF
  SET EXCLUSIVE OFF
  SET POINT TO "."
  SET SAFETY OFF
  SET SEPARATOR TO ","
  SET SYSMENU OFF
  SET STATUS BAR OFF
  SET TALK OFF
  SET NOTIFY OFF
  SET TABLEPROMPT OFF 
  SET CPDIALOG OFF
  SET DATE TO AMERICAN
  SET CENTURY ON
  SET MARK TO "/"
PUBLIC _xempresa,_xui
_xempresa=614
_xui=''
SET PROCEDURE TO mdb.prg, sincro_funciones.prg ADDITIVE 
CLOSE TABLES ALL
use auditoria excl 
DELETE ALL
PACK
reindex

*INSERT INTO rubro VALUES ('LAVADO', CTOD('07/30/13'), CTOT('07/30/13 02:59:55 PM'), 11, 11, 0, 0)
*INSERT INTO rubro VALUES ('BONIFICACIÓN', CTOD('07/30/13'), CTOT('07/30/13 03:11:01 PM'), 13, 13, 0, 0)

*INSERT INTO rubro VALUES ('RECARGO', CTOD('07/30/13'), CTOT('07/30/13 03:11:58 PM'), 14, 14, 0, 0)
*INSERT INTO rubro VALUES ('MANTELERÍA/ HOTELERÍA', CTOD('05/26/14'), CTOT('05/26/14 02:12:53 PM'), 16, 16, 0, 0)
*UPDATE rubro SET RUBRO = 'MANTE/HOTE' WHERE IDS = 16 
DELETE FROM rubro WHERE ids=14
*MESSAGEBOX(DATETIME())

;
; File encoding:  UTF-8
;

goto _aaa_skip

Update_3_beta3:
gosub Update_common
gosub Update_old_settings
return

Update_3_beta4:
gosub Update_common
gosub Update_old_settings
return

Update_common:
FileDelete, %LocalSciTEPath%\_platform.properties
FileDelete, %LocalSciTEPath%\$VER
FileAppend, %CurrentSciTEVersion%, %LocalSciTEPath%\$VER
SciTEVersion := CurrentSciTEVersion
return

Update_old_settings:
FileRead, ov, %LocalSciTEPath%\SciTEUser.properties
if pos := RegExMatch(ov, "sP)# The following settings.+?\R# \[\[.+?locale\.properties=locales\\(.+?)\.locale.+?make\.backup=([01]).+?import Styles\\(.+?)\.style.+?# \]\]", o)
{
	new := SubStr(ov, 1, pos-1)
	locale := SubStr(ov, oPos1, oLen1)
	backup := SubStr(ov, oPos2, oLen2)
	style := SubStr(ov, oPos3, oLen3)
	newheader =
	(LTrim
	# Import the settings that can be edited by the bundled properties editor
	import _config
	)
	new .= newheader SubStr(ov, pos+o)
	FileDelete, %LocalSciTEPath%\SciTEUser.properties
	FileAppend, % new, %LocalSciTEPath%\SciTEUser.properties
	new =
	(LTrim
	# THIS FILE IS SCRIPT-GENERATED - DON'T TOUCH
	locale.properties=locales\%locale%.locale.properties
	make.backup=%backup%
	code.page=0
	output.code.page=0
	save.position=1
	magnification=-1
	import Styles\%style%.style
	)
	FileDelete, %LocalSciTEPath%\_config.properties ; better be safe
	FileAppend, % new, %LocalSciTEPath%\_config.properties
	VarSetCapacity(new, 0), VarSetCapacity(ov, 0)
}else MsgBox RegEx fail`nErrorLevel: %ErrorLevel%`n`nReport this immediately to fincs along with your SciTEUser.properties file
return

_aaa_skip:
_=_
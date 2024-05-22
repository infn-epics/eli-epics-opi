from org.csstudio.display.builder.runtime.script import PVUtil
from org.csstudio.display.builder.runtime.script import ScriptUtil

logger = ScriptUtil.getLogger()
pv = PVUtil.getString(pvs[0])
device_prefix = widget.getEffectiveMacros().getValue("PREFIX")
device_actual = widget.getEffectiveMacros().getValue("DEVICE")

if device_prefix and pv:
	newdev=device_prefix+pv

	logger.info("PV Name " + str(pvs[0]) + " Val:"+pv+ " DEVICE:"+newdev)
	if not device_actual:
		device_actual="NONE"
		
	if newdev!=device_actual :
		widget.setPropertyValue("file","")
		logger.info("DEV CHANGED from "+ device_actual + " to "+newdev)

		# var pv = PVUtil.getString(pvs[0]);
		# var ms=widget.getPropertyValue("macros")

		# ms.getNames().forEach(element => {
		#     logger.info("MACRO name ="+element +" value="+ms.getValue(element))

		# });
		# var device_macro = ms.getValue("EVR");
		#widget.getEffectiveMacros().setValue("DEVICE", device_prefix+pv)

		widget.getPropertyValue("macros").add("DEVICE", newdev)
		widget.setPropertyValue("file","TML_Main.bob")



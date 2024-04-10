importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var macroInput = DataUtil.createMacrosInput(true);
var pv = PVUtil.getLong(pvs[0]);

macroInput.put("FP",pv);
widget.setPropertyValue("macros",macroInput);

//Reload the OPI file in the linking container again 
//by setting the property value with forcing fire option in true.
widgetController.setPropertyValue("opi_file", 
	widgetController.getPropertyValue("opi_file"), true);
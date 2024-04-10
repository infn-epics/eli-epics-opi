importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var macroInput = DataUtil.createMacrosInput(true);
var pv = PVUtil.getString(pvs[0]);
var device_macro = widget.getMacroValue("EVR");

/* Don't display "0.0" in Device header when OPI first opens */
if (pv == 0.0) {
    if (device_macro != null) {
        pv = device_macro;
    } else {
        pv = "";
    }
}

macroInput.put("EVR",pv);
widget.setPropertyValue("macros",macroInput);

//Reload the OPI file in the linking container again 
//by setting the property value with forcing fire option in true.
widgetController.setPropertyValue("opi_file", 
	widgetController.getPropertyValue("opi_file"), true);


importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var macroInput = DataUtil.createMacrosInput(true);
var pv = PVUtil.getString(pvs[0]);
// var device_macro = widget.getMacroValue("DEVICE");
var device_macro= widget.getPropertyValue("macros");
logger = ScriptUtil.getLogger()

logger.info("MACRO "+device_macro)
/* Don't display "0.0" in Device header when OPI first opens */
if (pv == 0.0) {
    if (device_macro != null) {
        pv = device_macro;
    } else {
        pv = "";
    }
}

macroInput.put("DEVICE", pv);
widgetController.setPropertyValue("macros", macroInput);

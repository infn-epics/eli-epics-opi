from org.csstudio.opibuilder.scriptUtil import ConsoleUtil
from org.csstudio.display.builder.runtime.script import ScriptUtil

ConsoleUtil.writeInfo("Executing script runningUnsaved.py")
w=ScriptUtil.findWidgetByName(widget, "Loaded_file")

saved= w.getValue()
# saved = display.getWidget("Loaded_file").getValue()
new = saved + '*'

if saved.endswith('.json'):
	w.setValue(str(new))

ScriptUtil.findWidgetByName(widget,"Star_main").setValue('*')

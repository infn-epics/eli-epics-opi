from org.csstudio.opibuilder.scriptUtil import ConsoleUtil

ConsoleUtil.writeInfo("Executing script runningUnsaved.py")

saved = display.getWidget("Loaded_file").getValue()
new = saved + '*'

if saved.endswith('.json'):
	display.getWidget("Loaded_file").setValue(str(new))

display.getWidget("Star_main").setValue('*')

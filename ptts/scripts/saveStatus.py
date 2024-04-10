from org.csstudio.opibuilder.scriptUtil import FileUtil
from org.csstudio.opibuilder.scriptUtil import ConsoleUtil
from org.csstudio.opibuilder.scriptUtil import PVUtil

from org.eclipse.jface.dialogs import MessageDialog

# Display whether current configuration is saved
# Need this for first execution and for save actions from main screen
# Any direct changes to PVs w/o saving are taken care of by other script

ConsoleUtil.writeInfo("Executing script saveStatus.py")

opi_path = display.getModel().getOpiFilePath()
try:
     abs_path = FileUtil.workspacePathToSysPath(str(opi_path))
except:
     # opi_path most likely already contains absolute path
     abs_path = str(opi_path)	
dir_path = abs_path[:abs_path.rfind("/")] + "/scripts/"
file_name = "loadedFile.txt"
file_dir = PVUtil.getString(pvs[2])
file_path = file_dir + file_name
		
try:
	loaded = FileUtil.readTextFile(str(file_path))

	if (triggerPV == pvs[0]):
		if str(loaded).endswith('*\n'):
			display.getWidget("Star").setValue('*')
	elif (triggerPV == pvs[1]):
		display.getWidget("Star").setValue(' ')
	
except:
	MessageDialog.openWarning(None, "Warning", "There is no information on the loaded configuration.")

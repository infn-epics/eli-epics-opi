from org.csstudio.display.builder.runtime.script import ScriptUtil,PVUtil

import os
from java.lang import Exception
logger = ScriptUtil.getLogger()
device_prefix = widget.getEffectiveMacros().getValue("PREFIX")

logger.info("LOAD MOTORS "+device_prefix)


motorini = PVUtil.getString(pvs[0]) ## Expects FileName as first parameter
if not os.path.exists(motorini):
    opihome=os.getenv("OPIHOME",".")
    ini=opihome+"/ini"
    motorini=ini+"/"+motorini

if not os.path.exists(motorini):
    ScriptUtil.showMessageDialog(widget,"Cannot find \""+motorini+"\"")

    
motorf = os.path.abspath(motorini)

logger.info("LOAD MOTORS opening "+motorini )
combo = ScriptUtil.findWidgetByName(widget, "DeviceCombo")
# axis = ScriptUtil.findWidgetByName(widget, "TML_AXIS")

# Initialize an empty list to store the values
motor_list = []

# Open the file and read values into the list
with open(motorf, 'r') as file:
    for line in file:
        # Strip whitespace characters (like newline) from each line
        stripped_line = line.strip()
        if stripped_line:  # Avoid adding empty lines
            logger.info("loading " +stripped_line )
            motor_list.append(stripped_line)


combo.setItems(motor_list)
#if len(motor_list) > 0:
    #device_macro= axis.getPropertyValue("macros")
    #device_macro.add("DEVICE", device_prefix + motor_list[0])
    # axis.setPropertyValue("file","")
    # axis.setPropertyValue("file","TML_Main.bob")


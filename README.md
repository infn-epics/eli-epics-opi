# Sparc Epics Opi

This repo is a composition of *git modules* of generic GUIs (for the moment CSS/Phoebus) used for the sparc control. 
This repo is cloned in control console to build control consoles.

- *start.sh* is the entry point for *https://baltig.infn.it/chaos-lnf-control/epics-console-chart*  that generate consoles in a k8s architecture.
- *settings.ini* contains settings for *Phoebus*
- *Launcher.bob* is the Launcher for the Phoebus control applications


## Getting started

git clone https://baltig.infn.it/lnf-da-control/sparc-epics-opi.git --recurse-submodules

Remember *git submodules* are not automatically synched to the last version, so go in the subfolder and pull the changes.

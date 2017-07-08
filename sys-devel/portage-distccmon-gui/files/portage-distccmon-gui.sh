#!/bin/bash
# launch the distccmon-gui program with the correct directory for Portage output
# (you need to be a member of the portage group, or root, for this to work)
set -e
DISTCC_DIR="/var/tmp/portage/.distcc/" /usr/bin/distccmon-gui &

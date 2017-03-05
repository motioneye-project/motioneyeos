
# Copyright (c) 2017 Calin Crisan
# This file is part of motionEyeOS.
#
# motionEyeOS is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>. 

import logging
import os
import subprocess


def get_all_versions():
    try:
        return subprocess.check_output('fwupdate versions', shell=True).strip().split('\n')

    except Exception as e:
        logging.error('failed to list versions: %s' % e)


def perform_update(version):
    logging.info('stopping motioneye watch script')
    os.system('kill $(pidof S85motioneye)')

    logging.info('stopping netwatch script')
    os.system('/etc/init.d/S41netwatch stop')

    logging.error('downloading firmware version %s' % version)
    if os.system('fwupdate download %s > /dev/null' % version):
        logging.error('firmware download failed')
    
    logging.error('extracting firmware')
    if os.system('fwupdate extract > /dev/null'):
        logging.error('firmware extracting failed')

    logging.error('flashing boot partition')
    if os.system('fwupdate flashboot > /dev/null'):
        logging.error('firmware flash boot failed')

    logging.error('rebooting')
    if os.system('fwupdate flashreboot > /dev/null'):
        logging.error('firmware flash reboot failed')



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


def get_os_version():
    with open('/etc/version') as f:
        lines = f.readlines()
    
    lines = [l.strip().split('=', 1) for l in lines]
    data = dict([(l[0], l[1].strip('"')) for l in lines])
    
    return (data['os_name'], data['os_version'])


def get_all_versions():
    try:
        return subprocess.check_output('fwupdate versions', shell=True).strip().split('\n')

    except Exception as e:
        raise Exception('failed to list versions: %s' % e)


def perform_update(version):
    logging.info('stopping motioneye watch script')
    os.system('kill $(pidof S85motioneye)')

    logging.info('stopping netwatch script')
    os.system('/etc/init.d/S41netwatch stop')

    logging.info('downloading firmware version %s' % version)
    if os.system('fwupdate download %s > /dev/null' % version):
        raise Exception('firmware download failed')
    
    logging.info('extracting firmware')
    if os.system('fwupdate extract > /dev/null'):
        raise Exception('firmware extracting failed')

    logging.info('flashing boot partition')
    if os.system('fwupdate flashboot > /dev/null'):
        raise Exception('firmware flash boot failed')

    logging.info('rebooting')
    if os.system('fwupdate flashreboot > /dev/null'):
        raise Exception('firmware flash reboot failed')


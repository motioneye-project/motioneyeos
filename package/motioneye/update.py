
# Copyright (c) 2015 Calin Crisan
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

import json
import logging
import os.path
import re
import shutil
import ssl
import subprocess
import time
import urllib2

import settings


_BOARD = open('/etc/board').read().strip()
_REPO = ('ccrisan', 'motioneyeos')
_DOWNLOAD_URL = 'https://github.com/{owner}/{repo}/releases/download/%(version)s/motioneyeos-%(board)s-%(version)s.img.gz'.format(
        owner=_REPO[0], repo=_REPO[1])
_LIST_VERSIONS_URL = 'https://api.github.com/repos/{owner}/{repo}/releases'.format(
        owner=_REPO[0], repo=_REPO[1])
_DOWNLOAD_DIR = '/data/.firmware_update'
_DOWNLOAD_FILE_NAME = os.path.join(_DOWNLOAD_DIR, 'firmware.gz')


# versions

def get_version():
    import motioneye
    
    return motioneye.VERSION


def get_all_versions():
    url = _LIST_VERSIONS_URL
    url += '?_=' + str(int(time.time())) # prevents caching

        want_prereleases = subprocess.check_output('source /data/etc/os.conf && echo $os_prereleases', shell=True, stderr=subprocess.STDOUT).strip() == 'true'

    try:
        logging.debug('board is %s' % _BOARD)
        logging.debug('fetching %s...' % url)

        context = ssl._create_unverified_context()

        response = urllib2.urlopen(url, timeout=settings.REMOTE_REQUEST_TIMEOUT, context=context)
        releases = json.load(response)

        versions = []
        for release in releases:
            if release.get('prerelease') and not want_prereleases:
                continue
            
            for asset in release.get('assets', []):
                if not re.match('^motioneyeos-%s-\d{8}\.img.gz$' % _BOARD, asset['name']):
                    continue
                    
            versions.append(release['name'])

        logging.debug('available versions: %(versions)s' % {'versions': ', '.join(versions)})

        return sorted(versions)

    except Exception as e:
        logging.error('could not get versions: %s' % e, exc_info=True)

    return []


def compare_versions(version1, version2):
    version1 = re.sub('[^0-9.]', '', version1)
    version2 = re.sub('[^0-9.]', '', version2)
    
    def int_or_0(n):
        try:
            return int(n)
        
        except:
            return 0

    version1 = [int_or_0(n) for n in version1.split('.')]
    version2 = [int_or_0(n) for n in version2.split('.')]
    
    len1 = len(version1)
    len2 = len(version2)
    length = min(len1, len2)
    for i in xrange(length):
        p1 = version1[i]
        p2 = version2[i]
        
        if p1 < p2:
            return -1
        
        elif p1 > p2:
            return 1
    
    if len1 < len2:
        return -1
    
    elif len1 > len2:
        return 1
    
    else:
        return 0


# updating

def download(version):
    url = _DOWNLOAD_URL % {'version': version, 'board': _BOARD}

    try:
        logging.info('downloading %s...' % url)

        shutil.rmtree(_DOWNLOAD_DIR, ignore_errors=True)
        os.makedirs(_DOWNLOAD_DIR)
        subprocess.check_call(['/usr/bin/wget', url, '--no-check-certificate', '-O', _DOWNLOAD_FILE_NAME])

    except Exception as e:
        logging.error('could not download update: %s' % e)

        raise

    try:
        logging.info('decompressing %s...' % _DOWNLOAD_FILE_NAME)

        subprocess.check_call(['/bin/gunzip', _DOWNLOAD_FILE_NAME])

    except Exception as e:
        logging.error('could not decompress archive: %s' % e)
        
        raise
    
    extracted_file_name = _DOWNLOAD_FILE_NAME.replace('.gz', '')

    try:
        logging.info('reading partiton table...')

        output = subprocess.check_output(['/sbin/fdisk', '-l', extracted_file_name])
        lines = [l.strip().replace('*', ' ') for l in output.split('\n') if l.startswith(extracted_file_name)]
        boot_info = lines[0].split()
        root_info = lines[1].split()
        
        boot_start, boot_end = int(boot_info[1]), int(boot_info[2])
        root_start, root_end = int(root_info[1]), int(root_info[2])
        
    except Exception as e:
        logging.error('could not read partition table: %s' % e)
        
        raise
        
    try:
        logging.info('extracting boot.img...')

        subprocess.check_call(['/bin/dd', 'if=' + extracted_file_name, 'of=' + os.path.join(_DOWNLOAD_DIR, 'boot.img'),
                'bs=2048', 'skip=' + str(boot_start / 4), 'count=' + str((boot_end - boot_start + 1) / 4)])

    except Exception as e:
        logging.error('could not extract boot.img: %s' % e)
        
        raise

    try:
        logging.info('extracting root.img...')

        subprocess.check_call(['/bin/dd', 'if=' + extracted_file_name, 'of=' + os.path.join(_DOWNLOAD_DIR, 'root.img'),
                'bs=2048', 'skip=' + str(root_start / 4), 'count=' + str((root_end - root_start + 1) / 4)])

    except Exception as e:
        logging.error('could not extract root.img: %s' % e)
        
        raise


def perform_update(version):
    logging.info('updating to version %(version)s...' % {'version': version})
    
    logging.info('killing motioneye init script...')
    os.system('kill $(pidof S85motioneye)')

    logging.info('stopping netwatch init script...')
    os.system('/etc/init.d/S41netwatch stop')

    download(version)
    
    logging.info('backing up /boot/config.txt')
    if os.system('/bin/cp /boot/config.txt /tmp/config.txt'):
        logging.error('failed to backup /boot/config.txt')

        raise Exception('failed to backup /boot/config.txt')
    
    logging.info('unmounting boot partition...')
    if os.system('/bin/umount /boot'):
        logging.error('failed to unmount boot partition')

        raise Exception('failed to unmount boot partition')

    try:
        logging.info('installing boot image...')
        boot_img = os.path.join(_DOWNLOAD_DIR, 'boot.img')
        
        subprocess.check_call(['/bin/dd', 'if=' + boot_img, 'of=/dev/mmcblk0p1', 'bs=1M'])

    except Exception as e:
        logging.error('could not install boot image: %s' % e)

        raise

    logging.info('mounting boot partition read-write...')
    if os.system('/bin/mount -o rw /dev/mmcblk0p1 /boot'):
        logging.error('failed to mount boot partition')
    
        raise Exception('failed to mount boot partition')

    logging.info('restoring up /boot/config.txt')
    if os.system('/bin/cp /tmp/config.txt /boot/config.txt'):
        logging.error('failed to restore /boot/config.txt')

        raise Exception('failed to restore /boot/config.txt')
    
    logging.info('preparing to boot in fwupdate mode...')
    try:
        config_lines = [c.strip() for c in open('/boot/config.txt', 'r').readlines() if c.strip()]
        
    except Exception as e:
        logging.error('failed to read /boot/config.txt: %s' % e, exc_info=True)
        
        raise

    config_lines.append('initramfs fwupdater.gz')

    try:
        with open('/boot/config.txt', 'w') as f:
            for line in config_lines:
                f.write(line + '\n')
        
    except Exception as e:
        logging.error('failed to write /boot/config.txt: %s' % e, exc_info=True)
        
        raise
        
    logging.info('rebooting...')

    if os.system('/sbin/reboot'):
        logging.error('failed to reboot')
        logging.info('hard rebooting...')
        open('/proc/sysrq-trigger', 'w').write('b') # reboot


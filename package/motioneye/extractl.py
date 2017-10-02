
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

import logging
import os.path
import subprocess

from config import additional_config


MOTIONEYE_CONF = '/data/etc/motioneye.conf'
OS_CONF = '/data/etc/os.conf'
HOSTNAME_CONF = '/data/etc/hostname'
DATE_CONF = '/data/etc/date.conf'


def _get_hostname():
    try:
        with open(HOSTNAME_CONF) as f:
            hostname = f.read().strip()
            logging.debug('hostname %s read from %s' % (hostname, HOSTNAME_CONF))
            return hostname

    except:
        return ''


def _set_hostname(hostname):
    if hostname:
        with open(HOSTNAME_CONF, 'w') as f:
            f.write(hostname)
        
        logging.debug('hostname %s written to %s' % (hostname, HOSTNAME_CONF))

    else:
        try:
            os.remove(HOSTNAME_CONF)
            logging.debug('hostname file %s removed' % HOSTNAME_CONF)
        
        except:
            pass

def _get_date_settings():
    date_method = 'http'
    date_host = 'google.com'
    date_ntp_server = ''
    date_timeout = 10
    date_interval = 900

    if os.path.exists(DATE_CONF):
        logging.debug('reading date settings from %s' % DATE_CONF)
        
        with open(DATE_CONF) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue

                if line.startswith('#'):
                    continue

                try:
                    name, value = line.split('=')
                    value = value.strip('"').strip("'")

                except:
                    continue

                if name == 'date_method':
                    date_method = value

                elif name == 'date_host':
                    date_host = value
                    
                elif name == 'date_ntp_server':
                    date_ntp_server = value

                elif name == 'date_timeout':
                    date_timeout = int(value)

                elif name == 'date_interval':
                    date_interval = int(value)

    s = {
        'dateMethod': date_method,
        'dateHost': date_host,
        'dateNtpServer': date_ntp_server,
        'dateTimeout': date_timeout,
        'dateInterval': date_interval
    }
    
    logging.debug('date settings: method=%(dateMethod)s, host=%(dateHost)s, ntp_server=%(dateNtpServer)s, timeout=%(dateTimeout)s, interval=%(dateInterval)s' % s)
    
    return s


def _set_date_settings(s):
    s.setdefault('dateMethod', 'http')
    s.setdefault('dateHost', 'google.com')
    s.setdefault('dateNtpServer', '')
    s.setdefault('dateTimeout', 10)
    s.setdefault('dateInterval', 900)

    logging.debug('writing date settings to %s: ' % DATE_CONF +
            'method=%(dateMethod)s, host=%(dateHost)s, ntp_server=%(dateNtpServer)s, timeout=%(dateTimeout)s, interval=%(dateInterval)s' % s)

    with open(DATE_CONF, 'w') as f:
        f.write('date_method=%s\n' % s['dateMethod'])
        f.write('date_host=%s\n' % s['dateHost'])
        f.write('date_ntp_server=%s\n' % s['dateNtpServer'])
        f.write('date_timeout=%s\n' % s['dateTimeout'])
        f.write('date_interval=%s\n' % s['dateInterval'])


def _get_os_settings():
    prereleases = False

    if os.path.exists(OS_CONF):
        logging.debug('reading OS settings from %s' % OS_CONF)

        with open(OS_CONF) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue

                if line.startswith('#'):
                    continue

                try:
                    name, value = line.split('=')
                    value = value.strip('"').strip("'")

                except:
                    continue

                if name == 'os_prereleases':
                    prereleases = value == 'true'

    s = {
        'prereleases': prereleases
    }
    
    logging.debug('OS settings: prereleases=%(prereleases)s' % s)
    
    return s


def _set_os_settings(s):
    s = dict(s)

    s.setdefault('prereleases', False)

    logging.debug('writing OS settings to %s: ' % OS_CONF +
            'prereleases=%(prereleases)s' % s)

    lines = []
    if os.path.exists(OS_CONF):
        with open(OS_CONF) as f:
            lines = f.readlines()

        for i, line in enumerate(lines):
            line = line.strip()
            if not line:
                continue

            try:
                name, _ = line.split('=', 2)
    
            except:
                continue
            
            if name == 'os_prereleases':
                lines[i] = 'os_prereleases="%s"' % str(s.pop('prereleases')).lower()
    
    if 'prereleases' in s:
        lines.append('os_prereleases="%s"' % str(s.pop('prereleases')).lower())

    with open(OS_CONF, 'w') as f:
        for line in lines:
            if not line.strip():
                continue
            if not line.endswith('\n'):
                line += '\n'
            f.write(line)


def _get_motioneye_settings():
    port = 80
    motion_binary = '/usr/bin/motion'
    debug = False
    motion_keep_alive = False

    if os.path.exists(MOTIONEYE_CONF):
        logging.debug('reading motioneye settings from %s' % MOTIONEYE_CONF)

        with open(MOTIONEYE_CONF) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue

                try:
                    name, value = line.split(' ', 1)

                except:
                    continue
                    
                name = name.replace('-', '_')

                if name == 'port':
                    port = int(value)

                elif name == 'motion_binary':
                    motion_binary = value
                    
                elif name == 'log_level':
                    debug = value == 'debug'

                elif name == 'mjpg_client_idle_timeout':
                    motion_keep_alive = value == '0'

    s = {
        'port': port,
        'motionBinary': motion_binary,
        'motionKeepAlive': motion_keep_alive,
        'debug': debug
    }

    logging.debug(('motioneye settings: port=%(port)s, motion_binary=%(motionBinary)s, ' +
            'motion_keep_alive=%(motionKeepAlive)s, debug=%(debug)s') % s)

    return s


def _set_motioneye_settings(s):
    s = dict(s)
    s.setdefault('port', 80)
    s.setdefault('motionBinary', '/usr/bin/motion')
    debug = s.setdefault('debug', False) # value needed later
    s.setdefault('motion_keep_alive', False)
    
    logging.debug('writing motioneye settings to %s: ' % MOTIONEYE_CONF +
            ('port=%(port)s, motion_binary=%(motionBinary)s, ' +
            'motion_keep_alive=%(motionKeepAlive)s, debug=%(debug)s') % s)

    lines = []
    if os.path.exists(MOTIONEYE_CONF):
        with open(MOTIONEYE_CONF) as f:
            lines = f.readlines()

        for i, line in enumerate(lines):
            line = line.strip()
            if not line:
                continue
    
            try:
                name, _ = line.split(' ', 2)
    
            except:
                continue
            
            name = name.replace('-', '_')
    
            if name == 'port':
                lines[i] = 'port %s' % s.pop('port')
    
            elif name == 'motion_binary':
                lines[i] = 'motion_binary %s' % s.pop('motionBinary')
    
            elif name == 'log_level':
                lines[i] = 'log_level %s' % ['info', 'debug'][s.pop('debug')]
                
            elif name == 'mjpg_client_idle_timeout':
                lines[i] = 'mjpg_client_idle_timeout %s' % [10, 0][s.pop('motionKeepAlive')]
    
    lines = [l for l in lines if l is not None]

    if 'port' in s:
        lines.append('port %s' % s.pop('port'))

    if 'motionBinary' in s:
        lines.append('motion_binary %s' % s.pop('motionBinary'))

    if 'debug' in s:
        lines.append('log_level %s' % ['info', 'debug'][s.pop('debug')])
        
    if 'motionKeepAlive' in s:
        lines.append('mjpg_client_idle_timeout %s' % [10, 0][s.pop('motionKeepAlive')])

    with open(MOTIONEYE_CONF, 'w') as f:
        for line in lines:
            if not line.strip():
                continue
            if not line.endswith('\n'):
                line += '\n'
            f.write(line)

    # also update debug in os.conf
    if debug:
        cmd = "sed -i -r 's/os_debug=\"?false\"?/os_debug=\"true\"/'  %s" % OS_CONF
        
    else:
        cmd = "sed -i -r 's/os_debug=\"?true\"?/os_debug=\"false\"/'  %s" % OS_CONF

    if os.system(cmd):
        logging.error('failed to set debug flag in os.conf')


def _get_motion_log():
    return '<a href="javascript:downloadFile(\'log/motion/\');">motion.log</a>'


def _get_motion_eye_log():
    return '<a href="javascript:downloadFile(\'log/motioneye/\');">motioneye.log</a>'


def _get_messages_log():
    return '<a href="javascript:downloadFile(\'log/messages/\');">messages.log</a>'


def _get_boot_log():
    return '<a href="javascript:downloadFile(\'log/boot/\');">boot.log</a>'


def _get_dmesg_log():
    return '<a href="javascript:downloadFile(\'log/dmesg/\');">dmesg.log</a>'


@additional_config
def hostname():
    return {
        'label': 'Hostname',
        'description': 'sets a custom hostname for the device (leave blank for default)',
        'type': 'str',
        'section': 'general',
        'advanced': True,
        'reboot': True,
        'required': False,
        'validate': '^[a-z0-9\-_.]{0,64}$',
        'get': _get_hostname,
        'set': _set_hostname
    }


@additional_config
def extraDateSeparator():
    return {
        'type': 'separator',
        'section': 'expertSettings',
        'advanced': True
    }


@additional_config
def dateMethod():
    return {
        'label': 'Date Method',
        'description': 'decides whether NTP or HTTP is used for setting and updating the system date',
        'type': 'choices',
        'choices': [('http', 'HTTP'), ('ntp', 'NTP')],
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'get': _get_date_settings,
        'set': _set_date_settings,
        'get_set_dict': True
    }


@additional_config
def dateHost():
    return {
        'label': 'Date HTTP Host',
        'description': 'sets the hostname or IP address to which the HTTP request will be made',
        'type': 'str',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['dateMethod==http'],
        'get': _get_date_settings,
        'set': _set_date_settings,
        'get_set_dict': True
    }


@additional_config
def dateNtpServer():
    return {
        'label': 'NTP Server',
        'description': 'sets a custom NTP server (leave blank to use the default server)',
        'type': 'str',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': False,
        'depends': ['dateMethod==ntp'],
        'get': _get_date_settings,
        'set': _set_date_settings,
        'get_set_dict': True
    }


@additional_config
def dateTimeout():
    return {
        'label': 'Date Updating Timeout',
        'description': 'sets the number of seconds to wait when requesting the date/time',
        'type': 'number',
        'min': 1,
        'max': 3600,
        'unit': 'seconds',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'get': _get_date_settings,
        'set': _set_date_settings,
        'get_set_dict': True
    }


@additional_config
def dateInterval():
    return {
        'label': 'Date Updating Interval',
        'description': 'sets the interval between system date updates',
        'type': 'number',
        'min': 10,
        'max': 86400,
        'unit': 'seconds',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['dateMethod==http'],
        'get': _get_date_settings,
        'set': _set_date_settings,
        'get_set_dict': True
    }


@additional_config
def extraMotionEyeSeparator():
    return {
        'type': 'separator',
        'section': 'expertSettings',
        'advanced': True
    }


@additional_config
def port():
    return {
        'label': 'HTTP Port',
        'description': 'sets the port on which the motionEye HTTP server listens',
        'type': 'number',
        'min': 1,
        'max': 65535,
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'get': _get_motioneye_settings,
        'set': _set_motioneye_settings,
        'get_set_dict': True
    }


@additional_config
def motionBinary():
    return {
        'label': 'Motion Binary',
        'description': 'sets the path to the motion binary',
        'type': 'str',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'get': _get_motioneye_settings,
        'set': _set_motioneye_settings,
        'get_set_dict': True
    }


@additional_config
def motionKeepAlive():
    return {
        'label': 'Motion Keep-alive',
        'description': 'enables continuous motion daemon hang detection (at the expense of a slightly higher CPU usage)',
        'type': 'bool',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'unit': 'seconds',
        'get': _get_motioneye_settings,
        'set': _set_motioneye_settings,
        'get_set_dict': True
    }


@additional_config
def debug():
    return {
        'label': 'Enable Debugging',
        'description': 'turning debugging on will generate verbose log messages and will mount all the partitions in read-write mode',
        'type': 'bool',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'get': _get_motioneye_settings,
        'set': _set_motioneye_settings,
        'get_set_dict': True
    }


@additional_config
def prereleases():
    return {
        'label': 'Enable Prereleases',
        'description': 'turning this option on will allow updating to prereleases (untested, possibly unstable versions)',
        'type': 'bool',
        'section': 'expertSettings',
        'advanced': True,
        'get': _get_os_settings,
        'set': _set_os_settings,
        'get_set_dict': True
    }


@additional_config
def extraLogsSeparator():
    return {
        'type': 'separator',
        'section': 'expertSettings',
        'advanced': True
    }


@additional_config
def motionLog():
    return {
        'label': 'Log Files',
        'description': 'download the log files and include them with any issue you want to report',
        'type': 'html',
        'section': 'expertSettings',
        'advanced': True,
        'get': _get_motion_log,
    }


@additional_config
def motionEyeLog():
    return {
        'type': 'html',
        'section': 'expertSettings',
        'advanced': True,
        'get': _get_motion_eye_log,
    }


@additional_config
def messagesLog():
    return {
        'type': 'html',
        'section': 'expertSettings',
        'advanced': True,
        'get': _get_messages_log,
    }


@additional_config
def bootLog():
    return {
        'type': 'html',
        'section': 'expertSettings',
        'advanced': True,
        'get': _get_boot_log,
    }


@additional_config
def dmesgLog():
    return {
        'type': 'html',
        'section': 'expertSettings',
        'advanced': True,
        'get': _get_dmesg_log,
    }


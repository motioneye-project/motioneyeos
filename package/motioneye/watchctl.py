
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

from config import additional_config, additional_section


WATCH_CONF = '/data/etc/watch.conf'


def _get_watch_settings():
    watch_link = False
    watch_link_timeout = 20

    watch_connect = False
    watch_connect_host = 'www.google.com'
    watch_connect_port = 80
    watch_connect_retries = 3
    watch_connect_timeout = 5
    watch_connect_interval = 20

    if os.path.exists(WATCH_CONF):
        logging.debug('reading watch settings from %s' % WATCH_CONF)
        
        with open(WATCH_CONF) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                
                comment = False
                if line.startswith('#'):
                    line = line.strip('#')
                    comment = True
                    
                try:
                    name, value = line.split('=')
                    value = value.strip('"').strip("'")

                except:
                    continue

                if name == 'link_watch':
                    watch_link = (value == 'true') and not comment
                
                elif name == 'link_watch_timeout':
                    watch_link_timeout = int(value)

                elif name == 'netwatch_host':
                    watch_connect = not comment
                    watch_connect_host = value

                elif name == 'netwatch_port':
                    watch_connect_port = int(value)

                elif name == 'netwatch_timeout':
                    watch_connect_timeout = int(value)

                elif name == 'netwatch_retries':
                    watch_connect_retries = int(value)

                elif name == 'netwatch_interval':
                    watch_connect_interval = int(value)
    
    s = {
        'watchLink': watch_link,
        'watchLinkTimeout': watch_link_timeout,
        'watchConnect': watch_connect,
        'watchConnectHost': watch_connect_host,
        'watchConnectPort': watch_connect_port,
        'watchConnectRetries': watch_connect_retries,
        'watchConnectTimeout': watch_connect_timeout,
        'watchConnectInterval': watch_connect_interval
    }
    
    logging.debug(('watch settings: watch_link=%(watchLink)s, watch_link_timeout=%(watchLinkTimeout)s, ' +
            'watch_connect=%(watchConnect)s, watch_connect_host=%(watchConnectHost)s, ' +
            'watch_connect_port=%(watchConnectPort)s, watch_connect_retries=%(watchConnectRetries)s, ' +
            'watch_connect_timeout=%(watchConnectTimeout)s, watch_connect_interval=%(watchConnectInterval)s') % s)
    
    return s


def _set_watch_settings(s):
    s.setdefault('watchLink', False)
    s.setdefault('watchLinkTimeout', 20)
    s.setdefault('watchConnect', False)
    s.setdefault('watchConnectHost', 'www.google.com')
    s.setdefault('watchConnectPort', 80)
    s.setdefault('watchConnectRetries', 3)
    s.setdefault('watchConnectTimeout', 5)
    s.setdefault('watchConnectInterval', 20)

    logging.debug('writing watch settings to %s: ' % WATCH_CONF +
            ('watch_link=%(watchLink)s, watch_link_timeout=%(watchLinkTimeout)s, ' +
            'watch_connect=%(watchConnect)s, watch_connect_host=%(watchConnectHost)s, ' +
            'watch_connect_port=%(watchConnectPort)s, watch_connect_retries=%(watchConnectRetries)s, ' +
            'watch_connect_timeout=%(watchConnectTimeout)s, watch_connect_interval=%(watchConnectInterval)s') % s)
    

    with open(WATCH_CONF, 'w') as f:
        f.write('link_watch=%s\n' % ['"false"', '"true"'][s['watchLink']])
        f.write('link_watch_timeout=%s\n' % s['watchLinkTimeout'])
        f.write('\n')
        f.write('ip_watch=%s\n' % ['"false"', '"true"'][s['watchLink']])
        f.write('ip_watch_timeout=%s\n' % s['watchLinkTimeout'])
        f.write('\n')
        f.write('%snetwatch_host=%s\n' % (('#' if not s['watchConnect'] else ''), s['watchConnectHost']))
        f.write('netwatch_port=%s\n' % s['watchConnectPort'])
        f.write('netwatch_retries=%s\n' % s['watchConnectRetries'])
        f.write('netwatch_timeout=%s\n' % s['watchConnectTimeout'])
        f.write('netwatch_interval=%s\n' % s['watchConnectInterval'])


@additional_section
def expertSettings():
    return {
        'label': 'Expert Settings',
        'description': 'system tweaks and board-specific options',
        'advanced': True
    }


@additional_config
def watchLink():
    return {
        'label': 'Network Link Watch',
        'description': 'enable this if you want the system to reboot upon detecting network link issues',
        'type': 'bool',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }


@additional_config
def watchLinkTimeout():
    return {
        'label': 'Network Link Timeout',
        'description': 'sets the time after which the network link is considered down',
        'type': 'number',
        'min': 1,
        'max': 3600,
        'unit': 'seconds',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['watchLink'],
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }


@additional_config
def watchConnect():
    return {
        'label': 'Connectivity Watch',
        'description': 'enable this if you want the system to constantly try to connect to a certain host and reboot upon failure',
        'type': 'bool',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }


@additional_config
def watchConnectHost():
    return {
        'label': 'Connectivity Watch Host',
        'description': 'sets the hostname or IP address to which a TCP connection will be opened',
        'type': 'str',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['watchConnect'],
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }


@additional_config
def watchConnectPort():
    return {
        'label': 'Connectivity Watch Port',
        'description': 'sets the TCP port TO which the TCP connection will be opened',
        'type': 'number',
        'min': 1,
        'max': 65535,
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['watchConnect'],
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }


@additional_config
def watchConnectRetries():
    return {
        'label': 'Connectivity Watch Retries',
        'description': 'sets the number of times to retry to connect',
        'type': 'number',
        'min': 1,
        'max': 100,
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['watchConnect'],
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }


@additional_config
def watchConnectTimeout():
    return {
        'label': 'Connectivity Watch Timeout',
        'description': 'sets the time to wait for the connection to succeed',
        'type': 'number',
        'min': 1,
        'max': 3600,
        'unit': 'seconds',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['watchConnect'],
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }


@additional_config
def watchConnectInterval():
    return {
        'label': 'Connectivity Watch Interval',
        'description': 'sets the time to wait between connections',
        'type': 'number',
        'min': 1,
        'max': 3600,
        'unit': 'seconds',
        'section': 'expertSettings',
        'advanced': True,
        'reboot': True,
        'required': True,
        'depends': ['watchConnect'],
        'get': _get_watch_settings,
        'set': _set_watch_settings,
        'get_set_dict': True
    }

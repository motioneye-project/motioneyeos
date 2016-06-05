
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
import re

from collections import OrderedDict

from config import additional_config


STATIC_IP_CONF = '/data/etc/static_ip.conf'


def _get_ip_settings():
    ip = None
    ip_comment = False
    cidr = '24'
    gw = '192.168.1.1'
    gw_comment = False
    dns = '8.8.8.8'
    dns_comment = False
    
    if os.path.exists(STATIC_IP_CONF):
        logging.debug('reading ip settings from %s' % STATIC_IP_CONF)

        with open(STATIC_IP_CONF) as f:
            for line in f:
                line = line.strip()
                if line.startswith('#'):
                    comment = True
                    line = line.strip('#')
    
                else:
                    comment = False
    
                if not line:
                    continue
    
                match = re.match('^static_ip="(.*)/(.*)"$', line)
                if match:
                    ip, cidr = match.groups()
                    ip_comment = comment
                    continue
    
                match = re.match('^static_gw="(.*)"$', line)
                if match:
                    gw = match.group(1)
                    gw_comment = comment
                    continue
    
                match = re.match('^static_dns="(.*)"$', line)
                if match:
                    dns = match.group(1)
                    dns_comment = comment
                    continue
    
    if ip is None or ip_comment:
        type = 'dhcp'
        
    else:
        type = 'static'

    if ip is None:
        ip = '192.168.1.101'

    bits = 0
    for i in xrange(32 - int(cidr), 32):
        bits |= (1 << i)
    
    mask = '%d.%d.%d.%d' % ((bits & 0xff000000) >> 24, (bits & 0xff0000) >> 16, (bits & 0xff00) >> 8 , (bits & 0xff))

    if gw_comment and type == 'static':
        gw = None
    
    if dns_comment and type == 'static':
        dns = None
        
    s = {
        'ipConfigType': type,
        'ipConfigStaticAddr': ip,
        'ipConfigStaticMask': mask,
        'ipConfigStaticGw': gw,
        'ipConfigStaticDns': dns
    }
    
    logging.debug(('ip settings: type=%(ipConfigType)s, addr=%(ipConfigStaticAddr)s, mask=%(ipConfigStaticMask)s, ' +
            'gw=%(ipConfigStaticGw)s, dns=%(ipConfigStaticDns)s') % s)

    return s


def _set_ip_settings(s):
    type = s.get('ipConfigType', 'dhcp')
    ip = s.get('ipConfigStaticAddr', '192.168.1.101')
    mask = s.get('ipConfigStaticMask', '255.255.255.0')
    gw = s.get('ipConfigStaticGw', '192.168.1.1')
    dns = s.get('ipConfigStaticDns', '8.8.8.8')
    
    logging.debug('writing ip settings to %s: ' % STATIC_IP_CONF +
            ('type=%(ipConfigType)s, addr=%(ipConfigStaticAddr)s, mask=%(ipConfigStaticMask)s, ' +
            'gw=%(ipConfigStaticGw)s, dns=%(ipConfigStaticDns)s') % s)

    cidr = '24'
    if mask:
        binary_str = ''
        for octet in mask.split('.'):
            binary_str += bin(int(octet))[2:].zfill(8)
        cidr = str(len(binary_str.rstrip('0')))
    
    current_settings = OrderedDict()
    if os.path.exists(STATIC_IP_CONF):
        with open(STATIC_IP_CONF, 'r') as f:
            for line in f:
                line = line.strip().split('=', 1)
                if len(line) != 2:
                    continue
                key, value = line
                if key.startswith('#'):
                    current_settings[key.strip('#')] = (value, False)

                else:
                    current_settings[key] = (value, True)

    enabled = type != 'dhcp'
    current_settings['static_ip'] = ('"%s/%s"' % (ip, cidr), enabled)
    current_settings['static_gw'] = ('"%s"' % gw, enabled)
    current_settings['static_dns'] = ('"%s"' % dns, enabled)

    with open(STATIC_IP_CONF, 'w') as f:
        for key, value in current_settings.items():
            (value, enabled) = value
            if not enabled:
                key = '#' + key
            f.write('%s=%s\n' % (key, value))


@additional_config
def ipSeparator():
    return {
        'type': 'separator',
        'section': 'network',
        'advanced': True
    }


@additional_config
def ipConfigType():
    return {
        'label': 'IP Configuration',
        'description': 'select the way your IP address is configured',
        'type': 'choices',
        'choices': [('dhcp', 'Automatic (DHCP)'), ('static', 'Manual (Static IP)')],
        'section': 'network',
        'advanced': True,
        'reboot': True,
        'get': _get_ip_settings,
        'set': _set_ip_settings,
        'get_set_dict': True
    }


@additional_config
def ipConfigStaticAddr():
    return {
        'label': 'IP Address',
        'description': 'manually set your static IP address',
        'type': 'str',
        'validate': '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$',
        'section': 'network',
        'advanced': True,
        'required': True,
        'depends': ['ipConfigType==static'],
        'reboot': True,
        'get': _get_ip_settings,
        'set': _set_ip_settings,
        'get_set_dict': True,
    }


@additional_config
def ipConfigStaticMask():
    return {
        'label': 'Network Mask',
        'description': 'manually set your network mask',
        'type': 'str',
        'validate': '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$',
        'section': 'network',
        'advanced': True,
        'required': True,
        'depends': ['ipConfigType==static'],
        'reboot': True,
        'get': _get_ip_settings,
        'set': _set_ip_settings,
        'get_set_dict': True,
    }


@additional_config
def ipConfigStaticGw():
    return {
        'label': 'Default Gateway',
        'description': 'manually set your default gateway',
        'type': 'str',
        'validate': '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$',
        'section': 'network',
        'advanced': True,
        'required': True,
        'depends': ['ipConfigType==static'],
        'reboot': True,
        'get': _get_ip_settings,
        'set': _set_ip_settings,
        'get_set_dict': True,
    }


@additional_config
def ipConfigStaticDns():
    return {
        'label': 'DNS Server',
        'description': 'manually set your DNS server',
        'type': 'str',
        'validate': '^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$',
        'section': 'network',
        'advanced': True,
        'required': True,
        'depends': ['ipConfigType==static'],
        'reboot': True,
        'get': _get_ip_settings,
        'set': _set_ip_settings,
        'get_set_dict': True,
    }


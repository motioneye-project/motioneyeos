
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

from config import additional_config, additional_section


FTP_CONF = '/data/etc/proftpd.conf'
FTP_DISABLE_FILE = '/data/etc/no_S61proftpd'
SMB_CONF = '/data/etc/smb.conf'
SMB_DISABLE_FILE = '/data/etc/no_S62smb'
SSH_DISABLE_FILE = '/data/etc/no_S60sshd'


def _get_service_settings():
    ftp_enabled = True
    ftp_auth = True
    ftp_writable = False
    smb_enabled = True
    smb_auth = True
    smb_writable = False
    ssh_enabled = True

    # FTP
    if os.path.exists(FTP_DISABLE_FILE):
        ftp_enabled = False

    if os.path.exists(FTP_CONF):
        logging.debug('reading ftp settings from %s' % FTP_CONF)
        
        with open(FTP_CONF) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue

                if line == '<Anonymous ~ftp>':
                    ftp_auth = False

                elif line == 'AllowAll':
                    ftp_writable = True

    # SMB
    if os.path.exists(SMB_DISABLE_FILE):
        smb_enabled = False

    if os.path.exists(SMB_CONF):
        logging.debug('reading smb settings from %s' % SMB_CONF)
        
        with open(SMB_CONF) as f:
            for line in f:
                line = line.strip()
                if re.match('^\s*public\s*=\s*yes\s*$', line):
                    smb_auth = False

                elif re.match('^\s*writable\s*=\s*yes\s*$', line):
                    smb_writable = True

    # SSH
    if os.path.exists(SSH_DISABLE_FILE):
        ssh_enabled = False
        
    s = {
        'ftpEnabled': ftp_enabled,
        'ftpAuth': ftp_auth,
        'ftpWritable': ftp_writable,
        'smbEnabled': smb_enabled,
        'smbAuth': smb_auth,
        'smbWritable': smb_writable,
        'sshEnabled': ssh_enabled
    }

    logging.debug(('service settings: ftp=%(ftpEnabled)s, ftp_auth=%(ftpAuth)s, ftp_writable=%(ftpWritable)s, ' +
            'smb=%(smbEnabled)s, smb_auth=%(smbAuth)s, smb_writable=%(smbWritable)s, ' +
            'ssh=%(sshEnabled)s') % s)

    return s


def _set_service_settings(s):
    s.setdefault('ftpEnabled', True)
    s.setdefault('ftpAuth', True)
    s.setdefault('ftpWritable', False)
    s.setdefault('smbEnabled', True)
    s.setdefault('smbAuth', True)
    s.setdefault('smbWritable', False)
    s.setdefault('sshEnabled', True)

    logging.debug(('saving service settings: ftp=%(ftpEnabled)s, ftp_auth=%(ftpAuth)s, ftp_writable=%(ftpWritable)s, ' +
            'smb=%(smbEnabled)s, smb_auth=%(smbAuth)s, smb_writable=%(smbWritable)s, ' +
            'ssh=%(sshEnabled)s') % s)

    # FTP
    ftp_mode = 'off' if not s['ftpEnabled'] else ('public' if not s['ftpAuth'] else ('auth' if not s['ftpWritable'] else 'writable'))
    logging.debug('setting FTP mode: %s' % ftp_mode)
    if s['ftpEnabled']:
        try:
            os.remove(FTP_DISABLE_FILE)
        
        except:
            pass
    
    else:
        with open(FTP_DISABLE_FILE, 'w'):
            pass

    with open(FTP_CONF, 'w') as f:
        if s['ftpAuth']:
            if s['ftpWritable']:
                f.write('<Limit WRITE>\n')
                f.write(' AllowAll\n')
                f.write('</Limit>\n')

        else:
            f.write('<Anonymous ~ftp>\n')
            f.write(' User ftp\n')
            f.write(' Group nogroup\n')
            f.write(' UserAlias anonymous ftp\n')
            f.write(' MaxClients 4\n')
            f.write(' <Limit WRITE>\n')
            f.write('   DenyAll\n')
            f.write(' </Limit>\n')
            f.write('</Anonymous>\n')

    # SMB
    smb_mode = 'off' if not s['smbEnabled'] else ('public' if not s['smbAuth'] else ('auth' if not s['smbWritable'] else 'writable'))
    logging.debug('setting SMB mode: %s' % smb_mode)
    if s['smbEnabled']:
        try:
            os.remove(SMB_DISABLE_FILE)
        
        except:
            pass
    
    else:
        with open(SMB_DISABLE_FILE, 'w'):
            pass

    with open(SMB_CONF, 'w') as f:
        if s['smbAuth']:
            if s['smbWritable']:
                f.write('writable = yes\n')
                f.write('public = no\n')

        else:
            f.write('writable = no\n')
            f.write('public = yes\n')

    # SSH
    ssh_mode = 'off' if not s['sshEnabled'] else 'enabled'
    logging.debug('setting SSH mode: %s' % ssh_mode)
    if s['sshEnabled']:
        try:
            os.remove(SSH_DISABLE_FILE)
        
        except:
            pass
    
    else:
        with open(SSH_DISABLE_FILE, 'w'):
            pass


@additional_section
def services():
    return {
        'label': 'Services',
        'description': 'configure extra services (such as FTP or SSH)',
        'advanced': True
    }


@additional_config
def ftpEnabled():
    return {
        'label': 'Enable FTP Server',
        'description': 'enable this if you want to access the files on your motionEyeOS system using FTP',
        'type': 'bool',
        'section': 'services',
        'advanced': True,
        'reboot': True,
        'get': _get_service_settings,
        'set': _set_service_settings,
        'get_set_dict': True
    }


@additional_config
def ftpAuth():
    return {
        'label': 'Require FTP Authentication',
        'description': 'enable this if you want the FTP server to ask for credentials (i.e. to disable anonymous logins)',
        'type': 'bool',
        'section': 'services',
        'advanced': True,
        'reboot': True,
        'depends': ['ftpEnabled'],
        'get': _get_service_settings,
        'set': _set_service_settings,
        'get_set_dict': True
    }


@additional_config
def ftpWritable():
    return {
        'label': 'Enable FTP Write Support',
        'description': 'enable this if you want to allow creating, editing or removing files/directories through FTP (i.e. to disable read-only mode)',
        'type': 'bool',
        'section': 'services',
        'advanced': True,
        'reboot': True,
        'depends': ['ftpAuth', 'ftpEnabled'],
        'get': _get_service_settings,
        'set': _set_service_settings,
        'get_set_dict': True
    }


@additional_config
def ftpSeparator():
    return {
        'type': 'separator',
        'section': 'services',
        'advanced': True
    }


@additional_config
def smbEnabled():
    return {
        'label': 'Enable Samba Server',
        'description': 'enable this if you want files on your motionEyeOS system to be visible on the local network (using SMB protocol)',
        'type': 'bool',
        'section': 'services',
        'advanced': True,
        'reboot': True,
        'get': _get_service_settings,
        'set': _set_service_settings,
        'get_set_dict': True
    }


@additional_config
def smbAuth():
    return {
        'label': 'Require Samba Authentication',
        'description': 'enable this if you want the Samba server to ask for credentials (i.e. to disable guest access)',
        'type': 'bool',
        'section': 'services',
        'advanced': True,
        'reboot': True,
        'depends': ['smbEnabled'],
        'get': _get_service_settings,
        'set': _set_service_settings,
        'get_set_dict': True
    }


@additional_config
def smbWritable():
    return {
        'label': 'Enable Samba Write Support',
        'description': 'enable this if you want to allow creating, editing or removing files/directories on your motionEyeOS system from the local network',
        'type': 'bool',
        'section': 'services',
        'advanced': True,
        'reboot': True,
        'depends': ['smbAuth', 'smbEnabled'],
        'get': _get_service_settings,
        'set': _set_service_settings,
        'get_set_dict': True
    }


@additional_config
def smbSeparator():
    return {
        'type': 'separator',
        'section': 'services',
        'advanced': True
    }


@additional_config
def sshEnabled():
    return {
        'label': 'Enable SSH Server',
        'description': 'enable this if you want to login remotely on your motionEyeOS system using an SSH client (such as Putty)',
        'type': 'bool',
        'section': 'services',
        'advanced': True,
        'reboot': True,
        'get': _get_service_settings,
        'set': _set_service_settings,
        'get_set_dict': True
    }

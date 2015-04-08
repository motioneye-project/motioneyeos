## gen-manual-lists.py
##
## This script generates the following Buildroot manual appendices:
##  - the package tables (one for the target, the other for host tools);
##  - the deprecated items.
##
## Author(s):
##  - Samuel Martin <s.martin49@gmail.com>
##
## Copyright (C) 2013 Samuel Martin
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

## Note about python2.
##
## This script can currently only be run using python2 interpreter due to
## its kconfiglib dependency (which is not yet python3 friendly).

from __future__ import print_function
from __future__ import unicode_literals

import os
import re
import sys
import datetime
from argparse import ArgumentParser

try:
    import kconfiglib
except ImportError:
    message = """
Could not find the module 'kconfiglib' in the PYTHONPATH:
"""
    message += "\n".join(["  {0}".format(path) for path in sys.path])
    message += """

Make sure the Kconfiglib directory is in the PYTHONPATH, then relaunch the
script.

You can get kconfiglib from:
  https://github.com/ulfalizer/Kconfiglib


"""
    sys.stderr.write(message)
    raise


def get_symbol_subset(root, filter_func):
    """ Return a generator of kconfig items.

    :param root_item:   Root item of the generated subset of items
    :param filter_func: Filter function

    """
    if hasattr(root, "get_items"):
        get_items = root.get_items
    elif hasattr(root, "get_top_level_items"):
        get_items = root.get_top_level_items
    else:
        message = "The symbol does not contain any subset of symbols"
        raise Exception(message)
    for item in get_items():
        if item.is_symbol():
            if not filter_func(item):
                continue
            yield item
        elif item.is_menu() or item.is_choice():
            for i in get_symbol_subset(item, filter_func):
                yield i


def get_symbol_parents(item, root=None, enable_choice=False):
    """ Return the list of the item's parents. The last item of the list is
    the closest parent, the first the furthest.

    :param item:          Item from which the parent list is generated
    :param root:          Root item stopping the search (not included in the
                          parent list)
    :param enable_choice: Flag enabling choices to appear in the parent list

    """
    parent = item.get_parent()
    parents = []
    while parent and parent != root:
        if parent.is_menu():
            parents.append(parent.get_title())
        elif enable_choice and parent.is_choice():
            parents.append(parent.prompts[0][0])
        parent = parent.get_parent()
    if isinstance(root, kconfiglib.Menu) or \
            (enable_choice and isinstance(root, kconfiglib.Choice)):
        parents.append("") # Dummy empty parent to get a leading arrow ->
    parents.reverse()
    return parents


def format_asciidoc_table(root, get_label_func, filter_func=lambda x: True,
                          format_func=lambda x: x,
                          enable_choice=False, sorted=True,
                          item_label=None):
    """ Return the asciidoc formatted table of the items and their location.

    :param root:           Root item of the item subset
    :param get_label_func: Item's label getter function
    :param filter_func:    Filter function to apply on the item subset
    :param format_func:    Function to format a symbol and the table header
    :param enable_choice:  Enable choices to appear as part of the item's
                           location
    :param sorted:         Flag to alphabetically sort the table

    """

    lines = []
    for item in get_symbol_subset(root, filter_func):
        lines.append(format_func(what="symbol", symbol=item, root=root,
                                 get_label_func=get_label_func,
                                 enable_choice=enable_choice))
    if sorted:
        lines.sort(key=lambda x: x.lower())
    table = ":halign: center\n\n"
    width, columns = format_func(what="layout")
    table = "[width=\"{0}\",cols=\"{1}\",options=\"header\"]\n".format(width, columns)
    table += "|===================================================\n"
    table += format_func(what="header", header=item_label, root=root)
    table += "\n" + "".join(lines) + "\n"
    table += "|===================================================\n"
    return table


class Buildroot:
    """ Buildroot configuration object.

    """
    root_config = "Config.in"
    package_dirname = "package"
    package_prefixes = ["BR2_PACKAGE_", "BR2_PACKAGE_HOST_"]
    re_pkg_prefix = re.compile(r"^(" + "|".join(package_prefixes) + ").*")
    deprecated_symbol = "BR2_DEPRECATED"
    list_in = """\
//
// Automatically generated list for Buildroot manual.
//

{table}
"""

    list_info = {
        'target-packages': {
            'filename': "package-list",
            'root_menu': "Target packages",
            'filter': "_is_real_package",
            'format': "_format_symbol_prompt_location",
            'sorted': True,
        },
        'host-packages': {
            'filename': "host-package-list",
            'root_menu': "Host utilities",
            'filter': "_is_real_package",
            'format': "_format_symbol_prompt",
            'sorted': True,
        },
        'virtual-packages': {
            'filename': "virtual-package-list",
            'root_menu': "Target packages",
            'filter': "_is_virtual_package",
            'format': "_format_symbol_virtual",
            'sorted': True,
        },
        'deprecated': {
            'filename': "deprecated-list",
            'root_menu': None,
            'filter': "_is_deprecated",
            'format': "_format_symbol_prompt_location",
            'sorted': False,
        },
    }

    def __init__(self):
        self.base_dir = os.environ.get("TOPDIR")
        self.output_dir = os.environ.get("O")
        self.package_dir = os.path.join(self.base_dir, self.package_dirname)
        # The kconfiglib requires an environment variable named "srctree" to
        # load the configuration, so set it.
        os.environ.update({'srctree': self.base_dir})
        self.config = kconfiglib.Config(os.path.join(self.base_dir,
                                                     self.root_config))
        self._deprecated = self.config.get_symbol(self.deprecated_symbol)

        self.gen_date = datetime.datetime.utcnow()
        self.br_version_full = os.environ.get("BR2_VERSION_FULL")
        if self.br_version_full and self.br_version_full.endswith("-git"):
            self.br_version_full = self.br_version_full[:-4]
        if not self.br_version_full:
            self.br_version_full = "undefined"

    def _get_package_symbols(self, package_name):
        """ Return a tuple containing the target and host package symbol.

        """
        symbols = re.sub("[-+.]", "_", package_name)
        symbols = symbols.upper()
        symbols = tuple([prefix + symbols for prefix in self.package_prefixes])
        return symbols

    def _is_deprecated(self, symbol):
        """ Return True if the symbol is marked as deprecated, otherwise False.

        """
        # This also catches BR2_DEPRECATED_SINCE_xxxx_xx
        return bool([ symbol for x in symbol.get_referenced_symbols()
            if x.get_name().startswith(self._deprecated.get_name()) ])

    def _is_package(self, symbol, type='real'):
        """ Return True if the symbol is a package or a host package, otherwise
        False.

        :param symbol:  The symbol to check
        :param type:    Limit to 'real' or 'virtual' types of packages,
                        with 'real' being the default.
                        Note: only 'real' is (implictly) handled for now

        """
        if not symbol.is_symbol():
            return False
        if type == 'real' and not symbol.prompts:
            return False
        if type == 'virtual' and symbol.prompts:
            return False
        if not self.re_pkg_prefix.match(symbol.get_name()):
            return False
        pkg_name = self._get_pkg_name(symbol)

        pattern = "^(HOST_)?" + pkg_name + "$"
        pattern = re.sub("_", ".", pattern)
        pattern = re.compile(pattern, re.IGNORECASE)
        # Here, we cannot just check for the location of the Config.in because
        # of the "virtual" package.
        #
        # So, to check that a symbol is a package (not a package option or
        # anything else), we check for the existence of the package *.mk file.
        #
        # By the way, to actually check for a package, we should grep all *.mk
        # files for the following regex:
        # "\$\(eval \$\((host-)?(generic|autotools|cmake)-package\)\)"
        #
        # Implementation details:
        #
        # * The package list is generated from the *.mk file existence, the
        #   first time this function is called. Despite the memory consumption,
        #   this list is stored because the execution time of this script is
        #   noticeably shorter than rescanning the package sub-tree for each
        #   symbol.
        if not hasattr(self, "_package_list"):
            pkg_list = []
            for _, _, files in os.walk(self.package_dir):
                for file_ in (f for f in files if f.endswith(".mk")):
                    pkg_list.append(re.sub(r"(.*?)\.mk", r"\1", file_))
            setattr(self, "_package_list", pkg_list)
        for pkg in getattr(self, "_package_list"):
            if type == 'real':
                if pattern.match(pkg) and not self._exists_virt_symbol(pkg):
                    return True
            if type == 'virtual':
                if pattern.match('has_' + pkg):
                    return True
        return False

    def _is_real_package(self, symbol):
        return self._is_package(symbol, 'real')

    def _is_virtual_package(self, symbol):
        return self._is_package(symbol, 'virtual')

    def _exists_virt_symbol(self, pkg_name):
        """ Return True if a symbol exists that defines the package as
        a virtual package, False otherwise

        :param pkg_name:    The name of the package, for which to check if
                            a symbol exists defining it as a virtual package

        """
        virt_pattern = "BR2_PACKAGE_HAS_" + pkg_name + "$"
        virt_pattern = re.sub("_", ".", virt_pattern)
        virt_pattern = re.compile(virt_pattern, re.IGNORECASE)
        for sym in self.config:
            if virt_pattern.match(sym.get_name()):
                return True
        return False

    def _get_pkg_name(self, symbol):
        """ Return the package name of the specified symbol.

        :param symbol:      The symbol to get the package name of

        """

        return re.sub("BR2_PACKAGE_(HOST_)?(.*)", r"\2", symbol.get_name())

    def _get_symbol_label(self, symbol, mark_deprecated=True):
        """ Return the label (a.k.a. prompt text) of the symbol.

        :param symbol:          The symbol
        :param mark_deprecated: Append a 'deprecated' to the label

        """
        label = symbol.prompts[0][0]
        if self._is_deprecated(symbol) and mark_deprecated:
            label += " *(deprecated)*"
        return label

    def _format_symbol_prompt(self, what=None, symbol=None, root=None,
                                    enable_choice=False, header=None,
                                    get_label_func=lambda x: x):
        if what == "layout":
            return ( "30%", "^1" )

        if what == "header":
            return "| {0:<40}\n".format(header)

        if what == "symbol":
            return "| {0:<40}\n".format(get_label_func(symbol))

        message = "Invalid argument 'what': '%s'\n" % str(what)
        message += "Allowed values are: 'layout', 'header' and 'symbol'"
        raise Exception(message)

    def _format_symbol_prompt_location(self, what=None, symbol=None, root=None,
                                             enable_choice=False, header=None,
                                             get_label_func=lambda x: x):
        if what == "layout":
            return ( "100%", "^1,4" )

        if what == "header":
            if hasattr(root, "get_title"):
                loc_label = get_symbol_parents(root, None, enable_choice=enable_choice)
                loc_label += [root.get_title(), "..."]
            else:
                loc_label = ["Location"]
            return "| {0:<40} <| {1}\n".format(header, " -> ".join(loc_label))

        if what == "symbol":
            parents = get_symbol_parents(symbol, root, enable_choice)
            return "| {0:<40} <| {1}\n".format(get_label_func(symbol),
                                               " -> ".join(parents))

        message = "Invalid argument 'what': '%s'\n" % str(what)
        message += "Allowed values are: 'layout', 'header' and 'symbol'"
        raise Exception(message)

    def _format_symbol_virtual(self, what=None, symbol=None, root=None,
                                     enable_choice=False, header=None,
                                     get_label_func=lambda x: "?"):
        def _symbol_is_legacy(symbol):
            selects = [ s.get_name() for s in symbol.get_selected_symbols() ]
            return ("BR2_LEGACY" in selects)

        def _get_parent_package(sym):
            if self._is_real_package(sym):
                return None
            # Trim the symbol name from its last component (separated with
            # underscores), until we either find a symbol which is a real
            # package, or until we have no component (i.e. just 'BR2')
            name = sym.get_name()
            while name != "BR2":
                name = name.rsplit("_", 1)[0]
                s = self.config.get_symbol(name)
                if s is None:
                    continue
                if self._is_real_package(s):
                    return s
            return None

        def _get_providers(symbol):
            providers = list()
            for sym in self.config:
                if not sym.is_symbol():
                    continue
                if _symbol_is_legacy(sym):
                    continue
                selects = sym.get_selected_symbols()
                if not selects:
                    continue
                for s in selects:
                    if s == symbol:
                        if sym.prompts:
                            l = self._get_symbol_label(sym,False)
                            parent_pkg = _get_parent_package(sym)
                            if parent_pkg is not None:
                                l = self._get_symbol_label(parent_pkg, False) \
                                  + " (w/ " + l + ")"
                            providers.append(l)
                        else:
                            providers.extend(_get_providers(sym))
            return providers

        if what == "layout":
            return ( "100%", "^1,4,4" )

        if what == "header":
            return "| {0:<20} <| {1:<32} <| Providers\n".format("Virtual packages", "Symbols")

        if what == "symbol":
            pkg = re.sub(r"^BR2_PACKAGE_HAS_(.+)$", r"\1", symbol.get_name())
            providers = _get_providers(symbol)

            return "| {0:<20} <| {1:<32} <| {2}\n".format(pkg.lower(),
                                                          '+' + symbol.get_name() + '+',
                                                          ", ".join(providers))

        message = "Invalid argument 'what': '%s'\n" % str(what)
        message += "Allowed values are: 'layout', 'header' and 'symbol'"
        raise Exception(message)


    def print_list(self, list_type, enable_choice=True, enable_deprecated=True,
                   dry_run=False, output=None):
        """ Print the requested list. If not dry run, then the list is
        automatically written in its own file.

        :param list_type:         The list type to be generated
        :param enable_choice:     Flag enabling choices to appear in the list
        :param enable_deprecated: Flag enabling deprecated items to appear in
                                  the package lists
        :param dry_run:           Dry run (print the list in stdout instead of
                                  writing the list file

        """
        def _get_menu(title):
            """ Return the first symbol menu matching the given title.

            """
            menus = self.config.get_menus()
            menu = [m for m in menus if m.get_title().lower() == title.lower()]
            if not menu:
                message = "No such menu: '{0}'".format(title)
                raise Exception(message)
            return menu[0]

        list_config = self.list_info[list_type]
        root_title = list_config.get('root_menu')
        if root_title:
            root_item = _get_menu(root_title)
        else:
            root_item = self.config
        filter_ = getattr(self, list_config.get('filter'))
        filter_func = lambda x: filter_(x)
        format_func = getattr(self, list_config.get('format'))
        if not enable_deprecated and list_type != "deprecated":
            filter_func = lambda x: filter_(x) and not self._is_deprecated(x)
        mark_depr = list_type != "deprecated"
        get_label = lambda x: self._get_symbol_label(x, mark_depr)
        item_label = "Features" if list_type == "deprecated" else "Packages"

        table = format_asciidoc_table(root_item, get_label,
                                      filter_func=filter_func,
                                      format_func=format_func,
                                      enable_choice=enable_choice,
                                      sorted=list_config.get('sorted'),
                                      item_label=item_label)

        content = self.list_in.format(table=table)

        if dry_run:
            print(content)
            return

        if not output:
            output_dir = self.output_dir
            if not output_dir:
                print("Warning: Undefined output directory.")
                print("\tUse source directory as output location.")
                output_dir = self.base_dir
            output = os.path.join(output_dir,
                                  list_config.get('filename') + ".txt")
        if not os.path.exists(os.path.dirname(output)):
            os.makedirs(os.path.dirname(output))
        print("Writing the {0} list in:\n\t{1}".format(list_type, output))
        with open(output, 'w') as fout:
            fout.write(content)


if __name__ == '__main__':
    list_types = ['target-packages', 'host-packages', 'virtual-packages', 'deprecated']
    parser = ArgumentParser()
    parser.add_argument("list_type", nargs="?", choices=list_types,
                        help="""\
Generate the given list (generate all lists if unspecified)""")
    parser.add_argument("-n", "--dry-run", dest="dry_run", action='store_true',
                        help="Output the generated list to stdout")
    parser.add_argument("--output-target", dest="output_target",
                        help="Output target package file")
    parser.add_argument("--output-host", dest="output_host",
                        help="Output host package file")
    parser.add_argument("--output-virtual", dest="output_virtual",
                        help="Output virtual package file")
    parser.add_argument("--output-deprecated", dest="output_deprecated",
                        help="Output deprecated file")
    args = parser.parse_args()
    lists = [args.list_type] if args.list_type else list_types
    buildroot = Buildroot()
    for list_name in lists:
        output = getattr(args, "output_" + list_name.split("-", 1)[0])
        buildroot.print_list(list_name, dry_run=args.dry_run, output=output)

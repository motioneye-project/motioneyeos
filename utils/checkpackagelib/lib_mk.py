# See utils/checkpackagelib/readme.txt before editing this file.
# There are already dependency checks during the build, so below check
# functions don't need to check for things already checked by exploring the
# menu options using "make menuconfig" and by running "make" with appropriate
# packages enabled.

import re

from base import _CheckFunction
from lib import ConsecutiveEmptyLines  # noqa: F401
from lib import EmptyLastLine          # noqa: F401
from lib import NewlineAtEof           # noqa: F401
from lib import TrailingSpace          # noqa: F401


class Indent(_CheckFunction):
    COMMENT = re.compile("^\s*#")
    CONDITIONAL = re.compile("^\s*(ifeq|ifneq|endif)\s")
    ENDS_WITH_BACKSLASH = re.compile(r"^[^#].*\\$")
    END_DEFINE = re.compile("^\s*endef\s")
    MAKEFILE_TARGET = re.compile("^[^# \t]+:\s")
    START_DEFINE = re.compile("^\s*define\s")

    def before(self):
        self.define = False
        self.backslash = False
        self.makefile_target = False

    def check_line(self, lineno, text):
        if self.START_DEFINE.search(text):
            self.define = True
            return
        if self.END_DEFINE.search(text):
            self.define = False
            return

        expect_tabs = False
        if self.define or self.backslash or self.makefile_target:
            expect_tabs = True
        if self.CONDITIONAL.search(text):
            expect_tabs = False

        # calculate for next line
        if self.ENDS_WITH_BACKSLASH.search(text):
            self.backslash = True
        else:
            self.backslash = False

        if self.MAKEFILE_TARGET.search(text):
            self.makefile_target = True
            return
        if text.strip() == "":
            self.makefile_target = False
            return

        # comment can be indented or not inside define ... endef, so ignore it
        if self.define and self.COMMENT.search(text):
            return

        if expect_tabs:
            if not text.startswith("\t"):
                return ["{}:{}: expected indent with tabs"
                        .format(self.filename, lineno),
                        text]
        else:
            if text.startswith("\t"):
                return ["{}:{}: unexpected indent with tabs"
                        .format(self.filename, lineno),
                        text]


class PackageHeader(_CheckFunction):
    def before(self):
        self.skip = False

    def check_line(self, lineno, text):
        if self.skip or lineno > 6:
            return

        if lineno in [1, 5]:
            if lineno == 1 and text.startswith("include "):
                self.skip = True
                return
            if text.rstrip() != "#" * 80:
                return ["{}:{}: should be 80 hashes ({}#writing-rules-mk)"
                        .format(self.filename, lineno, self.url_to_manual),
                        text,
                        "#" * 80]
        elif lineno in [2, 4]:
            if text.rstrip() != "#":
                return ["{}:{}: should be 1 hash ({}#writing-rules-mk)"
                        .format(self.filename, lineno, self.url_to_manual),
                        text]
        elif lineno == 6:
            if text.rstrip() != "":
                return ["{}:{}: should be a blank line ({}#writing-rules-mk)"
                        .format(self.filename, lineno, self.url_to_manual),
                        text]


class RemoveDefaultPackageSourceVariable(_CheckFunction):
    packages_that_may_contain_default_source = ["binutils", "gcc", "gdb"]
    PACKAGE_NAME = re.compile("/([^/]+)\.mk")

    def before(self):
        package = self.PACKAGE_NAME.search(self.filename).group(1)
        package_upper = package.replace("-", "_").upper()
        self.package = package
        self.FIND_SOURCE = re.compile(
            "^{}_SOURCE\s*=\s*{}-\$\({}_VERSION\)\.tar\.gz"
            .format(package_upper, package, package_upper))

    def check_line(self, lineno, text):
        if self.FIND_SOURCE.search(text):

            if self.package in self.packages_that_may_contain_default_source:
                return

            return ["{}:{}: remove default value of _SOURCE variable "
                    "({}#generic-package-reference)"
                    .format(self.filename, lineno, self.url_to_manual),
                    text]


class SpaceBeforeBackslash(_CheckFunction):
    TAB_OR_MULTIPLE_SPACES_BEFORE_BACKSLASH = re.compile(r"^.*(  |\t ?)\\$")

    def check_line(self, lineno, text):
        if self.TAB_OR_MULTIPLE_SPACES_BEFORE_BACKSLASH.match(text.rstrip()):
            return ["{}:{}: use only one space before backslash"
                    .format(self.filename, lineno),
                    text]


class TrailingBackslash(_CheckFunction):
    ENDS_WITH_BACKSLASH = re.compile(r"^[^#].*\\$")

    def before(self):
        self.backslash = False

    def check_line(self, lineno, text):
        last_line_ends_in_backslash = self.backslash

        # calculate for next line
        if self.ENDS_WITH_BACKSLASH.search(text):
            self.backslash = True
            self.lastline = text
            return
        self.backslash = False

        if last_line_ends_in_backslash and text.strip() == "":
            return ["{}:{}: remove trailing backslash"
                    .format(self.filename, lineno - 1),
                    self.lastline]


class TypoInPackageVariable(_CheckFunction):
    ALLOWED = re.compile("|".join([
        "ACLOCAL_DIR",
        "ACLOCAL_HOST_DIR",
        "BR_CCACHE_INITIAL_SETUP",
        "BR_LIBC",
        "BR_NO_CHECK_HASH_FOR",
        "LINUX_EXTENSIONS",
        "LINUX_POST_PATCH_HOOKS",
        "LINUX_TOOLS",
        "LUA_RUN",
        "MKFS_JFFS2",
        "MKIMAGE_ARCH",
        "PACKAGES_PERMISSIONS_TABLE",
        "PKG_CONFIG_HOST_BINARY",
        "SUMTOOL",
        "TARGET_FINALIZE_HOOKS",
        "TARGETS_ROOTFS",
        "XTENSA_CORE_NAME"]))
    PACKAGE_NAME = re.compile("/([^/]+)\.mk")
    VARIABLE = re.compile("^([A-Z0-9_]+_[A-Z0-9_]+)\s*(\+|)=")

    def before(self):
        package = self.PACKAGE_NAME.search(self.filename).group(1)
        package = package.replace("-", "_").upper()
        # linux tools do not use LINUX_TOOL_ prefix for variables
        package = package.replace("LINUX_TOOL_", "")
        # linux extensions do not use LINUX_EXT_ prefix for variables
        package = package.replace("LINUX_EXT_", "")
        self.package = package
        self.REGEX = re.compile("^(HOST_|ROOTFS_)?({}_[A-Z0-9_]+)".format(package))
        self.FIND_VIRTUAL = re.compile(
            "^{}_PROVIDES\s*(\+|)=\s*(.*)".format(package))
        self.virtual = []

    def check_line(self, lineno, text):
        m = self.VARIABLE.search(text)
        if m is None:
            return

        variable = m.group(1)

        # allow to set variables for virtual package this package provides
        v = self.FIND_VIRTUAL.search(text)
        if v:
            self.virtual += v.group(2).upper().split()
            return
        for virtual in self.virtual:
            if variable.startswith("{}_".format(virtual)):
                return

        if self.ALLOWED.match(variable):
            return
        if self.REGEX.search(text) is None:
            return ["{}:{}: possible typo: {} -> *{}*"
                    .format(self.filename, lineno, variable, self.package),
                    text]


class UselessFlag(_CheckFunction):
    DEFAULT_AUTOTOOLS_FLAG = re.compile("^.*{}".format("|".join([
        "_AUTORECONF\s*=\s*NO",
        "_LIBTOOL_PATCH\s*=\s*YES"])))
    DEFAULT_GENERIC_FLAG = re.compile("^.*{}".format("|".join([
        "_INSTALL_IMAGES\s*=\s*NO",
        "_INSTALL_REDISTRIBUTE\s*=\s*YES",
        "_INSTALL_STAGING\s*=\s*NO",
        "_INSTALL_TARGET\s*=\s*YES"])))
    END_CONDITIONAL = re.compile("^\s*(endif)")
    START_CONDITIONAL = re.compile("^\s*(ifeq|ifneq)")

    def before(self):
        self.conditional = 0

    def check_line(self, lineno, text):
        if self.START_CONDITIONAL.search(text):
            self.conditional += 1
            return
        if self.END_CONDITIONAL.search(text):
            self.conditional -= 1
            return

        # allow non-default conditionally overridden by default
        if self.conditional > 0:
            return

        if self.DEFAULT_GENERIC_FLAG.search(text):
            return ["{}:{}: useless default value ({}#"
                    "_infrastructure_for_packages_with_specific_build_systems)"
                    .format(self.filename, lineno, self.url_to_manual),
                    text]

        if self.DEFAULT_AUTOTOOLS_FLAG.search(text) and not text.lstrip().startswith("HOST_"):
            return ["{}:{}: useless default value "
                    "({}#_infrastructure_for_autotools_based_packages)"
                    .format(self.filename, lineno, self.url_to_manual),
                    text]


class VariableWithBraces(_CheckFunction):
    VARIABLE_WITH_BRACES = re.compile(r"^[^#].*[^$]\${\w+}")

    def check_line(self, lineno, text):
        if self.VARIABLE_WITH_BRACES.match(text.rstrip()):
            return ["{}:{}: use $() to delimit variables, not ${{}}"
                    .format(self.filename, lineno),
                    text]

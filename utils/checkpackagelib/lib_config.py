# See utils/checkpackagelib/readme.txt before editing this file.
# Kconfig generates errors if someone introduces a typo like "boool" instead of
# "bool", so below check functions don't need to check for things already
# checked by running "make menuconfig".

import re

from base import _CheckFunction
from lib import ConsecutiveEmptyLines  # noqa: F401
from lib import EmptyLastLine          # noqa: F401
from lib import NewlineAtEof           # noqa: F401
from lib import TrailingSpace          # noqa: F401


def _empty_or_comment(text):
    line = text.strip()
    # ignore empty lines and comment lines indented or not
    return line == "" or line.startswith("#")


def _part_of_help_text(text):
    return text.startswith("\t  ")


# used in more than one check
entries_that_should_not_be_indented = [
    "choice", "comment", "config", "endchoice", "endif", "endmenu", "if",
    "menu", "menuconfig", "source"]


class AttributesOrder(_CheckFunction):
    attributes_order_convention = {
        "bool": 1, "prompt": 1, "string": 1, "default": 2, "depends": 3,
        "select": 4, "help": 5}

    def before(self):
        self.state = 0

    def check_line(self, lineno, text):
        if _empty_or_comment(text) or _part_of_help_text(text):
            return

        attribute = text.split()[0]

        if attribute in entries_that_should_not_be_indented:
            self.state = 0
            return
        if attribute not in self.attributes_order_convention.keys():
            return
        new_state = self.attributes_order_convention[attribute]
        wrong_order = self.state > new_state

        # save to process next line
        self.state = new_state

        if wrong_order:
            return ["{}:{}: attributes order: type, default, depends on,"
                    " select, help ({}#_config_files)"
                    .format(self.filename, lineno, self.url_to_manual),
                    text]


class HelpText(_CheckFunction):
    HELP_TEXT_FORMAT = re.compile("^\t  .{,62}$")
    URL_ONLY = re.compile("^(http|https|git)://\S*$")

    def before(self):
        self.help_text = False

    def check_line(self, lineno, text):
        if _empty_or_comment(text):
            return

        entry = text.split()[0]

        if entry in entries_that_should_not_be_indented:
            self.help_text = False
            return
        if text.strip() == "help":
            self.help_text = True
            return

        if not self.help_text:
            return

        if self.HELP_TEXT_FORMAT.match(text.rstrip()):
            return
        if self.URL_ONLY.match(text.strip()):
            return
        return ["{}:{}: help text: <tab><2 spaces><62 chars>"
                " ({}#writing-rules-config-in)"
                .format(self.filename, lineno, self.url_to_manual),
                text,
                "\t  " + "123456789 " * 6 + "12"]


class Indent(_CheckFunction):
    ENDS_WITH_BACKSLASH = re.compile(r"^[^#].*\\$")
    entries_that_should_be_indented = [
        "bool", "default", "depends", "help", "prompt", "select", "string"]

    def before(self):
        self.backslash = False

    def check_line(self, lineno, text):
        if _empty_or_comment(text) or _part_of_help_text(text):
            self.backslash = False
            return

        entry = text.split()[0]

        last_line_ends_in_backslash = self.backslash

        # calculate for next line
        if self.ENDS_WITH_BACKSLASH.search(text):
            self.backslash = True
        else:
            self.backslash = False

        if last_line_ends_in_backslash:
            if text.startswith("\t"):
                return
            return ["{}:{}: continuation line should be indented using tabs"
                    .format(self.filename, lineno),
                    text]

        if entry in self.entries_that_should_be_indented:
            if not text.startswith("\t{}".format(entry)):
                return ["{}:{}: should be indented with one tab"
                        " ({}#_config_files)"
                        .format(self.filename, lineno, self.url_to_manual),
                        text]
        elif entry in entries_that_should_not_be_indented:
            if not text.startswith(entry):
                return ["{}:{}: should not be indented"
                        .format(self.filename, lineno),
                        text]

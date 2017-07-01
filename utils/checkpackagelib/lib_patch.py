# See utils/checkpackagelib/readme.txt before editing this file.
# The format of the patch files is tested during the build, so below check
# functions don't need to check for things already checked by running
# "make package-dirclean package-patch".

import re

from base import _CheckFunction
# Notice: ignore 'imported but unused' from pyflakes for check functions.
from lib import NewlineAtEof


class ApplyOrder(_CheckFunction):
    APPLY_ORDER = re.compile("/\d{1,4}-[^/]*$")

    def before(self):
        if not self.APPLY_ORDER.search(self.filename):
            return ["{}:0: use name <number>-<description>.patch "
                    "({}#_providing_patches)"
                    .format(self.filename, self.url_to_manual)]


class NumberedSubject(_CheckFunction):
    NUMBERED_PATCH = re.compile("Subject:\s*\[PATCH\s*\d+/\d+\]")

    def before(self):
        self.git_patch = False
        self.lineno = 0
        self.text = None

    def check_line(self, lineno, text):
        if text.startswith("diff --git"):
            self.git_patch = True
            return
        if self.NUMBERED_PATCH.search(text):
            self.lineno = lineno
            self.text = text

    def after(self):
        if self.git_patch and self.text:
            return ["{}:{}: generate your patches with 'git format-patch -N'"
                    .format(self.filename, self.lineno),
                    self.text]


class Sob(_CheckFunction):
    SOB_ENTRY = re.compile("^Signed-off-by: .*$")

    def before(self):
        self.found = False

    def check_line(self, lineno, text):
        if self.found:
            return
        if self.SOB_ENTRY.search(text):
            self.found = True

    def after(self):
        if not self.found:
            return ["{}:0: missing Signed-off-by in the header "
                    "({}#_format_and_licensing_of_the_package_patches)"
                    .format(self.filename, self.url_to_manual)]

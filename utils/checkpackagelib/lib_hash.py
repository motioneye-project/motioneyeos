# See utils/checkpackagelib/readme.txt before editing this file.
# The validity of the hashes itself is checked when building, so below check
# functions don't need to check for things already checked by running
# "make package-dirclean package-source".

import re

from checkpackagelib.base import _CheckFunction
from checkpackagelib.lib import ConsecutiveEmptyLines  # noqa: F401
from checkpackagelib.lib import EmptyLastLine          # noqa: F401
from checkpackagelib.lib import NewlineAtEof           # noqa: F401
from checkpackagelib.lib import TrailingSpace          # noqa: F401


def _empty_line_or_comment(text):
    return text.strip() == "" or text.startswith("#")


class HashNumberOfFields(_CheckFunction):
    def check_line(self, lineno, text):
        if _empty_line_or_comment(text):
            return

        fields = text.split()
        if len(fields) != 3:
            return ["{}:{}: expected three fields ({}#adding-packages-hash)"
                    .format(self.filename, lineno, self.url_to_manual),
                    text]


class HashType(_CheckFunction):
    len_of_hash = {"md5": 32, "sha1": 40, "sha224": 56, "sha256": 64,
                   "sha384": 96, "sha512": 128}

    def check_line(self, lineno, text):
        if _empty_line_or_comment(text):
            return

        fields = text.split()
        if len(fields) < 2:
            return

        htype, hexa = fields[:2]
        if htype == "none":
            return
        if htype not in self.len_of_hash.keys():
            return ["{}:{}: unexpected type of hash ({}#adding-packages-hash)"
                    .format(self.filename, lineno, self.url_to_manual),
                    text]
        if not re.match("^[0-9A-Fa-f]{%s}$" % self.len_of_hash[htype], hexa):
            return ["{}:{}: hash size does not match type "
                    "({}#adding-packages-hash)"
                    .format(self.filename, lineno, self.url_to_manual),
                    text,
                    "expected {} hex digits".format(self.len_of_hash[htype])]

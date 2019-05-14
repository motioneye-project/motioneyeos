# See utils/checkpackagelib/readme.txt before editing this file.
import re


class _CheckFunction(object):
    def __init__(self, filename, url_to_manual):
        self.filename = filename
        self.url_to_manual = url_to_manual
        self.disable = re.compile(r"^\s*# check-package .*\b{}\b".format(self.__class__.__name__))

    def before(self):
        pass

    def check_line(self, lineno, text):
        pass

    def after(self):
        pass

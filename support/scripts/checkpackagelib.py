# See support/scripts/check-package.txt before editing this file.

from checkpackagebase import _CheckFunction


class NewlineAtEof(_CheckFunction):
    def before(self):
        self.lastlineno = 0
        self.lastline = "\n"

    def check_line(self, lineno, text):
        self.lastlineno = lineno
        self.lastline = text

    def after(self):
        if self.lastline == self.lastline.rstrip("\r\n"):
            return ["{}:{}: missing newline at end of file"
                    .format(self.filename, self.lastlineno),
                    self.lastline]

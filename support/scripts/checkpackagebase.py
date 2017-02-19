# See support/scripts/check-package.txt before editing this file.


class _CheckFunction(object):
    def __init__(self, filename, url_to_manual):
        self.filename = filename
        self.url_to_manual = url_to_manual

    def before(self):
        pass

    def check_line(self, lineno, text):
        pass

    def after(self):
        pass

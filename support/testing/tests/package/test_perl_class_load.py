from tests.package.test_perl import TestPerlBase


class TestPerlClassLoad(TestPerlBase):
    """
    package:
        Class-Load
    direct dependencies:
        Data-OptList
        Module-Implementation
        Module-Runtime
        Package-Stash
        Try-Tiny
    indirect dependencies:
        Dist-CheckConflicts
        Params-Util   XS
        Sub-Install
    """

    config = TestPerlBase.config + \
        """
        BR2_PACKAGE_PERL=y
        BR2_PACKAGE_PERL_CLASS_LOAD=y
        """

    def test_run(self):
        self.login()
        self.module_test("Class::Load")

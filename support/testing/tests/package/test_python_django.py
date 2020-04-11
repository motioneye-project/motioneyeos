from tests.package.test_python import TestPythonPackageBase


class TestPythonDjango(TestPythonPackageBase):
    config = TestPythonPackageBase.config
    sample_scripts = ["tests/package/sample_python_django.py"]

    def run_sample_scripts(self):
        timeout = 35 * self.emulator.timeout_multiplier

        cmd = "cd /opt && /usr/bin/django-admin startproject testsite"
        self.assertRunOk(cmd, timeout=timeout)

        cmd = "cd /opt/testsite && " + self.interpreter + " ./manage.py migrate"
        output, exit_code = self.emulator.run(cmd, timeout=timeout)
        self.assertIn("Operations to perform:", output[0])
        self.assertEqual(exit_code, 0)

        cmd = "cd /opt/testsite && " + self.interpreter + " ./manage.py runserver 0.0.0.0:1234 & "
        # give some time to setup the server
        cmd += "sleep {}".format(str(30 * self.emulator.timeout_multiplier))
        self.assertRunOk(cmd, timeout=timeout)

        cmd = "netstat -ltn 2>/dev/null | grep 0.0.0.0:1234"
        self.assertRunOk(cmd)


class TestPythonPy3Django(TestPythonDjango):
    __test__ = True
    config = TestPythonDjango.config + \
        """
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_DJANGO=y
        BR2_PACKAGE_PYTHON3_SQLITE=y
        """

"""Test cases for utils/check-package.

It does not inherit from infra.basetest.BRTest and therefore does not generate
a logfile. Only when the tests fail there will be output to the console.

The make target ('make check-package') is already used by the job
'check-package' and won't be tested here.
"""
import os
import subprocess
import unittest

import infra


def call_script(args, env, cwd):
    """Call a script and return stdout and stderr as lists."""
    out, err = subprocess.Popen(args, cwd=cwd, stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE, env=env,
                                universal_newlines=True).communicate()
    return out.splitlines(), err.splitlines()


class TestCheckPackage(unittest.TestCase):
    """Test the various ways the script can be called.

    The script can be called either using relative path, absolute path or from
    PATH.

    The files to be checked can be passed as arguments using either relative
    path or absolute path.

    When in in-tree mode (without -b) some in-tree files and also all
    out-of-tree files are ignored.

    When in out-tree mode (with -b) the script does generate warnings for these
    but ignores external.mk.
    """

    WITH_EMPTY_PATH = {}
    WITH_UTILS_IN_PATH = {"PATH": infra.basepath("utils") + ":" + os.environ["PATH"]}
    relative = [
        # base_script           base_file               rel_script               rel_file                rel_cwd
        ["utils/check-package", "package/atop/atop.mk", "./utils/check-package", "package/atop/atop.mk", ""],
        ["utils/check-package", "package/atop/atop.mk", "./utils/check-package", "./package/atop/atop.mk", ""],
        ["utils/check-package", "package/atop/atop.mk", "../../utils/check-package", "atop.mk", "package/atop"],
        ["utils/check-package", "package/atop/atop.mk", "../../utils/check-package", "./atop.mk", "package/atop"],
        ["utils/check-package", "package/atop/atop.mk", "../utils/check-package", "atop/atop.mk", "package"],
        ["utils/check-package", "package/atop/atop.mk", "../utils/check-package", "./atop/atop.mk", "package"],
        ["utils/check-package", "package/atop/Config.in", "./utils/check-package", "package/atop/Config.in", ""],
        ["utils/check-package", "package/atop/Config.in", "./utils/check-package", "./package/atop/Config.in", ""],
        ["utils/check-package", "package/atop/Config.in", "../../utils/check-package", "Config.in", "package/atop"],
        ["utils/check-package", "package/atop/Config.in", "../../utils/check-package", "./Config.in", "package/atop"],
        ["utils/check-package", "package/atop/Config.in", "../utils/check-package", "atop/Config.in", "package"],
        ["utils/check-package", "package/atop/Config.in", "../utils/check-package", "./atop/Config.in", "package"]]

    def assert_file_was_processed(self, stderr):
        """Infer from check-package stderr if at least one file was processed
        and fail otherwise."""
        self.assertIn("lines processed", stderr[0], stderr)
        processed = int(stderr[0].split()[0])
        self.assertGreater(processed, 0)

    def assert_file_was_ignored(self, stderr):
        """Infer from check-package stderr if no file was processed and fail
        otherwise."""
        self.assertIn("lines processed", stderr[0], stderr)
        processed = int(stderr[0].split()[0])
        self.assertEqual(processed, 0)

    def assert_warnings_generated_for_file(self, stderr):
        """Infer from check-package stderr if at least one warning was generated
        and fail otherwise."""
        self.assertIn("warnings generated", stderr[1], stderr)
        generated = int(stderr[1].split()[0])
        self.assertGreater(generated, 0)

    def test_run(self):
        """Test the various ways the script can be called in a simple top to
        bottom sequence."""
        # an intree file can be checked by the script called from relative path,
        # absolute path and from PATH
        for base_script, base_file, rel_script, rel_file, rel_cwd in self.relative:
            abs_script = infra.basepath(base_script)
            abs_file = infra.basepath(base_file)
            cwd = infra.basepath(rel_cwd)

            _, m = call_script([rel_script, rel_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script([abs_script, rel_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script(["check-package", rel_file],
                               self.WITH_UTILS_IN_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script([rel_script, abs_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script([abs_script, abs_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script(["check-package", abs_file],
                               self.WITH_UTILS_IN_PATH, cwd)
            self.assert_file_was_processed(m)

        # some intree files are ignored
        _, m = call_script(["./utils/check-package", "package/pkg-generic.mk"],
                           self.WITH_EMPTY_PATH, infra.basepath())
        self.assert_file_was_ignored(m)

        _, m = call_script(["./utils/check-package", "-b", "package/pkg-generic.mk"],
                           self.WITH_EMPTY_PATH, infra.basepath())
        self.assert_file_was_processed(m)

        # an out-of-tree file can be checked by the script called from relative
        # path, absolute path and from PATH
        for base_script, base_file, rel_script, rel_file, rel_cwd in self.relative:
            abs_script = infra.basepath(base_script)
            abs_file = infra.basepath(base_file)
            cwd = infra.basepath(rel_cwd)

            _, m = call_script([rel_script, "-b", rel_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script([abs_script, "-b", rel_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script(["check-package", "-b", rel_file],
                               self.WITH_UTILS_IN_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script([rel_script, "-b", abs_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script([abs_script, "-b", abs_file],
                               self.WITH_EMPTY_PATH, cwd)
            self.assert_file_was_processed(m)

            _, m = call_script(["check-package", "-b", abs_file],
                               self.WITH_UTILS_IN_PATH, cwd)
            self.assert_file_was_processed(m)

        # out-of-tree files are are ignored without -b but can generate warnings
        # with -b
        abs_path = infra.filepath("tests/utils/br2-external")
        rel_file = "Config.in"
        abs_file = os.path.join(abs_path, rel_file)

        _, m = call_script(["check-package", rel_file],
                           self.WITH_UTILS_IN_PATH, abs_path)
        self.assert_file_was_ignored(m)

        _, m = call_script(["check-package", abs_file],
                           self.WITH_UTILS_IN_PATH, infra.basepath())
        self.assert_file_was_ignored(m)

        w, m = call_script(["check-package", "-b", rel_file],
                           self.WITH_UTILS_IN_PATH, abs_path)
        self.assert_file_was_processed(m)
        self.assert_warnings_generated_for_file(m)
        self.assertIn("{}:1: empty line at end of file".format(rel_file), w)

        w, m = call_script(["check-package", "-b", abs_file],
                           self.WITH_UTILS_IN_PATH, infra.basepath())
        self.assert_file_was_processed(m)
        self.assert_warnings_generated_for_file(m)
        self.assertIn("{}:1: empty line at end of file".format(abs_file), w)

        # external.mk is ignored only when in the root path of a br2-external
        rel_file = "external.mk"
        abs_file = os.path.join(abs_path, rel_file)

        _, m = call_script(["check-package", "-b", rel_file],
                           self.WITH_UTILS_IN_PATH, abs_path)
        self.assert_file_was_ignored(m)

        _, m = call_script(["check-package", "-b", abs_file],
                           self.WITH_UTILS_IN_PATH, infra.basepath())
        self.assert_file_was_ignored(m)

        abs_path = infra.filepath("tests/utils/br2-external/package/external")
        abs_file = os.path.join(abs_path, rel_file)

        w, m = call_script(["check-package", "-b", rel_file],
                           self.WITH_UTILS_IN_PATH, abs_path)
        self.assert_file_was_processed(m)
        self.assert_warnings_generated_for_file(m)
        self.assertIn("{}:1: should be 80 hashes (http://nightly.buildroot.org/#writing-rules-mk)".format(rel_file), w)

        w, m = call_script(["check-package", "-b", abs_file],
                           self.WITH_UTILS_IN_PATH, infra.basepath())
        self.assert_file_was_processed(m)
        self.assert_warnings_generated_for_file(m)
        self.assertIn("{}:1: should be 80 hashes (http://nightly.buildroot.org/#writing-rules-mk)".format(abs_file), w)

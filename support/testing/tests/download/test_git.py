import os

from gitremote import GitRemote

import infra


class GitTestBase(infra.basetest.BRTest):
    config = \
        """
        BR2_BACKUP_SITE=""
        """
    gitremotedir = infra.filepath("tests/download/git-remote")
    gitremote = None

    def setUp(self):
        super(GitTestBase, self).setUp()
        self.gitremote = GitRemote(self.builddir, self.gitremotedir, self.logtofile)

    def tearDown(self):
        self.show_msg("Cleaning up")
        if self.gitremote:
            self.gitremote.stop()
        if self.b and not self.keepbuilds:
            self.b.delete()

    def check_hash(self, package):
        # store downloaded tarball inside the output dir so the test infra
        # cleans it up at the end
        env = {"BR2_DL_DIR": os.path.join(self.builddir, "dl"),
               "GITREMOTE_PORT_NUMBER": str(self.gitremote.port)}
        self.b.build(["{}-dirclean".format(package),
                      "{}-source".format(package)],
                     env)


class TestGitHash(GitTestBase):
    br2_external = [infra.filepath("tests/download/br2-external/git-hash")]

    def test_run(self):
        with self.assertRaises(SystemError):
            self.check_hash("bad")
        self.check_hash("good")
        self.check_hash("nohash")

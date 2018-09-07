import os
import shutil
import subprocess

import infra


class Builder(object):
    def __init__(self, config, builddir, logtofile):
        self.config = '\n'.join([line.lstrip() for line in
                                 config.splitlines()]) + '\n'
        self.builddir = builddir
        self.logfile = infra.open_log_file(builddir, "build", logtofile)

    def configure(self):
        if not os.path.isdir(self.builddir):
            os.makedirs(self.builddir)

        config_file = os.path.join(self.builddir, ".config")
        with open(config_file, "w+") as cf:
            cf.write(self.config)
        # dump the defconfig to the logfile for easy debugging
        self.logfile.write("> start defconfig\n" + self.config +
                           "> end defconfig\n")
        self.logfile.flush()

        env = {"PATH": os.environ["PATH"]}
        cmd = ["make",
               "O={}".format(self.builddir),
               "olddefconfig"]
        ret = subprocess.call(cmd, stdout=self.logfile, stderr=self.logfile,
                              env=env)
        if ret != 0:
            raise SystemError("Cannot olddefconfig")

    def build(self):
        env = {"PATH": os.environ["PATH"]}
        if "http_proxy" in os.environ:
            self.logfile.write("Using system proxy: " +
                               os.environ["http_proxy"] + "\n")
            env['http_proxy'] = os.environ["http_proxy"]
            env['https_proxy'] = os.environ["http_proxy"]
        cmd = ["make", "-C", self.builddir]
        ret = subprocess.call(cmd, stdout=self.logfile, stderr=self.logfile,
                              env=env)
        if ret != 0:
            raise SystemError("Build failed")

        open(self.stamp_path(), 'a').close()

    def stamp_path(self):
        return os.path.join(self.builddir, "build-done")

    def is_finished(self):
        return os.path.exists(self.stamp_path())

    def delete(self):
        if os.path.exists(self.builddir):
            shutil.rmtree(self.builddir)

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

    def configure(self, make_extra_opts=[], make_extra_env={}):
        """Configure the build.

        make_extra_opts: a list of arguments to be passed to the make
        command.
        e.g. make_extra_opts=["BR2_EXTERNAL=/path"]

        make_extra_env: a dict of variables to be appended (or replaced)
        in the environment that calls make.
        e.g. make_extra_env={"BR2_DL_DIR": "/path"}
        """
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
        env.update(make_extra_env)

        cmd = ["make",
               "O={}".format(self.builddir)]
        cmd += make_extra_opts
        cmd += ["olddefconfig"]

        ret = subprocess.call(cmd, stdout=self.logfile, stderr=self.logfile,
                              env=env)
        if ret != 0:
            raise SystemError("Cannot olddefconfig")

    def build(self, make_extra_opts=[], make_extra_env={}):
        """Perform the build.

        make_extra_opts: a list of arguments to be passed to the make
        command. It can include a make target.
        e.g. make_extra_opts=["foo-source"]

        make_extra_env: a dict of variables to be appended (or replaced)
        in the environment that calls make.
        e.g. make_extra_env={"BR2_DL_DIR": "/path"}
        """
        env = {"PATH": os.environ["PATH"]}
        if "http_proxy" in os.environ:
            self.logfile.write("Using system proxy: " +
                               os.environ["http_proxy"] + "\n")
            env['http_proxy'] = os.environ["http_proxy"]
            env['https_proxy'] = os.environ["http_proxy"]
        env.update(make_extra_env)

        cmd = ["make", "-C", self.builddir]
        cmd += make_extra_opts

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

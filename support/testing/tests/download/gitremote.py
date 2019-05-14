# subprocess does not kill the child daemon when a test case fails by raising
# an exception. So use pexpect instead.
import infra

import pexpect


GIT_REMOTE_PORT_INITIAL = 9418
GIT_REMOTE_PORT_LAST = GIT_REMOTE_PORT_INITIAL + 99


class GitRemote(object):
    def __init__(self, builddir, serveddir, logtofile):
        """
        Start a local git server.

        In order to support test cases in parallel, select the port the
        server will listen to in runtime. Since there is no reliable way
        to allocate the port prior to starting the server (another
        process in the host machine can use the port between it is
        selected from a list and it is really allocated to the server)
        try to start the server in a port and in the case it is already
        in use, try the next one in the allowed range.
        """
        self.daemon = None
        self.port = None
        self.logfile = infra.open_log_file(builddir, "gitremote", logtofile)

        daemon_cmd = ["git", "daemon", "--reuseaddr", "--verbose",
                      "--listen=localhost", "--export-all",
                      "--base-path={}".format(serveddir)]
        for port in range(GIT_REMOTE_PORT_INITIAL, GIT_REMOTE_PORT_LAST + 1):
            cmd = daemon_cmd + ["--port={port}".format(port=port)]
            self.logfile.write("> starting git remote with '{}'\n".format(" ".join(cmd)))
            self.daemon = pexpect.spawn(cmd[0], cmd[1:], logfile=self.logfile)
            ret = self.daemon.expect(["Ready to rumble",
                                      "Address already in use"])
            if ret == 0:
                self.port = port
                return
        raise SystemError("Could not find a free port to run git remote")

    def stop(self):
        if self.daemon is None:
            return
        self.daemon.terminate(force=True)

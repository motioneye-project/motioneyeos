from twisted.internet import reactor
import treq


def done(response):
    print(response.code)
    reactor.stop()


def err(fail):
    print(fail.value)
    reactor.stop()


treq.get("https://localhost").addCallback(done).addErrback(err)
reactor.run()

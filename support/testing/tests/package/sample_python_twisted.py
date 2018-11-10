from twisted.internet import protocol, reactor, endpoints


class F(protocol.Factory):
    pass


endpoints.serverFromString(reactor, "tcp:1234").listen(F())
reactor.run()

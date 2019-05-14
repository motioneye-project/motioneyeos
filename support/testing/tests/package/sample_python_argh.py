import argh


@argh.arg("foo", help="help for foo")
@argh.arg("--bar", help="help for bar")
def main(foo, bar=False):
    print("{}, {}".format(foo, bar))


argh.dispatch_command(main)

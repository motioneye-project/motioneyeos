import click


@click.command()
@click.argument("foo")
@click.option("--bar", is_flag=True, help="help for bar")
def main(foo, bar):
    click.echo("{}, {}".format(foo, bar))


if __name__ == '__main__':
    main()

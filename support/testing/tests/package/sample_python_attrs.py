import attr


@attr.s
class Obj(object):
    x = attr.ib()
    y = attr.ib(default=1)


obj1 = Obj(2)
assert(obj1.x == 2)
assert(obj1.y == 1)
obj2 = Obj(3, 4)
assert(obj2.x == 3)
assert(obj2.y == 4)

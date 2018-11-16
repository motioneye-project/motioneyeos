from constantly import ValueConstant, Values


class RESULT(Values):
    OK = ValueConstant(0)
    FAIL = ValueConstant(-1)

    @classmethod
    def get(cls, rc):
        if rc == 0:
            return cls.OK
        else:
            return cls.FAIL


print(list(RESULT.iterconstants()))
assert(RESULT.OK < RESULT.FAIL)
assert(RESULT.OK.value > RESULT.FAIL.value)
assert(RESULT.get(-5) == RESULT.FAIL)

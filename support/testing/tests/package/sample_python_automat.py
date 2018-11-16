from automat import MethodicalMachine


class Led(object):
    _machine = MethodicalMachine()

    @_machine.state()
    def led_on(self):
        "led is on"

    @_machine.state(initial=True)
    def led_off(self):
        "led is off"

    @_machine.input()
    def turn_on(self):
        "turn the led on"

    @_machine.output()
    def _light(self):
        print("light")

    led_off.upon(turn_on, enter=led_on, outputs=[_light])


led = Led()
led.turn_on()

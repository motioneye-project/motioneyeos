# when leaving the console clear the screen to increase privacy

case "`tty`" in
    /dev/tty[0-9]*) clear
esac


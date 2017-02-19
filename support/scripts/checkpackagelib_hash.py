# See support/scripts/check-package.txt before editing this file.
# The validity of the hashes itself is checked when building, so below check
# functions don't need to check for things already checked by running
# "make package-dirclean package-source".

# Notice: ignore 'imported but unused' from pyflakes for check functions.
from checkpackagelib import ConsecutiveEmptyLines
from checkpackagelib import EmptyLastLine
from checkpackagelib import NewlineAtEof
from checkpackagelib import TrailingSpace

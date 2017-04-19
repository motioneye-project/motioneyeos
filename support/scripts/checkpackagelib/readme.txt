How the scripts are structured:
- check-package is the main engine, called by the user.
  For each input file, this script decides which parser should be used and it
  collects all classes declared in the library file and instantiates them.
  The main engine opens the input files and it serves each raw line (including
  newline!) to the method check_line() of every check object.
  Two special methods before() and after() are used to call the initialization
  of variables (for the case it needs to keep data across calls) and the
  equivalent finalization (e.g. for the case a warning must be issued if some
  pattern is not in the input file).
- base.py contains the base class for all check functions.
- lib.py contains the classes for common check functions.
  Each check function is explicitly included in a given type-parsing library.
  Do not include every single check function in this file, a class that will
  only parse hash files should be implemented in the hash-parsing library.
  When a warning must be issued, the check function returns an array of strings.
  Each string is a warning message and is displayed if the corresponding verbose
  level is active. When the script is called without --verbose only the first
  warning in the returned array is printed; when called with --verbose both
  first and second warnings are printed; when called with -vv until the third
  warning is printed; an so on.
  Helper functions can be defined and will not be called by the main script.
- lib_type.py contains check functions specific to files of this type.

Some hints when changing this code:
- prefer O(n) algorithms, where n is the total number of lines in the files
  processed.
- when there is no other reason for ordering, use alphabetical order (e.g. keep
  the check functions in alphabetical order, keep the imports in alphabetical
  order, and so on).
- use pyflakes to detect and fix potential problems.
- use pep8 formatting.
- keep in mind that for every class the method before() will be called before
  any line is served to be checked by the method check_line(). A class that
  checks the filename should only implement the method before(). A function that
  needs to keep data across calls (e.g. keep the last line before the one being
  processed) should initialize all variables using this method.
- keep in mind that for every class the method after() will be called after all
  lines were served to be checked by the method check_line(). A class that
  checks the absence of a pattern in the file will need to use this method.
- try to avoid false warnings. It's better to not issue a warning message to a
  corner case than have too many false warnings. The second can make users stop
  using the script.
- do not check spacing in the input line in every single function. Trailing
  whitespace and wrong indentation should be checked by separate functions.
- avoid duplicate tests. Try to test only one thing in each function.
- in the warning message, include the url to a section from the manual, when
  applicable. It potentially will make more people know the manual.
- use short sentences in the warning messages. A complete explanation can be
  added to show when --verbose is used.
- when testing, verify the error message is displayed when the error pattern is
  found, but also verify the error message is not displayed for few
  well-formatted packages... there are many of these, just pick your favorite
  as golden package that should not trigger any warning message.
- check the url displayed by the warning message works.

Usage examples:
- to get a list of check functions that would be called without actually
  calling them you can use the --dry-run option:
$ support/scripts/check-package --dry-run package/yourfavorite/*

- when you just added a new check function, e.g. Something, check how it behaves
  for all current packages:
$ support/scripts/check-package --include-only Something $(find package -type f)

- the effective processing time (when the .pyc were already generated and all
  files to be processed are cached in the RAM) should stay in the order of few
  seconds:
$ support/scripts/check-package $(find package -type f) >/dev/null ; \
  time support/scripts/check-package $(find package -type f) >/dev/null

- vim users can navigate the warnings (most editors probably have similar
  function) since warnings are generated in the form 'path/file:line: warning':
$ find package/ -name 'Config.*' > filelist && vim -c \
  'set makeprg=support/scripts/check-package\ $(cat\ filelist)' -c make -c copen

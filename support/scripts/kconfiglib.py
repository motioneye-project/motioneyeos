# This is Kconfiglib, a Python library for scripting, debugging, and extracting
# information from Kconfig-based configuration systems. To view the
# documentation, run
#
#  $ pydoc kconfiglib
#
# or, if you prefer HTML,
#
#  $ pydoc -w kconfiglib
#
# The examples/ subdirectory contains examples, to be run with e.g.
#
#  $ make scriptconfig SCRIPT=Kconfiglib/examples/print_tree.py
#
# Look in testsuite.py for the test suite.

"""
Kconfiglib is a Python library for scripting and extracting information from
Kconfig-based configuration systems. Features include the following:

 - Symbol values and properties can be looked up and values assigned
   programmatically.
 - .config files can be read and written.
 - Expressions can be evaluated in the context of a Kconfig configuration.
 - Relations between symbols can be quickly determined, such as finding all
   symbols that reference a particular symbol.
 - Highly compatible with the scripts/kconfig/*conf utilities. The test suite
   automatically compares outputs between Kconfiglib and the C implementation
   for a large number of cases.

For the Linux kernel, scripts are run using

 $ make scriptconfig SCRIPT=<path to script> [SCRIPT_ARG=<arg>]

Running scripts via the 'scriptconfig' target ensures that required environment
variables (SRCARCH, ARCH, srctree, KERNELVERSION, etc.) are set up correctly.
Alternative architectures can be specified like for other 'make *config'
targets:

 $ make scriptconfig ARCH=mips SCRIPT=<path to script> [SCRIPT_ARG=<arg>]

The script will receive the name of the Kconfig file to load in sys.argv[1].
(As of Linux 3.7.0-rc8 this is always "Kconfig" from the kernel top-level
directory.) If an argument is provided with SCRIPT_ARG, it will appear in
sys.argv[2].

To get an interactive Python prompt with Kconfiglib preloaded and a Config
object 'c' created, use

 $ make iscriptconfig [ARCH=<architecture>]

Kconfiglib requires Python 2. For (i)scriptconfig the command to run the Python
interpreter can be passed in the environment variable PYTHONCMD (defaults to
'python'; PyPy works too and is a bit faster).

Look in the examples/ subdirectory for examples, which can be run with e.g.

 $ make scriptconfig SCRIPT=Kconfiglib/examples/print_tree.py

or

 $ make scriptconfig SCRIPT=Kconfiglib/examples/help_grep.py SCRIPT_ARG="kernel"

Look in testsuite.py for the test suite.

Credits: Written by Ulf "Ulfalizer" Magnusson

Send bug reports, suggestions and other feedback to kconfiglib@gmail.com .
Don't wrestle with internal APIs. Tell me what you need and I might add it in a
safe way as a client API instead."""

# If you have Psyco installed (32-bit installations, Python <= 2.6 only),
# setting this to True (right here, not at runtime) might give a nice speedup.
# (22% faster for parsing arch/x86/Kconfig and 58% faster for evaluating all
# symbols in it without a .config on my Core Duo.)
use_psyco = False

import os
import re
import string
import sys

class Config():

    """Represents a Kconfig configuration, e.g. for i386 or ARM. This is the
    set of symbols and other items appearing in the configuration together with
    their values. Creating any number of Config objects -- including for
    different architectures -- is safe; Kconfiglib has no global state."""

    #
    # Public interface
    #

    def __init__(self,
                 filename = "Kconfig",
                 base_dir = "$srctree",
                 print_warnings = True,
                 print_undef_assign = False):
        """Creates a new Config object, representing a Kconfig configuration.
        Raises Kconfig_Syntax_Error on syntax errors.

        filename (default: "Kconfig") -- The base Kconfig file of the
                 configuration. For the Linux kernel, this should usually be be
                 "Kconfig" from the top-level directory, as environment
                 variables will make sure the right Kconfig is included from
                 there (usually arch/<architecture>/Kconfig). If you are using
                 kconfiglib via 'make scriptconfig' the filename of the
                 correct Kconfig will be in sys.argv[1].

        base_dir (default: "$srctree") -- The base directory relative to which
                'source' statements within Kconfig files will work. For the
                Linux kernel this should be the top-level directory of the
                kernel tree. $-references to environment variables will be
                expanded.

                The environment variable 'srctree' is set by the Linux makefiles
                to the top-level kernel directory. A default of "." would not
                work if an alternative build directory is used.

        print_warnings (default: True) -- Set to True if warnings related to
                       this configuration should be printed to stderr. This can
                       be changed later with Config.set_print_warnings(). It is
                       provided as a constructor argument since warnings might
                       be generated during parsing.

        print_undef_assign (default: False) -- Set to True if informational
                           messages related to assignments to undefined symbols
                           should be printed to stderr for this configuration.
                           Can be changed later with
                           Config.set_print_undef_assign()."""

        # The set of all symbols, indexed by name (a string)
        self.syms = {}

        # The set of all defined symbols in the configuration in the order they
        # appear in the Kconfig files. This excludes the special symbols n, m,
        # and y as well as symbols that are referenced but never defined.
        self.kconfig_syms = []

        # The set of all named choices (yes, choices can have names), indexed
        # by name (a string)
        self.named_choices = {}

        def register_special_symbol(type, name, value):
            sym = Symbol()
            sym.is_special_ = True
            sym.is_defined_ = True
            sym.config = self
            sym.name = name
            sym.type = type
            sym.cached_value = value
            self.syms[name] = sym
            return sym

        # The special symbols n, m and y, used as shorthand for "n", "m" and
        # "y"
        self.n = register_special_symbol(TRISTATE, "n", "n")
        self.m = register_special_symbol(TRISTATE, "m", "m")
        self.y = register_special_symbol(TRISTATE, "y", "y")

        # DEFCONFIG_LIST uses this
        register_special_symbol(STRING, "UNAME_RELEASE", os.uname()[2])

        # The symbol with "option defconfig_list" set, containing a list of
        # default .config files
        self.defconfig_sym = None

        # See Symbol.get_(src)arch()
        self.arch    = os.environ.get("ARCH")
        self.srcarch = os.environ.get("SRCARCH")

        # See Config.__init__(). We need this for get_defconfig_filename().
        self.srctree = os.environ.get("srctree")
        if self.srctree is None:
            self.srctree = "."

        self.filename = filename
        self.base_dir = _strip_trailing_slash(os.path.expandvars(base_dir))

        # The 'mainmenu' text
        self.mainmenu_text = None

        # The filename of the most recently loaded .config file
        self.config_filename = None

        # The textual header of the most recently loaded .config, uncommented
        self.config_header = None

        self.print_warnings = print_warnings
        self.print_undef_assign = print_undef_assign

        # Lists containing all choices, menus and comments in the configuration

        self.choices = []
        self.menus = []
        self.comments = []

        # For parsing routines that stop when finding a line belonging to a
        # different construct, these holds that line and the tokenized version
        # of that line. The purpose is to avoid having to re-tokenize the line,
        # which is inefficient and causes problems when recording references to
        # symbols.
        self.end_line = None
        self.end_line_tokens = None

        # See the comment in _parse_expr().
        self.parse_expr_cur_sym_or_choice = None
        self.parse_expr_line = None
        self.parse_expr_filename = None
        self.parse_expr_linenr = None
        self.parse_expr_transform_m = None

        # Parse the Kconfig files
        self.top_block = self._parse_file(filename, None, None, None)

        # Build Symbol.dep for all symbols
        self._build_dep()

    def load_config(self, filename, replace = True):
        """Loads symbol values from a file in the familiar .config format.
           Equivalent to calling Symbol.set_user_value() to set each of the
           values.

           filename -- The .config file to load. $-references to environment
                       variables will be expanded. For scripts to work even
                       when an alternative build directory is used with the
                       Linux kernel, you need to refer to the top-level kernel
                       directory with "$srctree".

           replace (default: True) -- True if the configuration should replace
                   the old configuration; False if it should add to it."""

        def warn_override(filename, linenr, name, old_user_val, new_user_val):
            self._warn("overriding the value of {0}. "
                       'Old value: "{1}", new value: "{2}".'
                        .format(name, old_user_val, new_user_val),
                       filename,
                       linenr)

        filename = os.path.expandvars(filename)

        # Put this first so that a missing file doesn't screw up our state
        line_feeder = _FileFeed(_get_lines(filename), filename)

        self.config_filename = filename

        # Invalidate everything. This is usually faster than finding the
        # minimal set of symbols that needs to be invalidated, as nearly all
        # symbols will tend to be affected anyway.
        if replace:
            self.unset_user_values()
        else:
            self._invalidate_all()

        # Read header

        self.config_header = None

        def is_header_line(line):
            return line.startswith("#") and \
                   not unset_re.match(line)

        first_line = line_feeder.get_next()

        if first_line is None:
            return

        if not is_header_line(first_line):
            line_feeder.go_back()
        else:
            self.config_header = first_line[1:]

            # Read remaining header lines
            while 1:
                line = line_feeder.get_next()

                if line is None:
                    break

                if not is_header_line(line):
                    line_feeder.go_back()
                    break

                self.config_header += line[1:]

            # Remove trailing newline
            if self.config_header.endswith("\n"):
                self.config_header = self.config_header[:-1]

        # Read assignments

        filename = line_feeder.get_filename()

        while 1:
            line = line_feeder.get_next()
            if line is None:
                return

            linenr = line_feeder.get_linenr()

            line = line.strip()

            set_re_match = set_re.match(line)
            if set_re_match:
                name, val = set_re_match.groups()
                # The unescaping producedure below should be safe since " can
                # only appear as \" inside the string
                val = _strip_quotes(val, line, filename, linenr)\
                      .replace('\\"', '"').replace("\\\\", "\\")
                if name in self.syms:
                    sym = self.syms[name]

                    old_user_val = sym.user_val
                    if old_user_val is not None:
                        warn_override(filename, linenr, name, old_user_val, val)

                    if sym.is_choice_symbol_:
                        user_mode = sym.parent.user_mode
                        if user_mode is not None and user_mode != val:
                            self._warn("assignment to {0} changes mode of containing "
                                       'choice from "{1}" to "{2}".'
                                       .format(name, val, user_mode),
                                       filename,
                                       linenr)

                    sym._set_user_value_no_invalidate(val, True)

                else:
                    self._undef_assign('attempt to assign the value "{0}" to the '
                                       "undefined symbol {1}."
                                       .format(val, name),
                                       filename,
                                       linenr)

            else:
                unset_re_match = unset_re.match(line)
                if unset_re_match:
                    name = unset_re_match.group(1)
                    if name in self.syms:
                        sym = self.syms[name]

                        old_user_val = sym.user_val
                        if old_user_val is not None:
                            warn_override(filename, linenr, name, old_user_val, "n")

                        sym._set_user_value_no_invalidate("n", True)

    def write_config(self, filename, header = None):
        """Writes out symbol values in the familiar .config format.

           filename -- The filename under which to save the configuration.

           header (default: None) -- A textual header that will appear at the
                  beginning of the file, with each line commented out
                  automatically. None means no header."""

        # already_written is set when _make_conf() is called on a symbol, so
        # that symbols defined in multiple locations only get one entry in the
        # .config. We need to reset it prior to writing out a new .config.
        for sym in self.syms.itervalues():
            sym.already_written = False

        with open(filename, "w") as f:
            # Write header
            if header is not None:
                f.write(_comment(header))
                f.write("\n")

            # Write configuration.
            # (You'd think passing a list around to all the nodes and appending
            # to it to avoid copying would be faster, but it's actually a lot
            # slower with PyPy, and about as fast with Python. Passing the file
            # around is slower too.)
            f.write("\n".join(self.top_block._make_conf()))
            f.write("\n")

    def get_kconfig_filename(self):
        """Returns the name of the (base) kconfig file this configuration was
        loaded from."""
        return self.filename

    def get_arch(self):
        """Returns the value the environment variable ARCH had at the time the
        Config instance was created, or None if ARCH was not set. For the
        kernel, this corresponds to the architecture being built for, with
        values such as "i386" or "mips"."""
        return self.arch

    def get_srcarch(self):
        """Returns the value the environment variable SRCARCH had at the time
        the Config instance was created, or None if SRCARCH was not set. For
        the kernel, this corresponds to the arch/ subdirectory containing
        architecture-specific source code."""
        return self.srcarch

    def get_srctree(self):
        """Returns the value the environment variable srctree had at the time
        the Config instance was created, or None if srctree was not defined.
        This variable points to the source directory and is used when building
        in a separate directory."""
        return self.srctree

    def get_config_filename(self):
        """Returns the name of the most recently loaded configuration file, or
        None if no configuration has been loaded."""
        return self.config_filename

    def get_mainmenu_text(self):
        """Returns the text of the 'mainmenu' statement (with $-references to
        symbols replaced by symbol values), or None if the configuration has no
        'mainmenu' statement."""
        return None if self.mainmenu_text is None else \
          self._expand_sym_refs(self.mainmenu_text)

    def get_defconfig_filename(self):
        """Returns the name of the defconfig file, which is the first existing
        file in the list given in a symbol having 'option defconfig_list' set.
        $-references to symbols will be expanded ("$FOO bar" -> "foo bar" if
        FOO has the value "foo"). Returns None in case of no defconfig file.
        Setting 'option defconfig_list' on multiple symbols currently results
        in undefined behavior.

        If the environment variable 'srctree' was set when the Config was
        created, get_defconfig_filename() will first look relative to that
        directory before looking in the current directory; see
        Config.__init__()."""

        if self.defconfig_sym is None:
            return None

        for (filename, cond_expr) in self.defconfig_sym.def_exprs:
            if self._eval_expr(cond_expr) == "y":
                filename = self._expand_sym_refs(filename)

                # We first look in $srctree. os.path.join() won't work here as
                # an absolute path in filename would override $srctree.
                srctree_filename = os.path.normpath(self.srctree + "/" + filename)
                if os.path.exists(srctree_filename):
                    return srctree_filename

                if os.path.exists(filename):
                    return filename

        return None

    def get_symbol(self, name):
        """Returns the symbol with name 'name', or None if no such symbol
        appears in the configuration. An alternative shorthand is conf[name],
        where conf is a Config instance, though that will instead raise
        KeyError if the symbol does not exist."""
        return self.syms.get(name)

    def get_top_level_items(self):
        """Returns a list containing the items (symbols, menus, choice
        statements and comments) at the top level of the configuration -- that
        is, all items that do not appear within a menu or choice. The items
        appear in the same order as within the configuration."""
        return self.top_block.get_items()

    def get_symbols(self, all_symbols = True):
        """Returns a list of symbols from the configuration. An alternative for
        iterating over all defined symbols (in the order of definition) is

        for sym in config:
            ...

        which relies on Config implementing __iter__() and is equivalent to

        for sym in config.get_symbols(False):
            ...

        all_symbols (default: True) -- If True, all symbols - including special
                    and undefined symbols - will be included in the result, in
                    an undefined order. If False, only symbols actually defined
                    and not merely referred to in the configuration will be
                    included in the result, and will appear in the order that
                    they are defined within the Kconfig configuration files."""
        return self.syms.values() if all_symbols else self.kconfig_syms

    def get_choices(self):
        """Returns a list containing all choice statements in the
        configuration, in the order they appear in the Kconfig files."""
        return self.choices

    def get_menus(self):
        """Returns a list containing all menus in the configuration, in the
        order they appear in the Kconfig files."""
        return self.menus

    def get_comments(self):
        """Returns a list containing all comments in the configuration, in the
        order they appear in the Kconfig files."""
        return self.comments

    def eval(self, s):
        """Returns the value of the expression 's' -- where 's' is represented
        as a string -- in the context of the configuration. Raises
        Kconfig_Syntax_Error if syntax errors are detected in 's'.

        For example, if FOO and BAR are tristate symbols at least one of which
        has the value "y", then config.eval("y && (FOO || BAR)") => "y"

        This functions always yields a tristate value. To get the value of
        non-bool, non-tristate symbols, use Symbol.get_value().

        The result of this function is consistent with how evaluation works for
        conditional expressions in the configuration as well as in the C
        implementation. "m" and m are rewritten as '"m" && MODULES' and 'm &&
        MODULES', respectively, and a result of "m" will get promoted to "y" if
        we're running without modules."""
        return self._eval_expr(self._parse_expr(self._tokenize(s, True), # Feed
                                                None, # Current symbol or choice
                                                s))   # line

    def get_config_header(self):
        """Returns the (uncommented) textual header of the .config file most
        recently loaded with load_config(). Returns None if no .config file has
        been loaded or if the most recently loaded .config file has no header.
        The header comprises all lines up to but not including the first line
        that either

        1. Does not start with "#"
        2. Has the form "# CONFIG_FOO is not set."
        """
        return self.config_header

    def get_base_dir(self):
        """Returns the base directory relative to which 'source' statements
        will work, passed as an argument to Config.__init__()."""
        return self.base_dir

    def set_print_warnings(self, print_warnings):
        """Determines whether warnings related to this configuration (for
        things like attempting to assign illegal values to symbols with
        Symbol.set_user_value()) should be printed to stderr.

        print_warnings -- True if warnings should be
                          printed, otherwise False."""
        self.print_warnings = print_warnings

    def set_print_undef_assign(self, print_undef_assign):
        """Determines whether informational messages related to assignments to
        undefined symbols should be printed to stderr for this configuration.

        print_undef_assign -- If True, such messages will be printed."""
        self.print_undef_assign = print_undef_assign

    def __getitem__(self, key):
        """Returns the symbol with name 'name'. Raises KeyError if the symbol
        does not appear in the configuration."""
        return self.syms[key]

    def __iter__(self):
        """Convenience function for iterating over the set of all defined
        symbols in the configuration, used like

        for sym in conf:
            ...

        The iteration happens in the order of definition within the Kconfig
        configuration files. Symbols only referred to but not defined will not
        be included, nor will the special symbols n, m, and y. If you want to
        include such symbols as well, see config.get_symbols()."""
        return iter(self.kconfig_syms)

    def unset_user_values(self):
        """Resets the values of all symbols, as if Config.load_config() or
        Symbol.set_user_value() had never been called."""
        for sym in self.syms.itervalues():
            sym._unset_user_value_no_recursive_invalidate()

    def __str__(self):
        """Returns a string containing various information about the Config."""
        return _sep_lines("Configuration",
                          "File                                   : " + self.filename,
                          "Base directory                         : " + self.base_dir,
                          "Value of $ARCH at creation time        : " +
                            ("(not set)" if self.arch is None else self.arch),
                          "Value of $SRCARCH at creation time     : " +
                            ("(not set)" if self.srcarch is None else self.srcarch),
                          "Source tree (derived from $srctree;",
                          "defaults to '.' if $srctree isn't set) : " + self.srctree,
                          "Most recently loaded .config           : " +
                            ("(no .config loaded)" if self.config_filename is None else
                             self.config_filename),
                          "Print warnings                         : " +
                            bool_str[self.print_warnings],
                          "Print assignments to undefined symbols : " +
                            bool_str[self.print_undef_assign])


    #
    # Private methods
    #

    def _invalidate_all(self):
        for sym in self.syms.itervalues():
            sym._invalidate()

    def _tokenize(self,
                  s,
                  for_eval = False,
                  filename = None,
                  linenr = None):
        """Returns a _Feed instance containing tokens derived from the string
        's'. Registers any new symbols encountered (via _sym_lookup()).

        (I experimented with a pure regular expression implementation, but it
        came out slower, less readable, and wouldn't have been as flexible.)

        for_eval -- True when parsing an expression for a call to
                    Config.eval(), in which case we should not treat the first
                    token specially nor register new symbols."""
        s = s.lstrip()
        if s == "" or s[0] == "#":
            return _Feed([])

        if for_eval:
            i = 0 # The current index in the string being tokenized
            previous = None # The previous token seen
            tokens = []
        else:
            # The initial word on a line is parsed specially. Let
            # command_chars = [A-Za-z0-9_]. Then
            #  - leading non-command_chars characters on the line are ignored, and
            #  - the first token consists the following one or more command_chars
            #    characters.
            # This is why things like "----help--" are accepted.

            initial_token_match = initial_token_re.match(s)
            if initial_token_match is None:
                return _Feed([])
            # The current index in the string being tokenized
            i = initial_token_match.end()

            keyword = keywords.get(initial_token_match.group(1))
            if keyword is None:
                # We expect a keyword as the first token
                _tokenization_error(s, len(s), filename, linenr)
            if keyword == T_HELP:
                # Avoid junk after "help", e.g. "---", being registered as a
                # symbol
                return _Feed([T_HELP])
            tokens = [keyword]
            previous = keyword

        # _tokenize() is a hotspot during parsing, and this speeds things up a
        # bit
        strlen = len(s)
        append = tokens.append

        # Main tokenization loop. (Handles tokens past the first one.)
        while i < strlen:
            # Test for an identifier/keyword preceded by whitespace first; this
            # is the most common case.
            id_keyword_match = id_keyword_re.match(s, i)
            if id_keyword_match:
                # We have an identifier or keyword. The above also stripped any
                # whitespace for us.
                name = id_keyword_match.group(1)
                # Jump past it
                i = id_keyword_match.end()

                # Keyword?
                keyword = keywords.get(name)
                if keyword is not None:
                    append(keyword)
                # What would ordinarily be considered a name is treated as a
                # string after certain tokens.
                elif previous in string_lex:
                    append(name)
                else:
                    # We're dealing with a symbol. _sym_lookup() will take care
                    # of allocating a new Symbol instance if it's the first
                    # time we see it.
                    sym = self._sym_lookup(name, not for_eval)

                    if previous == T_CONFIG or previous == T_MENUCONFIG:
                        # If the previous token is T_(MENU)CONFIG
                        # ("(menu)config"), we're tokenizing the first line of
                        # a symbol definition, and should remember this as a
                        # location where the symbol is defined.
                        sym.def_locations.append((filename, linenr))
                    else:
                        # Otherwise, it's a reference to the symbol
                        sym.ref_locations.append((filename, linenr))

                    append(sym)

            else:
                # This restrips whitespace that could have been stripped in the
                # regex above, but it's worth it since identifiers/keywords are
                # more common
                s = s[i:].lstrip()
                if s == "":
                    break
                strlen = len(s)
                i = 0
                c = s[0]

                # String literal (constant symbol)
                if c == '"' or c == "'":
                    i += 1

                    if "\\" in s:
                        # Slow path: This could probably be sped up, but it's a
                        # very unusual case anyway.
                        quote = c
                        value = ""
                        while 1:
                            if i >= strlen:
                                _tokenization_error(s, strlen, filename,
                                                    linenr)
                            c = s[i]
                            if c == quote:
                                break
                            if c == "\\":
                                if i + 1 >= strlen:
                                    _tokenization_error(s, strlen, filename,
                                                        linenr)
                                value += s[i + 1]
                                i += 2
                            else:
                                value += c
                                i += 1
                        i += 1
                        append(value)
                    else:
                        # Fast path: If the string contains no backslashes (almost
                        # always) we can simply look for the matching quote.
                        end = s.find(c, i)
                        if end == -1:
                            _tokenization_error(s, strlen, filename, linenr)
                        append(s[i:end])
                        i = end + 1

                elif c == "&":
                    if i + 1 >= strlen:
                        # Invalid characters are ignored
                        continue
                    if s[i + 1] != "&":
                        # Invalid characters are ignored
                        i += 1
                        continue
                    append(T_AND)
                    i += 2

                elif c == "|":
                    if i + 1 >= strlen:
                        # Invalid characters are ignored
                        continue
                    if s[i + 1] != "|":
                        # Invalid characters are ignored
                        i += 1
                        continue
                    append(T_OR)
                    i += 2

                elif c == "!":
                    if i + 1 >= strlen:
                        _tokenization_error(s, strlen, filename, linenr)
                    if s[i + 1] == "=":
                        append(T_UNEQUAL)
                        i += 2
                    else:
                        append(T_NOT)
                        i += 1

                elif c == "=":
                    append(T_EQUAL)
                    i += 1

                elif c == "(":
                    append(T_OPEN_PAREN)
                    i += 1

                elif c == ")":
                    append(T_CLOSE_PAREN)
                    i += 1

                elif c == "#":
                    break

                else:
                    # Invalid characters are ignored
                    i += 1
                    continue

            previous = tokens[-1]

        return _Feed(tokens)

    #
    # Parsing
    #

    # Expression grammar:
    #
    # <expr> -> <symbol>
    #           <symbol> '=' <symbol>
    #           <symbol> '!=' <symbol>
    #           '(' <expr> ')'
    #           '!' <expr>
    #           <expr> '&&' <expr>
    #           <expr> '||' <expr>

    def _parse_expr(self,
                    feed,
                    cur_sym_or_choice,
                    line,
                    filename = None,
                    linenr = None,
                    transform_m = True):
        """Parse an expression from the tokens in 'feed' using a simple
        top-down approach. The result has the form (<operator>, <list
        containing parsed operands>).

        feed -- _Feed instance containing the tokens for the expression.

        cur_sym_or_choice -- The symbol or choice currently being parsed, or
                             None if we're not parsing a symbol or choice.
                             Used for recording references to symbols.

        line -- The line containing the expression being parsed.

        filename (default: None) -- The file containing the expression.

        linenr (default: None) -- The line number containing the expression.

        transform_m (default: False) -- Determines if 'm' should be rewritten to
                                        'm && MODULES' -- see
                                        parse_val_and_cond()."""

        # Use instance variables to avoid having to pass these as arguments
        # through the top-down parser in _parse_expr_2(), which is tedious and
        # obfuscates the code. A profiler run shows no noticeable performance
        # difference.
        self.parse_expr_cur_sym_or_choice = cur_sym_or_choice
        self.parse_expr_line = line
        self.parse_expr_filename = filename
        self.parse_expr_linenr = linenr
        self.parse_expr_transform_m = transform_m

        return self._parse_expr_2(feed)

    def _parse_expr_2(self, feed):
        or_terms = [self._parse_or_term(feed)]
        # Keep parsing additional terms while the lookahead is '||'
        while feed.check(T_OR):
            or_terms.append(self._parse_or_term(feed))

        return or_terms[0] if len(or_terms) == 1 else (OR, or_terms)

    def _parse_or_term(self, feed):
        and_terms = [self._parse_factor(feed)]
        # Keep parsing additional terms while the lookahead is '&&'
        while feed.check(T_AND):
            and_terms.append(self._parse_factor(feed))

        return and_terms[0] if len(and_terms) == 1 else (AND, and_terms)

    def _parse_factor(self, feed):
        if feed.check(T_OPEN_PAREN):
            expr_parse = self._parse_expr_2(feed)

            if not feed.check(T_CLOSE_PAREN):
                _parse_error(self.parse_expr_line,
                             "missing end parenthesis.",
                             self.parse_expr_filename,
                             self.parse_expr_linenr)

            return expr_parse

        if feed.check(T_NOT):
            return (NOT, self._parse_factor(feed))

        sym_or_string = feed.get_next()

        if not isinstance(sym_or_string, (Symbol, str)):
            _parse_error(self.parse_expr_line,
                         "malformed expression.",
                         self.parse_expr_filename,
                         self.parse_expr_linenr)

        if self.parse_expr_cur_sym_or_choice is not None and \
           isinstance(sym_or_string, Symbol):
            self.parse_expr_cur_sym_or_choice.referenced_syms.add(sym_or_string)

        next_token = feed.peek_next()

        # For conditional expressions ('depends on <expr>', '... if <expr>',
        # etc.), "m" and m are rewritten to "m" && MODULES.
        if next_token != T_EQUAL and next_token != T_UNEQUAL:
            if self.parse_expr_transform_m and (sym_or_string is self.m or
                                                sym_or_string == "m"):
                return (AND, ["m", self._sym_lookup("MODULES")])
            return sym_or_string

        relation = EQUAL if (feed.get_next() == T_EQUAL) else UNEQUAL
        sym_or_string_2 = feed.get_next()

        if self.parse_expr_cur_sym_or_choice is not None and \
           isinstance(sym_or_string_2, Symbol):
            self.parse_expr_cur_sym_or_choice.referenced_syms.add(sym_or_string_2)

        if sym_or_string is self.m:
            sym_or_string = "m"

        if sym_or_string_2 is self.m:
            sym_or_string_2 = "m"

        return (relation, sym_or_string, sym_or_string_2)

    def _parse_file(self, filename, parent, deps, visible_if_deps, res = None):
        """Parse the Kconfig file 'filename'. The result is a _Block with all
        items from the file. See _parse_block() for the meaning of the
        parameters."""
        line_feeder = _FileFeed(_get_lines(filename), filename)
        return self._parse_block(line_feeder, None, parent, deps, visible_if_deps, res)

    def _parse_block(self, line_feeder, end_marker, parent, deps,
                     visible_if_deps = None, res = None):
        """Parses a block, which is the contents of either a file or an if,
        menu, or choice statement. The result is a _Block with the items from
        the block.

        end_marker -- The token that ends the block, e.g. T_ENDIF ("endif") for
                      if's. None for files.

        parent -- The enclosing menu, choice or if, or None if we're at the top
                  level.

        deps -- Dependencies from enclosing menus, choices and if's.

        visible_if_deps (default: None) -- 'visible if' dependencies from
                        enclosing menus.

        res (default: None) -- The _Block to add items to. If None, a new
                               _Block is created to hold the items."""

        block = _Block() if res is None else res

        filename = line_feeder.get_filename()

        while 1:

            # Do we already have a tokenized line that we determined wasn't
            # part of whatever we were parsing earlier? See comment in
            # Config.__init__().
            if self.end_line is not None:
                assert self.end_line_tokens is not None
                tokens = self.end_line_tokens
                tokens.go_to_start()

                line = self.end_line
                linenr = line_feeder.get_linenr()

                self.end_line = None
                self.end_line_tokens = None

            else:
                line = line_feeder.get_next()
                if line is None:
                    if end_marker is not None:
                        raise Kconfig_Syntax_Error, (
                                "Unexpected end of file {0}."
                                .format(line_feeder.get_filename()))
                    return block

                linenr = line_feeder.get_linenr()

                tokens = self._tokenize(line, False, filename, linenr)

            if tokens.is_empty():
                continue

            t0 = tokens.get_next()

            # Have we reached the end of the block?
            if t0 == end_marker:
                return block

            if t0 == T_CONFIG or t0 == T_MENUCONFIG:
                # The tokenizer will automatically allocate a new Symbol object
                # for any new names it encounters, so we don't need to worry
                # about that here.
                sym = tokens.get_next()

                # Symbols defined in multiple places get the parent of their
                # first definition. However, for symbols whose parents are choice
                # statements, the choice statement takes precedence.
                if not sym.is_defined_ or isinstance(parent, Choice):
                    sym.parent = parent

                sym.is_defined_ = True

                self.kconfig_syms.append(sym)
                block.add_item(sym)

                self._parse_properties(line_feeder, sym, deps, visible_if_deps)

            elif t0 == T_MENU:
                menu = Menu()
                self.menus.append(menu)
                menu.config = self
                menu.parent = parent
                menu.title = tokens.get_next()

                menu.filename = filename
                menu.linenr = linenr

                # Parse properties and contents
                self._parse_properties(line_feeder, menu, deps, visible_if_deps)
                menu.block = self._parse_block(line_feeder,
                                               T_ENDMENU,
                                               menu,
                                               menu.dep_expr,
                                               _make_and(visible_if_deps,
                                                         menu.visible_if_expr))

                block.add_item(menu)

            elif t0 == T_IF:
                # If statements are treated as syntactic sugar for adding
                # dependencies to enclosed items and do not have an explicit
                # object representation.

                dep_expr = self._parse_expr(tokens, None, line, filename, linenr)
                self._parse_block(line_feeder,
                                  T_ENDIF,
                                  parent,
                                  _make_and(dep_expr, deps),
                                  visible_if_deps,
                                  block) # Add items to the same block

            elif t0 == T_CHOICE:
                # We support named choices
                already_defined = False
                name = None
                if len(tokens) > 1 and isinstance(tokens[1], str):
                    name = tokens[1]
                    already_defined = name in self.named_choices

                if already_defined:
                    choice = self.named_choices[name]
                else:
                    choice = Choice()
                    self.choices.append(choice)
                    if name is not None:
                        choice.name = name
                        self.named_choices[name] = choice

                choice.config = self
                choice.parent = parent

                choice.def_locations.append((filename, linenr))

                # Parse properties and contents
                self._parse_properties(line_feeder, choice, deps, visible_if_deps)
                choice.block = self._parse_block(line_feeder,
                                                 T_ENDCHOICE,
                                                 choice,
                                                 None,
                                                 visible_if_deps)

                choice._determine_actual_symbols()

                # If no type is set for the choice, its type is that of the first
                # choice item
                if choice.type == UNKNOWN:
                    for item in choice.get_symbols():
                        if item.type != UNKNOWN:
                            choice.type = item.type
                            break

                # Each choice item of UNKNOWN type gets the type of the choice
                for item in choice.get_symbols():
                    if item.type == UNKNOWN:
                        item.type = choice.type

                # For named choices defined in multiple locations, only record
                # at the first definition
                if not already_defined:
                    block.add_item(choice)

            elif t0 == T_COMMENT:
                comment = Comment()
                comment.config = self
                comment.parent = parent

                comment.filename = filename
                comment.linenr = linenr

                comment.text = tokens.get_next()
                self._parse_properties(line_feeder, comment, deps, visible_if_deps)

                block.add_item(comment)
                self.comments.append(comment)

            elif t0 == T_SOURCE:
                kconfig_file = tokens.get_next()
                exp_kconfig_file = self._expand_sym_refs(kconfig_file)
                f = os.path.join(self.base_dir, exp_kconfig_file)

                if not os.path.exists(f):
                    raise IOError, ('{0}:{1}: sourced file "{2}" (expands to\n'
                                    '"{3}") not found. Perhaps base_dir\n'
                                    '(argument to Config.__init__(), currently\n'
                                    '"{4}") is set to the wrong value.'
                                    .format(filename,
                                            linenr,
                                            kconfig_file,
                                            exp_kconfig_file,
                                            self.base_dir))

                # Add items to the same block
                self._parse_file(f, parent, deps, visible_if_deps, block)

            elif t0 == T_MAINMENU:
                text = tokens.get_next()

                if self.mainmenu_text is not None:
                    self._warn("overriding 'mainmenu' text. "
                               'Old value: "{0}", new value: "{1}".'
                                .format(self.mainmenu_text, text),
                               filename,
                               linenr)

                self.mainmenu_text = text

            else:
                _parse_error(line, "unrecognized construct.", filename, linenr)

    def _parse_properties(self, line_feeder, stmt, deps, visible_if_deps):
        """Parsing of properties for symbols, menus, choices, and comments."""

        def parse_val_and_cond(tokens, line, filename, linenr):
            """Parses '<expr1> if <expr2>' constructs, where the 'if' part is
            optional. Returns a tuple containing the parsed expressions, with
            None as the second element if the 'if' part is missing."""
            val = self._parse_expr(tokens, stmt, line, filename, linenr, False)

            if tokens.check(T_IF):
                return (val, self._parse_expr(tokens, stmt, line, filename, linenr))

            return (val, None)

        # In case the symbol is defined in multiple locations, we need to
        # remember what prompts, defaults, and selects are new for this
        # definition, as "depends on" should only apply to the local
        # definition.
        new_prompt = None
        new_def_exprs = []
        new_selects = []

        # Dependencies from 'depends on' statements
        depends_on_expr = None

        while 1:
            line = line_feeder.get_next()
            if line is None:
                break

            filename = line_feeder.get_filename()
            linenr = line_feeder.get_linenr()

            tokens = self._tokenize(line, False, filename, linenr)

            if tokens.is_empty():
                continue

            t0 = tokens.get_next()

            if t0 == T_HELP:
                # Find first non-empty line and get its indentation

                line_feeder.remove_while(str.isspace)
                line = line_feeder.get_next()

                if line is None:
                    stmt.help = ""
                    break

                indent = _indentation(line)

                # If the first non-empty lines has zero indent, there is no
                # help text
                if indent == 0:
                    stmt.help = ""
                    line_feeder.go_back()
                    break

                help_lines = [_deindent(line, indent)]

                # The help text goes on till the first non-empty line with less
                # indent
                while 1:
                    line = line_feeder.get_next()
                    if (line is None) or \
                       (not line.isspace() and _indentation(line) < indent):
                        stmt.help = "".join(help_lines)
                        break

                    help_lines.append(_deindent(line, indent))

                if line is None:
                    break

                line_feeder.go_back()

            elif t0 == T_PROMPT:
                # 'prompt' properties override each other within a single
                # definition of a symbol, but additional prompts can be added
                # by defining the symbol multiple times; hence 'new_prompt'
                # instead of 'prompt'.
                new_prompt = parse_val_and_cond(tokens, line, filename, linenr)

            elif t0 == T_DEFAULT:
                new_def_exprs.append(parse_val_and_cond(tokens, line, filename, linenr))

            elif t0 == T_DEPENDS:
                if not tokens.check(T_ON):
                    _parse_error(line, 'expected "on" after "depends".', filename, linenr)

                parsed_deps = self._parse_expr(tokens, stmt, line, filename, linenr)

                if isinstance(stmt, (Menu, Comment)):
                    stmt.dep_expr = _make_and(stmt.dep_expr, parsed_deps)
                else:
                    depends_on_expr = _make_and(depends_on_expr, parsed_deps)

            elif t0 == T_VISIBLE:
                if not tokens.check(T_IF):
                    _parse_error(line, 'expected "if" after "visible".', filename, linenr)
                if not isinstance(stmt, Menu):
                    _parse_error(line,
                                 "'visible if' is only valid for menus.",
                                 filename,
                                 linenr)

                parsed_deps = self._parse_expr(tokens, stmt, line, filename, linenr)
                stmt.visible_if_expr = _make_and(stmt.visible_if_expr, parsed_deps)

            elif t0 == T_SELECT:
                target = tokens.get_next()

                stmt.referenced_syms.add(target)
                stmt.selected_syms.add(target)

                if tokens.check(T_IF):
                    new_selects.append((target,
                                        self._parse_expr(tokens, stmt, line, filename, linenr)))
                else:
                    new_selects.append((target, None))

            elif t0 in (T_BOOL, T_TRISTATE, T_INT, T_HEX, T_STRING):
                stmt.type = token_to_type[t0]

                if len(tokens) > 1:
                    new_prompt = parse_val_and_cond(tokens, line, filename, linenr)

            elif t0 == T_RANGE:
                lower = tokens.get_next()
                upper = tokens.get_next()
                stmt.referenced_syms.add(lower)
                stmt.referenced_syms.add(upper)

                if tokens.check(T_IF):
                    stmt.ranges.append((lower, upper,
                                        self._parse_expr(tokens, stmt, line, filename, linenr)))
                else:
                    stmt.ranges.append((lower, upper, None))

            elif t0 == T_DEF_BOOL:
                stmt.type = BOOL

                if len(tokens) > 1:
                    new_def_exprs.append(parse_val_and_cond(tokens, line, filename, linenr))

            elif t0 == T_DEF_TRISTATE:
                stmt.type = TRISTATE

                if len(tokens) > 1:
                    new_def_exprs.append(parse_val_and_cond(tokens, line, filename, linenr))

            elif t0 == T_OPTIONAL:
                if not isinstance(stmt, Choice):
                    _parse_error(line,
                                 '"optional" is only valid for choices.',
                                 filename,
                                 linenr)
                stmt.optional = True

            elif t0 == T_OPTION:
                if tokens.check(T_ENV) and tokens.check(T_EQUAL):
                    env_var = tokens.get_next()

                    stmt.is_special_ = True
                    stmt.is_from_env = True

                    if env_var not in os.environ:
                        self._warn("""
The symbol {0} references the non-existent environment variable {1} and will
get the empty string as its value.

If you're using kconfiglib via 'make (i)scriptconfig' it should have set up the
environment correctly for you. If you still got this message, that might be an
error, and you should e-mail kconfiglib@gmail.com.
."""                               .format(stmt.name, env_var),
                                   filename,
                                   linenr)

                        stmt.cached_value = ""
                    else:
                        stmt.cached_value = os.environ[env_var]

                elif tokens.check(T_DEFCONFIG_LIST):
                    self.defconfig_sym = stmt

                elif tokens.check(T_MODULES):
                    self._warn("the 'modules' option is not supported. "
                               "Let me know if this is a problem for you; "
                               "it shouldn't be that hard to implement.",
                               filename,
                               linenr)

                else:
                    _parse_error(line, "unrecognized option.", filename, linenr)

            else:
                # See comment in Config.__init__()
                self.end_line = line
                self.end_line_tokens = tokens
                break

        # Propagate dependencies from enclosing menus and if's.

        # For menus and comments..
        if isinstance(stmt, (Menu, Comment)):
            stmt.orig_deps = stmt.dep_expr
            stmt.deps_from_containing = deps
            stmt.dep_expr = _make_and(stmt.dep_expr, deps)

            stmt.all_referenced_syms = \
              stmt.referenced_syms | _get_expr_syms(deps)

        # For symbols and choices..
        else:

            # See comment for 'menu_dep'
            stmt.menu_dep = depends_on_expr

            # Propagate dependencies specified with 'depends on' to any new
            # default expressions, prompts, and selections. ("New" since a
            # symbol might be defined in multiple places and the dependencies
            # should only apply to the local definition.)

            new_def_exprs = [(val_expr, _make_and(cond_expr, depends_on_expr))
                             for (val_expr, cond_expr) in new_def_exprs]

            new_selects = [(target, _make_and(cond_expr, depends_on_expr))
                           for (target, cond_expr) in new_selects]

            if new_prompt is not None:
                prompt, cond_expr = new_prompt

                # 'visible if' dependencies from enclosing menus get propagated
                # to prompts
                if visible_if_deps is not None:
                    cond_expr = _make_and(cond_expr, visible_if_deps)

                new_prompt = (prompt, _make_and(cond_expr, depends_on_expr))

            # We save the original expressions -- before any menu and if
            # conditions have been propagated -- so these can be retrieved
            # later.

            stmt.orig_def_exprs.extend(new_def_exprs)
            if new_prompt is not None:
                stmt.orig_prompts.append(new_prompt)

            # Only symbols can select
            if isinstance(stmt, Symbol):
                stmt.orig_selects.extend(new_selects)

            # Save dependencies from enclosing menus and if's
            stmt.deps_from_containing = deps

            # The set of symbols referenced directly by the symbol/choice plus
            # all symbols referenced by enclosing menus and if's.
            stmt.all_referenced_syms = \
              stmt.referenced_syms | _get_expr_syms(deps)

            # Propagate dependencies from enclosing menus and if's

            stmt.def_exprs.extend([(val_expr, _make_and(cond_expr, deps))
                                   for (val_expr, cond_expr) in new_def_exprs])

            for (target, cond) in new_selects:
                target.rev_dep = _make_or(target.rev_dep,
                                          _make_and(stmt,
                                                    _make_and(cond, deps)))

            if new_prompt is not None:
                prompt, cond_expr = new_prompt
                stmt.prompts.append((prompt, _make_and(cond_expr, deps)))

    #
    # Symbol table manipulation
    #

    def _sym_lookup(self, name, add_sym_if_not_exists = True):
        """Fetches the symbol 'name' from the symbol table, optionally adding
        it if it does not exist (this is usually what we want)."""
        if name in self.syms:
            return self.syms[name]

        new_sym = Symbol()
        new_sym.config = self
        new_sym.name = name

        if add_sym_if_not_exists:
            self.syms[name] = new_sym
        else:
            # This warning is generated while evaluating an expression
            # containing undefined symbols using Config.eval()
            self._warn("no symbol {0} in configuration".format(name))

        return new_sym

    #
    # Evaluation of symbols and expressions
    #

    def _eval_expr(self, expr):
        """Evaluates an expression and returns one of the tristate values "n",
        "m" or "y"."""
        res = self._eval_expr_2(expr)

        # Promote "m" to "y" if we're running without modules. Internally, "m"
        # is often rewritten to "m" && MODULES by both the C implementation and
        # kconfiglib, which takes care of cases where "m" should be false if
        # we're running without modules.
        if res == "m" and not self._has_modules():
            return "y"

        return res

    def _eval_expr_2(self, expr):
        if expr is None:
            return "y"

        if isinstance(expr, Symbol):
            # Non-bool/tristate symbols are always "n" in a tristate sense,
            # regardless of their value
            if expr.type != BOOL and expr.type != TRISTATE:
                return "n"
            return expr.get_value()

        if isinstance(expr, str):
            return expr if (expr == "y" or expr == "m") else "n"

        first_expr = expr[0]

        if first_expr == OR:
            res = "n"

            for subexpr in expr[1]:
                ev = self._eval_expr_2(subexpr)

                # Return immediately upon discovering a "y" term
                if ev == "y":
                    return "y"

                if ev == "m":
                    res = "m"

            # 'res' is either "n" or "m" here; we already handled the
            # short-circuiting "y" case in the loop.
            return res

        if first_expr == AND:
            res = "y"

            for subexpr in expr[1]:
                ev = self._eval_expr_2(subexpr)

                # Return immediately upon discovering an "n" term
                if ev == "n":
                    return "n"

                if ev == "m":
                    res = "m"

            # 'res' is either "m" or "y" here; we already handled the
            # short-circuiting "n" case in the loop.
            return res

        if first_expr == NOT:
            ev = self._eval_expr_2(expr[1])

            if ev == "y":
                return "n"

            return "y" if (ev == "n") else "m"

        if first_expr == EQUAL:
            return "y" if (self._get_str_value(expr[1]) ==
                           self._get_str_value(expr[2])) else "n"

        if first_expr == UNEQUAL:
            return "y" if (self._get_str_value(expr[1]) !=
                           self._get_str_value(expr[2])) else "n"

        _internal_error("Internal error while evaluating expression: "
                        "unknown operation {0}.".format(first_expr))

    def _get_str_value(self, obj):
        if isinstance(obj, str):
            return obj
        # obj is a Symbol
        return obj.get_value()

    def _eval_min(self, e1, e2):
        e1_eval = self._eval_expr(e1)
        e2_eval = self._eval_expr(e2)

        return e1_eval if tri_less(e1_eval, e2_eval) else e2_eval

    def _eval_max(self, e1, e2):
        e1_eval = self._eval_expr(e1)
        e2_eval = self._eval_expr(e2)

        return e1_eval if tri_greater(e1_eval, e2_eval) else e2_eval

    #
    # Methods related to the MODULES symbol
    #

    def _has_modules(self):
        modules_sym = self.syms.get("MODULES")
        return (modules_sym is not None) and (modules_sym.get_value() == "y")

    #
    # Dependency tracking
    #

    def _build_dep(self):
        """Populates the Symbol.dep sets, linking the symbol to the symbols
        that immediately depend on it in the sense that changing the value of
        the symbol might affect the values of those other symbols. This is used
        for caching/invalidation purposes. The calculated sets might be larger
        than necessary as we don't do any complicated analysis of the
        expressions."""
        for sym in self.syms.itervalues():
            sym.dep = set()

        # Adds 'sym' as a directly dependent symbol to all symbols that appear
        # in the expression 'e'
        def add_expr_deps(e, sym):
            for s in _get_expr_syms(e):
                s.dep.add(sym)

        # The directly dependent symbols of a symbol are:
        #  - Any symbols whose prompts, default values, rev_dep (select
        #    condition), or ranges depend on the symbol
        #  - Any symbols that belong to the same choice statement as the symbol
        #    (these won't be included in 'dep' as that makes the dependency
        #    graph unwieldy, but Symbol._get_dependent() will include them)
        #  - Any symbols in a choice statement that depends on the symbol
        for sym in self.syms.itervalues():
            for (_, e) in sym.prompts:
                add_expr_deps(e, sym)

            for (v, e) in sym.def_exprs:
                add_expr_deps(v, sym)
                add_expr_deps(e, sym)

            add_expr_deps(sym.rev_dep, sym)

            for (l, u, e) in sym.ranges:
                add_expr_deps(l, sym)
                add_expr_deps(u, sym)
                add_expr_deps(e, sym)

            if sym.is_choice_symbol_:
                choice = sym.parent

                for (_, e) in choice.prompts:
                    add_expr_deps(e, sym)

                for (_, e) in choice.def_exprs:
                    add_expr_deps(e, sym)

    def _expr_val_str(self, expr, no_value_str = "(none)", get_val_instead_of_eval = False):
        # Since values are valid expressions, _expr_to_str() will get a nice
        # string representation for those as well.

        if expr is None:
            return no_value_str

        if get_val_instead_of_eval:
            if isinstance(expr, str):
                return _expr_to_str(expr)
            val = expr.get_value()
        else:
            val = self._eval_expr(expr)

        return "{0} (value: {1})".format(_expr_to_str(expr), _expr_to_str(val))

    def _expand_sym_refs(self, s):
        """Expands $-references to symbols in 's' to symbol values, or to the
        empty string for undefined symbols."""

        while 1:
            sym_ref_re_match = sym_ref_re.search(s)
            if sym_ref_re_match is None:
                return s

            sym_name = sym_ref_re_match.group(0)[1:]
            sym = self.syms.get(sym_name)
            expansion = "" if sym is None else sym.get_value()

            s = s[:sym_ref_re_match.start()] + \
                expansion + \
                s[sym_ref_re_match.end():]

    def _get_sym_or_choice_str(self, sc):
        """Symbols and choices have many properties in common, so we factor out
        common __str__() stuff here. "sc" is short for "symbol or choice"."""

        # As we deal a lot with string representations here, use some
        # convenient shorthand:
        s = _expr_to_str

        #
        # Common symbol/choice properties
        #

        user_value_str = "(no user value)" if sc.user_val is None else s(sc.user_val)

        visibility_str = s(sc.get_visibility())

        # Build prompts string
        if sc.prompts == []:
            prompts_str = " (no prompts)"
        else:
            prompts_str_rows = []

            for (prompt, cond_expr) in sc.orig_prompts:
                if cond_expr is None:
                    prompts_str_rows.append(' "{0}"'.format(prompt))
                else:
                    prompts_str_rows.append(' "{0}" if '.format(prompt) +
                                            self._expr_val_str(cond_expr))

            prompts_str = "\n".join(prompts_str_rows)

        # Build locations string
        if sc.def_locations == []:
            locations_str = "(no locations)"
        else:
            locations_str = " ".join(["{0}:{1}".format(filename, linenr) for
                                      (filename, linenr) in sc.def_locations])

        # Build additional-dependencies-from-menus-and-if's string
        additional_deps_str = " " + self._expr_val_str(sc.deps_from_containing,
                                                       "(no additional dependencies)")

        #
        # Symbol-specific stuff
        #

        if isinstance(sc, Symbol):

            # Build value string
            value_str = s(sc.get_value())

            # Build ranges string
            if isinstance(sc, Symbol):
                if sc.ranges == []:
                    ranges_str = " (no ranges)"
                else:
                    ranges_str_rows = []

                    for (l, u, cond_expr) in sc.ranges:
                        if cond_expr is None:
                            ranges_str_rows.append(" [{0}, {1}]".format(s(l), s(u)))
                        else:
                            ranges_str_rows.append(" [{0}, {1}] if {2}"
                                                   .format(s(l), s(u), self._expr_val_str(cond_expr)))

                    ranges_str = "\n".join(ranges_str_rows)

            # Build default values string
            if sc.def_exprs == []:
                defaults_str = " (no default values)"
            else:
                defaults_str_rows = []

                for (val_expr, cond_expr) in sc.orig_def_exprs:
                    row_str = " " + self._expr_val_str(val_expr, "(none)", sc.type == STRING)
                    defaults_str_rows.append(row_str)
                    defaults_str_rows.append("  Condition: " + self._expr_val_str(cond_expr))

                defaults_str = "\n".join(defaults_str_rows)

            # Build selects string
            if sc.orig_selects == []:
                selects_str = " (no selects)"
            else:
                selects_str_rows = []

                for (target, cond_expr) in sc.orig_selects:
                    if cond_expr is None:
                        selects_str_rows.append(" {0}".format(target.name))
                    else:
                        selects_str_rows.append(" {0} if ".format(target.name) +
                                                self._expr_val_str(cond_expr))

                selects_str = "\n".join(selects_str_rows)

            # Build reverse dependencies string
            if sc.rev_dep == "n":
                rev_dep_str = " (no reverse dependencies)"
            else:
                rev_dep_str = " " + self._expr_val_str(sc.rev_dep)

            res = _sep_lines("Symbol " + (sc.name if sc.name is not None else "(no name)"),
                             "Type           : " + typename[sc.type],
                             "Value          : " + value_str,
                             "User value     : " + user_value_str,
                             "Visibility     : " + visibility_str,
                             "Is choice item : " + bool_str[sc.is_choice_symbol_],
                             "Is defined     : " + bool_str[sc.is_defined_],
                             "Is from env.   : " + bool_str[sc.is_from_env],
                             "Is special     : " + bool_str[sc.is_special_] + "\n")

            if sc.ranges != []:
                res += _sep_lines("Ranges:",
                                  ranges_str + "\n")

            res += _sep_lines("Prompts:",
                              prompts_str,
                              "Default values:",
                              defaults_str,
                              "Selects:",
                              selects_str,
                              "Reverse dependencies:",
                              rev_dep_str,
                              "Additional dependencies from enclosing menus and if's:",
                              additional_deps_str,
                              "Locations: " + locations_str)

            return res

        #
        # Choice-specific stuff
        #

        # Build name string (for named choices)
        if sc.name is None:
            name_str = "(no name)"
        else:
            name_str = sc.name

        # Build selected symbol string
        sel = sc.get_selection()
        if sel is None:
            sel_str = "(no selection)"
        else:
            sel_str = sel.name

        # Build mode string
        mode_str = s(sc.get_mode())

        # Build default values string
        if sc.def_exprs == []:
            defaults_str = " (no default values)"
        else:
            defaults_str_rows = []

            for (sym, cond_expr) in sc.orig_def_exprs:
                if cond_expr is None:
                    defaults_str_rows.append(" {0}".format(sym.name))
                else:
                    defaults_str_rows.append(" {0} if ".format(sym.name) +
                                             self._expr_val_str(cond_expr))

            defaults_str = "\n".join(defaults_str_rows)

        # Build contained symbols string
        names = [sym.name for sym in sc.get_symbols()]

        if names == []:
            syms_string = "(empty)"
        else:
            syms_string = " ".join(names)

        return _sep_lines("Choice",
                          "Name (for named choices): " + name_str,
                          "Type            : " + typename[sc.type],
                          "Selected symbol : " + sel_str,
                          "User value      : " + user_value_str,
                          "Mode            : " + mode_str,
                          "Visibility      : " + visibility_str,
                          "Optional        : " + bool_str[sc.optional],
                          "Prompts:",
                          prompts_str,
                          "Defaults:",
                          defaults_str,
                          "Choice symbols:",
                          " " + syms_string,
                          "Additional dependencies from enclosing menus and if's:",
                          additional_deps_str,
                          "Locations: " + locations_str)

    def _expr_depends_on(self, expr, sym):
        """Reimplementation of expr_depends_symbol() from mconf.c. Used to
        determine if a submenu should be implicitly created, which influences what
        items inside choice statements are considered choice items."""
        if expr is None:
            return False

        def rec(expr):
            if isinstance(expr, str):
                return False

            if isinstance(expr, Symbol):
                return expr is sym

            e0 = expr[0]

            if e0 == EQUAL or e0 == UNEQUAL:
                return self._eq_to_sym(expr) is sym

            if e0 == AND:
                for and_expr in expr[1]:
                    if rec(and_expr):
                        return True

            return False

        return rec(expr)

    def _eq_to_sym(self, eq):
        """_expr_depends_on() helper. For (in)equalities of the form sym = y/m
        or sym != n, returns sym. For other (in)equalities, returns None."""
        relation, left, right = eq

        left  = self._transform_n_m_y(left)
        right = self._transform_n_m_y(right)

        # Make sure the symbol (if any) appears to the left
        if not isinstance(left, Symbol):
            left, right = right, left

        if not isinstance(left, Symbol):
            return None

        if (relation == EQUAL   and (right == "m" or right == "y")) or \
           (relation == UNEQUAL and right == "n"):
            return left

        return None

    def _transform_n_m_y(self, item):
        """_eq_to_sym() helper. Translates the symbols n, m, and y to their
        string equivalents."""
        if item is self.n:
            return "n"
        if item is self.m:
            return "m"
        if item is self.y:
            return "y"
        return item

    def _warn(self, msg, filename = None, linenr = None):
        """For printing warnings to stderr."""
        if self.print_warnings:
            self._warn_or_undef_assign(msg, WARNING, filename, linenr)

    def _undef_assign(self, msg, filename = None, linenr = None):
        """For printing informational messages related to assignments
        to undefined variables to stderr."""
        if self.print_undef_assign:
            self._warn_or_undef_assign(msg, UNDEF_ASSIGN, filename, linenr)

    def _warn_or_undef_assign(self, msg, msg_type, filename, linenr):
        if filename is not None:
            sys.stderr.write("{0}:".format(_clean_up_path(filename)))
        if linenr is not None:
            sys.stderr.write("{0}:".format(linenr))

        if msg_type == WARNING:
            sys.stderr.write("warning: ")
        elif msg_type == UNDEF_ASSIGN:
            sys.stderr.write("info: ")
        else:
            _internal_error('Internal error while printing warning: unknown warning type "{0}".'
                            .format(msg_type))

        sys.stderr.write(msg + "\n")

def _get_expr_syms(expr):
    """Returns the set() of symbols appearing in expr."""
    res = set()
    if expr is None:
        return res

    def rec(expr):
        if isinstance(expr, Symbol):
            res.add(expr)
            return

        if isinstance(expr, str):
            return

        e0 = expr[0]

        if e0 == OR or e0 == AND:
            for term in expr[1]:
                rec(term)

        elif e0 == NOT:
            rec(expr[1])

        elif e0 == EQUAL or e0 == UNEQUAL:
            _, v1, v2 = expr

            if isinstance(v1, Symbol):
                res.add(v1)

            if isinstance(v2, Symbol):
                res.add(v2)

        else:
            _internal_error("Internal error while fetching symbols from an "
                            "expression with token stream {0}.".format(expr))

    rec(expr)
    return res


#
# Construction of expressions
#

# These functions as well as the _eval_min/max() functions above equate
# None with "y", which is usually what we want, but needs to be kept in
# mind.

def _make_or(e1, e2):
    # Perform trivial simplification and avoid None's (which
    # correspond to y's)
    if e1 is None or e2 is None or \
       e1 == "y" or e2 == "y":
        return "y"

    if e1 == "n":
        return e2

    if e2 == "n":
        return e1

    # Prefer to merge/update argument list if possible instead of creating
    # a new OR node

    if isinstance(e1, tuple) and e1[0] == OR:
        if isinstance(e2, tuple) and e2[0] == OR:
            return (OR, e1[1] + e2[1])
        return (OR, e1[1] + [e2])

    if isinstance(e2, tuple) and e2[0] == OR:
        return (OR, e2[1] + [e1])

    return (OR, [e1, e2])

# Note: returns None if e1 == e2 == None

def _make_and(e1, e2):
    if e1 == "n" or e2 == "n":
        return "n"

    if e1 is None or e1 == "y":
        return e2

    if e2 is None or e2 == "y":
        return e1

    # Prefer to merge/update argument list if possible instead of creating
    # a new AND node

    if isinstance(e1, tuple) and e1[0] == AND:
        if isinstance(e2, tuple) and e2[0] == AND:
            return (AND, e1[1] + e2[1])
        return (AND, e1[1] + [e2])

    if isinstance(e2, tuple) and e2[0] == AND:
        return (AND, e2[1] + [e1])

    return (AND, [e1, e2])

#
# Constants and functions related to types, parsing, evaluation and printing,
# put globally to unclutter the Config class a bit.
#

# Tokens
(T_OR, T_AND, T_NOT,
 T_OPEN_PAREN, T_CLOSE_PAREN,
 T_EQUAL, T_UNEQUAL,
 T_MAINMENU, T_MENU, T_ENDMENU,
 T_SOURCE, T_CHOICE, T_ENDCHOICE,
 T_COMMENT, T_CONFIG, T_MENUCONFIG,
 T_HELP, T_IF, T_ENDIF, T_DEPENDS, T_ON,
 T_OPTIONAL, T_PROMPT, T_DEFAULT,
 T_BOOL, T_TRISTATE, T_HEX, T_INT, T_STRING,
 T_DEF_BOOL, T_DEF_TRISTATE,
 T_SELECT, T_RANGE, T_OPTION, T_ENV,
 T_DEFCONFIG_LIST, T_MODULES, T_VISIBLE) = range(0, 38)

# Keyword to token map
keywords = {
        "mainmenu"       : T_MAINMENU,
        "menu"           : T_MENU,
        "endmenu"        : T_ENDMENU,
        "endif"          : T_ENDIF,
        "endchoice"      : T_ENDCHOICE,
        "source"         : T_SOURCE,
        "choice"         : T_CHOICE,
        "config"         : T_CONFIG,
        "comment"        : T_COMMENT,
        "menuconfig"     : T_MENUCONFIG,
        "help"           : T_HELP,
        "if"             : T_IF,
        "depends"        : T_DEPENDS,
        "on"             : T_ON,
        "optional"       : T_OPTIONAL,
        "prompt"         : T_PROMPT,
        "default"        : T_DEFAULT,
        "bool"           : T_BOOL,
        "boolean"        : T_BOOL,
        "tristate"       : T_TRISTATE,
        "int"            : T_INT,
        "hex"            : T_HEX,
        "def_bool"       : T_DEF_BOOL,
        "def_tristate"   : T_DEF_TRISTATE,
        "string"         : T_STRING,
        "select"         : T_SELECT,
        "range"          : T_RANGE,
        "option"         : T_OPTION,
        "env"            : T_ENV,
        "defconfig_list" : T_DEFCONFIG_LIST,
        "modules"        : T_MODULES,
        "visible"        : T_VISIBLE }

# Strings to use for True and False
bool_str = { False : "false", True : "true" }

# Tokens after which identifier-like lexemes are treated as strings. T_CHOICE
# is included to avoid symbols being registered for named choices.
string_lex = frozenset((T_BOOL, T_TRISTATE, T_INT, T_HEX, T_STRING, T_CHOICE,
                        T_PROMPT, T_MENU, T_COMMENT, T_SOURCE, T_MAINMENU))

# Matches the initial token on a line; see _tokenize().
initial_token_re = re.compile(r"[^\w]*(\w+)")

# Matches an identifier/keyword optionally preceded by whitespace
id_keyword_re = re.compile(r"\s*([\w./-]+)")

# Regular expressions for parsing .config files
set_re   = re.compile(r"CONFIG_(\w+)=(.*)")
unset_re = re.compile(r"# CONFIG_(\w+) is not set")

# Regular expression for finding $-references to symbols in strings
sym_ref_re = re.compile(r"\$[A-Za-z_]+")

# Integers representing symbol types
UNKNOWN, BOOL, TRISTATE, STRING, HEX, INT = range(0, 6)

# Strings to use for types
typename = {
        UNKNOWN  : "unknown",
        BOOL     : "bool",
        TRISTATE : "tristate",
        STRING   : "string",
        HEX      : "hex",
        INT      : "int" }

# Token to type mapping
token_to_type = { T_BOOL     : BOOL,
                  T_TRISTATE : TRISTATE,
                  T_STRING   : STRING,
                  T_INT      : INT,
                  T_HEX      : HEX }

# Default values for symbols of different types (the value the symbol gets if
# it is not assigned a user value and none of its 'default' clauses kick in)
default_value = { BOOL     : "n",
                  TRISTATE : "n",
                  STRING   : "",
                  INT      : "",
                  HEX      : "" }

# Indicates that no item is selected in a choice statement
NO_SELECTION = 0

# Integers representing expression types
OR, AND, NOT, EQUAL, UNEQUAL = range(0, 5)

# Map from tristate values to integers
tri_to_int = { "n" : 0, "m" : 1, "y" : 2 }

# Printing-related stuff

op_to_str = { AND     : " && ",
              OR      : " || ",
              EQUAL   : " = ",
              UNEQUAL : " != " }

precedence = { OR : 0, AND : 1, NOT : 2 }

# Types of informational messages
WARNING = 0
UNDEF_ASSIGN = 1

def _intersperse(lst, op):
    """_expr_to_str() helper. Gets the string representation of each expression in lst
    and produces a list where op has been inserted between the elements."""
    if lst == []:
        return ""

    res = []

    def handle_sub_expr(expr):
        no_parens = isinstance(expr, (str, Symbol)) or \
                    expr[0] in (EQUAL, UNEQUAL) or \
                    precedence[op] <= precedence[expr[0]]
        if not no_parens:
            res.append("(")
        res.extend(_expr_to_str_rec(expr))
        if not no_parens:
            res.append(")")

    op_str = op_to_str[op]

    handle_sub_expr(lst[0])
    for expr in lst[1:]:
        res.append(op_str)
        handle_sub_expr(expr)

    return res

def _expr_to_str(expr):
    s = "".join(_expr_to_str_rec(expr))
    return s

def _sym_str_string(sym_or_str):
    if isinstance(sym_or_str, str):
        return '"{0}"'.format(sym_or_str)
    return sym_or_str.name

def _expr_to_str_rec(expr):
    if expr is None:
        return [""]

    if isinstance(expr, (Symbol, str)):
        return [_sym_str_string(expr)]

    e0 = expr[0]

    if e0 == OR or e0 == AND:
        return _intersperse(expr[1], expr[0])

    if e0 == NOT:
        need_parens = not isinstance(expr[1], (str, Symbol))

        res = ["!"]
        if need_parens:
            res.append("(")
        res.extend(_expr_to_str_rec(expr[1]))
        if need_parens:
            res.append(")")
        return res

    if e0 == EQUAL or e0 == UNEQUAL:
        return [_sym_str_string(expr[1]),
                op_to_str[expr[0]],
                _sym_str_string(expr[2])]

class _Block:

    """Represents a list of items (symbols, menus, choice statements and
    comments) appearing at the top-level of a file or witin a menu, choice or
    if statement."""

    def __init__(self):
        self.items = []

    def get_items(self):
        return self.items

    def add_item(self, item):
        self.items.append(item)

    def _make_conf(self):
        # Collect the substrings in a list and later use join() instead of +=
        # to build the final .config contents. With older Python versions, this
        # yields linear instead of quadratic complexity.
        strings = []
        for item in self.items:
            strings.extend(item._make_conf())

        return strings

    def add_depend_expr(self, expr):
        for item in self.items:
            item.add_depend_expr(expr)

class Item():

    """Base class for symbols and other Kconfig constructs. Subclasses are
    Symbol, Choice, Menu, and Comment."""

    def is_symbol(self):
        """Returns True if the item is a symbol, otherwise False. Short for
        isinstance(item, kconfiglib.Symbol)."""
        return isinstance(self, Symbol)

    def is_choice(self):
        """Returns True if the item is a choice, otherwise False. Short for
        isinstance(item, kconfiglib.Choice)."""
        return isinstance(self, Choice)

    def is_menu(self):
        """Returns True if the item is a menu, otherwise False. Short for
        isinstance(item, kconfiglib.Menu)."""
        return isinstance(self, Menu)

    def is_comment(self):
        """Returns True if the item is a comment, otherwise False. Short for
        isinstance(item, kconfiglib.Comment)."""
        return isinstance(self, Comment)

class _HasVisibility():

    """Base class for elements that have a "visibility" that acts as an upper
    limit on the values a user can set for them. Subclasses are Symbol and
    Choice (which supply some of the attributes)."""

    def __init__(self):
        self.cached_visibility = None
        self.prompts = []

    def _invalidate(self):
        self.cached_visibility = None

    def _get_visibility(self):
        if self.cached_visibility is None:
            vis = "n"
            for (prompt, cond_expr) in self.prompts:
                vis = self.config._eval_max(vis, cond_expr)

            if isinstance(self, Symbol) and self.is_choice_symbol_:
                vis = self.config._eval_min(vis, self.parent._get_visibility())

            # Promote "m" to "y" if we're dealing with a non-tristate
            if vis == "m" and self.type != TRISTATE:
                vis = "y"

            self.cached_visibility = vis

        return self.cached_visibility

class Symbol(Item, _HasVisibility):

    """Represents a configuration symbol - e.g. FOO for

    config FOO
        ..."""

    #
    # Public interface
    #

    def get_value(self):
        """Calculate and return the value of the symbol. See also
        Symbol.set_user_value()."""

        if self.cached_value is not None:
            return self.cached_value

        self.write_to_conf = False

        # As a quirk of Kconfig, undefined symbols get their name as their
        # value. This is why things like "FOO = bar" work for seeing if FOO has
        # the value "bar".
        if self.type == UNKNOWN:
            self.cached_value = self.name
            return self.name

        new_val = default_value[self.type]

        vis = self._get_visibility()

        if self.type == BOOL or self.type == TRISTATE:
            # The visibility and mode (modules-only or single-selection) of
            # choice items will be taken into account in self._get_visibility()

            if self.is_choice_symbol_:
                if vis != "n":
                    choice = self.parent
                    mode = choice.get_mode()

                    self.write_to_conf = (mode != "n")

                    if mode == "y":
                        new_val = "y" if (choice.get_selection() is self) else "n"
                    elif mode == "m":
                        if self.user_val == "m" or self.user_val == "y":
                            new_val = "m"

            else:
                use_defaults = True

                if vis != "n":
                    # If the symbol is visible and has a user value, use that.
                    # Otherwise, look at defaults.
                    self.write_to_conf = True

                    if self.user_val is not None:
                        new_val = self.config._eval_min(self.user_val, vis)
                        use_defaults = False

                if use_defaults:
                    for (val_expr, cond_expr) in self.def_exprs:
                        cond_eval = self.config._eval_expr(cond_expr)

                        if cond_eval != "n":
                            self.write_to_conf = True
                            new_val = self.config._eval_min(val_expr, cond_eval)
                            break

                # Reverse dependencies take precedence
                rev_dep_val = self.config._eval_expr(self.rev_dep)

                if rev_dep_val != "n":
                    self.write_to_conf = True
                    new_val = self.config._eval_max(new_val, rev_dep_val)

            # Promote "m" to "y" for booleans
            if new_val == "m" and self.type == BOOL:
                new_val = "y"

        elif self.type == STRING:
            use_defaults = True

            if vis != "n":
                self.write_to_conf = True
                if self.user_val is not None:
                    new_val = self.user_val
                    use_defaults = False

            if use_defaults:
                for (val_expr, cond_expr) in self.def_exprs:
                    if self.config._eval_expr(cond_expr) != "n":
                        self.write_to_conf = True
                        new_val = self.config._get_str_value(val_expr)
                        break

        elif self.type == HEX or self.type == INT:
            has_active_range = False
            low = None
            high = None
            use_defaults = True

            base = 16 if self.type == HEX else 10

            for(l, h, cond_expr) in self.ranges:
                if self.config._eval_expr(cond_expr) != "n":
                    has_active_range = True

                    low_str = self.config._get_str_value(l)
                    high_str = self.config._get_str_value(h)

                    low = int(low_str, base) if \
                      _is_base_n(low_str, base) else 0
                    high = int(high_str, base) if \
                      _is_base_n(high_str, base) else 0

                    break

            if vis != "n":
                self.write_to_conf = True

                if self.user_val is not None and \
                   _is_base_n(self.user_val, base) and \
                   (not has_active_range or
                    low <= int(self.user_val, base) <= high):

                    # If the user value is OK, it is stored in exactly the same
                    # form as specified in the assignment (with or without
                    # "0x", etc).

                    use_defaults = False
                    new_val = self.user_val

            if use_defaults:
                for (val_expr, cond_expr) in self.def_exprs:
                    if self.config._eval_expr(cond_expr) != "n":
                        self.write_to_conf = True

                        # If the default value is OK, it is stored in exactly
                        # the same form as specified. Otherwise, it is clamped
                        # to the range, and the output has "0x" as appropriate
                        # for the type.

                        new_val = self.config._get_str_value(val_expr)

                        if _is_base_n(new_val, base):
                            new_val_num = int(new_val, base)
                            if has_active_range:
                                clamped_val = None

                                if new_val_num < low:
                                    clamped_val = low
                                elif new_val_num > high:
                                    clamped_val = high

                                if clamped_val is not None:
                                    new_val = (hex(clamped_val) if \
                                      self.type == HEX else str(clamped_val))

                            break
                else: # For the for loop
                    # If no user value or default kicks in but the hex/int has
                    # an active range, then the low end of the range is used,
                    # provided it's > 0, with "0x" prepended as appropriate.

                    if has_active_range and low > 0:
                        new_val = (hex(low) if self.type == HEX else str(low))

        self.cached_value = new_val
        return new_val

    def set_user_value(self, v):
        """Sets the user value of the symbol.

        Equal in effect to assigning the value to the symbol within a .config
        file. Use get_lower/upper_bound() or get_assignable_values() to find
        the range of currently assignable values for bool and tristate symbols;
        setting values outside this range will cause the user value to differ
        from the result of Symbol.get_value() (be truncated). Values that are
        invalid for the type (such as a_bool.set_user_value("foo")) are
        ignored, and a warning is emitted if an attempt is made to assign such
        a value.

        For any type of symbol, is_modifiable() can be used to check if a user
        value will currently have any effect on the symbol, as determined by
        its visibility and range of assignable values. Any value that is valid
        for the type (bool, tristate, etc.) will end up being reflected in
        get_user_value() though, and might have an effect later if conditions
        change. To get rid of the user value, use unset_user_value().

        Any symbols dependent on the symbol are (recursively) invalidated, so
        things will just work with regards to dependencies.

        v -- The user value to give to the symbol."""
        self._set_user_value_no_invalidate(v, False)

        # There might be something more efficient you could do here, but play
        # it safe.
        if self.name == "MODULES":
            self.config._invalidate_all()
            return

        self._invalidate()
        self._invalidate_dependent()

    def unset_user_value(self):
        """Resets the user value of the symbol, as if the symbol had never
        gotten a user value via Config.load_config() or
        Symbol.set_user_value()."""
        self._unset_user_value_no_recursive_invalidate()
        self._invalidate_dependent()

    def get_user_value(self):
        """Returns the value assigned to the symbol in a .config or via
        Symbol.set_user_value() (provided the value was valid for the type of the
        symbol). Returns None in case of no user value."""
        return self.user_val

    def get_name(self):
        """Returns the name of the symbol."""
        return self.name

    def get_upper_bound(self):
        """For string/hex/int symbols and for bool and tristate symbols that
        cannot be modified (see is_modifiable()), returns None.

        Otherwise, returns the highest value the symbol can be set to with
        Symbol.set_user_value() (that will not be truncated): one of "m" or "y",
        arranged from lowest to highest. This corresponds to the highest value
        the symbol could be given in e.g. the 'make menuconfig' interface.

        See also the tri_less*() and tri_greater*() functions, which could come
        in handy."""
        if self.type != BOOL and self.type != TRISTATE:
            return None
        rev_dep = self.config._eval_expr(self.rev_dep)
        # A bool selected to "m" gets promoted to "y"
        if self.type == BOOL and rev_dep == "m":
            rev_dep = "y"
        vis = self._get_visibility()
        if (tri_to_int[vis] - tri_to_int[rev_dep]) > 0:
            return vis
        return None

    def get_lower_bound(self):
        """For string/hex/int symbols and for bool and tristate symbols that
        cannot be modified (see is_modifiable()), returns None.

        Otherwise, returns the lowest value the symbol can be set to with
        Symbol.set_user_value() (that will not be truncated): one of "n" or "m",
        arranged from lowest to highest. This corresponds to the lowest value
        the symbol could be given in e.g. the 'make menuconfig' interface.

        See also the tri_less*() and tri_greater*() functions, which could come
        in handy."""
        if self.type != BOOL and self.type != TRISTATE:
            return None
        rev_dep = self.config._eval_expr(self.rev_dep)
        # A bool selected to "m" gets promoted to "y"
        if self.type == BOOL and rev_dep == "m":
            rev_dep = "y"
        if (tri_to_int[self._get_visibility()] - tri_to_int[rev_dep]) > 0:
            return rev_dep
        return None

    def get_assignable_values(self):
        """For string/hex/int symbols and for bool and tristate symbols that
        cannot be modified (see is_modifiable()), returns the empty list.

        Otherwise, returns a list containing the user values that can be
        assigned to the symbol (that won't be truncated). Usage example:

        if "m" in sym.get_assignable_values():
            sym.set_user_value("m")

        This is basically a more convenient interface to
        get_lower/upper_bound() when wanting to test if a particular tristate
        value can be assigned."""
        if self.type != BOOL and self.type != TRISTATE:
            return []
        rev_dep = self.config._eval_expr(self.rev_dep)
        # A bool selected to "m" gets promoted to "y"
        if self.type == BOOL and rev_dep == "m":
            rev_dep = "y"
        res = ["n", "m", "y"][tri_to_int[rev_dep] :
                              tri_to_int[self._get_visibility()] + 1]
        return res if len(res) > 1 else []

    def get_type(self):
        """Returns the type of the symbol: one of UNKNOWN, BOOL, TRISTATE,
        STRING, HEX, or INT. These are defined at the top level of the module,
        so you'd do something like

        if sym.get_type() == kconfiglib.STRING:
            ..."""
        return self.type

    def get_visibility(self):
        """Returns the visibility of the symbol: one of "n", "m" or "y". For
        bool and tristate symbols, this is an upper bound on the value users
        can set for the symbol. For other types of symbols, a visibility of "n"
        means the user value will be ignored. A visibility of "n" corresponds
        to not being visible in the 'make *config' interfaces.

        Example (assuming we're running with modules enabled -- i.e., MODULES
        set to 'y'):

        # Assume this has been assigned 'n'
        config N_SYM
            tristate "N_SYM"

        # Assume this has been assigned 'm'
        config M_SYM
            tristate "M_SYM"

        # Has visibility 'n'
        config A
            tristate "A"
            depends on N_SYM

        # Has visibility 'm'
        config B
            tristate "B"
            depends on M_SYM

        # Has visibility 'y'
        config C
            tristate "C"

        # Has no prompt, and hence visibility 'n'
        config D
            tristate

        Having visibility be tri-valued ensures that e.g. a symbol cannot be
        set to "y" by the user if it depends on a symbol with value "m", which
        wouldn't be safe.

        You should probably look at get_lower/upper_bound(),
        get_assignable_values() and is_modifiable() before using this."""
        return self._get_visibility()

    def get_parent(self):
        """Returns the menu or choice statement that contains the symbol, or
        None if the symbol is at the top level. Note that if statements are
        treated as syntactic and do not have an explicit class
        representation."""
        return self.parent

    def get_referenced_symbols(self, refs_from_enclosing = False):
        """Returns the set() of all symbols referenced by this symbol. For
        example, the symbol defined by

        config FOO
            bool
            prompt "foo" if A && B
            default C if D
            depends on E
            select F if G

        references the symbols A through G.

        refs_from_enclosing (default: False) -- If True, the symbols
                            referenced by enclosing menus and if's will be
                            included in the result."""
        return self.all_referenced_syms if refs_from_enclosing else self.referenced_syms

    def get_selected_symbols(self):
        """Returns the set() of all symbols X for which this symbol has a
        'select X' or 'select X if Y' (regardless of whether Y is satisfied or
        not). This is a subset of the symbols returned by
        get_referenced_symbols()."""
        return self.selected_syms

    def get_help(self):
        """Returns the help text of the symbol, or None if the symbol has no
        help text."""
        return self.help

    def get_config(self):
        """Returns the Config instance this symbol is from."""
        return self.config

    def get_def_locations(self):
        """Returns a list of (filename, linenr) tuples, where filename (string)
        and linenr (int) represent a location where the symbol is defined. For
        the vast majority of symbols this list will only contain one element.
        For the following Kconfig, FOO would get two entries: the lines marked
        with *.

        config FOO *
            bool "foo prompt 1"

        config FOO *
            bool "foo prompt 2"
        """
        return self.def_locations

    def get_ref_locations(self):
        """Returns a list of (filename, linenr) tuples, where filename (string)
        and linenr (int) represent a location where the symbol is referenced in
        the configuration. For example, the lines marked by * would be included
        for FOO below:

        config A
            bool
            default BAR || FOO *

        config B
            tristate
            depends on FOO *
            default m if FOO *

        if FOO *
            config A
                bool "A"
        endif

        config FOO (definition not included)
            bool
        """
        return self.ref_locations

    def is_modifiable(self):
        """Returns True if the value of the symbol could be modified by calling
        Symbol.set_user_value() and False otherwise.

        For bools and tristates, this corresponds to the symbol being visible
        in the 'make menuconfig' interface and not already being pinned to a
        specific value (e.g. because it is selected by another symbol).

        For strings and numbers, this corresponds to just being visible. (See
        Symbol.get_visibility().)"""
        if self.is_special_:
            return False
        if self.type == BOOL or self.type == TRISTATE:
            rev_dep = self.config._eval_expr(self.rev_dep)
            # A bool selected to "m" gets promoted to "y"
            if self.type == BOOL and rev_dep == "m":
                rev_dep = "y"
            return (tri_to_int[self._get_visibility()] -
                    tri_to_int[rev_dep]) > 0
        return self._get_visibility() != "n"

    def is_defined(self):
        """Returns False if the symbol is referred to in the Kconfig but never
        actually defined, otherwise True."""
        return self.is_defined_

    def is_special(self):
        """Returns True if the symbol is one of the special symbols n, m, y, or
        UNAME_RELEASE, or gets its value from the environment. Otherwise,
        returns False."""
        return self.is_special_

    def is_from_environment(self):
        """Returns True if the symbol gets its value from the environment.
        Otherwise, returns False."""
        return self.is_from_env

    def has_ranges(self):
        """Returns True if the symbol is of type INT or HEX and has ranges that
        limits what values it can take on, otherwise False."""
        return self.ranges != []

    def is_choice_symbol(self):
        """Returns True if the symbol is in a choice statement and is an actual
        choice symbol (see Choice.get_symbols()); otherwise, returns
        False."""
        return self.is_choice_symbol_

    def is_choice_selection(self):
        """Returns True if the symbol is contained in a choice statement and is
        the selected item, otherwise False. Equivalent to 'sym.is_choice_symbol()
        and sym.get_parent().get_selection() is sym'."""
        return self.is_choice_symbol_ and self.parent.get_selection() is self

    def __str__(self):
        """Returns a string containing various information about the symbol."""
        return self.config._get_sym_or_choice_str(self)

    #
    # Private methods
    #

    def __init__(self):
        """Symbol constructor -- not intended to be called directly by
        kconfiglib clients."""

        # Set default values
        _HasVisibility.__init__(self)

        self.config = None

        self.parent = None
        self.name = None
        self.type = UNKNOWN

        self.def_exprs = []
        self.ranges = []
        self.rev_dep = "n"

        # The prompt, default value and select conditions without any
        # dependencies from menus or if's propagated to them

        self.orig_prompts = []
        self.orig_def_exprs = []
        self.orig_selects = []

        # Dependencies inherited from containing menus and if's
        self.deps_from_containing = None

        self.help = None

        # The set of symbols referenced by this symbol (see
        # get_referenced_symbols())
        self.referenced_syms = set()

        # The set of symbols selected by this symbol (see
        # get_selected_symbols())
        self.selected_syms = set()

        # Like 'referenced_syms', but includes symbols from
        # dependencies inherited from enclosing menus and if's
        self.all_referenced_syms = set()

        # This is set to True for "actual" choice symbols. See
        # Choice._determine_actual_symbols(). The trailing underscore avoids a
        # collision with is_choice_symbol().
        self.is_choice_symbol_ = False

        # This records only dependencies specified with 'depends on'. Needed
        # when determining actual choice items (hrrrr...). See also
        # Choice._determine_actual_symbols().
        self.menu_dep = None

        # See Symbol.get_ref/def_locations().
        self.def_locations = []
        self.ref_locations = []

        self.user_val = None

        # Flags

        # Should the symbol get an entry in .config?
        self.write_to_conf = False

        # Caches the calculated value
        self.cached_value = None

        # Note: An instance variable 'self.dep' gets set on the Symbol in
        # Config._build_dep(), linking the symbol to the symbols that
        # immediately depend on it (in a caching/invalidation sense). The total
        # set of dependent symbols for the symbol (the transitive closure) is
        # calculated on an as-needed basis in _get_dependent().

        # Caches the total list of dependent symbols. Calculated in
        # _get_dependent().
        self.cached_deps = None

        # Does the symbol have an entry in the Kconfig file? The trailing
        # underscore avoids a collision with is_defined().
        self.is_defined_ = False

        # Does the symbol get its value in some special way, e.g. from the
        # environment or by being one of the special symbols n, m, and y? If
        # so, the value is stored in self.cached_value, which is never
        # invalidated. The trailing underscore avoids a collision with
        # is_special().
        self.is_special_ = False

        # Does the symbol get its value from the environment?
        self.is_from_env = False

    def _invalidate(self):
        if self.is_special_:
            return

        if self.is_choice_symbol_:
            self.parent._invalidate()

        _HasVisibility._invalidate(self)

        self.write_to_conf = False
        self.cached_value = None

    def _invalidate_dependent(self):
        for sym in self._get_dependent():
            sym._invalidate()

    def _set_user_value_no_invalidate(self, v, suppress_load_warnings):
        """Like set_user_value(), but does not invalidate any symbols.

        suppress_load_warnings --
          some warnings are annoying when loading a .config that can be helpful
          when manually invoking set_user_value(). This flag is set to True to
          suppress such warnings.

          Perhaps this could be made optional for load_config() instead."""

        if self.is_special_:
            if self.is_from_env:
                self.config._warn('attempt to assign the value "{0}" to the '
                                  'symbol {1}, which gets its value from the '
                                  'environment. Assignment ignored.'
                                  .format(v, self.name))
            else:
                self.config._warn('attempt to assign the value "{0}" to the '
                                  'special symbol {1}. Assignment ignored.'
                                  .format(v, self.name))

            return


        if not self.is_defined_:
            filename, linenr = self.ref_locations[0]

            self.config._undef_assign('attempt to assign the value "{0}" to {1}, '
                                      "which is referenced at {2}:{3} but never "
                                      "defined. Assignment ignored."
                                      .format(v, self.name, filename, linenr))
            return

        # Check if the value is valid for our type

        if not (( self.type == BOOL     and (v == "n" or v == "y")    ) or
                ( self.type == TRISTATE and (v == "n" or v == "m" or
                                             v == "y")                ) or
                ( self.type == STRING                                 ) or
                ( self.type == INT      and _is_base_n(v, 10)         ) or
                ( self.type == HEX      and _is_base_n(v, 16)         )):

            self.config._warn('the value "{0}" is invalid for {1}, which has type {2}. '
                              "Assignment ignored."
                              .format(v, self.name, typename[self.type]))
            return

        if self.prompts == [] and not suppress_load_warnings:
            self.config._warn('assigning "{0}" to the symbol {1} which '
                              'lacks prompts and thus has visibility "n". '
                              'The assignment will have no effect.'
                              .format(v, self.name))

        self.user_val = v

        if self.is_choice_symbol_ and (self.type == BOOL or
                                       self.type == TRISTATE):
            choice = self.parent
            if v == "y":
                choice.user_val = self
                choice.user_mode = "y"
            elif v == "m":
                choice.user_val = None
                choice.user_mode = "m"

    def _unset_user_value_no_recursive_invalidate(self):
        self._invalidate()
        self.user_val = None

        if self.is_choice_symbol_:
            self.parent._unset_user_value()

    def _make_conf(self):
        if self.already_written:
            return []

        self.already_written = True

        # Note: write_to_conf is determined in get_value()
        val = self.get_value()
        if not self.write_to_conf:
            return []

        if self.type == BOOL or self.type == TRISTATE:
            if val == "m" or val == "y":
                return ["CONFIG_{0}={1}".format(self.name, val)]
            return ["# CONFIG_{0} is not set".format(self.name)]

        elif self.type == STRING:
            # Escape \ and "
            return ['CONFIG_{0}="{1}"'
                    .format(self.name,
                            val.replace("\\", "\\\\").replace('"', '\\"'))]

        elif self.type == INT or self.type == HEX:
            return ["CONFIG_{0}={1}".format(self.name, val)]

        else:
            _internal_error('Internal error while creating .config: unknown type "{0}".'
                            .format(self.type))

    def _get_dependent(self):
        """Returns the set of symbols that should be invalidated if the value
        of the symbol changes, because they might be affected by the change.
        Note that this is an internal API -- it's probably of limited
        usefulness to clients."""
        if self.cached_deps is not None:
            return self.cached_deps

        res = set()

        self._add_dependent_ignore_siblings(res)
        if self.is_choice_symbol_:
            for s in self.parent.get_symbols():
                if s is not self:
                    res.add(s)
                    s._add_dependent_ignore_siblings(res)

        self.cached_deps = res
        return res

    def _add_dependent_ignore_siblings(self, to):
        """Calculating dependencies gets a bit tricky for choice items as they
        all depend on each other, potentially leading to infinite recursion.
        This helper function calculates dependencies ignoring the other symbols
        in the choice. It also works fine for symbols that are not choice
        items."""
        for s in self.dep:
            to.add(s)
            to |= s._get_dependent()

    def _has_auto_menu_dep_on(self, on):
        """See Choice._determine_actual_symbols()."""
        if not isinstance(self.parent, Choice):
            _internal_error("Attempt to determine auto menu dependency for symbol ouside of choice.")

        if self.prompts == []:
            # If we have no prompt, use the menu dependencies instead (what was
            # specified with 'depends on')
            return self.menu_dep is not None and \
                   self.config._expr_depends_on(self.menu_dep, on)

        for (_, cond_expr) in self.prompts:
            if self.config._expr_depends_on(cond_expr, on):
                return True

        return False

class Menu(Item):

    """Represents a menu statement."""

    #
    # Public interface
    #

    def get_config(self):
        """Return the Config instance this menu is from."""
        return self.config

    def get_visibility(self):
        """Returns the visibility of the menu. This also affects the visibility
        of subitems. See also Symbol.get_visibility()."""
        return self.config._eval_expr(self.dep_expr)

    def get_visible_if_visibility(self):
        """Returns the visibility the menu gets from its 'visible if'
        condition. "y" if the menu has no 'visible if' condition."""
        return self.config._eval_expr(self.visible_if_expr)

    def get_items(self, recursive = False):
        """Returns a list containing the items (symbols, menus, choice
        statements and comments) in in the menu, in the same order that the
        items appear within the menu.

        recursive (default: False) -- True if items contained in items within
                                      the menu should be included
                                      recursively (preorder)."""

        if not recursive:
            return self.block.get_items()

        res = []
        for item in self.block.get_items():
            res.append(item)
            if isinstance(item, Menu):
                res.extend(item.get_items(True))
            elif isinstance(item, Choice):
                res.extend(item.get_items())
        return res

    def get_symbols(self, recursive = False):
        """Returns a list containing the symbols in the menu, in the same order
        that they appear within the menu.

        recursive (default: False) -- True if symbols contained in items within
                                      the menu should be included
                                      recursively."""

        return [item for item in self.get_items(recursive) if isinstance(item, Symbol)]

    def get_title(self):
        """Returns the title text of the menu."""
        return self.title

    def get_parent(self):
        """Returns the menu or choice statement that contains the menu, or
        None if the menu is at the top level. Note that if statements are
        treated as syntactic sugar and do not have an explicit class
        representation."""
        return self.parent

    def get_referenced_symbols(self, refs_from_enclosing = False):
        """See Symbol.get_referenced_symbols()."""
        return self.all_referenced_syms if refs_from_enclosing else self.referenced_syms

    def get_location(self):
        """Returns the location of the menu as a (filename, linenr) tuple,
        where filename is a string and linenr an int."""
        return (self.filename, self.linenr)

    def __str__(self):
        """Returns a string containing various information about the menu."""
        depends_on_str = self.config._expr_val_str(self.orig_deps,
                                                   "(no dependencies)")
        visible_if_str = self.config._expr_val_str(self.visible_if_expr,
                                                   "(no dependencies)")

        additional_deps_str = " " + self.config._expr_val_str(self.deps_from_containing,
                                                              "(no additional dependencies)")

        return _sep_lines("Menu",
                          "Title                     : " + self.title,
                          "'depends on' dependencies : " + depends_on_str,
                          "'visible if' dependencies : " + visible_if_str,
                          "Additional dependencies from enclosing menus and if's:",
                          additional_deps_str,
                          "Location: {0}:{1}".format(self.filename, self.linenr))

    #
    # Private methods
    #

    def __init__(self):
        """Menu constructor -- not intended to be called directly by
        kconfiglib clients."""

        self.config = None

        self.parent = None
        self.title = None
        self.block = None
        self.dep_expr = None

        # Dependency expression without dependencies from enclosing menus and
        # if's propagated
        self.orig_deps = None

        # Dependencies inherited from containing menus and if's
        self.deps_from_containing = None

        # The 'visible if' expression
        self.visible_if_expr = None

        # The set of symbols referenced by this menu (see
        # get_referenced_symbols())
        self.referenced_syms = set()

        # Like 'referenced_syms', but includes symbols from
        # dependencies inherited from enclosing menus and if's
        self.all_referenced_syms = None

        self.filename = None
        self.linenr = None

    def _make_conf(self):
        item_conf = self.block._make_conf()

        if self.config._eval_expr(self.dep_expr) != "n" and \
           self.config._eval_expr(self.visible_if_expr) != "n":
            return ["\n#\n# {0}\n#".format(self.title)] + item_conf
        return item_conf

class Choice(Item, _HasVisibility):

    """Represents a choice statement. A choice can be in one of three modes:

    "n" - The choice is not visible and no symbols can be selected.

    "m" - Any number of symbols can be set to "m". The rest will be "n". This
          is safe since potentially conflicting options don't actually get
          compiled into the kernel simultaneously with "m".

    "y" - One symbol will be "y" while the rest are "n".

    Only tristate choices can be in "m" mode, and the visibility of the choice
    is an upper bound on the mode, so that e.g. a choice that depends on a
    symbol with value "m" will be in "m" mode.

    The mode changes automatically when a value is assigned to a symbol within
    the choice.

    See Symbol.get_visibility() too."""

    #
    # Public interface
    #

    def get_selection(self):
        """Returns the symbol selected (either by the user or through
        defaults), or None if either no symbol is selected or the mode is not
        "y"."""
        if self.cached_selection is not None:
            if self.cached_selection == NO_SELECTION:
                return None
            return self.cached_selection

        if self.get_mode() != "y":
            return self._cache_ret(None)

        # User choice available?
        if self.user_val is not None and \
           self.user_val._get_visibility() == "y":
            return self._cache_ret(self.user_val)

        if self.optional:
            return self._cache_ret(None)

        return self._cache_ret(self.get_selection_from_defaults())

    def get_selection_from_defaults(self):
        """Like Choice.get_selection(), but acts as if no symbol has been
        selected by the user and no 'optional' flag is in effect."""

        if self.actual_symbols == []:
            return None

        for (symbol, cond_expr) in self.def_exprs:
            if self.config._eval_expr(cond_expr) != "n":
                chosen_symbol = symbol
                break
        else:
            chosen_symbol = self.actual_symbols[0]

        # Is the chosen symbol visible?
        if chosen_symbol._get_visibility() != "n":
            return chosen_symbol
        # Otherwise, pick the first visible symbol
        for sym in self.actual_symbols:
            if sym._get_visibility() != "n":
                return sym
        return None

    def get_user_selection(self):
        """If the choice is in "y" mode and has a user-selected symbol, returns
        that symbol. Otherwise, returns None."""
        return self.user_val

    def get_config(self):
        """Returns the Config instance this choice is from."""
        return self.config

    def get_name(self):
        """For named choices, returns the name. Returns None for unnamed
        choices. No named choices appear anywhere in the kernel Kconfig files
        as of Linux 3.7.0-rc8."""
        return self.name

    def get_help(self):
        """Returns the help text of the choice, or None if the choice has no
        help text."""
        return self.help

    def get_type(self):
        """Returns the type of the choice. See Symbol.get_type()."""
        return self.type

    def get_items(self):
        """Gets all items contained in the choice in the same order as within
        the configuration ("items" instead of "symbols" since choices and
        comments might appear within choices. This only happens in one place as
        of Linux 3.7.0-rc8, in drivers/usb/gadget/Kconfig)."""
        return self.block.get_items()

    def get_symbols(self):
        """Returns a list containing the choice's symbols.

        A quirk (perhaps a bug) of Kconfig is that you can put items within a
        choice that will not be considered members of the choice insofar as
        selection is concerned. This happens for example if one symbol within a
        choice 'depends on' the symbol preceding it, or if you put non-symbol
        items within choices.

        As of Linux 3.7.0-rc8, this seems to be used intentionally in one
        place: drivers/usb/gadget/Kconfig.

        This function returns the "proper" symbols of the choice in the order
        they appear in the choice, excluding such items. If you want all items
        in the choice, use get_items()."""
        return self.actual_symbols

    def get_parent(self):
        """Returns the menu or choice statement that contains the choice, or
        None if the choice is at the top level. Note that if statements are
        treated as syntactic sugar and do not have an explicit class
        representation."""
        return self.parent

    def get_referenced_symbols(self, refs_from_enclosing = False):
        """See Symbol.get_referenced_symbols()."""
        return self.all_referenced_syms if refs_from_enclosing else self.referenced_syms

    def get_def_locations(self):
        """Returns a list of (filename, linenr) tuples, where filename (string)
        and linenr (int) represent a location where the choice is defined. For
        the vast majority of choices (all of them as of Linux 3.7.0-rc8) this
        list will only contain one element, but its possible for named choices
        to be defined in multiple locations."""
        return self.def_locations

    def get_visibility(self):
        """Returns the visibility of the choice statement: one of "n", "m" or
        "y". This acts as an upper limit on the mode of the choice (though bool
        choices can only have the mode "y"). See the class documentation for an
        explanation of modes."""
        return self._get_visibility()

    def get_mode(self):
        """Returns the mode of the choice. See the class documentation for
        an explanation of modes."""
        minimum_mode = "n" if self.optional else "m"
        mode = self.user_mode if self.user_mode is not None else minimum_mode
        mode = self.config._eval_min(mode, self._get_visibility())

        # Promote "m" to "y" for boolean choices
        if mode == "m" and self.type == BOOL:
            return "y"

        return mode

    def is_optional(self):
        """Returns True if the symbol has the optional flag set (and so will default
        to "n" mode). Otherwise, returns False."""
        return self.optional

    def __str__(self):
        """Returns a string containing various information about the choice
        statement."""
        return self.config._get_sym_or_choice_str(self)

    #
    # Private methods
    #

    def __init__(self):
        """Choice constructor -- not intended to be called directly by
        kconfiglib clients."""

        _HasVisibility.__init__(self)

        self.config = None

        self.parent = None
        self.name = None # Yes, choices can be named
        self.type = UNKNOWN
        self.def_exprs = []
        self.help = None
        self.optional = False
        self.block = None

        # The prompts and default values without any dependencies from
        # enclosing menus or if's propagated

        self.orig_prompts = []
        self.orig_def_exprs = []

        # Dependencies inherited from containing menus and if's
        self.deps_from_containing = None

        # We need to filter out symbols that appear within the choice block but
        # are not considered choice items (see
        # Choice._determine_actual_symbols()) This list holds the "actual" choice
        # items.
        self.actual_symbols = []

        # The set of symbols referenced by this choice (see
        # get_referenced_symbols())
        self.referenced_syms = set()

        # Like 'referenced_syms', but includes symbols from
        # dependencies inherited from enclosing menus and if's
        self.all_referenced_syms = set()

        # See Choice.get_def_locations()
        self.def_locations = []

        self.user_val = None
        self.user_mode = None

        self.cached_selection = None

    def _determine_actual_symbols(self):
        """If a symbol's visibility depends on the preceding symbol within a
        choice, it is no longer viewed as a choice item (quite possibly a bug,
        but some things consciously use it.. ugh. It stems from automatic
        submenu creation). In addition, it's possible to have choices and
        comments within choices, and those shouldn't be considered as choice
        items either. Only drivers/usb/gadget/Kconfig seems to depend on any of
        this. This method computes the "actual" items in the choice and sets
        the is_choice_symbol_ flag on them (retrieved via is_choice_symbol()).

        Don't let this scare you: an earlier version simply checked for a
        sequence of symbols where all symbols after the first appeared in the
        'depends on' expression of the first, and that worked fine.  The added
        complexity is to be future-proof in the event that
        drivers/usb/gadget/Kconfig turns even more sinister. It might very well
        be overkilling things (especially if that file is refactored ;)."""

        items = self.block.get_items()

        # Items might depend on each other in a tree structure, so we need a
        # stack to keep track of the current tentative parent
        stack = []

        for item in items:
            if not isinstance(item, Symbol):
                stack = []
                continue

            while stack != []:
                if item._has_auto_menu_dep_on(stack[-1]):
                    # The item should not be viewed as a choice item, so don't
                    # set item.is_choice_symbol_.
                    stack.append(item)
                    break
                else:
                    stack.pop()
            else:
                item.is_choice_symbol_ = True
                self.actual_symbols.append(item)
                stack.append(item)

    def _cache_ret(self, selection):
        # As None is used to indicate the lack of a cached value we can't use
        # that to cache the fact that the choice has no selection. Instead, we
        # use the symbolic constant NO_SELECTION.
        if selection is None:
            self.cached_selection = NO_SELECTION
        else:
            self.cached_selection = selection

        return selection

    def _invalidate(self):
        _HasVisibility._invalidate(self)
        self.cached_selection = None

    def _unset_user_value(self):
        self._invalidate()
        self.user_val = None
        self.user_mode = None

    def _make_conf(self):
        return self.block._make_conf()

class Comment(Item):

    """Represents a comment statement."""

    #
    # Public interface
    #

    def get_config(self):
        """Returns the Config instance this comment is from."""
        return self.config

    def get_visibility(self):
        """Returns the visibility of the comment. See also
        Symbol.get_visibility()."""
        return self.config._eval_expr(self.dep_expr)

    def get_text(self):
        """Returns the text of the comment."""
        return self.text

    def get_parent(self):
        """Returns the menu or choice statement that contains the comment, or
        None if the comment is at the top level. Note that if statements are
        treated as syntactic sugar and do not have an explicit class
        representation."""
        return self.parent

    def get_referenced_symbols(self, refs_from_enclosing = False):
        """See Symbol.get_referenced_symbols()."""
        return self.all_referenced_syms if refs_from_enclosing else self.referenced_syms

    def get_location(self):
        """Returns the location of the comment as a (filename, linenr) tuple,
        where filename is a string and linenr an int."""
        return (self.filename, self.linenr)

    def __str__(self):
        """Returns a string containing various information about the comment."""
        dep_str = self.config._expr_val_str(self.orig_deps, "(no dependencies)")

        additional_deps_str = " " + self.config._expr_val_str(self.deps_from_containing,
                                                              "(no additional dependencies)")

        return _sep_lines("Comment",
                          "Text: "         + str(self.text),
                          "Dependencies: " + dep_str,
                          "Additional dependencies from enclosing menus and if's:",
                          additional_deps_str,
                          "Location: {0}:{1}".format(self.filename, self.linenr))

    #
    # Private methods
    #

    def __init__(self):
        """Comment constructor -- not intended to be called directly by
        kconfiglib clients."""

        self.config = None

        self.parent = None
        self.text = None
        self.dep_expr = None

        # Dependency expression without dependencies from enclosing menus and
        # if's propagated
        self.orig_deps = None

        # Dependencies inherited from containing menus and if's
        self.deps_from_containing = None

        # The set of symbols referenced by this comment (see
        # get_referenced_symbols())
        self.referenced_syms = set()

        # Like 'referenced_syms', but includes symbols from
        # dependencies inherited from enclosing menus and if's
        self.all_referenced_syms = None

        self.filename = None
        self.linenr = None

    def _make_conf(self):
        if self.config._eval_expr(self.dep_expr) != "n":
            return ["\n#\n# {0}\n#".format(self.text)]
        return []

class _Feed:

    """Class for working with sequences in a stream-like fashion; handy for tokens."""

    def __init__(self, items):
        self.items = items
        self.length = len(self.items)
        self.i = 0

    def get_next(self):
        if self.i >= self.length:
            return None

        item = self.items[self.i]
        self.i += 1
        return item

    def peek_next(self):
        return None if self.i >= self.length else self.items[self.i]

    def go_to_start(self):
        self.i = 0

    def __getitem__(self, index):
        return self.items[index]

    def __len__(self):
        return len(self.items)

    def is_empty(self):
        return self.items == []

    def check(self, token):
        """Check if the next token is 'token'. If so, remove it from the token
        feed and return True. Otherwise, leave it in and return False."""
        if self.i >= self.length:
            return None

        if self.items[self.i] == token:
            self.i += 1
            return True

        return False

    def remove_while(self, pred):
        while self.i < self.length and pred(self.items[self.i]):
            self.i += 1

    def go_back(self):
        if self.i <= 0:
            _internal_error("Attempt to move back in Feed while already at the beginning.")
        self.i -= 1

class _FileFeed(_Feed):

    """Feed subclass that keeps track of the current filename and line
    number."""

    def __init__(self, lines, filename):
        self.filename = _clean_up_path(filename)
        _Feed.__init__(self, lines)

    def get_filename(self):
        return self.filename

    def get_linenr(self):
        return self.i

#
# Misc. public global utility functions
#

def tri_less(v1, v2):
    """Returns True if the tristate v1 is less than the tristate v2, where "n",
    "m" and "y" are ordered from lowest to highest. Otherwise, returns
    False."""
    return tri_to_int[v1] < tri_to_int[v2]

def tri_less_eq(v1, v2):
    """Returns True if the tristate v1 is less than or equal to the tristate
    v2, where "n", "m" and "y" are ordered from lowest to highest. Otherwise,
    returns False."""
    return tri_to_int[v1] <= tri_to_int[v2]

def tri_greater(v1, v2):
    """Returns True if the tristate v1 is greater than the tristate v2, where
    "n", "m" and "y" are ordered from lowest to highest. Otherwise, returns
    False."""
    return tri_to_int[v1] > tri_to_int[v2]

def tri_greater_eq(v1, v2):
    """Returns True if the tristate v1 is greater than or equal to the tristate
    v2, where "n", "m" and "y" are ordered from lowest to highest. Otherwise,
    returns False."""
    return tri_to_int[v1] >= tri_to_int[v2]

#
# Helper functions, mostly related to text processing
#

def _strip_quotes(s, line, filename, linenr):
    """Removes any quotes surrounding 's' if it has them; otherwise returns 's'
    unmodified."""
    s = s.strip()
    if not s:
        return ""
    if s[0] == '"' or s[0] == "'":
        if len(s) < 2 or s[-1] != s[0]:
            _parse_error(line,
                         "malformed string literal",
                         filename,
                         linenr)
        return s[1:-1]
    return s

def _indentation(line):
    """Returns the indentation of the line, treating tab stops as being spaced
    8 characters apart."""
    if line.isspace():
        _internal_error("Attempt to take indentation of blank line.")
    indent = 0
    for c in line:
        if c == " ":
            indent += 1
        elif c == "\t":
            # Go to the next tab stop
            indent = (indent + 8) & ~7
        else:
            return indent

def _deindent(line, indent):
    """Deindent 'line' by 'indent' spaces."""
    line = line.expandtabs()
    if len(line) <= indent:
        return line
    return line[indent:]

def _is_base_n(s, n):
    try:
        int(s, n)
        return True
    except ValueError:
        return False

def _sep_lines(*args):
    """Returns a string comprised of all arguments, with newlines inserted
    between them."""
    return "\n".join(args)

def _comment(s):
    """Returns a new string with "#" inserted before each line in 's'."""
    if not s:
        return "#"
    res = "".join(["#" + line for line in s.splitlines(True)])
    if s.endswith("\n"):
        return res + "#"
    return res

def _get_lines(filename):
    """Returns a list of lines from 'filename', joining any line ending in \\
    with the following line."""
    with open(filename, "r") as f:
        lines = []
        accum = ""
        while 1:
            line = f.readline()

            if line == "":
                return lines

            if line.endswith("\\\n"):
                accum += line[:-2]
            else:
                accum += line
                lines.append(accum)
                accum = ""

def _strip_trailing_slash(path):
    """Removes any trailing slash from 'path'."""
    return path[:-1] if path.endswith("/") else path

def _clean_up_path(path):
    """Strips any initial "./" and trailing slash from 'path'."""
    if path.startswith("./"):
        path = path[2:]
    return _strip_trailing_slash(path)

#
# Error handling
#

class Kconfig_Syntax_Error(Exception):
    """Exception raised for syntax errors."""
    pass

class Internal_Error(Exception):
    """Exception raised for internal errors."""
    pass

def _tokenization_error(s, index, filename, linenr):
    if filename is not None:
        assert linenr is not None
        sys.stderr.write("{0}:{1}:\n".format(filename, linenr))

    if s.endswith("\n"):
        s = s[:-1]

    # Calculate the visual offset corresponding to index 'index' in 's'
    # assuming tabstops are spaced 8 characters apart
    vis_index = 0
    for c in s[:index]:
        if c == "\t":
            vis_index = (vis_index + 8) & ~7
        else:
            vis_index += 1

    # Don't output actual tabs to be independent of how the terminal renders
    # them
    s = s.expandtabs()

    raise Kconfig_Syntax_Error, (
        _sep_lines("Error during tokenization at location indicated by caret.\n",
                   s,
                   " " * vis_index + "^\n"))

def _parse_error(s, msg, filename, linenr):
    error_str = ""

    if filename is not None:
        assert linenr is not None
        error_str += "{0}:{1}: ".format(filename, linenr)

    if s.endswith("\n"):
        s = s[:-1]

    error_str += 'Error while parsing "{0}"'.format(s) + \
      ("." if msg is None else ": " + msg)

    raise Kconfig_Syntax_Error, error_str

def _internal_error(msg):
    msg += "\nSorry! You may want to send an email to kconfiglib@gmail.com " \
           "to tell me about this. Include the message above and the stack " \
           "trace and describe what you were doing."

    raise Internal_Error, msg

if use_psyco:
    import psyco

    Config._tokenize  = psyco.proxy(Config._tokenize)
    Config._eval_expr = psyco.proxy(Config._eval_expr)

    _indentation = psyco.proxy(_indentation)
    _get_lines   = psyco.proxy(_get_lines)

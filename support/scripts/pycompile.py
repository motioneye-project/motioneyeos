#!/usr/bin/env python

# Wrapper for python2 and python3 around compileall to raise exception
# when a python byte code generation failed.
#
# Inspired from:
#   http://stackoverflow.com/questions/615632/how-to-detect-errors-from-compileall-compile-dir

from __future__ import print_function
import sys
import py_compile
import compileall

class ReportProblem:
    def __nonzero__(self):
        type, value, traceback = sys.exc_info()
        if type is not None and issubclass(type, py_compile.PyCompileError):
            print("Cannot compile %s" %value.file)
            raise value
        return 1

report_problem = ReportProblem()

compileall.compile_dir(sys.argv[1], quiet=report_problem)

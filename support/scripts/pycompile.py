#!/usr/bin/env python

'''Wrapper for python2 and python3 around compileall to raise exception
when a python byte code generation failed.

Inspired from:
   http://stackoverflow.com/questions/615632/how-to-detect-errors-from-compileall-compile-dir
'''
from __future__ import print_function
import sys
import py_compile
import compileall
import argparse


def check_for_errors(comparison):
    '''Wrap comparison operator with code checking for PyCompileError.
    If PyCompileError was raised, re-raise it again to abort execution,
    otherwise perform comparison as expected.
    '''
    def operator(self, other):
        exc_type, value, traceback = sys.exc_info()
        if exc_type is not None and issubclass(exc_type,
                                               py_compile.PyCompileError):
            print("Cannot compile %s" % value.file)
            raise value

        return comparison(self, other)

    return operator


class ReportProblem(int):
    '''Class that pretends to be an int() object but implements all of its
    comparison operators such that it'd detect being called in
    PyCompileError handling context and abort execution
    '''
    VALUE = 1

    def __new__(cls, *args, **kwargs):
        return int.__new__(cls, ReportProblem.VALUE, **kwargs)

    @check_for_errors
    def __lt__(self, other):
        return ReportProblem.VALUE < other

    @check_for_errors
    def __eq__(self, other):
        return ReportProblem.VALUE == other

    def __ge__(self, other):
        return not self < other

    def __gt__(self, other):
        return not self < other and not self == other

    def __ne__(self, other):
        return not self == other


parser = argparse.ArgumentParser(description='Compile Python source files in a directory tree.')
parser.add_argument("target", metavar='DIRECTORY',
                    help='Directory to scan')
parser.add_argument("--force", action='store_true',
                    help="Force compilation even if alread compiled")

args = parser.parse_args()

compileall.compile_dir(args.target, force=args.force, quiet=ReportProblem())

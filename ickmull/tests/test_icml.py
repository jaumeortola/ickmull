#!/usr/bin/env python
# encoding: utf-8
"""
test_icml.py

Created by Keith Fahlgren on Mon Dec 21 15:37:55 PST 2009
Copyright (c) 2009 John W Maxwell. All rights reserved.
"""

import os.path

from lxml import etree
from nose.tools import *

import ickmull.icml

class TestICML(object):
    def setup(self):
        self.testfiles_dir = os.path.join(os.path.dirname(__file__), 'files')

    def test_icml_valid(self): 
        """An ICML document should be able to be successfully validated."""
        valid_icml_fn = os.path.join(self.testfiles_dir, 'valid.icml')
        valid_icml = etree.parse(valid_icml_fn)
        assert(ickmull.icml.validate(valid_icml))

    def test_icml_not_valid(self): 
        """An improperly-formed ICML document should not be able to be successfully validated."""
        not_valid_icml_fn = os.path.join(self.testfiles_dir, 'not_valid.icml')
        not_valid = etree.parse(not_valid_icml_fn)
        assert(not(ickmull.icml.validate(not_valid)))


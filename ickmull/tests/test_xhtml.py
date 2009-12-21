#!/usr/bin/env python
# encoding: utf-8
"""
test_xhtml.py

Created by Keith Fahlgren on Mon Dec 21 15:08:24 PST 2009
Copyright (c) 2009 John W Maxwell. All rights reserved.
"""

import os.path

from lxml import etree
from nose.tools import *

def TestXHTML(object):
    def setup(self):
        self.testfiles_dir = os.path.join(os.path.dirname(__file__), 'files')
        self.xml_prod_xhtml_fn = os.path.join(self.testfiles_dir, 'XHTMLProductionStartWithTheWeb.xhtml')
        self.xml_prod_xhtml = etree.parse(self.xml_prod_xhtml_fn)

    def test_icml_output(self):
        """An XHTML document should be able to be transformed into an ICML document."""
        expected = "Document"
        icml = ickmull.xhtml.as_icml(self.xml_prod_xhtml)
        root_tag = icml.getroot().tag
        assert_equal(expected, root_tag)

    def test_icml_output_valid(self):
        """An XHTML document should be able to be transformed into an ICML document that passes validation."""
        idml_rng_fn = os.path.join(os.path.dirname(__file__), '..', 'externals', 'idml_schema', )
        icml = ickmull.xhtml.as_icml(self.xml_prod_xhtml)
        assert(icml.validate())



#!/usr/bin/env python
# encoding: utf-8
"""
test_xhtml.py

Created by Keith Fahlgren on Mon Dec 21 15:08:24 PST 2009
Copyright (c) 2009 John W Maxwell. All rights reserved.
"""

import difflib
import glob
import logging
import os.path

from lxml import etree
from nose.tools import *

import ickmull.xhtml

log = logging.getLogger(__name__)

class TestXHTML(object):
    def setup(self):
        self.testfiles_dir = os.path.join(os.path.dirname(__file__), 'files')
        self.test_xhtml_fn = os.path.join(self.testfiles_dir, 'test.html')
        self.test_xhtml = etree.parse(self.test_xhtml_fn)

    def test_xhtml_icml_output(self):
        """An XHTML document should be able to be transformed into an ICML document."""
        expected = "Document"
        icml = ickmull.xhtml.as_icml(self.test_xhtml)
        root_tag = icml.getroot().tag
        assert_equal(expected, root_tag)

    def test_xhtml_icml_output_valid(self):
        """An XHTML document should be able to be transformed into an ICML document that passes validation."""
        idml_rng_fn = os.path.join(os.path.dirname(__file__), '..', 'externals', 'idml_schema', )
        icml = ickmull.xhtml.as_icml(self.test_xhtml)
        assert(ickmull.icml.validate(icml))

    def test_xhtml_icml_output_same_smoke(self):
        """All XHTML documents collected for smoketesting should be able to be transformed into an ICML document that matches the saved version."""
        smoketests_dir = os.path.join(self.testfiles_dir, 'smoketests')
        for xhtml_fn in glob.glob(smoketests_dir + '/*.html'):
            xhtml_docname, _ = os.path.splitext(os.path.basename(xhtml_fn))
            expected_icml_fn = os.path.join(smoketests_dir, xhtml_docname + '.icml')
            expected_icml = etree.parse(expected_icml_fn)

            log.debug('\nSmoke testing ICML similarity of %s' % xhtml_docname)
            xhtml = etree.parse(xhtml_fn)
            icml = ickmull.xhtml.as_icml(xhtml)
            try:
                assert_equal(etree.tostring(expected_icml), etree.tostring(icml))
            except AssertionError:
                # This is an absurd oneliner to keep the nose detailed-errors
                # output small
                diff = '\n'.join(list(difflib.unified_diff(etree.tostring(expected_icml, pretty_print=True).splitlines(),
                                                           etree.tostring(icml, pretty_print=True).splitlines())))
                raise AssertionError('XML documents did not match. Diff:\n%s' % diff)

    def test_xhtml_icml_output_valid_smoke(self):
        """All XHTML documents collected for smoketesting should be able to be transformed into an ICML document that passes validation."""
        smoketests_dir = os.path.join(self.testfiles_dir, 'smoketests')
        for xhtml_fn in glob.glob(smoketests_dir + '/*.html'):
            log.debug('\nSmoke testing validation of %s' % xhtml_fn)
            xhtml = etree.parse(xhtml_fn)
            icml = ickmull.xhtml.as_icml(self.test_xhtml)
            assert(ickmull.icml.validate(icml))


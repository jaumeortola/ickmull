#!/usr/bin/env python
# encoding: utf-8
"""
test_xhtml.py

Created by Keith Fahlgren on Mon Dec 21 15:08:24 PST 2009
Copyright (c) 2009 John W Maxwell. All rights reserved.
"""

import StringIO


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

    def test_xhtml_three_footnote_warning(self):
        """An XHTML document with many-paragraph footnotes should not be able to be transformed into an ICML document without warning the user."""
        three_para_footnote_xhtml_fn = os.path.join(self.testfiles_dir, 'smoketests', 'ThreeParagraphFootnoteTest.html')
        three_para_footnote_xhtml = etree.parse(three_para_footnote_xhtml_fn)
        warning_log_output = StringIO.StringIO()
        warning_log = logging.getLogger('ickmull.xhtml')
        warning_log_handler = logging.StreamHandler(warning_log_output)
        warning_log_handler.setLevel(logging.DEBUG)
        warning_log_handler.setFormatter(logging.Formatter('%(name)-12s: %(levelname)-8s %(message)s'))
        warning_log.addHandler(warning_log_handler)
        icml = ickmull.xhtml.as_icml(three_para_footnote_xhtml)
        warning_log_handler.flush()
        output = warning_log_output.getvalue()
        assert('more than 2' in output)

    def test_xhtml_icml_output_same_smoke(self):
        """All XHTML documents collected for smoketesting should be able to be transformed into an ICML document that matches the saved version."""
        smoketests_dir = os.path.join(self.testfiles_dir, 'smoketests')
        for xhtml_fn in glob.glob(smoketests_dir + '/*.html'):
            xhtml_docname, _ = os.path.splitext(os.path.basename(xhtml_fn))
            expected_icml_fn = os.path.join(smoketests_dir, xhtml_docname + '.icml')
            expected_icml = etree.parse(expected_icml_fn)

            xhtml = etree.parse(xhtml_fn)
            icml = ickmull.xhtml.as_icml(xhtml)
            try:
                assert_equal(etree.tostring(expected_icml), etree.tostring(icml))
            except AssertionError:
                # This is an absurd oneliner to keep the nose detailed-errors
                # output small
                diff = '\n'.join(list(difflib.unified_diff(etree.tostring(expected_icml, pretty_print=True).splitlines(),
                                                           etree.tostring(icml, pretty_print=True).splitlines())))
                raise AssertionError('XML documents for %s did not match. Diff:\n%s' % (xhtml_docname, diff))

    def test_xhtml_icml_output_valid_smoke(self):
        """All XHTML documents collected for smoketesting should be able to be transformed into an ICML document that passes validation."""
        smoketests_dir = os.path.join(self.testfiles_dir, 'smoketests')
        for xhtml_fn in glob.glob(smoketests_dir + '/*.html'):
            log.debug('\nSmoke testing validation of %s' % xhtml_fn)
            xhtml = etree.parse(xhtml_fn)
            icml = ickmull.xhtml.as_icml(self.test_xhtml)
            assert(ickmull.icml.validate(icml))


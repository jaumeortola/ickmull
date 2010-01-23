# encoding: utf-8
"""
xhtml.py

Created by Keith Fahlgren on Mon Dec 21 15:08:24 PST 2009
Copyright (c) 2009 John W Maxwell. All rights reserved.
"""

import logging
import os.path

from lxml import etree

log = logging.getLogger(__name__)

XHTML_TO_ICML = os.path.join(os.path.dirname(__file__), 'externals', 'xslt', 'tkbr2icml.xsl')

def as_icml(xhtml):
    """Convert the supplied XHTML (etree) document to InDesign's ICML format. Returns the 
       result as another etree document, ready for serialization.""" 
    icml_transformer = etree.XSLT(etree.parse(XHTML_TO_ICML))
    icml = icml_transformer(xhtml)
    errors = icml_transformer.error_log
    if str(errors).strip() != '':
        log.warn(errors)
    return icml




# encoding: utf-8
"""
icml.py

Created by Keith Fahlgren on Mon Dec 21 15:29:08 PST 2009
Copyright (c) 2009 John W Maxwell. All rights reserved.
"""

import logging
import os.path

from lxml import etree

log = logging.getLogger(__name__)

ICML_RNG = os.path.join(os.path.dirname(__file__), 'externals', 'idml_schema', 'IDMarkupLanguage.rng')

def validate(icml):
    """Validate the supplied ICML (etree) document against a default IDML schema. Returns boolean. Writes warnings
       to this classes' log stream."""
    validator = etree.RelaxNG(etree.parse(ICML_RNG))
    valid = validator.validate(icml)
    if valid:
        return True
    else:
        error_log = validator.error_log
        log.warn('Validation errors:\n%s' % error_log)
        return False





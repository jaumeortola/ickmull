from setuptools import setup, find_packages
import sys, os

version = '0.1'

setup(name='ickmull',
      version=version,
      description="Ickmull provides tools and testing for the transformation of XHTML into ICML using XSLT.",
      long_description="""\
      Ickmull is a development of John W Maxwell at the Canadian Centre for Studies in Publishing at Simon Fraser University 
      See http://thinkubator.ccsp.sfu.ca/wikis/xmlProduction/Home for more details""",
      classifiers=[], # Get strings from http://pypi.python.org/pypi?%3Aaction=list_classifiers
      keywords='icml xslt indesign',
      author='John Maxwell',
      author_email='jmax@sfu.ca',
      url='http://thinkubator.ccsp.sfu.ca/wikis/xmlProduction/Home',
      license='GPL',
      packages=find_packages(exclude=['ez_setup', 'examples', 'tests']),
      package_data = { 'ickmull.externals': ['idml_schema/*.rng',
                                             'jing/*.*',
                                             'xslt/*.*',
                                            ],
                     },
      include_package_data=True,
      zip_safe=False,
      install_requires=[
          # -*- Extra requirements: -*-
          'lxml >= 2.2'
      ],
      # Tests require:
      #   * Java
      entry_points="""
      # -*- Entry points: -*-
      """,
      )

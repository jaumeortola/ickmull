You don't need to worry about setting up the development tools if you just want to use the ickmull stylesheet to transform XHTML into ICML for importing into InDesign. However, if you'd like to improve the quality of the transformation or add more support to ickmull, please follow the steps below to get started.

# Repository Setup #

In your terminal:
```
# Get a space to work on the project
$ mkdir ickmull.googlecode.com
$ cd ickmull.googlecode.com

# Checkout the source
$ hg clone https://ickmull.googlecode.com/hg/ default
requesting all changes
adding changesets
adding manifests
adding file changes
added 30 changesets with 147 changes to 56 files
updating working directory
52 files updated, 0 files merged, 0 files removed, 0 files unresolved
$ cd default/

$ ls
ickmull			ickmull.egg-info	setup.cfg		setup.py

# Make a virtual environment for these packages
$ virtualenv env-ickmull
New python executable in env-ickmull/bin/python
Installing setuptools............done.

# Turn on the virtual environemnt
$ source env-ickmull/bin/activate

# Get all of the dependencies installed
(env-ickmull)$ python setup.py develop
```

# Running the tests #

You'll need to have installed [nose](http://somethingaboutorange.com/mrl/projects/nose/0.11.3/) already.
```
# Go to your checkout and turn on the virtual environemnt
$ source env-ickmull/bin/activate

# Get all of the dependencies installed
(env-ickmull)$ nosetests
An improperly-formed ICML document should not be able to be successfully validated. ... ok
An ICML document should be able to be successfully validated. ... ok
An XHTML document should be able to be transformed into an ICML document. ... ok
All XHTML documents collected for smoketesting should be able to be transformed into an ICML document that matches the saved version. ... ok
An XHTML document should be able to be transformed into an ICML document that passes validation. ... ok
All XHTML documents collected for smoketesting should be able to be transformed into an ICML document that passes validation. ... ok
An XHTML document with many-paragraph footnotes should not be able to be transformed into an ICML document without warning the user. ... ok

Name                Stmts   Exec  Cover   Missing
-------------------------------------------------
ickmull                 1      1   100%   
ickmull.externals       1      1   100%   
ickmull.icml           14     14   100%   
ickmull.xhtml          13     13   100%   
-------------------------------------------------
TOTAL                  29     29   100%   
----------------------------------------------------------------------
Ran 7 tests in 5.127s

OK

```

# Smoketesting #

The test suite for ickmull uses nose and Python to help `smoketest` the stylesheet. Here's how it works:

  1. Python collects every single `.html` file in `ickmull/tests/files/smoketests/`
  1. It transforms the XHTML in the file into ICML using the stylesheet in `ickmull/externals/xslt/tkbr2icml.xsl`
  1. It comparse the `.icml` file in `ickmull/tests/files/smoketests/` (the _expected_ result) with the same name as the `.html` file to make sure the generated ICML is **exactly** the same
  1. It validates each ICML output against the base ICML schema
  1. It reports any differences

If it finds any differences between what was generated and what was expected (in the standalone `.icml`) file, it outputs a diff. Here's an example of a change in the XSLT that called the character style for `<em>` in InDesign `emphasis` instead of `i`:
```
======================================================================
FAIL: All XHTML documents collected for smoketesting should be able to be transformed into an ICML document that matches the saved version.
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/Users/abdelazer/repos/ickmull.googlecode.com/default/env-ickmull/lib/python2.6/site-packages/nose-0.11.3-py2.6.egg/nose/case.py", line 186, in runTest
    self.test(*self.arg)
  File "/Users/abdelazer/repos/ickmull.googlecode.com/default/ickmull/tests/test_xhtml.py", line 76, in test_xhtml_icml_output_same_smoke
    raise AssertionError('XML documents for %s did not match. Diff:\n%s' % (xhtml_docname, diff))
AssertionError: XML documents for DraftForJEP did not match. Diff:
---  

+++  

@@ -111,7 +111,7 @@

       <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
         <Content>This article is </Content>
       </CharacterStyleRange>
-      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
+      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/emphasis">
         <Content>not</Content>
       </CharacterStyleRange>
       <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
@@ -125,7 +125,7 @@

       <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
         <Content> is that XML editorial and production workflows </Content>
       </CharacterStyleRange>
-      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
+      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/emphasis">
         <Content>do</Content>
       </CharacterStyleRange>
       <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
@@ -143,7 +143,7 @@
...
```
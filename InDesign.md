Adobe InDesign's XML file format

As of the CS4 version (2009), Adobe's InDesign page-layout software features an entirely open, xml-based file format as an alternative to the usual proprietary one.

IDML is a complete representation of an InDesign file, from content to stylesheets to masters pages, layers, flows, objects, graphics, geometry, etc. It's actually pretty well designed and nicely modular (actually lots of xml files packaged up in a disguised .zip file, as Adobe likes to do these days.

See:

> http://www.adobe.com/devnet/indesign/pdfs/idml-specification.pdf

> http://www.adobe.com/devnet/indesign/pdfs/idml-cookbook.pdf

ICML is a subset, which basically pares it down to content only. Adobe's distributed editing software, InCopy (think of a multi-editor news office feeding into a single newspaper layout) now uses the ICML file format as its native one.

That means you can replace InCopy with any XML application -- like, say, the web -- and feed content into an InDesign layout. Or automatically update content in InDesign layouts. Or things like that.


README
======

Install
********

On Linux::
	sudo apt-get install rst2pdf  docutils

Create Documentation
***********************

There is actually two kind of doc:

* cheatsheet (short doc)
* Documentation : full information with screenshot and comment.

You can create french or english documentation.

You have to edit readComponentsDir.py file and chage parameter in the first line::
	lang = 'fr' # or en
	short = False

False for full documentation, True for cheatsheet.

1. python readComponentsDir.py
2. bash export.sh

The last command will create html and pdf doc into _build/ dir.


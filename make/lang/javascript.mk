#
# JAVASCRIPT.MK --Rules for dealing with JAVASCRIPT files.
#
# Contents:
# javascript-toc: --Build the table-of-contents for shell, awk files.
# javascript-src: --javascript-specific customisations for the "src" target.
# todo:           --Report unfinished work (identified by keyword comments)
#
$(wwwdir)/%.js:	%.js;	$(INSTALL_FILE) $? $@

#
# javascript-toc: --Build the table-of-contents for shell, awk files.
#
.PHONY: javascript-toc
toc:	javascript-toc
javascript-toc:
	$(ECHO_TARGET)
	mk-toc $(JS_SRC)
#
# javascript-src: --javascript-specific customisations for the "src" target.
#
src:	javascript-src
.PHONY:	javascript-src
javascript-src:	
	$(ECHO_TARGET)
	@mk-filelist -qn JS_SRC *.js

#
# todo: --Report unfinished work (identified by keyword comments)
# 
.PHONY: javascript-todo
todo:	javascript-todo
javascript-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(JS_SRC) /dev/null || true

#
# QT.MK --Rules for building Qt GUI applications
#
# Contents:
# build: --Build the Qt files
# clean: --Remove objects and intermediates created from Qt files.
# src:   --Update the QTH_SRC, QTR_SRC macros.
# todo:  --Find "unfinished work" comments in QT files.
#
# Remarks:
# The qt module adds support for building Qt-related software.
# It defines some pattern rules for compiling ".qrc" files,
# and ".h" files that contain Qt definitions.  These rules
# will be applied to files defined by the macros:
#
#  * QTR_SRC -- ".qrc" files
#  * QTH_SRC -- ".h" files containing QT_OBJECT usage.
#
# The "src" target will update the current makefile with suitable
# definitions of these macros; it uses the value of $(H++_SUFFIX)
# to find $(QTH_SRC) candidates, and $(C++_SUFFIX) to name
# generated C++ files.
#
.PHONY: $(recursive-targets:%=%-qt)

-include $(QTR_SRC:%.qrc=$(archdir)/%.d) $(UI_SRC:%.qrc=$(archdir)/%.d)

RCC	?= rcc
MOC	?= moc-qt4
UIC	?= uic-qt4

C++_SUFFIX ?= cc
H++_SUFFIX ?= h
QRC_SUFFIX ?= qrc
QUI_SUFFIX ?= ui

ifdef autosrc
    LOCAL_QTR_SRC := $(wildcard *.qrc)
    LOCAL_QUI_SRC := $(wildcard *.ui)
    LOCAL_QTH_SRC := $(shell grep -l Q_OBJECT *.$(H++_SUFFIX) 2>/dev/null)

    QTR_SRC ?= $(LOCAL_QTR_SRC)
    QUI_SRC ?= $(LOCAL_QUI_SRC)
    QTH_SRC ?= $(LOCAL_QTH_SRC)
endif

ALL_RCC_FLAGS = $(OS.RCC_FLAGS) $(ARCH.RCC_FLAGS) \
    $(PROJECT.RCC_FLAGS) $(LOCAL.RCC_FLAGS) $(TARGET.RCC_FLAGS) $(RCC_FLAGS)

ALL_MOC_FLAGS = $(OS.MOC_FLAGS) $(ARCH.MOC_FLAGS) \
    $(PROJECT.MOC_FLAGS) $(LOCAL.MOC_FLAGS) $(TARGET.MOC_FLAGS) $(MOC_FLAGS)

ALL_UIC_FLAGS = $(OS.UIC_FLAGS) $(ARCH.UIC_FLAGS) \
    $(PROJECT.UIC_FLAGS) $(LOCAL.UIC_FLAGS) $(TARGET.UIC_FLAGS) $(UIC_FLAGS)

QTR_TRG = $(QTR_SRC:%.$(QRC_SUFFIX)=$(gendir)/%.$(C++_SUFFIX))
QTH_TRG = $(QTH_SRC:%.$(H++_SUFFIX)=$(gendir)/moc-%.$(C++_SUFFIX))
QUI_TRG = $(QUI_SRC:%.$(QUI_SUFFIX)=$(gendir)/uic-%.$(H++_SUFFIX))
QT_TRG  = $(QTR_TRG) $(QTH_TRG) $(QUI_TRG)

QTR_OBJ = $(QTR_TRG:$(gendir)/%.$(C++_SUFFIX)=$(archdir)/%.o)
QTH_OBJ = $(QTH_TRG:$(gendir)/%.$(C++_SUFFIX)=$(archdir)/%.o)
QT_OBJ  = $(QTR_OBJ) $(QTH_OBJ)

.PRECIOUS:	$(QT_TRG)
#
# build: --Build the Qt files
#
build:	$(QT_OBJ) $(QT_TRG)

$(gendir)/%.$(C++_SUFFIX):	%.qrc
	$(ECHO_TARGET)
	$(MKDIR) $(@D)
	$(RCC) $(ALL_RCC_FLAGS) $< >$@

$(gendir)/moc-%.$(C++_SUFFIX):	%.$(H++_SUFFIX)
	$(ECHO_TARGET)
	$(MKDIR) $(@D)
	$(MOC) $(ALL_MOC_FLAGS) -o $@ $<

$(gendir)/uic-%.$(H++_SUFFIX):	%.$(QUI_SUFFIX)
	$(ECHO_TARGET)
	$(MKDIR) $(@D)
	$(UIC) $(ALL_UIC_FLAGS) -o $@ $<

#
# clean: --Remove objects and intermediates created from Qt files.
#
clean:	clean-qt
clean-qt:
	$(ECHO_TARGET)
	$(RM) $(QT_TRG) $(QT_OBJ)

#
# src: --Update the QTH_SRC, QTR_SRC macros.
#
src:	src-qt
src-qt:
	$(ECHO_TARGET)
	@mk-filelist -qn QTR_SRC *.qrc
	@mk-filelist -qn QUI_SRC *.ui
	@mk-filelist -qn QTH_SRC $$(grep -l Q_OBJECT *.$(H++_SUFFIX))

#
# todo: --Find "unfinished work" comments in QT files.
#
todo:	todo-qt
todo-qt:
	$(ECHO_TARGET)
	@$(GREP) $(TODO_PATTERN) $(QTR_SRC) $(QUI_SRC) $(QTH_SRC) /dev/null || true

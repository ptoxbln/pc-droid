program		= pc-droid
version		= 1.1

# Installation directories: prefix
prefix		= /usr
bindir		= $(prefix)/bin

sourcedir	= src
builddir	= build

qmk		= $(builddir)/Makefile
qpro		= $(program).pro
qres		= $(program).qrc

binary		= $(builddir)/$(program)

all: $(qres) $(qpro) $(qmk) $(binary)

$(qres):
	@echo "<!DOCTYPE RCC>" > $@
	@echo "<RCC version=\"1.0\">" >> $@; echo "  <qresource>" >> $@
	@for file in images/*.png; do echo "    <file>$$file</file>" >> $@; done
	@echo "  </qresource>" >> $@; echo "</RCC>" >> $@

$(qpro):
	@echo "QT       	= widgets" > $@
	@echo "TARGET 		= $(program)" >> $@; echo "TEMPLATE 	= app" >> $@
	@echo "RESOURCES 	= $(program).qrc" >> $@; echo "" >> $@
	@echo "SOURCES += \\" >> $@; for file in src/*.cpp; do echo "    $$file \\" >> $@; done; echo "" >> $@
	@echo "HEADERS += \\" >> $@; for file in src/*.h;   do echo "    $$file \\" >> $@; done; echo "" >> $@
	@sed 's|src/utils.cpp \\|src/utils.cpp|g;s|src/utils.h \\|src/utils.h|g' -i $@

$(qmk):
	mkdir -p build
	qmake $(program).pro -o $@

$(binary):
	make -C build

strip: 
	strip $(builddir)/$(program)

install: strip
	install -Dp -m0755 $(builddir)/$(program) $(DESTDIR)$(bindir)/$(program)

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(program)

clean:
	rm -fr build $(qpro) $(qres)

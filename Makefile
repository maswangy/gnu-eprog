images = flash-ram-mm.png \
	 linker.png \
	 relocation.png \
	 sections.png \
	 stack.png \
	 csections.png

htmls = arm-iset.html \
	asm-directives.html \
	data-in-ram.html \
	index.html \
	using-ram.html \
	arm-lab.html \
	copyright.html \
	lds.html \
	arm-prog-model.html \
	hello-arm.html \
	linker.html \
	c-startup.html \
	exc-handle.html \
	contributing.html \
	credits.html \
	c-library.html \
	inline-assembly.html \
	arm-stacks.html

all: $(htmls) $(images) revision.rss

gnu-eprog.epub: gnu-eprog.asciidoc $(images)
	a2x -d book -f epub $<

$(htmls): gnu-eprog.xml 
	java -cp "/usr/share/java/saxon.jar:/usr/share/java/xslthl.jar" \
	  -Dxslthl.config="file://$(PWD)/xslthl-config.xml" \
	  com.icl.saxon.StyleSheet gnu-eprog.xml docbook.xsl
	imgsizer $(htmls)
	-tidy --quiet -m $(htmls) 2> /dev/null

revision.rss: gnu-eprog.xml
	xsltproc rss.xsl gnu-eprog.xml | tr -s "\n" > revision.rss

%.xml: %.asciidoc
	asciidoc -b docbook  $<

%.png: %.dia
	dia --export=$@ --filter=png-libart $<

clean:
	rm -f *.html
	rm -f gnu-eprog.xml
	rm -f $(images)

distclean: clean
	find . -name "*~" -exec rm -f {} ";"

upload:
	lftp -f upload.lftp

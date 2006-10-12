XSLTPROC=saxon8

all: ucum.html ucum-cs.units ucum-ci.units ucum-essence.xml

ucum.html: ucum.xml V3mLayoutHTML20.xsl
	$(XSLTPROC) -o $@ $^

ucum.xml: ucum-source.xml v3dt-v3pub.xsl
	$(XSLTPROC) -o $@ $^

ucum-essence.xml: ucum-source.xml ucum-winnow.xsl
	$(XSLTPROC) -o $@ $^

ucum-cs.units: ucum-source.xml ucum-oldfile.xsl
	$(XSLTPROC) -o $@ $^ case="sensitive"

ucum-ci.units: ucum-source.xml ucum-oldfile.xsl
	$(XSLTPROC) -o $@ $^ case="insensitive"

clean:
	rm -f *~ ucum.xml ucum-cs.units ucum-ci.units ucum.html ucum-essence.xml


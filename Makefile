XSLTPROC=java -jar build/saxon8.jar

all: ucum.html ucum-cs.units ucum-ci.units ucum-essence.xml

ucum.html: ucum.xml build/V3mLayoutHTML20.xsl
	$(XSLTPROC) -o $@ $^

ucum.xml: ucum-source.xml build/v3dt-v3pub.xsl
	$(XSLTPROC) -o $@ $^

ucum-essence.xml: ucum-source.xml build/ucum-winnow.xsl
	$(XSLTPROC) -o $@ $^

ucum-cs.units: ucum-source.xml build/ucum-oldfile.xsl
	$(XSLTPROC) -o $@ $^ case="sensitive"

ucum-ci.units: ucum-source.xml build/ucum-oldfile.xsl
	$(XSLTPROC) -o $@ $^ case="insensitive"

clean:
	rm -f *~ ucum.xml ucum-cs.units ucum-ci.units ucum.html ucum-essence.xml


#!/bin/sh
# Make everything

export XML_CATALOG_FILES=catalog/root.xml

# remove our temporary files
mkdir -p logs
rm -f logs/build-stdout
rm -f logs/validate-stdout
rm -f logs/index-stdout

# Generate makefile
xsltproc index-makefile.xsl index.xml > Makefile
# Clean things
make clean > logs/clean-stdout 2>&1

OUTPUTDIR=output/html

mkdir -p "${OUTPUTDIR}"

# Now build stuff
make > logs/build-stdout 2>&1 || echo "ERROR: Build failed - see logs/build-stdout"
make validate > logs/validate-stdout 2>&1 || echo "ERROR: Validate failed - see logs/validate-stdout"
echo Processing plain index
xsltproc                                 -o "${OUTPUTDIR}/index.html" index.xsl index.xml > logs/index-stdout 2>&1
echo Processing source links
xsltproc -param include-source "'yes'"   -o "${OUTPUTDIR}/index-source.html" index.xsl index.xml > /dev/null 2> /dev/null
echo Processing contents index
xsltproc -param make-contents "'yes'"    -o "${OUTPUTDIR}/index.html" index.xsl index.xml > /dev/null 2> /dev/null

# remove any core dump if it failed
rm -f core

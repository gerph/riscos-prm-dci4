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

# Generate the 'raw' XML archives
if false ; then
    cd ..
    rm roldoc-xml.tar.gz
    rm roldoc-xml.zip
    tar zcf roldoc-xml.tar.gz roldoc > /dev/null 2> /dev/null
    zip -9r roldoc-xml.zip roldoc > /dev/null 2> /dev/null
    cd roldoc
fi

OUTPUTDIR=output/help

mkdir -p "${OUTPUTDIR}"

# Now build stuff
make > logs/build-stdout 2>&1
make validate > logs/validate-stdout 2>&1
#echo Processing plain index
xsltproc                                 -o "${OUTPUTDIR}"/index.html index.xsl index.xml > logs/index-stdout 2>&1
#echo Processing source links
#xsltproc -param include-source "'yes'"   -o ${OUTPUTDIR}/index-source.html index.xsl index.xml > /dev/null 2> /dev/null
#echo Processing contents index
#xsltproc -param make-contents "'yes'"    -o ${OUTPUTDIR}/index.html index.xsl index.xml > /dev/null 2> /dev/null

# remove any core dump if it failed
rm -f core

# Generate the 'full' archives
if false ; then
    cd ..
    rm roldoc.tar.gz
    rm roldoc.zip
    tar zcf roldoc.tar.gz roldoc > /dev/null 2> /dev/null
    zip -9r roldoc.zip roldoc > /dev/null 2> /dev/null
    cd roldoc

    # And some archives for the catalog files
    tar zcf ../roldoc-catalog.tar.gz catalog > /dev/null 2> /dev/null
    zip -9r ../roldoc-catalog.zip    catalog > /dev/null 2> /dev/null
fi

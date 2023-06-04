# Build all the documentation using the PRM-in-XML tools

.PHONY: output pdf dirs

TOOL = riscos-prminxml

all: pdf

lint: dirs
	${TOOL} --lint -f index -L logs index.xml
	cat logs/2-build.log

output: dirs
	${TOOL} -f index -L logs index.xml
	cat logs/2-build.log

pdf: output
ifeq (${PRINCEXML_I_HAVE_A_LICENSE},1)
	if [ -f output/html/filelist.txt ] ; then \
		cd output/html && prince --verbose -o ../RISC_OS_DCI4.pdf -l filelist.txt ; \
	else \
		echo NOTE: riscos-prminxml tool is too old to generate PDF. ; \
	fi
else
	echo NOTE: Not licensed for PrinceXML, so not building the PDF.
endif

dirs:
	mkdir -p logs

zip: output
	rm -f src.zip output.zip
	zip -9r src.zip index.xml build.sh Makefile src
	zip -9r output.zip output

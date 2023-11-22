#!/bin/bash
##
# Helper script to build a given style of document (or multiple styles)

set -e
set -o pipefail

scriptdir="$(cd "$(dirname "$0")" && pwd -P)"

OUTPUTDIR="output"
rm -rf "${OUTPUTDIR}"
mkdir -p "${OUTPUTDIR}"

TMPINDEX="${TMPDIR:-/tmp}/prminxml-index.xml"

# Common extra variants
extra_variants="large-bullets page-a4"
index_variants="no-edge-index index-no-descriptions-in-print index-include-indexed-header-label"

# Construct a new index.xml for us to use.
function generate_documents() {
    local srcindex=$1
    local name=$2
    local variants=$3
    local html=${4:-html5}
    local catalog=${5:-103}
    echo "- Building documents in ${OUTPUTDIR}/$name"

    sed -E \
        -e "s!output/!${OUTPUTDIR}/$name/!g" \
        -e "s!page-css-variant='[^']*'!page-css-variant='$variants'!g" \
        -e "s!index-css-variant='[^']*'!index-css-variant='$variants $index_variants'!g" \
        -e "s!page-format='.*'!page-format='$html'!" \
        "$srcindex" > "${TMPINDEX}"

    mkdir -p "${OUTPUTDIR}/logs-$name"
    riscos-prminxml --catalog "$catalog" -f index -L "${OUTPUTDIR}/logs-$name" "${TMPINDEX}"
    if [[ "$PRINCEXML_I_HAVE_A_LICENSE" = 1 && -f "${OUTPUTDIR}/$name/html/filelist.txt" ]] ; then
        ( cd "${OUTPUTDIR}/$name/html" &&
          prince --verbose -o "../RISC_OS_PRM_DCI4.pdf" -l filelist.txt )
    fi
    cp "${TMPINDEX}" "${OUTPUTDIR}/$name/index.xml"
}

# Build each of the requested formats
# Arguably we shouldn't really /have/ to regenerate all the documentation just to replace the
# CSS. But that's the way they've been set up. A bit of a rethink of the CSS generation would
# be needed to make it more flexible... but that's for another day.
for arg in "$@" ; do
    handled=false
    if [[ "$arg" = 'all' || "$arg" = 'regular' ]] ; then
        generate_documents "index.xml" regular "$extra_variants"
        handled=true
    fi
    if [[ "$arg" = 'all' || "$arg" = 'unstyled' ]] ; then
        generate_documents "index.xml" unstyled "$extra_variants" "html"
        handled=true
    fi
    if [[ "$arg" = 'all' || "$arg" = 'prm' ]] ; then
        generate_documents "index.xml" prm "prm body-fraunces heading-raleway webfont-fraunces webfont-raleway $extra_variants"
        handled=true
    fi
    if [[ "$arg" = 'all' || "$arg" = 'prm-ro2' ]] ; then
        generate_documents "index.xml" prm-ro2 "prm prm-ro2 body-fraunces heading-raleway webfont-fraunces webfont-raleway $extra_variants"
        handled=true
    fi
    if [[ "$arg" = 'all' || "$arg" = 'prm-modern' ]] ; then
        generate_documents "index.xml" prm-modern "prm prm-modern body-notosans heading-saira webfont-notosans webfont-saira $extra_variants"
        handled=true
    fi
    if ! $handled ; then
        echo "Did not understand build style '$arg'" >&2
        exit 1
    fi
done

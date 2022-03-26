#!/bin/bash
##
# Build the index, obtaining the tools first.
#
# We will obtain all the tools we need from the OS.
# We will try to get a version of PRM-in-XML that we can work with.
# We will obtain PrinceXML to generate PDFs.
#
# Because PrinceXML requires that you have a license to use it,
# the installation of PrinceXML and the PDF generation will only
# be performed if you set the environment variable:
#
#   PRINCEXML_I_HAVE_A_LICENSE=1
#
# For example running this script with:
#
#   PRINCEXML_I_HAVE_A_LICENSE=1 ./build.sh
#
# Consult the PrinceXML documentation for license details.
#
# Supported operating systems:
#
#   macOS
#   Ubuntu Linux (18.04-21.04)
#   Centos (7 and 8)
#   Debian (10)
#

set -e
set -o pipefail

PRINCE_VERSION=14.2
#PRMINXML_VERSION=1.02.65
PRMINXML_VERSION=1.03.65.html5-css.105
SYSTEM="$(uname -s)"

if [[ "$SYSTEM" = 'Darwin' ]] ; then
    DISTRO="macOS"
    DISTRO_RELEASE='unknown'
else
    if [[ -f '/etc/lsb-release' ]] ; then
        # Probably an Ubuntu or Debian
        DISTRO=$(source /etc/lsb-release ; echo $DISTRIB_ID | tr A-Z a-z)
        DISTRO_RELEASE=$(source /etc/lsb-release ; echo $DISTRIB_RELEASE)
    elif [[ -f '/etc/os-release' ]] ; then
        DISTRO=$(source /etc/os-release ; echo $ID)
        DISTRO_RELEASE=$(source /etc/os-release ; echo $VERSION_ID)
    else
        echo "Unrecognised Linux version" >&2
        exit 1
    fi

    # DISTRO = centos | ubuntu
    # DISTRO_RELEASE = 6, 7, 8 for centos; 18.04 for ubuntu
fi


scriptdir="$(cd "$(dirname "$0")" && pwd -P)"

# State for our `apt-get update` and whether we can use sudo.
package_indexed=false
sudo_queried=false


##
# Run some operations as root, if required.
function run_root() {
    local command=$@

    if [[ $EUID -ne 0 ]] ; then
        if ! $sudo_queried ; then
            echo "Not running as root. I will require the installation of packages through sudo."
            read -p "Are you sure? " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
                echo "OK. Cowardly refusing to continue." >&2
                exit 1
            fi
            sudo_queried=true
        fi
        sudo "$@"
    else
        "$@"
    fi
}


function update_packages() {
    if $package_indexed ; then
        true
    else
        if [[ "${SYSTEM}" = 'Linux' ]] ; then
            if [[ "${DISTRO}" = 'centos' ]] ; then
                # No update for yum on centos
                true
            else
                run_root apt-get update
            fi
            package_indexed=true
        else
            echo "Cannot update packages list on ${SYSTEM}" >&2
            exit 1
        fi
        true
    fi
}


##
# Install a package from the package manager
function install_package() {
    local pkg="$1"
    local install_pkg="${2:-$1}"
    if ! type -p "$1" >/dev/null 2>&1  ; then
        echo "+++ Obtaining $pkg"
        if [[ "${SYSTEM}" = 'Darwin' ]] ; then
            echo "Need $pkg on Darwin" >&2
            exit 1
        elif [[ "${SYSTEM}" = 'Linux' ]] ; then
            # I'm assuming this is Ubuntu
            if [[ "${DISTRO}" = 'centos' ]] ; then
                # No update for yum on centos
                # Translations for the packages we use:
                if [[ "$install_pkg" = 'xsltproc' ]] ; then
                    install_pkg=libxslt
                elif [[ "$install_pkg" = 'libtiff5' ]] ; then
                    install_pkg=libtiff
                elif [[ "$install_pkg" = 'libpng16-16' ]] ; then
                    install_pkg=libpng
                elif [[ "$install_pkg" = 'liblcms2-2' ]] ; then
                    install_pkg=lcms2
                elif [[ "$install_pkg" = 'libfontconfig1' ]] ; then
                    install_pkg=fontconfig
                elif [[ "$install_pkg" = 'libgif7' ]] ; then
                    install_pkg=giflib
                elif [[ "$install_pkg" = 'libcurl4' ]] ; then
                    if [[ "${DISTRO_RELEASE}" = 8 ]] ; then
                        install_pkg=libcurl-minimal
                    else
                        install_pkg=libcurl
                    fi
                fi
                update_packages && run_root yum install -y "$install_pkg"
            else
                update_packages && run_root env DEBIAN_FRONTEND="noninteractive" apt-get install -y "$install_pkg"
            fi
        else
            echo "Cannot install $pkg on ${SYSTEM}" >&2
            exit 1
        fi
    fi
}


# Install the packages we need for these installations and for the run of the tools.

install_package wget
install_package perl
install_package git
install_package xsltproc
install_package xmllint libxml2-utils
install_package make



if ! type -p riscos-prminxml >/dev/null 2>&1 ; then
    # riscos-prminxml isn't installed, so let's get a copy.
    if [[ ! -x "./riscos-prminxml-$PRMINXML_VERSION/riscos-prminxml" ]] ; then
        echo +++ Obtaining riscos-prminxml
        archive="/tmp/prminxml-${PRINCE_VERSION}.tar.gz"
        url="https://github.com/gerph/riscos-prminxml-tool/releases/download/v${PRMINXML_VERSION}/POSIX-PRMinXML-${PRMINXML_VERSION}.tar.gz"
        wget -q -O "${archive}" "$url" || echo "Could not obtain PRM-in-XML from $url" >&2
        rm -rf "riscos-prminxml-$PRMINXML_VERSION"
        mkdir -p "riscos-prminxml-$PRMINXML_VERSION"
        tar zxv -C "riscos-prminxml-$PRMINXML_VERSION" -f "${archive}"
    fi
    export PATH="${scriptdir}/riscos-prminxml-$PRMINXML_VERSION:$PATH"
fi

if ! type -p prince >/dev/null 2>&1 && [[ "$PRINCEXML_I_HAVE_A_LICENSE" = 1 ]] ; then
    # princexml isn't installed, so we need to get a version.
    prince_install="${scriptdir}/prince-install-$PRINCE_VERSION-$DISTRO-$DISTRO_RELEASE"
    if [[ ! -d "$prince_install" ]] ; then
        echo "+++ Obtaining prince"
        if [[ "$SYSTEM" = 'Darwin' ]] ; then
            url="https://www.princexml.com/download/prince-$PRINCE_VERSION-macos.zip"
            extract_dir="prince-${PRINCE_VERSION}-macos"
            ext="zip"
        elif [[ "$SYSTEM" = 'Linux' ]] ; then
            # I'm assuming this is amd64.
            PRINCE_DISTRO_RELEASE=${DISTRO_RELEASE}
            if [[ "$DISTRO" = 'ubuntu' ]] ; then
                if [[ "$DISTRO_RELEASE" =~ 20.10|21.04|21.10 ]] ; then
                    PRINCE_DISTRO_RELEASE=20.04
                elif [[ "$DISTRO_RELEASE" =~ 18.10|19.04|19.10 ]] ; then
                    PRINCE_DISTRO_RELEASE=18.04
                fi
                # FIXME: Determine the actual architecture
                PRINCE_ARCH='amd64'
            elif [[ "$DISTRO" = 'debian' ]] ; then
                PRINCE_ARCH='amd64'
            elif [[ "$DISTRO" = 'centos' ]] ; then
                PRINCE_ARCH='x86_64'
            fi
            url="https://www.princexml.com/download/prince-$PRINCE_VERSION-${DISTRO}${PRINCE_DISTRO_RELEASE}-${PRINCE_ARCH}.tar.gz"
            extract_dir="prince-${PRINCE_VERSION}-${DISTRO}${PRINCE_DISTRO_RELEASE}-${PRINCE_ARCH}"
            ext="tar.gz"
        else
            echo "Unrecognised OS" >&2
            exit 1
        fi

        # Download the prince installation
        archive="/tmp/prince-${PRINCE_VERSION}.${ext}"
        wget -q -O "${archive}" "$url" || echo "Could not obtain Prince from $url" >&2
        if [[ ! -f "${archive}" ]] ; then
            echo "Cannot use PrinceXML: Disabling"
            export PRINCEXML_I_HAVE_A_LICENSE=
        else
            # Now extract it.
            if [[ "${ext}" = 'zip' ]] ; then
                unzip "${archive}"
            else
                tar zxvf "${archive}"
            fi

            # Install it into our temporary directory
            echo | "${extract_dir}/install.sh" "${prince_install}"

            # Clean up
            rm "$archive"
            rm -rf "$extract_dir"
        fi
    fi

    if [[ "$PRINCEXML_I_HAVE_A_LICENSE" = 1 ]] ; then
        export PATH="${prince_install}/bin:$PATH"
        # Check if we have a working prince installation
        if ! prince --version > /dev/null 2>&1 ; then

            if [[ "$SYSTEM" = 'Linux' ]] ; then
                # We also seem to need some libraries to be installed (there's no binary so this will just install)
                install_package libtiff5
                install_package libgif7
                install_package libpng16-16
                install_package liblcms2-2
                install_package libcurl4
                install_package libfontconfig1
            fi
        fi
    fi
fi


echo
echo "+++ Environment configured..."
echo 'riscos-prminxml can be found at:' $(which riscos-prminxml)
riscos-prminxml --version
xmllint --version
xsltproc --version

if [[ "$PRINCEXML_I_HAVE_A_LICENSE" = 1 ]] ; then
    prince --version
fi


echo Run the build...
riscos-prminxml -f index -L logs index.xml
if [[ "$PRINCEXML_I_HAVE_A_LICENSE" = 1 ]] ; then
    cd output/html && prince --verbose -o ../index.pdf -l filelist.txt
fi

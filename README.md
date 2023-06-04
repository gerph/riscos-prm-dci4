# RISC OS DCI 4 Networking

## Introduction

The content here comprises the documentation for the DCI 4 network stack on RISC OS.
The content uses the PRM-in-XML format, and has been converted from the original
textual and HTML documents. By being in an open source format, editable as text,
and able to be stored in a git repository, it brings the maintenance of
documentation to users.

## Status of the documentation

The documentation has been converted raw, and then reorganised to structure the
information in a form closer to that used by the RISC OS Programmer's Reference
Manuals.

The documentation was originally copyight Acorn/ANT. Acorn had concerns that the
information might be used to subvert school systems. This concern, together with
the inability to obtain any clear answer on the reproduction rights for the
documentation, has left the documentation in limbo for many years.

After many years, the ownership of the original Acorn licensed content has
fallen to RISC OS Developments.

The DCI statistics and MBufManager have a license statement that is similar to
an open source MIT license, so they are distributable. The DCI device driver
documentation was an Acorn document so falls entirely under the purview of
RISC OS Developments.


## How to build

The documentation builds on Linux and macOS at present. Although individual documents should work on RISC OS, the makefiles that build the content are not set up for building on such systems.

To build the content on an Ubuntu system (other distributions may work but are not regularly used), run the command:

```
./build.sh
```

The content will be generated into the `output` directory. To enable the building of PDFs, use:

```
env PRINCEXML_I_HAVE_A_LICENSE=1 ./build.sh
```

Using PrinceXML to generate PDFs for non-commercial use is free. Consult license documentation for other cases.

The build process will use a configured release version of the PRM-in-XML tools, which it will download if necessary. It is possible to override the version used by setting the environment variable `PRMINXML_VERSION` to the release version to use. It may also be set to the value `local` to use the locally installed version of PRM-in-XML tools.

## Validation

The files can be validated with the command:

```
./build.sh lint
```

This will report problems to the screen and a full log in the `logs` directory.

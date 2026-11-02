---
title: About UCUM Release Artifacts
post_excerpt: An explanation of the files contained in the UCUM distribution
---

The UCUM repository contains a number of files. This document aims to explain the purpose and origin of each, as of version 2.2 (June 2024).

## ucum-source.xml

True to its name, this is the source file to which all edits are made. This includes a list of all base units by category and corresponding narrative text. All other files are built from this file using XSL transformations.

## ucum.html

This file represents the UCUM Specification. It is built as part of release processes and includes important reference links to other sections within the document. This file is published on the UCUM website at [https://ucum.org/ucum](https://ucum.org/ucum).

## ucum.xml

This file is the UCUM Specification minus the unit tables, i.e. it contains the narrative text of the specification.

## ucum-essence.xml

This XML is designed for use by developers and other implementers. It contains only the prefixes and units of the specification.

## ucum-cs.units

This is a simple text file containing each base unit and its definitional value. The file includes constants and prefixes with their corresponding values. The "cs" in the file name denotes these are the case-sensitive version of UCUM units.

## ucum-ci.units

This file is the same as above except it contains only the case-insensitive set of UCUM units, as the file name suggests.

## Makefile

The Makefile contains the instructions to build each of the release artifacts from the ucum-source.xml file. The file's commands reference XSLT files included in the build directory.

## README.md

As is common with Git and GitHub repositories, this Markdown-formatted file serves as an introduction and contains topical information. Most web browsers can properly render Markdown files. By their nature, they are also human readable in their raw form.

## LICENSE.md

This is the current text of the UCUM License in Markdown format.

## CHANGELOG.md

The Changelog contains notable changes by release version. Ticket numbers and URLs listed prior to version 2.2 are of no value as they reference a previous system.

## common-units/

This directory contains three listings of common units used in medical applications. See the seprate documentation at [/docs/common-units.md](../docs/common-units.md).

## docs/

The docs directory includes Markdown-formatted documentation of UCUM concepts. They can be considered a supplement to the UCUM Specification. These files are published on the UCUM website at [https://ucum.org/docs](https://ucum.org/docs). This document itself exists within this docs folder.

## build/

This directory contains XSLT files and other assets used in the artifact build process as directed by the Makefile.

## .github/

This "hidden" directory contains configuration files used by github.com.

## assets/images/ucum-state-automaton.gif

This automaton image is referenced in the UCUM Specification.

## Remaining files

All files and directories not mentioned here are vestigial and may be deleted in future releases.

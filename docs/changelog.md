---
title: Change Log
post_excerpt: A summary of notable changes in versions of the UCUM specification.
---

The following has been ported from a legacy system and may not be formatted correctly.

## Version 2.1

This fixes 4 defects of the specification itself. No new units.

  - \#185 tan100 defined inconsistently
  - \#183 Fix typing error for weber quantity kind
  - \#184 Canonical form not described
  - \#189 Two concerns on syntax
tree

## Version 2.0.1

## Version 2.0

\[<http://unitsofmeasure.org/trac/query?status=closed&group=resolution&milestone=Version+2.0>
List of Issues Resolved\]

  - Emergency minor release 2.0.1 on 13-NOV-2015 to fix the exponent of
    Planck's constant. \#175
  - ucum-essence.xml had elements in no name space. This was obviously a
    bug. It was resolved, not an emergency, but would have been more
    difficult to hold this minor fix back until 2.1
\#157

## Version 1.9

\[<http://unitsofmeasure.org/trac/query?status=closed&group=resolution&milestone=Revision+1.9>
List of Issues Resolved\]

### New units

||tex || 1 ||g/km ||metric ||tex ||\[den\] || 1 ||g/9/km ||nonmetric ||
Denier ||\[anti'Xa'U\] || 1 || 1 ||nonmetric || arbitrary anti factor Xa
unit ||\[EID\_50\] || 1 || 1 ||nonmetric || arbitrary 50% embryo
infectious dose ||\[Amb'a'1'U\] || 1 || 1 ||nonmetric || arbitrary
allergen unit for Ambrosia artemisiifolia ||\[Lf\] || 1 || 1 ||nonmetric
|| arbitrary Limit of flocculation ||\[D'ag'U\] || 1 || 1 ||nonmetric ||
arbitrary D-antigen unit ||\[FEU\] || 1 || 1 ||nonmetric || arbitrary
fibrinogen equivalent unit ||\[ELU\] || 1 || 1 ||nonmetric || arbitrary
ELISA unit ||\[EU\] || 1 || 1 ||nonmetric || arbitrary Ehrlich unit
||\[foz\_m\] || 30 || mL ||nonmetric || metric fluid ounce ||\[cup\_m\]
|| 240 || mL ||nonmetric || metric cup ||\[tsp\_m\] || 5 || mL
||nonmetric || metric teaspoon ||\[tbs\_m\] || 15 || mL ||nonmetric ||
metric tablespoon ||\[oz\_m\] || 28 || g ||nonmetric || metric ounce
||\[degR\] || 5 || K/9 ||nonmetric || degree Rankine

### Changed Units

#### Exact Constants

The following units are modified to turn constants which were stated of
limited precision to exact. This is indicated by removing the decimal
point from the number. If a number has a decimal point, it is considered
having this number of significant digits, hence limited precision. If
there is no decimal point (and magnitude adjusted in the exponent) it is
considered exact. ||\[g\] || 980665e-5 (was: 9.80665) || m/s2 || metric
|| standard acceleration of free fall ||m\[H2O\] || 980665e-5 (was
9.80665) || kPa || metric || meter of water column ||Ci || 37e9 (was:
3.7e10) || Bq || metric || Curie ||\[car\_m\] ||2e-1 (was: 0.2) ||g
||nonmetric ||metric carat

#### Corrected Constants

||\[Ch\] ||1 ||mm/3 (was: mm/\[pi\]) ||nonmetric ||Charrière ||AU ||
149597.870''691'' || Mm || nonmetric || astronomic unit ||\[drp\] ||1
||ml/20 (was: ml/12) ||nonmetric ||drop

## Version 1.8.2

The major change of this release is the establishment of a class of
"arbitrary units" which are no longer simply dimensionless. This is to
protect the false assumption that one could convert measurement values
expressed in some arbitrary unit into one in another arbitrary or
dimensionless
units.

## Version 1.8

\[<http://unitsofmeasure.org/trac/query?status=closed&group=resolution&milestone=Revision+1.8>
List of Issues Resolved\]

New units:

||\[wood'U\] || 1 ||mm\[Hg\].min/L ||nonmetric || Wood unit ||\[IU\] ||
1 ||\[iU\] ||metric || arbitrary international unit ||\[BAU\] || 1 ||1
||nonmetric || arbitrary bioequivalent allergen unit ||\[AU\] || 1 ||1
||nonmetric || arbitrary allergen unit ||\[PNU\] || 1 ||1 ||nonmetric ||
arbitrary protein nitrogen unit ||B\[10.nV\] || \* || 2lg(10 nV)
||metric || bel 10 nanovolt

# Procedure Defined Units

How come 1 meter is a good unit but 1 tuberculine unit is not?

How come UCUM has both of these units?

How come the equality of 1 Bq and 1 Hz is not a problem, but the
equality of 1 tuberculine unit and 1 allergy unit is a problem?

How come glucose measured in 1 gram or 1 mol is not a problem?

How can we have both allergen unit \[AU\] and biological equivalent
allergy unit \[BAU\] in one system?

How come 1 Gray and 1 Sievert both exist in the SI, are they equal?

This is the biggest challenge that the UCUM project is currently facing.

## Synthetic Analogy

I think the problem always occurs when we measure one thing by an
equivalent of another.

Like if I measured an amount of people by the amount of oxygen they
consume in the room.

And it gets worse if the measurand and the equivalent quantity are of
the same dimension,

Like if I measure the number of people by the number of hairs they leave
behind.

And it is all fine if I have a fixed constant conventional coefficient,
Like: a person loses 10 hairs per hour, so if after 2 hours a room has
10<sup>6</sup> hairs on the floor, there must have been
5\*10<sup>4</sup> people in the room.

But it gets worse if an expert comes along and says:

Wait, you can't tell how many people are in the room, all you know is
how much hair they lost\!

At this very point you start measuring amount of people by some
procedure defined unit:

Like: HEU (hair equivalent unit) the amount of people in a room who lose
10 million hairs in 1 hours.

At this point people demand that UCUM has the HEU unit.

But the problem is, this definition of HEU is explicitly not directly
related to the straight-forward number of people in the room, but it is
a new kind of quantity, locked to this idiosyncratic proxy measure.

And that now has established its very own dimension also, because in a
dimension all units are comparable in fixed conversion formulas (usually
proportional, linear, but at least a conventional a-priori defined
function.) But not here, because the whole premise was that people
rejected the idea of just relating the unit directly to number of people
or just reporting number of people directly.

Thus all procedure defined units are dimensions unto themselves.

And thus our simple 7 component dimension vector stops being a vector of
any finite length.

## What do we do?

The present approach was to add a new property "arbitrary unit" into the
unit definition. This measure at least prevents units to be falsely
taken as equivalent. But this also prevents any kind of conversion, even
between 1 HEU and 1 kHEU. This is presently the best we can do, and it
is a good idea to limit the ability to form complex terms with arbitrary
units. It might not even make sense in some cases (e.g., if the unit is
not on a ratio scale how can one even multiply it?)

But we need a final solution that deals with this challenge.

### One Solution

One possible solution is to assume a hard-line scientific position and
put any and all UCUM units on a black-list that are used to merely
decorate dimensionless number, indexes, or ratios. A very good argument
for this position can be found in \#27 (the strike-through only
indicates this issue is closed, not that it is invalid).

### A Way Forward

Arbitrary units \[IU\] and \[iU\] are equal, they are, in fact, the same
(just literal difference). The same issue you have with the
case-insensitive and case-sensitive lexical variants. So, if we use the
isArbitrary property to force checking the unit, we must not fail equal
because of those differences.

Therefore, we probably need to extend our dimension and base-unit vector
with additional fields, and when checking dimensionality, we need to
take those into account. This makes the dimension and base-unit vector
sparse at the end. There are 10<sup>3</sup> arbitrary units to reckon
with.

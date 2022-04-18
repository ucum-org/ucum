---
title: Comments
post_excerpt: ...
---

``` 

> ... I work as a software developer ..., 
> creating a new modelling tool with extensive support for
> measurement units.
>
> I found your paper "The Unified Code for Units of Measure" on 
> the Internet. If is very useful.
> 
> I wonder if I may come with a few suggestions:
> 
> 1) The introduction of month as base unit (it should really be
> part of SI).

Month is not introduced as a "base unit", that would not make sense.
There are several different months, lunar, average calendar, etc. 

> Reason - month-based time and second-based time are not compatible
> from a mathematical point of view, as a month is not a multiple of
> seconds.

agree

> However, conversions can be made using a calendar as an
> intermediate step. I have implemented this in our new software, and it
> is very elegant to use, and it removes the burden from the modeller to
> make sure that time is correctly handled.

I've made attempts at specifying an abstract calendar which can map
physical time to calendar time. So I am interested in seeing your 
work too. It has no direct bearing on UCUM though because we only
deal with physical time, and there, month is at best imprecise and 
at worst ambiguous. Although UCUM takes all ambiguity out, it is
not clear whether people will be always using units exactly as defined.

> 2) The introduction of a point-unit concept in your standard. A point
> unit has an origin and a scale. Point units are most useful with
> temperatures and time (dates). Point units can also make sense in other
> situations, for example meter above (or below) ocean level. A point unit
> has an origin, a non-point unit does not.
> 
> I am sure this distinction has been made before, but maybe you would be
> interested in looking into how we have solved it. In shrt, all units
> have the capability of being point units. When using the unit, a @ sign
> is put in front of the name when the unit is treated as a point unit. If
> the @ is omitted, the unit is treated as a normal unit.
> 
> Examples:
> 
>     10 @C is the temperatur equal to 273.15+10 kevin, i.e. 283.15 @K
> 
>     10 C is a temperature difference equal to 10 kelvin, i.e. 10 K.
> 
>     2000 @year is the year 2000, measured in month-time. It is equal to
> date(2000).
> 
>     100 year is one hundred years of time, measured in month-time, i.e.
> the same as 1200 months.
> 
>     1 @s is the point-in-time one second after the origin of time, as
> defined for the second-unit. In our implementation it is set to
> 1.1.2000. The value is the same as date(2000, Jan, 1, 0, 0, 1).

We have "special units" that use conversion functions. I agree that this
might be a feature for an implementation, I'd be concerned at how people 
would use this. The calendar examples you give seem to be out of the scope
of a units of measure standard. We have other standards for expressing 
points in time on a calendar.

> Rules for the use of units can be checked by the software. They are:
> 
>     point + normal = point
> 
>     normal + normal = normal
> 
>     point - normal = point
> 
>     normal - normal = normal
> 
>     point - point = normal
> 
>     point + point is illegal

I agree to those rules, but I think that these point measures are outside
the scope of units. Units do not replace the need to specifying the property
that is being measured. And these distinctions seem to be in the properties.
 
> The symbol ° can be used as an alternative to @. This means that 10 °K
> is the temperature 10 kelvin, whereas 10 K is a temperature difference
> (delta) of 10 kelvin.
> 
> A unit is defined like this:
> 
> 1) Units with origin = zero:
> 
> name = normal unit expression
> 
> Example: cm = 0.001 m
> 
> 2) Units with origin <> zero
> 
> name = @(scale, origin)
> 
> Where origin must be a point unit expression, and scale a normal unit
> expression.
> 
> Examples:
> 
>     C = @(1K, 273.15@K)
> 
>     F = @(5/9*C, (5/9*32)@C)
> 
> The syntax @(scale,origin) is easy to read for humans and easy to parse
> for software. Maybe you can consider it for your Unified Code for Units
> of Measure.

I don't know if this syntax is relevant for the *use* of UCUM unit 
rather than for their *definition*. For defining Cel and degF we 
are applying a similar, yet more general approach using the conversion
function pair. Your proposal suggets to add a special case for these
linear conversions.

> There are some minor mistakes in the document, that you may want to
> correct. In particular, horse power is defined as:
> 
> [ft_i].[lbf_av]/s
> 
> However, lbf_av does not exist. It is called lb_av.

But [lbf_av] is defined. It is 

pound force     force       1 [lbf_av] = 1 [lb_av].[g] 

> Here is a sentence that you should look more closely at: "Hence, the
> symbols for the U.S. survey foot and the British Imperial foot are
> defined as “|[ft_i]|,” “|[ft_us]|,” and “|[ft_br]|” respectively." (ch.
> 4.4).

I fixed this immediately to include international foot lining up the 
respective items. Thanks.
```

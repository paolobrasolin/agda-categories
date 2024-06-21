# Contributing


## Design principles


## Code conventions

The full code of the library is available online:
* https://github.com/agda/agda-categories is the code repository, where the GitHub interface allows you to easily search the codebase and inspect its history;
* https://agda.github.io/agda-categories/ is an HTML rendering, where syntax highlighting and hyperlinks allow you to easily browse and read the codebase.

In the remainder of this section we go through the ideas organizing the structure of the library.

Since the Agda module system forces file paths to match modules names, we'll only talk about the module names.


### Structure


#### Basics

**All code that shouldn't (eventually) be in the Agda standard library is under `Categories`.**

All important concepts in Category Theory have their own namespace: `Categories.Category`, `Categories.Functor`, `Categories.Adjoint`, etc.

Many of the usual definitions are gathered in submodules: `Categories.Category.Complete`, `Categories.Category.Cartesian`, `Categories.Category.Topos`, etc.

There are also namespaces for other concepts: `Categories.Bicategory`, `Categories.Enriched`, `Categories.Pseudofunctor`, etc.


#### Properties

**If `P` is a property following from the definition of `X` then its path must be `X.Properties.Y`.**


#### Instances

**If `Y` is an _instance_ of `X` then its path must be `X.Instance.Y`.**

By _instance_ we mean "an example of something": as a rule of thumb, you should be able to say _`Y` is an `X`_.

As opposed to constructions, instances are not parametrized over any input in a non-trivial way.

Examples:
* the (large) Category of (small) Categories;
* the Category of Types and functions;
* the Category of Setoids.


#### Constructions

**If `Y` is a construction over `X` then its path must be `X.Construction.Y`.**

By _construction_ we mean "something built out of something": as a rule of thumb, you should be able to say _given an `X` then we can build a `Y`_.

As opposed to instances, constructions are parametrized over some input in a non-trivial way.


#### Core

It is sometimes necessary to isolate the main definitions of a module to avoid various kinds of import loops.

In such situations, the main definitions of `X` should be extracted in a module named `X.Core` and re-exported as follows:
```agda
-- src/Categories/X/Core.agda
module Categories.X.Core where
{- Main definitions go here. -}
```
```agda
-- src/Categories/X.agda
module Categories.X where
open import Categories.X.Core public
{- Other definitions go here. -}
```
**`X.Core` should only be imported if importing `X` causes an import cycle.**

Examples:
* [`Categories.Category.Core`](https://agda.github.io/agda-categories/Categories.Category.Core.html)
* [`Categories.Functor.Core`](https://agda.github.io/agda-categories/Categories.Functor.Core.html)
* [see all on GitHub](https://github.com/search?type=code&q=repo%3Aagda%2Fagda-categories+path%3Asrc%2F**%2FCore.agda)


### Naming

- Named modules are often used when multiple structures are in concurrent use; for example,
  if the 'components' of two categories (say A and B) are used in the same context, then
  (private) modules A and B are defined for easier access.

- Components of larger structures use long English names instead of the more usual
  Categorical 1-Greek-letter short-hands.  So unitor<sup>l</sup> rather than
  &lambda; and associator rather than &alpha;.


### Style


## Performance guidelines


# References

* https://github.com/agda/agda-categories/blob/master/README.md
* https://github.com/agda/agda-categories/issues/308
* https://github.com/agda/agda-categories/wiki/speed
* https://arxiv.org/pdf/2005.07059
* https://arxiv.org/pdf/1401.7694


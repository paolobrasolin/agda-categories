# Contributing


## Design principles


## Code conventions

The full code of the library is available online:
* https://github.com/agda/agda-categories is the code repository, where the GitHub interface allows you to easily search the codebase and inspect its history;
* https://agda.github.io/agda-categories/ is an HTML rendering, where syntax highlighting and hyperlinks allow you to easily browse and read the codebase.

In the remainder of this section we go through the ideas organizing the structure of the library.

Agda's module system enforces a one-to-one correspondence between module names and file paths (e.g. `Foo.Bar.Qux` must be defined in the file `src/Foo/Bar/Qux.agda`), therefore we'll primarily refer to modules in the following.


### Structure


#### Foundation

Implementing `agda-categories` requires some extensions to `agda-stdlib`.

**All code extending `agda-stdlib` follows the structure of `agda-stdlib` itself.**

**All code implementing `agda-categories` proper is the `Categories` module.**


#### Basics

**All main concepts in Category Theory have their own namespace in `Categories`.**

Examples:
[`Categories.Category`](https://agda.github.io/agda-categories/Categories.Category.html),
[`Categories.Functor`](https://agda.github.io/agda-categories/Categories.Functor.html),
[`Categories.Adjoint`](https://agda.github.io/agda-categories/Categories.Adjoint.html);
[see all on GitHub](https://github.com/search?type=code&q=repo%3Aagda%2Fagda-categories+path%3Asrc%2FCategories%2F*.agda).


#### Specializations
<!-- TODO: is "specialization" the best way to put it? -->

**If `Y` is a specialization of `X` then its path must be `X.Y`.**

By specialization we mean "adding structure or properties to something": as a rule of thumb, you should be able to say _`Y` is an `X` with extra structure and/or properties_.

Examples:
[`Categories.Category.Complete`](https://agda.github.io/agda-categories/Categories.Category.Complete.html),
[`Categories.Category.Cartesian`](https://agda.github.io/agda-categories/Categories.Category.Cartesian.html),
[`Categories.Category.Topos`](https://agda.github.io/agda-categories/Categories.Category.Topos.html).
<!-- NOTE: we can't really catch these with a search query. -->
<!-- [see more on GitHub](https://github.com/search?type=code&q=repo%3Aagda%2Fagda-categories+path%3Asrc%2FCategories%2F*%2F*.agda). -->


#### Properties

**If `P` is a property following from the definition of `X` then its path must be `X.Properties.P`.**

<!-- TODO: yeah, the phrasing above isn't really working tbh -->
<!-- TODO: that's... not true? clarify that we don't mean properties derived from the definitions, but properties that MIGHT hold. -->

Examples:
[`Categories.Category.Cartesian.Properties`](https://agda.github.io/agda-categories/Categories.Cartesian.Properties.html);
[`Categories.Functor.Properties`](https://agda.github.io/agda-categories/Categories.Functor.Properties.html),
[`Categories.Yoneda.Properties`](https://agda.github.io/agda-categories/Categories.Yoneda.Properties.html),
[see all on GitHub](https://github.com/search?type=code&q=repo%3Aagda%2Fagda-categories+path%3Asrc%2F**%2FProperties**).

#### Instances

**If `Y` is an _instance_ of `X` then its path must be `X.Instance.Y`.**

By _instance_ we mean "an example of something": as a rule of thumb, you should be able to say _`Y` is an `X`_.

As opposed to constructions, instances are not parametrized over any input in a non-trivial way.

Examples:
* the (large) Category of (small) Categories [`Categories.Category.Instance.Cat`](https://agda.github.io/agda-categories/Categories.Category.Instance.Cat.html),
* the Category of Types and functions [`Categories.Category.Instance.Set`](https://agda.github.io/agda-categories/Categories.Category.Instance.Set.html),
* the Category of Setoids [`Categories.Category.Instance.Setoids`](https://agda.github.io/agda-categories/Categories.Category.Instance.Setoids.html);
* [see all on GitHub](https://github.com/search?type=code&q=repo%3Aagda%2Fagda-categories+path%3Asrc%2F**%2FInstance%2F*.agda).


#### Constructions

**If `Y` is a construction over `X` then its path must be `X.Construction.Y`.**

By _construction_ we mean "something built out of something": as a rule of thumb, you should be able to say _given an `X` then we can build a `Y`_.

As opposed to instances, constructions are parametrized over some input in a non-trivial way.

Examples:
* the core of a Category [`Categories.Category.Construction.Core`](https://agda.github.io/agda-categories/Categories.Category.Construction.Core.html),
* the limit of a functor [`Categories.Functor.Construction.Limit`](https://agda.github.io/agda-categories/Categories.Functor.Construction.Limit.html),
* [see all on GitHub](https://github.com/search?type=code&q=repo%3Aagda%2Fagda-categories+path%3Asrc%2F**%2FConstruction%2F*.agda).

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

> Named modules are often used when multiple structures are in concurrent use; for example, if the 'components' of two categories (say A and B) are used in the same context, then (private) modules A and B are defined for easier access.

> Components of larger structures use long English names instead of the more usual Categorical 1-Greek-letter short-hands. So unitor<sup>l</sup> rather than &lambda; and associator rather than &alpha;.


### Style


## Performance guidelines


# References

[^readme]: https://github.com/agda/agda-categories/blob/v0.2.0/README.md
[^Issue308]: https://github.com/agda/agda-categories/issues/308
[^Wiki]: https://github.com/agda/agda-categories/wiki/speed
[^Hu20]: https://arxiv.org/pdf/2005.07059
[^Gross14]: https://arxiv.org/pdf/1401.7694


# Contributing


> One of the main reasons that the old library started bit-rotting was that it used *proof-irrelevance* quite extensively. And that this feature started misbehaving in later versions of Agda (it does not seem to be used much in the standard library, so gets less testing). And the desire to see how far one could go in Category Theory while being *proof relevant*. This proof relevance does not have a large effect, at least not until some definitions that use natural transformation-based identities (like that for Monad); here the classical definition is "sloppy", omitting some coherence natural isomorphisms that are expanded away in the proof-irrelevant case, but must be inserted here. Along with proof relevance, it also makes sense to develop under the conditions of *--without-K* and *--safe*.  And to stay away from strict category theory -- being Setoid-enriched doesn't play well with that at all. Ref: [^GithubReadme].

> A second aim is to make this library 'ready' to be, in whole or in part, incorporated into the main standard library. Thus that means removing many custom-made parts written for Setoid-based reasoning from the previous version, amongst others, and instead rely on the standard library as much as possible. Also, the style should be adapted to use that of the standard library. Ref: [^GithubReadme].

> Another clear design decision, already present in the original, is to internalize to each category a version of Hom-equality, i.e. as mentioned above, to be Setoid-enriched.  In practice what this means is that here and there, the flavour is that of bicategory theory instead of category theory. Ref: [^GithubReadme].

> All non-trivial proofs are done in equational style. One-liner proofs are not; some very short proofs (obvious 2- or 3-steps) are done combinator-style. Very large proofs with trivial sequences of steps "in the middle" have those done combinator-style too. Ref: [^GithubReadme].

> We add `sym-assoc` and `identity²` in order to achieve better definitional equality of `Category`. The rationale can be found in [this paper](https://arxiv.org/pdf/1401.7694.pdf). Ref: [^GithubReadme].

> We also add other "redundant" axioms into other definitions so that we achieve a better definitional equality property for definitions with opposites. Ref: [^GithubReadme].

> Use (private) modules instead of local renaming to resolve name clashes that would occur with opening the same module twice, such as when working with two categories, two functors, etc. Ref: [^GithubReadme].

> (bicategory is defined as Enriched over (Monoidal) Cats instead of 'by hand') Ref: [^GithubReadme].

> (definition of Pseudofunctor is in Benabou style rather than 'by hand') Ref: [^GithubReadme].

> Do not make implicit fields that can rarely be inferred (like what had been done in Category and Functor) Ref: [^GithubReadme].

> Do not use Heterogeneous equality at all. Really, never ever. Ref: [^GithubReadme].

> Minimize all use of propositional equality. Try to make things Setoid-enriched instead of Set-enriched. Ref: [^GithubReadme].

### Other sources:

* [Categories.Category.Discrete](src/Categories/Category/Discrete.agda)
* [Categories.Category.Monoidal](src/Categories/Category/Monoidal.agda)
* [Categories.Adjoint.Mate](src/Categories/Adjoint/Mate.agda)
* agda/agda-categories#5


## Design choices


### Fitting with modern Agda


#### Agda system

* use dependent types
* be constructive


#### Agda ecosystem

* use `agda-stdlib` as much as possible
* use `agda-stdlib`'s naming conventions whenever meaningful


#### Agda modes

* use `--safe`
* use `--without-K`


## Formalization choices



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

> Named modules are often used when multiple structures are in concurrent use; for example, if the 'components' of two categories (say A and B) are used in the same context, then (private) modules A and B are defined for easier access. Ref: [^GithubReadme].

> Components of larger structures use long English names instead of the more usual Categorical 1-Greek-letter short-hands. So unitor<sup>l</sup> rather than &lambda; and associator rather than &alpha;. Ref: [^GithubReadme].


### Style

> Be very sparing with open public. This can be convenient at times, but can also really pollute the name space and make interoperability complicated. Ref: [^GithubComment909599749].

> Avoid putting too many utilities directly in a record. Instead, go for minimal records and a utility module that adds them all. Then users can choose to bring them in at the use site. Ref: [^GithubComment909599749].

## Performance guidelines

> Reasonably often, it's not your code that is the biggest culprit, it is the library itself. There are known issues in the Monoidal and Bicategory hierarchy that have not yet been fixed. PRs for these would be most welcome. Ref: [^GithubWikiSpeed].

> Don't inline long equational proofs in record definitions. Ref: [^GithubComment906570461], [^GitHubComment905410931], [^ZulipTopicEqProofs].

> Don't use let-in because that's just syntactic sugar, and it will get expanded out / duplicated everywhere. It might be ok for open and giving short names meant for humans. Ref: [^GithubComment909599749].

> Don't put module versions of a record in records all over the place. These make the end results a lot bigger, and make typechecking time go up quite a bit too. Note: the paper explicitly advocates for this pattern! It is indeed super-convenient, but also very bad for efficiency. Ref: [^GithubComment909599749].

> Do use using qualifiers, both at the top and for local modules. These end up in the signature of the modules, and can have a knock-on effect on size. Ref: [^GithubComment909599749].

> **Asking agda to work too hard:** using lots of _ in equational proofs.
> Solution: Don't be so lazy, expand out those _.
> Ref: [^GithubWikiSpeed].

> **Hard implicits:** when you have a term that has a f  ∘ g (or equivalent) that computes away, the "middle type" might no longer be visible at all in the fully evaluated goal.
> Solution: Take a look at your goals with all implicits shown and normalize fully. If your implicits are filled with expanded records instead of the name of the thing you had expected Agda to provide, it's because Agda chose to reconstruct it. You should provide those explicitly, to turn the problem into one of checking instead of inference.
> Ref: [^GithubWikiSpeed].

> **Large files:** it sure feels like typechecking isn't linear in the size of your file. Conjecture: I think Agda 'peeks' too much when it actually knows the full definition, and doesn't do it as much cross-modules.
> Solution: Split things up!
> Ref: [^GithubWikiSpeed].

> **Large interfaces:** remember that it's not just the fields of a record that are on its interfaces, but all conservative extensions (aka definitions) are too.
> Solution: Split the helper routines into its own module (and its own file). Some downstream code will use these a lot, some very little. That saves a lot of time for that latter downstream code. If you have to import some huge module, then use using, this cuts things down significantly.
> Ref: [^GithubWikiSpeed].

> **Convenience modules:** the lure of just being able to use . is so strong.
> Solution: These feel like they should be no cost, but that's not true. Agda copies everything (and does some re-checking). This bloats the size of interfaces hugely. agda-categories uses a lot of these "convenience" modules (we didn't realize how expensive they were). It looks like if you make the convenience modules private then it's not as bad, as they don't appear on the interface.
> Ref: [^GithubWikiSpeed].

> **Inline proofs:** you know that something's a proof, but Agda doesn't. It's all just values. And Agda is awful at sharing, so it's splay those all over.
> Solution: Use a lot of where clauses where you name your proofs. Or put them in private blocks above your record. It seems that defining some things via copatterns instead of an explicit record might help too.
> Ref: [^GithubWikiSpeed].

> **Lack of sharing:** you know you've typed the same expression over and over, but Agda doesn't.
> Solution: For long equational proofs, some sub-expressions might take .5 seconds to typecheck -- but they appear 25 times in your proof... Agda doesn't go hash-consing or anything like that. It's quite well-known to do the opposite (let bindings get splayed out, the horror!). Go ahead and give names (and types) to oft repeated intermediate expressions (via where not let, of course).
> Ref: [^GithubWikiSpeed].

> It's also good to read [NAD's AIM 32](https://www.cse.chalmers.se/~nad/publications/danielsson-aim32-talk.txt) notes on efficiency and the [Performance Debugging](https://agda.readthedocs.io/en/v2.6.3/tools/performance.html) section of the manual.


<!-- References -->

[^GithubReadme]: https://github.com/agda/agda-categories/blob/v0.2.0/README.md
[^Hu20]: https://arxiv.org/pdf/2005.07059
[^Gross14]: https://arxiv.org/pdf/1401.7694

[^GithubComment906570461]: https://github.com/agda/agda-categories/issues/308#issuecomment-906570461
[^GithubComment905410931]: https://github.com/agda/agda-categories/pull/304#issuecomment-905410931
[^ZulipTopicEqProofs]: https://agda.zulipchat.com/#narrow/stream/238741-general/topic/*Very*.20long.20checking.20times.20for.20equational.20proofs
[^GithubComment909599749]: https://github.com/agda/agda-categories/issues/308#issuecomment-909599749
[^GithubWikiSpeed]: https://github.com/agda/agda-categories/wiki/speed


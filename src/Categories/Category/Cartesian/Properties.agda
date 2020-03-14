{-# OPTIONS --without-K --safe #-}

open import Categories.Category

module Categories.Category.Cartesian.Properties {o ℓ e} (C : Category o ℓ e) where

open import Level using (_⊔_)
open import Function using (_$_)
open import Data.Nat using (ℕ; zero; suc)
open import Data.Product using (Σ; _,_; proj₁) renaming (_×_ to _&_)
open import Data.Product.Properties
open import Data.List as List
open import Data.List.Any as Any using (here; there)
open import Data.List.Any.Properties
open import Data.List.Membership.Propositional
open import Data.Vec as Vec using (Vec; []; _∷_)
open import Data.Vec.Any as AnyV using (here; there)
open import Data.Vec.Membership.Propositional renaming (_∈_ to _∈ᵥ_)

open import Relation.Binary.PropositionalEquality as ≡ using (refl; _≡_)

open import Categories.Category.Cartesian C

open import Categories.Diagram.Pullback C
open import Categories.Diagram.Equalizer C
open import Categories.Morphism.Reasoning C

private
  open Category C
  open HomReasoning
  variable
    A B X Y : Obj
    f g : A ⇒ B

-- all binary products and pullbacks implies equalizers
module _ (prods : BinaryProducts) (pullbacks : ∀ {A B X} (f : A ⇒ X) (g : B ⇒ X) → Pullback f g) where
  open BinaryProducts prods
  open HomReasoning
  
  prods×pullbacks⇒equalizers : Equalizer f g
  prods×pullbacks⇒equalizers {f = f} {g = g} = record
    { arr       = pb′.p₁
    ; equality  = begin
      f ∘ pb′.p₁           ≈⟨ refl⟩∘⟨ helper₁ ⟩
      f ∘ pb.p₁ ∘ pb′.p₂   ≈⟨ pullˡ pb.commute ⟩
      (g ∘ pb.p₂) ∘ pb′.p₂ ≈˘⟨ pushʳ helper₂ ⟩
      g ∘ pb′.p₁           ∎
    ; equalize  = λ {_ i} eq → pb′.universal $ begin
      ⟨ id , id ⟩ ∘ i                                       ≈⟨ ⟨⟩∘ ⟩
      ⟨ id ∘ i , id ∘ i ⟩                                   ≈⟨ ⟨⟩-cong₂ identityˡ identityˡ ⟩
      ⟨ i ,  i ⟩                                            ≈˘⟨ ⟨⟩-cong₂ pb.p₁∘universal≈h₁ pb.p₂∘universal≈h₂ ⟩
      ⟨ pb.p₁ ∘ pb.universal eq , pb.p₂ ∘ pb.universal eq ⟩ ≈˘⟨ ⟨⟩∘ ⟩
      h ∘ pb.universal eq                                   ∎
    ; universal = ⟺ pb′.p₁∘universal≈h₁
    ; unique    = λ eq → pb′.unique (⟺ eq) (pb.unique (pullˡ (⟺ helper₁) ○ ⟺ eq) (pullˡ (⟺ helper₂) ○ ⟺ eq))
    }
    where pb : Pullback f g
          pb         = pullbacks _ _
          module pb  = Pullback pb
          h          = ⟨ pb.p₁ , pb.p₂ ⟩
          pb′ : Pullback ⟨ id , id ⟩ h
          pb′        = pullbacks _ _
          module pb′ = Pullback pb′
          helper₁ : pb′.p₁ ≈ pb.p₁ ∘ pb′.p₂
          helper₁    = begin
            pb′.p₁                    ≈˘⟨ cancelˡ project₁ ⟩
            π₁ ∘ ⟨ id , id ⟩ ∘ pb′.p₁ ≈⟨ refl⟩∘⟨ pb′.commute ⟩
            π₁ ∘ h ∘ pb′.p₂           ≈⟨ pullˡ project₁ ⟩
            pb.p₁ ∘ pb′.p₂            ∎
          helper₂ : pb′.p₁ ≈ pb.p₂ ∘ pb′.p₂
          helper₂    = begin
            pb′.p₁                    ≈˘⟨ cancelˡ project₂ ⟩
            π₂ ∘ ⟨ id , id ⟩ ∘ pb′.p₁ ≈⟨ refl⟩∘⟨ pb′.commute ⟩
            π₂ ∘ h ∘ pb′.p₂           ≈⟨ pullˡ project₂ ⟩
            pb.p₂ ∘ pb′.p₂            ∎


module Prods (car : Cartesian) where
  open Cartesian car

  -- for lists

  prod : List Obj → Obj
  prod objs = foldr _×_ ⊤ objs

  π[_] : ∀ {x xs} → x ∈ xs → prod xs ⇒ x
  π[ here refl ]  = π₁
  π[ there x∈xs ] = π[ x∈xs ] ∘ π₂

  data _⇒_* : Obj → List Obj → Set (o ⊔ ℓ) where
    _~[] : ∀ x → x ⇒ [] *
    _∷_  : ∀ {x y ys} → x ⇒ y → x ⇒ ys * → x ⇒ y ∷ ys *

  ⟨_⟩* : ∀ {x ys} (fs : x ⇒ ys *) → x ⇒ prod ys
  ⟨ x ~[] ⟩*  = !
  ⟨ f ∷ fs ⟩* = ⟨ f , ⟨ fs ⟩* ⟩

  ∈⇒mor : ∀ {x y ys} (fs : x ⇒ ys *) (y∈ys : y ∈ ys) → x ⇒ y
  ∈⇒mor (x ~[]) ()
  ∈⇒mor (f ∷ fs) (here refl)  = f
  ∈⇒mor (f ∷ fs) (there y∈ys) = ∈⇒mor fs y∈ys

  project* : ∀ {x y ys} (fs : x ⇒ ys *) (y∈ys : y ∈ ys) → π[ y∈ys ] ∘ ⟨ fs ⟩* ≈ ∈⇒mor fs y∈ys
  project* (x ~[]) ()
  project* (f ∷ fs) (here refl)  = project₁
  project* (f ∷ fs) (there y∈ys) = pullʳ project₂ ○ project* fs y∈ys

  uniqueness* : ∀ {x ys} {g h : x ⇒ prod ys} → (∀ {y} (y∈ys : y ∈ ys) → π[ y∈ys ] ∘ g ≈ π[ y∈ys ] ∘ h) → g ≈ h
  uniqueness* {x} {[]} uni     = !-unique₂
  uniqueness* {x} {y ∷ ys} uni = unique′ (uni (here ≡.refl)) (uniqueness* λ y∈ys → sym-assoc ○ uni (there y∈ys) ○ assoc)

  module _ {a} {A : Set a} (f : A → Obj) where
  
    f∈fl : ∀ {a l} (a∈l : a ∈ l) → f a ∈ map f l
    f∈fl a∈l = map⁺ (Any.map (≡.cong f) a∈l)

    f∈fl⁻¹ : ∀ {x l} → x ∈ map f l → Σ A (λ a → a ∈ l & x ≡ f a)
    f∈fl⁻¹ {x} {a ∷ l} (here px) = a , here ≡.refl , px
    f∈fl⁻¹ {x} {b ∷ l} (there x∈fl) with f∈fl⁻¹ x∈fl
    ... | a , a∈l , eq           = a , there a∈l , eq

    module _ {x} (g : ∀ a → x ⇒ f a) where
  
      build-mors : (l : List A) → x ⇒ map f l *
      build-mors []      = _ ~[]
      build-mors (y ∷ l) = g y ∷ build-mors l
  
      build-proj≡ : ∀ {a l} (a∈l : a ∈ l) → g a ≡ ∈⇒mor (build-mors l) (f∈fl a∈l)
      build-proj≡ (here refl) = ≡.refl
      build-proj≡ (there a∈l) = build-proj≡ a∈l
  
      build-proj : ∀ {a l} (a∈l : a ∈ l) → g a ≈ π[ f∈fl a∈l ] ∘ ⟨ build-mors l ⟩*
      build-proj {_} {l} a∈l = reflexive (build-proj≡ a∈l) ○ ⟺ (project* (build-mors l) _)
  
  -- for vectors

  prodᵥ : ∀ {n} → Vec Obj (suc n) → Obj
  prodᵥ v = Vec.foldr₁ _×_ v

  π[_]ᵥ : ∀ {n x} {xs : Vec Obj (suc n)} → x ∈ᵥ xs → prodᵥ xs ⇒ x
  π[_]ᵥ {.0} {.x} {x ∷ []} (here refl)           = id
  π[_]ᵥ {.(suc _)} {.x} {x ∷ y ∷ xs} (here refl) = π₁
  π[_]ᵥ {.(suc _)} {x} {_ ∷ y ∷ xs} (there x∈xs) = π[ x∈xs ]ᵥ ∘ π₂

  data [_]_⇒ᵥ_* : ∀ n → Obj → Vec Obj n → Set (o ⊔ ℓ) where
    _~[] : ∀ x → [ 0 ] x ⇒ᵥ [] *
    _∷_  : ∀ {x y n} {ys : Vec Obj n} → x ⇒ y → [ n ] x ⇒ᵥ ys * → [ suc n ] x ⇒ᵥ y ∷ ys *

  ⟨_⟩ᵥ* : ∀ {n x ys} (fs : [ suc n ] x ⇒ᵥ ys *) → x ⇒ prodᵥ ys
  ⟨ f ∷ (x ~[]) ⟩ᵥ*  = f
  ⟨ f ∷ (g ∷ fs) ⟩ᵥ* = ⟨ f , ⟨ g ∷ fs ⟩ᵥ* ⟩
  
  ∈⇒morᵥ : ∀ {n x y ys} (fs : [ n ] x ⇒ᵥ ys *) (y∈ys : y ∈ᵥ ys) → x ⇒ y
  ∈⇒morᵥ (x ~[]) ()
  ∈⇒morᵥ (f ∷ fs) (here refl)  = f
  ∈⇒morᵥ (f ∷ fs) (there y∈ys) = ∈⇒morᵥ fs y∈ys

  projectᵥ* : ∀ {n x y ys} (fs : [ suc n ] x ⇒ᵥ ys *) (y∈ys : y ∈ᵥ ys) → π[ y∈ys ]ᵥ ∘ ⟨ fs ⟩ᵥ* ≈ ∈⇒morᵥ fs y∈ys
  projectᵥ* (f ∷ (x ~[])) (here ≡.refl) = identityˡ
  projectᵥ* (f ∷ g ∷ fs) (here ≡.refl)  = project₁
  projectᵥ* (f ∷ g ∷ fs) (there y∈ys)   = pullʳ project₂ ○ projectᵥ* (g ∷ fs) y∈ys

  uniquenessᵥ* : ∀ {x n ys} {g h : x ⇒ prodᵥ {n} ys} → (∀ {y} (y∈ys : y ∈ᵥ ys) → π[ y∈ys ]ᵥ ∘ g ≈ π[ y∈ys ]ᵥ ∘ h) → g ≈ h
  uniquenessᵥ* {x} {.0} {y ∷ []} uni           = ⟺ identityˡ ○ uni (here ≡.refl) ○ identityˡ
  uniquenessᵥ* {x} {.(suc _)} {y ∷ z ∷ ys} uni = unique′ (uni (here ≡.refl)) (uniquenessᵥ* (λ y∈ys → sym-assoc ○ uni (there y∈ys) ○ assoc))

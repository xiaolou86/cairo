use core::panics::Panic;

trait Copy<T>;
trait Drop<T>;

impl SnapshotCopy<T> of Copy<@T>;
impl SnapshotDrop<T> of Drop<@T>;

// TODO(spapini): When associated types are supported, support the general trait Add<X, Y>.
trait Add<T> {
    fn add(lhs: T, rhs: T) -> T;
}
trait AddEq<T> {
    fn add_eq(ref self: T, other: T);
}

// TODO(spapini): When associated types are supported, support the general trait Sub<X, Y>.
trait Sub<T> {
    fn sub(lhs: T, rhs: T) -> T;
}
trait SubEq<T> {
    fn sub_eq(ref self: T, other: T);
}

// TODO(spapini): When associated types are supported, support the general trait Mul<X, Y>.
trait Mul<T> {
    fn mul(lhs: T, rhs: T) -> T;
}
trait MulEq<T> {
    fn mul_eq(ref self: T, other: T);
}

// TODO(spapini): When associated types are supported, support the general trait Div<X, Y>.
trait Div<T> {
    fn div(lhs: T, rhs: T) -> T;
}
trait DivEq<T> {
    fn div_eq(ref self: T, other: T);
}

// TODO(spapini): When associated types are supported, support the general trait Rem<X, Y>.
trait Rem<T> {
    fn rem(lhs: T, rhs: T) -> T;
}
trait RemEq<T> {
    fn rem_eq(ref self: T, other: T);
}

// TODO(spapini): When associated types are supported, support the general trait DivRem<X, Y>.
/// Division with remainder.
trait DivRem<T> {
    fn div_rem(lhs: T, rhs: NonZero<T>) -> (T, T);
}

trait PartialEq<T> {
    fn eq(lhs: @T, rhs: @T) -> bool;
    fn ne(lhs: @T, rhs: @T) -> bool;
}
impl PartialEqSnap<T, impl TEq: PartialEq<T>> of PartialEq<@T> {
    fn eq(lhs: @@T, rhs: @@T) -> bool {
        TEq::eq(*lhs, *rhs)
    }
    fn ne(lhs: @@T, rhs: @@T) -> bool {
        TEq::ne(*lhs, *rhs)
    }
}

// TODO(spapini): When associated types are supported, support the general trait BitAnd<X, Y>.
trait BitAnd<T> {
    fn bitand(lhs: T, rhs: T) -> T;
}

// TODO(spapini): When associated types are supported, support the general trait BitOr<X, Y>.
trait BitOr<T> {
    fn bitor(lhs: T, rhs: T) -> T;
}

// TODO(spapini): When associated types are supported, support the general trait BitXor<X, Y>.
trait BitXor<T> {
    fn bitxor(lhs: T, rhs: T) -> T;
}

trait BitNot<T> {
    fn bitnot(a: T) -> T;
}

trait PartialOrd<T> {
    fn le(lhs: T, rhs: T) -> bool;
    fn ge(lhs: T, rhs: T) -> bool;
    fn lt(lhs: T, rhs: T) -> bool;
    fn gt(lhs: T, rhs: T) -> bool;
}

/// Trait for conversion between types.
trait Into<T, S> {
    fn into(self: T) -> S;
}

impl TIntoT<T> of Into<T, T> {
    fn into(self: T) -> T {
        self
    }
}

/// Trait for fallible conversion between types.
trait TryInto<T, S> {
    fn try_into(self: T) -> Option<S>;
}

trait Neg<T> {
    fn neg(a: T) -> T;
}

trait Not<T> {
    fn not(a: T) -> T;
}

/// The following two traits are for implementing the [] operator. Only one should be implemented
/// for each type. Both are not consuming of self, the first gets a snapshot of the object and
/// the second gets ref.
trait IndexView<C, I, V> {
    fn index(self: @C, index: I) -> V;
}

trait Index<C, I, V> {
    fn index(ref self: C, index: I) -> V;
}

trait Destruct<T> {
    fn destruct(self: T) nopanic;
}
// TODO(spapini): Remove this, it can lead to multiple impls and unwanted Destruct implementation.
impl DestructFromDrop<T, impl TDrop: Drop<T>> of Destruct<T> {
    #[inline(always)]
    fn destruct(self: T) nopanic {}
}

trait PanicDestruct<T> {
    fn panic_destruct(self: T, ref panic: Panic) nopanic;
}
impl PanicDestructForDestruct<T, impl TDestruct: Destruct<T>> of PanicDestruct<T> {
    #[inline(always)]
    fn panic_destruct(self: T, ref panic: Panic) nopanic {
        TDestruct::destruct(self);
    }
}

trait Default<T> {
    fn default() -> T;
}

impl SnapshotDefault<T, impl TDefault: Default<T>, impl TDrop: Drop<T>> of Default<@T> {
    #[inline(always)]
    fn default() -> @T {
        @Default::default()
    }
}

/// Trait for types allowed as values in a Felt252Dict.
trait Felt252DictValue<T> {
    /// Returns the default value for this type as a value in a Felt252Dict.
    /// Should be logically equivalent to 0.
    fn zero_default() -> T nopanic;
}

// Tuple Copy impls.
impl TupleSize0Copy of Copy<()>;

impl TupleSize1Copy<E0, impl E0Copy: Copy<E0>> of Copy<(E0, )>;

impl TupleSize2Copy<E0, E1, impl E0Copy: Copy<E0>, impl E1Copy: Copy<E1>> of Copy<(E0, E1)>;

impl TupleSize3Copy<
    E0, E1, E2, impl E0Copy: Copy<E0>, impl E1Copy: Copy<E1>, impl E2Copy: Copy<E2>
> of Copy<(E0, E1, E2)>;

impl TupleSize4Copy<
    E0,
    E1,
    E2,
    E3,
    impl E0Copy: Copy<E0>,
    impl E1Copy: Copy<E1>,
    impl E2Copy: Copy<E2>,
    impl E3Copy: Copy<E3>
> of Copy<(E0, E1, E2, E3)>;

// Tuple Drop impls.
impl TupleSize0Drop of Drop<()>;

impl TupleSize1Drop<E0, impl E0Drop: Drop<E0>> of Drop<(E0, )>;

impl TupleSize2Drop<E0, E1, impl E0Drop: Drop<E0>, impl E1Drop: Drop<E1>> of Drop<(E0, E1)>;

impl TupleSize3Drop<
    E0, E1, E2, impl E0Drop: Drop<E0>, impl E1Drop: Drop<E1>, impl E2Drop: Drop<E2>
> of Drop<(E0, E1, E2)>;

impl TupleSize4Drop<
    E0,
    E1,
    E2,
    E3,
    impl E0Drop: Drop<E0>,
    impl E1Drop: Drop<E1>,
    impl E2Drop: Drop<E2>,
    impl E2Drop: Drop<E3>
> of Drop<(E0, E1, E2, E3)>;

// Tuple PartialEq impls.
impl TupleSize0PartialEq of PartialEq<()> {
    #[inline(always)]
    fn eq(lhs: @(), rhs: @()) -> bool {
        true
    }
    #[inline(always)]
    fn ne(lhs: @(), rhs: @()) -> bool {
        false
    }
}

impl TupleSize1PartialEq<E0, impl E0PartialEq: PartialEq<E0>> of PartialEq<(E0, )> {
    #[inline(always)]
    fn eq(lhs: @(E0, ), rhs: @(E0, )) -> bool {
        let (lhs, ) = lhs;
        let (rhs, ) = rhs;
        lhs == rhs
    }
    #[inline(always)]
    fn ne(lhs: @(E0, ), rhs: @(E0, )) -> bool {
        !(rhs == lhs)
    }
}

impl TupleSize2PartialEq<
    E0, E1, impl E0PartialEq: PartialEq<E0>, impl E1PartialEq: PartialEq<E1>
> of PartialEq<(E0, E1)> {
    #[inline(always)]
    fn eq(lhs: @(E0, E1), rhs: @(E0, E1)) -> bool {
        let (lhs0, lhs1) = lhs;
        let (rhs0, rhs1) = rhs;
        lhs0 == rhs0 && lhs1 == rhs1
    }
    #[inline(always)]
    fn ne(lhs: @(E0, E1), rhs: @(E0, E1)) -> bool {
        !(rhs == lhs)
    }
}

impl TupleSize3PartialEq<
    E0,
    E1,
    E2,
    impl E0PartialEq: PartialEq<E0>,
    impl E1PartialEq: PartialEq<E1>,
    impl E2PartialEq: PartialEq<E2>
> of PartialEq<(E0, E1, E2)> {
    #[inline(always)]
    fn eq(lhs: @(E0, E1, E2), rhs: @(E0, E1, E2)) -> bool {
        let (lhs0, lhs1, lhs2) = lhs;
        let (rhs0, rhs1, rhs2) = rhs;
        lhs0 == rhs0 && lhs1 == rhs1 && lhs2 == rhs2
    }
    #[inline(always)]
    fn ne(lhs: @(E0, E1, E2), rhs: @(E0, E1, E2)) -> bool {
        !(rhs == lhs)
    }
}

impl TupleSize4PartialEq<
    E0,
    E1,
    E2,
    E3,
    impl E0PartialEq: PartialEq<E0>,
    impl E1PartialEq: PartialEq<E1>,
    impl E2PartialEq: PartialEq<E2>,
    impl E3PartialEq: PartialEq<E3>
> of PartialEq<(E0, E1, E2, E3)> {
    #[inline(always)]
    fn eq(lhs: @(E0, E1, E2, E3), rhs: @(E0, E1, E2, E3)) -> bool {
        let (lhs0, lhs1, lhs2, lhs3) = lhs;
        let (rhs0, rhs1, rhs2, rhs3) = rhs;
        lhs0 == rhs0 && lhs1 == rhs1 && lhs2 == rhs2 && lhs3 == rhs3
    }
    #[inline(always)]
    fn ne(lhs: @(E0, E1, E2, E3), rhs: @(E0, E1, E2, E3)) -> bool {
        !(rhs == lhs)
    }
}

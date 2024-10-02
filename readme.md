# primrec: a primitive recursive function interpreter

`primrec` is a deeply simple interpreter for computing 
[primitive recursive functions](https://en.wikipedia.org/wiki/Primitive_recursive_function#cite_ref-1).

# Primitives
In `primrec`, all values are functions of integers. Their signature is simply
their *arity* aka how many arguments they take. For example, the integer 1 is
a function taking 0 arguments and returning the integer 1.

`primrec` ships with few keywords:
- `succ n` is the successor function, it can be applied to any value to add 1 to it.
- `proj (i <values>)` allows you to select the `i`th value out of multiple ones
- `rec (g h)` takes two values and acts as a for-loop from 0 to the value of `g`.

# Syntax
Our syntax is similar to that of Lisps, meaning you get a lot of parentheses to
make sure code is correct (and to save time writing a parser).

```lisp
proj (1 2 3 4)
```
Applies the keyword `proj` to arguments `1 2 3 4`, and has a value of `3` (it returns
the second argument, we index from 0).

Values can also be bounded to keywords, the syntax:
```lisp
bind x = proj (1 2 3 4)
```
will bind the value of `proj (1 2 3 4)` to the identifier `x`, which you can then
reuse to define more complex computations!

# Features
## Termination
`primrec` programs hold the guarantee to **always terminate**, a safety that
not even the folks over at [Rust](https://www.rust-lang.org/) can guarantee. 
Possibly non-halting programs can still be created by using the `bind UNSAFE` 
(in all caps to make sure you can't miss it) syntax, which gives you access to 
"unbounded minimization". All values that are bounded using the `bind UNSAFE` syntax 
can only be used within other unsafe binds.

## Type safety
Creating a robust and safe type system has been a fruitful area of research. We
simply opted for the simplest and most robust solution: **getting rid of types
altogether**.

Everything is an integer or a function producing integers. Can't have type errors
without types, so your program *must* be correct.

## Future proof
The specification for the `primrec` language can be found [here](https://en.wikipedia.org/wiki/Primitive_recursive_function).
It hasn't changed since its creation and will not change in the future, so programs
written in `primrec` are **guaranteed** to be viable forever, even more so than 
new "robust" languages like [Hare](https://harelang.org/) which have had their specification
for less than a few years.

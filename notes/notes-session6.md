# Session 6

## recap

- lets have a look at the new CXL documentation which you probably all know in the meantime.
- in the previous episodes we covered almost every piece and bit what makes an expression in CXL. From functions, literals, operators, predicates to path expressions.
- we also learned that expressions can be used in CDL for example in
annotation expressions, calculated elements or anywhere in a View. Furthermore expressions can also be used in CQL, which we mostly used to show the power of CXL throughout the sessions.
- in the last session we had a focus on path expressions
- we played around with the `nonSeller` association-like calculated element which was derived from the `books` association
- for example we wanted to get all those authors which had a `nonSeller`:

```js
> await cds.ql`SELECT from ${Authors} { name } where exists nonSeller`
```

- then we wanted to get some information about their `nonSeller`s and added some path expressions to the query:

```js
> await cds.ql`SELECT from ${Authors} { fullName, nonSeller.title, nonSeller.stock } where exists nonSeller`
```

- that resulted in a flat list with the author being returned multiple times with each of their books.

- we then spend some time to explore the nested projection syntax which allows us to get the non-seller books as a nested structure:

```js
> await cds.ql`SELECT from ${Authors} { name, nonSeller { title, stock }  } where exists nonSeller`
```

- we had a look at the SQL and the json function which enabled us to use the result set of the subquery as if it was a single value.


## todays stuff

- so last week we talked a lot about expands but it is worth noting that there is another type of a nested projections called `inline`:

```js
await cds.ql `SELECT from ${Authors} { name, books.{ title, stock } }`
```

-it can be used to group path expressions together, which again gives you the possibility to use renaming, exclusion and wildcards just with the other types
of projections

- alright lets move on and  explore the infix filter syntax a bit more
- first lets checkout the syntax diagram for the infix filter again
- What we see in the path expression syntax diagram is that we can use an infix filter after each association segment in a path expression
- depending on the context, the filter condition will become part of a forward declared join a where clause or will be pushed down into a subquery.

```js
await cds.ql `SELECT from Books[where stock between 50 and 100] { title }`
```

```js
await cds.ql `SELECT from Books[stock between 50 and 100]:author { name }`
```

```js
await cds.ql `SELECT from Books[stock between 50 and 100]:author[order by name asc] { name }`
```

pair it with exists:

```js
await cds.ql `SELECT from Books[stock between 50 and 100 and exists genre[name = 'Fantasy']]:author[order by name asc] { name }`
```

you can also use infix filters in the select list for example with an inlined path expression:

```js
cds.ql `SELECT from ${Authors} { name, books[stock between 50 and 100].{ title, stock } }`
```

or, to get rid of duplicated authors you can use the `expand` syntax:

```js
await cds.ql `SELECT from ${Authors} { name, books[stock between 50 and 100] { title, stock } }`
```
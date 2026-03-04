# Session 4

## recap

In the beginning of the session we talked a bit about the bits and pieces of the CDS expression language: Literals, operators, function and predicates.
We then spent some time on using expressions within CQL queries as well as in calculated elements. We ended the session with a look at how to
use CAPs portable functions in the context of CDL and CQL.

Good news: the new CXL documentation is now available for everyone: <https://cap.cloud.sap/docs/releases/2026/jan26#cds-expression-language>

✅ To start with a useful tool which comes in handy lets first let's have a look at the case expression:
which is another ternary operator:

```
> cds.parse.expr`case when stock > 10 then 'non seller' else 'sells quickly' end`
> cds.parse.expr`stock > 10 ? 'non seller' : 'sells quickly'`
> cds.parse.expr`stock > 10 ? (price > 50 ? 'expensive non seller' :  'cheap non seller'): 'sells quickly'`
```


✅ Before jumping into the path expresison topic, we will learn a little bit more about predicates.

The BETWEEN predicate is a special type known as a "ternary predicate".

```
> cds.parse.expr`stock >= 10 and stock <= 30`
```

we can write
```
cds.parse.expr`stock between 12 and 14`
> await cds.ql`select from Books { title, stock } where stock between 12 and 34`
```

this is a closed interval, meaning both boundaries are included.

the IN predicate is also a special one, as it can be used in two flavors: with a list of values or with a subquery.

```
> await cds.ql`select from ${Books} { title, ID, stock } where (author.ID) in (select ID from ${Authors} where dateOfDeath is null)`
```

lets now dive into path expressions, which are a powerful way to navigate associations in CQL.

```
> await cds.ql`select from ${Authors} { name } where books.genre.name = 'Fantasy'`
```


my most favorite predicate is the `exists` predicate, which is the single most powerful predicate in CQL.
And can be used in conjunction with path expressions to express conditions on associated entities.

use the exits predicates for to-many checks like this:


```
> await cds.ql`select from ${Authors} { name } where exists books[genre.name = 'Fantasy']`
```
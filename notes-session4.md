# Session 4

## recap

In the beginning of the session we talked a bit about the bits and pieces of the CDS expression language: Literals, operators, function and predicates.
We then spent some time on using expressions within CQL queries as well as in calculated elements. We ended the session with a look at how to
use CAPs portable functions in the context of CDL and CQL.

Good news: the new CXL documentation is now available for everyone: <https://cap.cloud.sap/docs/releases/2026/jan26#cds-expression-language>

We will jump in with an example on hot to use predicates in CDS expressions.
The BETWEEN predicate is a special type known as a "ternary predicate".


```
> cds.parse.expr`stock >= 10 and stock <= 30`
```

we can write
```
cds.parse.expr`stock between 12 and 14`
```

this is a closed interval, meaning both boundaries are included.


the IN predicate is also a special one, as it can be used in two flavors: with a list of values or with a subquery.

```
> await cds.ql`select from ${Books} { title, ID, stock } where (author.ID) in (select ID from ${Authors} where dateOfDeath is null)`
```

we will also have a look at the exists predicate later, but first let's have a look at the case expression:
which is another ternary operator:

```
> cds.parse.expr`case when stock > 10 then 'non seller' else 'sells quickly' end`
> cds.parse.expr`stock > 10 ? 'non seller' : 'sells quickly'`
> cds.parse.expr`stock > 10 ? (price > 50 ? 'expensive non seller' :  'cheap non seller'): 'sells quickly'`
```


```
  nonSeller  = books[stock > 100];
```
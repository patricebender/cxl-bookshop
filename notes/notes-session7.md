# Session 7

I will talk about past sessions and give you a sneak peak of stuff the cap team is currently preparing in the machine room.

## Session 1

### explained differences of languages:

- **CDL** = Conceptual Definition Language
- **CSN** = Core Schema Notation
- **CQL** = CDS Query Language
- **CQN** = CDS Query Notation
- **CXL** = CDS eXpression Language
- **CXN** = CDS eXpression Notation

💡 CXL is used everywhere, the expressions used throughout CAP always end up in the context of queries

### declarative constraints

show example again

## Session 2 & 3

### Literals

```js [cds repl]
> cds.parse.expr ` 42 `
```

### Operators

Unary & Binary:

```js [cds repl]
> cds.parse.expr `not foo`
> cds.parse.expr `foo > bar`
> cds.parse.expr `foo > bar AND bar != baz`
```

### Predicates

```js [cds repl]
> cds.parse.expr `foo IS NULL`
> cds.parse.expr `exists assoc`
> await cds.ql`select from Books { title, stock } where stock between 12 and 34`
```

### Functions

```js [cds repl]
> cds.parse.expr ` func(arg1) `
```

### Applied the concepts

```js [cds repl]
> await cds.ql`SELECT from Authors { age, name } where years_between(dateOfBirth, coalesce(dateOfDeath, $now)) < 50`
```

--> learned about forSQL() and  toSQL() to introspect the different stages a cds expression goes through until it is finally executed as SQL on the database.

## Session 4, 5 & 6

path expressions & infix filters

## Outlook

https://pages.github.tools.sap/cap/docs/cds/cxl#live-code
http://localhost:5173/docs/cds/cql
join relevant path expressions in filter expressions
https://recap-conf.dev/

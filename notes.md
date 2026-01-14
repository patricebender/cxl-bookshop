# Session with DJ

## Agenda

### Kickoff

#### ✅ release notes on declarative constraints

Show the mechanism in the bookshop.

```cds
annotate AdminService.Books:stock with @assert: (
  case
    when stock < 0 then 'Stock cannot be negative'
  end
);
```

then in cds.repl with Debug mode:

```js
{ Books } = AdminService.entities

await INSERT.into(Books).entries({ ID: 555, title: 'foo', stock: -1, author_ID: 180 })
```

💡 Show and explain the SQL transaction flow

#### ✅ Lets backup a bit and shed some light on all the Abbreviations

- **CDL** = Conceptual Definition Language
--> everything that you write in .cds files (entities, services, types, annotations, ...)

- **CSN** = Core Schema Notation
--> the in-memory representation of CDL models that captures Entity-Relationship Models and Extensions.

- **CQL** = CDS Query Language
--> typically used in your custom handlers to fire queries during runtime

- **CQN** = CDS Query Notation
--> the in-memory representation of CQL queries

- **CXL** = CDS eXpression Language
--> used in CDL: calculated elements, annotations, views and projections
--> used in CQL: columns, where, group by, having, order by, ...

- **CXN** = CDS eXpression Notation
--> the in-memory representation of CXL expressions

💡 CXL is used everywhere, the expressions used throughout CAP always end up in the context of queries

### Main Part

#### ✅ Now that we have clarified the abbreviations, we can dive deeper into CXL

- Show the new CXL documentation
- How to read this guide

#### ✅ CXL is based on the SQL expression language, so many syntax elements from SQL are also available in CXL.

- lets explore the sqlite syntax diagrams for expressions: <https://www.sqlite.org/syntax/expr.html>
- Lets compare the expr syntax diagrams of sqlite and CXL
--> They are not so different after all!

#### ✅ Literals

- Show different literal types in CXL

```js [cds repl]
> cds.parse.expr ` 42 `
{ val: 42 }
> cds.parse.expr ` 'Hello World' `
{ val: 'Hello World' }
> cds.parse.expr ` null `
{ val: null }
> cds.parse.expr ` true `
{ val: true }
> cds.parse.expr ` false `
{ val: false }
> cds.parse.expr ` Date'2026-01-01' `
{ val: '2026-01-01', literal: 'date' }
> cds.parse.expr ` Time'08:42:15.000' `
{ val: '08:42:15.000', literal: 'time' }
> cds.parse.expr ` TimeStamp'2026-01-14T10:30:00Z' `
{ val: '2026-01-14T10:30:00Z', literal: 'timestamp' }
```

#### ✅ Operators

- Unary operators that operate on a single operand:

```js [cds repl]
> cds.parse.expr ` +5 ` 
{ xpr: [ '+', { val: 5 } ] }
> cds.parse.expr ` -5 ` 
{ val: -5 }
> cds.parse.expr ` not 5 ` // boolean operator
{ xpr: [ 'not', { val: 5 } ] }
```

- Binary operators that operate on two operands:

```js [cds repl]
> cds.parse.expr ` x > y `
{
  xpr: [ { ref: [ 'x' ] }, '>', { ref: [ 'y' ] } ]
}
> cds.parse.expr ` x > y AND y > z` // boolean operator
{
  xpr: [
    { ref: [ 'x' ] },
    '>',
    { ref: [ 'y' ] },
    'and',
    { ref: [ 'y' ] },
    '>',
    { ref: [ 'z' ] }
  ]
}
> cds.parse.expr ` (x > y) AND (y > z)` // boolean operator
{
  xpr: [
    {
      xpr: [ { ref: [ 'x' ] }, '>', { ref: [ 'y' ] } ]
    },
    'and',
    {
      xpr: [ { ref: [ 'y' ] }, '>', { ref: [ 'z' ] } ]
    }
  ]
}
```

#### ✅ Predicates

- Show different predicates in CXL

```js [cds repl]
> cds.parse.expr ` x IS NULL `
{
  xpr: [ { ref: [ 'x' ] }, 'is', 'null' ]
}
> cds.parse.expr ` x IS NOT NULL `
{
  xpr: [ { ref: [ 'x' ] }, 'is', 'not', 'null' ]
}
> cds.parse.expr ` x IN (1, 2, 3) `
{
  xpr: [
    { ref: [ 'x' ] },
    'in',
    { list: [ { val: 1 }, { val: 2 }, { val: 3 } ] }
  ]
}
> cds.parse.expr ` x BETWEEN 1 AND 10 `
{
  xpr: [ { ref: [ 'x' ] }, 'between', { val: 1 }, 'and', { val: 10 } ]
}
> cds.parse.expr ` x LIKE 'Hello%' `
{
  xpr: [ { ref: [ 'x' ] }, 'like', { val: 'Hello%' } ]
}
> cds.parse.expr ` exists author `
{
  xpr: [ 'exists', { ref: [ 'author' ] } ]
}
```

### Optional: What Not How - HANA repl session

```shell
cds add mta
cds add hana
npm i
cds deploy --to hana
 cds bind --exec --profile hybrid -- cds r --run .
```

### Main Part II

We start with the @assert from last time which needs to be executed against the application service.
We continue with two questions:

1. 🤔 Q: Would it be possible to build an expression and then re-use it for different assertions?
2. 🤔 Q: Can we iterate over composition items with expressions? Example calculate order total amount using line item amounts?

#### ✅ [Literals](https://capire-cxl.cfapps.sap.hana.ondemand.com/docs/cds/cxl#literal-value)

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

#### ✅ [Operators](https://capire-cxl.cfapps.sap.hana.ondemand.com/docs/cds/cxl#operators)

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

#### ✅ [Functions](https://capire-cxl.cfapps.sap.hana.ondemand.com/docs/cds/cxl#function)

- Show different functions in CXL

```js [cds repl]
> cds.parse.expr ` func(arg1) `
{
  func: 'func',
  args: [ { ref: [ 'arg1' ] } ]
}

> cds.parse.expr ` func(arg1: foo > bar) `
{
  ref: [
    {
      id: 'func',
      args: {
        arg1: {
          xpr: [ { ref: [ 'foo' ] }, '>', { ref: [ 'bar' ] } ]
        }
      }
    }
  ]
}
```

- CAP also supports some portable functions which can be used on different databases

```js [cds repl]
> await cds.ql`SELECT name, years_between( dateOfBirth, coalesce(dateOfDeath, $now )) from ${Authors}`
[
  { name: 'Emily Brontë', years_between: 30 },
  { name: 'Charlotte Brontë', years_between: 36 },
  { name: 'Edgar Allen Poe', years_between: 40 },
  { name: 'Richard Carpenter', years_between: 82 },
  { name: 'Brandon Sanderson', years_between: 50 },
  { name: 'J. R. R. Tolkien', years_between: 81 }
]
```

and this also works the same way on HANA, SQLite, Postgres, ...

### Optional: What Not How - HANA repl session

```shell
cds add hana
npm i
cds deploy --to hana
cds bind --exec --profile hybrid -- cds r --run .
```

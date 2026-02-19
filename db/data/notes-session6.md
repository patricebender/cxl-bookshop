# Session 6

## recap

- CXL documentation is constantly improved, syntax diagrams are now more concise and better looking. Shoutout to Daniel for his work on this.
- We had a quick look at the CASE … WHEN statement (and the ternary shortcut)
- We then checked out predicates like the `expr between expr and expr`
- In our bookshop, we added an association-like calculated element which was based on the association to books.
  It allowed us to get all books of an author which have a stock of more than 100.
- then DJ asked if we can also re-use other element with the calculated element syntax --> SHOW fullName example

- We then learned why to prefer the `exists` predicate for existence checks over to-many relations.

```  
cds.ql`SELECT from Authors { name } where books.title like '%Mistborn%'`
cds.ql`SELECT from Authors { name } where exists books[ title like '%Mistborn%' ]`
```

## todays stuff

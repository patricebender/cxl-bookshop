# Session 4

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

- Lets go into the topics for today, starting from where we left of
- We used the `nonSeller` to get only those authors back, which have books which do not sell well.

```js
> await cds.ql`SELECT from ${Authors} { fullName } where exists nonSeller`
```

if we want to get the title of the non sellers:

```js
> await cds.ql`SELECT from ${Authors} { fullName, nonSeller.title, nonSeller.stock } where exists nonSeller`
```

However, here we get duplicates for authors with multiple non-seller books.

```js
> await cds.ql`SELECT from ${Authors} { fullName, nonSeller { title, stock }  } where exists nonSeller`
```

This syntax allows us to get the non-seller books as a nested structure. SO make sure to use nested projection for this!

Through the `nonSeller` calculated element we leveraged the infix filter to further narrow down the forward declared join
by the `books` association.

Lets have a look at the infix filter syntax diagram for a moment.

We can see, that we can use any expression within the brackets, so lets try to use another path expression within the brackets:

For example, if we only want those authors which have written a fantasy books. So first I show you how TO NOT do it:

```js
> q = cds.ql`SELECT from ${Authors} { fullName } where books.genre.name = 'Fantasy'`
```

we will now get an author back for each book which has the fantasy genre, so if an author has written 3 fantasy books, we get 3 entries for this author.

```js
> q = cds.ql`SELECT from ${Authors} { fullName } where exists books[genre.name = 'Fantasy']`
```
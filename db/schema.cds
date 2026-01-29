using { Currency, managed, sap } from '@sap/cds/common';

namespace sap.capire.bookshop;

aspect ConstrainedTitle {
  @assert: (
    case
      when length(title) > 1  then 'title must be at least 2 characters long'
    end
  )
  title : String @mandatory;
}


entity Books : managed, ConstrainedTitle {
  key ID   : Integer;
  descr    : localized String(1111);
  author   : Association to Authors @mandatory;
  genre    : Association to Genres;
  stock    : Integer;
  price    : Decimal;
  currency : Currency;
}

entity Authors : managed {
  key ID       : Integer;
  name         : String(111) @mandatory;
  dateOfBirth  : Date;
  dateOfDeath  : Date;
  placeOfBirth : String;
  placeOfDeath : String;
  books        : Association to many Books
                   on books.author = $self;
}

/** Hierarchically organized Code List for Genres */
entity Genres : sap.common.CodeList {
  key ID       : Integer;
      parent   : Association to Genres;
      children : Composition of many Genres
                   on children.parent = $self;
}

entity Orders: ConstrainedTitle {
  key ID : Int16;
  items  : Composition of many OrderItems on items.order = $self;
}
entity OrderItems {
  key order    : Association to Orders;
  key pos      : Integer;
  book         : Association to Books;
  quantity     : Integer;
  descr        : String;
}
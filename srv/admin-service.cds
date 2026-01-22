using {sap.capire.bookshop as my} from '../db/schema';

service AdminService {
  entity Books   as projection on my.Books;
  entity Authors as projection on my.Authors;
}

annotate AdminService.Books:stock with @assert: (
  case
    when stock < 0 then 'stock must not be negative'
    when stock > 1000 then 'stock exceeds maximum limit of 1000'
  end
);
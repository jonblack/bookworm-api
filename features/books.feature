Feature: Access book information
    As a client
    I want to access information relating to books
    So I can display this information to the user

    Scenario: Get all books
        Given the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
            | 2  | Andy Weer  |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
            | 2  | The Martian        | 2011           | 2         |
        When the client requests GET /books
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "_embedded":{
                "books":[
                  {
                    "id":1,
                    "title":"Ancilliary Justice",
                    "year_published":2013,
                    "_links":{
                      "self":{ "href":"http://example.org/book/1" },
                      "ratings":{ "href":"http://example.org/book/1/ratings" }
                    }
                  },
                  {
                    "id":2,
                    "title":"The Martian",
                    "year_published":2011,
                    "_links":{
                      "self":{ "href":"http://example.org/book/2" },
                      "ratings":{ "href":"http://example.org/book/2/ratings" }
                    }
                  }
                ]
              },
              "_links":{
                "self":{ "href":"http://example.org/books" }
              }
            }
            """

    Scenario: Get a single book
        Given the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
            | 2  | Andy Weer  |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
            | 2  | The Martian        | 2011           | 2         |
        When the client requests GET /book/1
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "id":1,
              "title":"Ancilliary Justice",
              "year_published":2013,
              "_links":{
                "self":{ "href":"http://example.org/book/1" },
                "ratings":{ "href":"http://example.org/book/1/ratings" }
              }
            }
            """

    Scenario: Get a non-existant book
        When the client requests GET /book/1
        Then the response Content-Type must be json
        And the response status code is 404
        And the response contains:
            """
            {
              "message":"Unknown book"
            }
            """

    Scenario: Get all books for a single author
        Given the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
            | 2  | Andy Weer  |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
            | 2  | The Martian        | 2011           | 2         |
        When the client requests GET /author/1/books
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "_embedded":{
                "books":[
                  {
                    "id":1,
                    "title":"Ancilliary Justice",
                    "year_published":2013,
                    "_links":{
                      "self":{ "href":"http://example.org/book/1" },
                      "ratings":{ "href":"http://example.org/book/1/ratings" }
                    }
                  }
                ]
              },
              "_links":{
                "self":{ "href":"http://example.org/author/1/books" }
              }
            }
            """

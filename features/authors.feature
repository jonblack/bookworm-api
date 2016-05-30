Feature: Access author information
    As a client
    I want to access information relating to authors
    So I can display this information to the user

    Scenario: Get all authors
        Given the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
            | 2  | Andy Weer  |
        When the client requests GET /authors
        Then the response Content-Type must be hal+json
        And the response contains:
           """
           {
             "_embedded":{
               "authors":[
                 {
                   "id":2,
                   "name":"Andy Weer",
                   "_links":{
                     "self":{ "href":"http://example.org/author/2" },
                     "books":{ "href":"http://example.org/author/2/books" }
                   }
                 },
                 {
                   "id":1,
                   "name":"Ann Leckie",
                   "_links":{
                     "self":{ "href":"http://example.org/author/1" },
                     "books":{ "href":"http://example.org/author/1/books" }
                   }
                 }
               ]
             },
             "_links":{
               "self":{ "href":"http://example.org/authors" }
             }
           }
           """

    Scenario: Get a single author
        Given the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
        When the client requests GET /author/1
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "id":1,
              "name":"Ann Leckie",
              "_links":{
                "self":{ "href":"http://example.org/author/1" },
                "books":{ "href":"http://example.org/author/1/books" }
              }
            }
            """

    Scenario: Get a non-existant author
        When the client requests GET /author/1
        Then the response Content-Type must be json
        And the response status code is 404
        And the response contains:
           """
           {
             "message":"Unknown author"
           }
           """

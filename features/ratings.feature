Feature: Access rating information
    As a client
    I want to access information relating to ratings
    So I can display this information to the user

    Scenario: Get all ratings by a single user
        Given the system knows about the following users:
            | id | username   | password |
            | 1  | jon        | testtest |
            | 2  | anna       | testtest |
        And the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
            | 2  | Andy Weer  |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
            | 2  | The Martian        | 2011           | 2         |
        And the system knows about the following ratings:
            | id | score | user_id | book_id |
            | 1  | 1     | 1       | 1       |
            | 2  | 2     | 1       | 2       |
            | 3  | 3     | 2       | 1       |
            | 4  | 4     | 2       | 2       |
        When the client requests GET /user/1/ratings
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "_embedded":{
                "ratings":[
                  {
                    "id":1,
                    "score":1,
                    "user_id":1,
                    "_links":{
                      "self":{ "href":"http://example.org/book/1/rating/1" },
                      "book":{ "href":"http://example.org/book/1" },
                      "user":{ "href":"http://example.org/user/1" }
                    }
                  },
                  {
                    "id":2,
                    "score":2,
                    "user_id":1,
                    "_links":{
                      "self":{ "href":"http://example.org/book/2/rating/2" },
                      "book":{ "href":"http://example.org/book/2" },
                      "user":{ "href":"http://example.org/user/1" }
                    }
                  }
                ]
              },
              "_links":{
                "self":{ "href":"http://example.org/user/1/ratings" }
              }
            }
            """

    Scenario: Get all ratings for a single book
        Given the system knows about the following users:
            | id | username   | password |
            | 1  | jon        | testtest |
            | 2  | anna       | testtest |
        And the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
            | 2  | Andy Weer  |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
            | 2  | The Martian        | 2011           | 2         |
        And the system knows about the following ratings:
            | id | score | user_id | book_id |
            | 1  | 1     | 1       | 1       |
            | 2  | 2     | 1       | 2       |
            | 3  | 3     | 2       | 1       |
            | 4  | 4     | 2       | 2       |
        When the client requests GET /book/1/ratings
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "_embedded":{
                "ratings":[
                  {
                    "id":1,
                    "score":1,
                    "user_id":1,
                    "_links":{
                      "self":{ "href":"http://example.org/book/1/rating/1" },
                      "book":{ "href":"http://example.org/book/1" },
                      "user":{ "href":"http://example.org/user/1" }
                    }
                  },
                  {
                    "id":3,
                    "score":3,
                    "user_id":2,
                    "_links":{
                      "self":{ "href":"http://example.org/book/1/rating/3" },
                      "book":{ "href":"http://example.org/book/1" },
                      "user":{ "href":"http://example.org/user/2" }
                    }
                  }
                ]
              },
              "_links":{
                "self":{ "href":"http://example.org/book/1/ratings" }
              }
            }
            """

    Scenario: Rate a book
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        And the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
        When the client requests POST /users/login with:
            """
            {
              "username":"test",
              "password":"testtest"
            }
            """
        And the client requests POST /book/1/ratings with:
            """
            {
              "score":3
            }
            """
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "id": 1,
              "score": 3,
              "user_id":1,
              "_links": {
                "self": { "href": "http://example.org/book/1/rating/1" },
                "book": { "href": "http://example.org/book/1" },
                "user": { "href": "http://example.org/user/1" }
              }
            }
            """

    Scenario: Rate a book by unauthenticated user
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        And the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
        And the client requests POST /book/1/ratings with:
            """
            {
              "score":3
            }
            """
        Then the response Content-Type must be json
        And the response status code is 401
        And the response contains:
            """
            {
              "message":"Authorization required"
            }
            """


    Scenario: Rate a book greater than 5 is an error
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        And the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
        When the client requests POST /users/login with:
            """
            {
              "username":"test",
              "password":"testtest"
            }
            """
        And the client requests POST /book/1/ratings with:
            """
            {
              "score":6
            }
            """
        Then the response Content-Type must be json
        And the response status code is 400
        And the response contains:
            """
            {
              "message":"Validation failed: Score must be between 1 and 5"
            }
            """

    Scenario: Rate the same book more than once by the same user
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        And the system knows about the following authors:
            | id | name       |
            | 1  | Ann Leckie |
        And the system knows about the following books:
            | id | title              | year_published | author_id |
            | 1  | Ancilliary Justice | 2013           | 1         |
        And the system knows about the following ratings:
            | id  | score | user_id | book_id |
            | 99  | 1     | 1       | 1       |
        When the client requests POST /users/login with:
            """
            {
              "username":"test",
              "password":"testtest"
            }
            """
        And the client requests POST /book/1/ratings with:
            """
            {
              "score":3
            }
            """
        Then the response Content-Type must be json
        And the response status code is 400
        And the response contains:
            """
            {
              "message": "This book has already been rated by this user"
            }
            """

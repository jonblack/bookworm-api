Feature: Authentication
    As a client
    I want to authenticate with the system
    So I can access the authenticated API

    Scenario: A new user signs up
        When the client requests POST /users/signup with:
            """
            {
              "username":"test",
              "password":"testtest"
            }
            """
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "id":1,
              "username":"test",
              "auth_token":"[a-z0-9]+",
              "_links":{
                "self":{ "href":"http://example.org/user/1" },
                "ratings":{ "href":"http://example.org/user/1/ratings" }
              }
            }
            """

    Scenario: A new user signs up with a password that's too short
        When the client requests POST /users/signup with:
            """
            {
              "username":"test",
              "password":"test"
            }
            """
        Then the response Content-Type must be json
        And the response status code is 400
        And the response contains:
            """
            {
              "message":"Validation failed: Password is too short (minimum is 8 characters)"
            }
            """

    Scenario: A new user signs up with an existing username
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        When the client requests POST /users/signup with:
            """
            {
              "username":"test",
              "password":"testtest"
            }
            """
        Then the response Content-Type must be json
        And the response status code is 400
        And the response contains:
            """
            {
              "message":"Validation failed: Username has already been taken"
            }
            """

    Scenario: Login
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        When the client requests POST /users/login with:
            """
            {
              "username":"test",
              "password":"testtest"
            }
            """
        Then the response Content-Type must be hal+json
        And the response contains:
            """
            {
              "id":1,
              "username":"test",
              "auth_token":"[a-z0-9]+",
              "_links":{
                "self":{ "href":"http://example.org/user/1" },
                "ratings":{ "href":"http://example.org/user/1/ratings" }
              }
            }
            """

    Scenario: Login with a non-existant username
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        When the client requests POST /users/login with:
            """
            {
              "username":"another",
              "password":"test"
            }
            """
        Then the response Content-Type must be json
        And the response status code is 400
        And the response contains:
            """
            {
              "message":"Unknown username"
            }
            """

    Scenario: Login with the wrong password
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        When the client requests POST /users/login with:
            """
            {
              "username":"test",
              "password":"test"
            }
            """
        Then the response Content-Type must be json
        And the response status code is 401
        And the response contains:
            """
            {
              "message":"Incorrect password"
            }
            """

    Scenario: Logout
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        When the client requests POST /users/login with:
            """
            {
              "username":"test",
              "password":"testtest"
            }
            """
        And the client requests POST /users/logout with:
            """
            {}
            """
        Then the response Content-Type must be json
        And the response status code is 200
        And the response contains:
            """
            {
              "id":1,
              "username":"test",
              "auth_token":"",
              "_links":{
                "self":{ "href":"http://example.org/user/1" },
                "ratings":{ "href":"http://example.org/user/1/ratings" }
              }
            }
            """

    Scenario: Logout fails for unauthenticated users
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        When the client requests POST /users/logout with:
            """
            {}
            """
        Then the response Content-Type must be json
        And the response status code is 401
        And the response contains:
            """
            {
              "message":"Authorization required"
            }
            """

    Scenario: Get a user and don't show their auth_token
        Given the system knows about the following users:
            | id | username | password |
            | 1  | test     | testtest |
        When the client requests GET /user/1
        Then the response Content-Type must be hal+json
        And the response status code is 200
        And the response contains:
            """
            {
              "id":1,
              "username":"test",
              "_links":{
                "self":{ "href":"http://example.org/user/1" },
                "ratings":{ "href":"http://example.org/user/1/ratings" }
              }
            }
            """

    Scenario: Get a non-existant user
        When the client requests GET /user/1
        Then the response Content-Type must be json
        And the response status code is 404
        And the response contains:
            """
            {
              "message":"Unknown user"
            }
            """

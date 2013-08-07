Feature: I use rimg Error class processing  the information errors
  Scenario Outline: I use the send() function to have an error image
    Given I set the argument for Error class "<error_path>","<error_image>","<size>"
    And I am an new Rimage::Error object
    When I use send() function get a error image
    Then I can see the error pictures in the error path
    And I delete the error path new image

  Examples:
    |error_path          |error_image|size|
    |public/images/error/|not_found  |555 |
    |public/images/error/|default    |555 |
    |public/images/error/|message    |555 |
    |public/images/error/|redirect   |555 |
    |public/images/error/|server     |555 |
    |public/images/error/|not_found  |222 |
    |public/images/error/|default    |222 |
    |public/images/error/|message    |222 |
    |public/images/error/|redirect   |222 |
    |public/images/error/|server     |222 |

  Scenario Outline: I use the code() function to Handle the code
    Given I set the argument for Error class(code) "<error_path>","<code>","<size>","<error_image>"
    And I am an new Rimage::Error object
    When I use code() function
    Then I can see the error pictures in the error path
    And I delete the error path new image

  Examples:
    |error_path          |code|size|error_image|
    |public/images/error/|404 |555 |not_found  |
    |public/images/error/|120 |555 |message    |
    |public/images/error/|323 |555 |redirect   |
    |public/images/error/|523 |555 |server     |
    |public/images/error/|024 |555 |default    |


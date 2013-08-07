Feature: I run this application, and I use it to upload and access pictures of different sizes.

  @right
  Scenario Outline: I use the application to make a new pictures.And change the image.
    Given I am a blue-moon application.
    And delete the public origin and cache files
    And I set the argument for the application."<path>","<image>","<size>"
    When I send a get request "/upload_form"
    And I upload the image
    Then I can see a new pictures in the origin path
    When I change the image size
    Then I can see a new pictures in the cache path.
    When I change the cache path image
    When I read the image again
    And I can see the changed image in the cache path
    And delete the public origin and cache files

  Examples:
    |path                     |image   |size|
    |features/test_img/origin/|test.jpg|960 |
    |features/test_img/origin/|test.gif|960 |
    |features/test_img/origin/|test.png|960 |
    |features/test_img/origin/|test.jpg|640 |
    |features/test_img/origin/|test.gif|640 |
    |features/test_img/origin/|test.png|640 |
    |features/test_img/origin/|test.jpg|768 |
    |features/test_img/origin/|test.gif|768 |
    |features/test_img/origin/|test.png|768 |
    |features/test_img/origin/|test.jpg|320 |
    |features/test_img/origin/|test.gif|320 |
    |features/test_img/origin/|test.png|320 |

  @error
  Scenario Outline: I use the application to make a does not exist pictures.
    Given I am a blue-moon application.
    And I set the error argument for the application."<path>","<file>","<error_file>"
    And delete the public origin and cache files
    When I send a get request "/upload_form"
    And I upload a other type file
    Then I can see the error pictures

  Examples:
    |path                     |file    |error_file                           |
    |features/test_img/origin/|test.csv|public/images/error/not_found_960.png|
    |features/test_img/origin/|test.ppp|public/images/error/not_found_960.png|

  @error
  Scenario Outline: I use the application to make a does not exist pictures.
    Given I am a blue-moon application.
    And delete the public origin and cache files
    And I set the error_size argument for the application."<path>","<image>","<error_size>","<code>","<error_file>"
    When I send a get request "/upload_form"
    And I upload the image
    Then I can see a new pictures in the origin path
    When I read a error_size picture
    Then requerst the http code and error_image
    And I delelte the error files
    And delete the public origin and cache files

  Examples:
  |path                     |image   |error_size|code|error_file    |
  |features/test_img/origin/|test.jpg|940       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|123       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|222       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|wwe       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|9w0       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|213       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|240       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|zzz       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|444       |404 |not_found_960.png|
  |features/test_img/origin/|test.jpg|ddd       |404 |not_found_960.png|

  @error
  Scenario Outline: I use the application to make a does not exist pictures.
    Given I am a blue-moon application.
    And delete the public origin and cache files
    And I set the error_name argument for the application."<path>","<image>","<error_name>","<right_size>","<code>","<error_file>"
    When I send a get request "/upload_form"
    And I upload the image
    Then I can see a new pictures in the origin path
    When I read a error_name picture
    Then requerst the http code and error_image
    And I delelte the error files
    And delete the public origin and cache files

  Examples:
    |path                     |image   |error_name    |right_size|code|error_file       |
    |features/test_img/origin/|test.jpg|test_error.jpg|960       |404 |not_found_960.png|
    |features/test_img/origin/|test.jpg|test_error.jpg|320       |404 |not_found_960.png|
    |features/test_img/origin/|test.jpg|test_error.jpg|640       |404 |not_found_960.png|
    |features/test_img/origin/|test.jpg|test_error.jpg|768       |404 |not_found_960.png|
    |features/test_img/origin/|test.jpg|test_error.dsg|960       |404 |not_found_960.png|
    |features/test_img/origin/|test.jpg|test_sossr.jpg|320       |404 |not_found_960.png|
    |features/test_img/origin/|test.jpg|test_earor.png|640       |404 |not_found_960.png|
    |features/test_img/origin/|test.jpg|tet_ersror.gif|768       |404 |not_found_960.png|

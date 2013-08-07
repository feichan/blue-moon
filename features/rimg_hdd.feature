Feature: I use rimg HDD class handle the image.
  Scenario Outline: I use the right argument set() function to read a image,and the cache_path not is nil
    Given I set the argument for window "<image>","<origin_path>","<cache_path>","<size>"
    And I am an new Rimage::HDD object
    When I use set() function to set a object
    Then the image have set
    And I use the send() function to read image
    Then I can see a new pictures in the cache_path
    When I change the pictures
    And I use the send() function to read image again
    Then I can see the changed image in the cache_path
    And I delete the cache_path files


  Examples:
    |origin_path              |cache_path              |image   |size|
    |features/test_img/origin/|features/test_img/cache/|test.gif|555 |
    |features/test_img/origin/|features/test_img/cache/|test.gif|222 |
    |features/test_img/origin/|features/test_img/cache/|test.png|555 |
    |features/test_img/origin/|features/test_img/cache/|test.png|222 |
    |features/test_img/origin/|features/test_img/cache/|test.jpg|555 |
    |features/test_img/origin/|features/test_img/cache/|test.jpg|222 |

  Scenario Outline: I use the right argument set() function to read a image,and the cache_path is nil
    Given I set the argument for window "<image>","<origin_path>","<cache_path>","<size>"
    And I am an new Rimage::HDD object
    When I use set() function to set a object second
    Then the image have set
    And I use the send() function to read image
    Then I can see a new pictures in the origin_path
    And I delete the cache_path files

  Examples:
    |origin_path              |cache_path|image   |size|
    |features/test_img/origin/|          |test.gif|555 |
    |features/test_img/origin/|          |test.gif|222 |
    |features/test_img/origin/|          |test.png|555 |
    |features/test_img/origin/|          |test.png|222 |
    |features/test_img/origin/|          |test.jpg|555 |
    |features/test_img/origin/|          |test.jpg|222 |

  Scenario Outline: I use the error argument set() function to read a image
    Given I set the argument for window "<image>","<origin_path>","<cache_path>" and "<word>"
    And I am an new Rimage::HDD object
    When I use set() function to set a object
    Then give me the error word.

  Examples:
    |origin_path               |cache_path              |image    |word           |
    |features/test_img/origins/|features/test_img/cache/|test.gif |Image Not Found|
    |features/test_img/origin/ |features/test_img/cache/|tests.gif|Image Not Found|
    |features/test_img/origins/|                        |test.jpg |Image Not Found|
    |features/test_img/origin/s|                        |test.jpg |Image Not Found|
    |features/test_img/origin/ |                        |tests.csv|Image Not Found|
    |features/test_img/origin/ |features/test_img/cache/|tests.csv|Image Not Found|


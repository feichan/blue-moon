Feature: Test aliyun_oss
  
  Scenario: request an image
		Given I am new an Rimage::AliyunOss object
		Then I set a image id not existed

	Scenario: request an image which no cache
		Given I am new an Rimage::AliyunOss object
		And I set a image id existed
		Then I get size image and save cache


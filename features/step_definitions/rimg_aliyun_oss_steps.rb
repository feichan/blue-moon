Given(/^I am new an Rimage::AliyunOss object$/) do
  @aliyun_oss = Rimg::AliyunOss.new('blue-moon')
end

Then(/^I set a image id not existed$/) do
	begin
  	@aliyun_oss.set('51a81a6cb53169e206000001')
  rescue Exception => e
  	e.message.should == "Image Not Found"
  end
end

Given(/^I set a image id existed$/) do
  @aliyun_oss.set('51a81a6cb53169e206000001.jpg')
end

Then(/^I get size image and save cache$/) do
  @aliyun_oss.send(960)
  open("http://blue-moon-cache.oss.aliyuncs.com/51a81a6cb53169e206000001_960.jpg")
end
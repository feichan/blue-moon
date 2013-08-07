Given(/^I set the argument for Error class "(.*?)","(.*?)","(.*?)"$/) do |error_path,error_image,size|
  @error_path = error_path
  @error_image = error_image
  @size = size
  @errr_file = @error_image+"_"+@size+".png"
  @path = @error_path+@errr_file

  @rimg_error
end

Given(/^I am an new Rimage::Error object$/) do
  @rimg_error = Rimg::Error.new(@error_path)
end

When(/^I use send\(\) function get a error image$/) do
  send_r = @rimg_error.send((@error_path+@error_image),@size)
  @return_md5 =  Digest::MD5.hexdigest(send_r)
end

Then(/^I can see the error pictures in the error path$/) do
  @error_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@path).to_blob)
  @return_md5.should == @error_md5
end

Then(/^I delete the error path new image$/) do
  `rm #{@path}`
end

Given(/^I set the argument for Error class\(code\) "(.*?)","(.*?)","(.*?)","(.*?)"$/) do |error_path,code,size,error_image|
  @code = code
  @size = size
  @error_image = error_image
  @error_path = error_path
  @errr_file = @error_image+"_"+@size+".png"
  @path = @error_path+@errr_file
end

When(/^I use code\(\) function$/) do
  code_r = @rimg_error.code(@code,@size)
  @return_md5 = Digest::MD5.hexdigest(code_r)
end

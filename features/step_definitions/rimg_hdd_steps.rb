Given(/^I set the argument for window "(.*?)","(.*?)","(.*?)","(.*?)"$/) do |image,origin,cache,size|
  img_arr = image.split(/\./)
  @image = image
  @img_name = img_arr[0]
  @img_type = img_arr[1]
  @origin = origin
  @cache = cache
  @size = size

  @rimg
  @s_md5

  @cache_name = @img_name+"_"+@size+"."+@img_type
  @path = (@cache == '') ? @origin+@cache_name : @cache+@cache_name

  @change_size = (@size.to_i+100).to_s
  @cache_name_2 = @img_name+"_"+@change_size+"."+@img_type
  @path_2 = (@cache == '') ? @origin+@cache_name_2 : @cache+@cache_name_2
end

Given(/^I am an new Rimage::HDD object$/) do
  @rimg = Rimg::HDD.new()
end

When(/^I use set\(\) function to set a object$/) do
  begin
    @rimg.set(@image,@origin,@cache)
  rescue => e
    @error = e
  end
end

When(/^I use set\(\) function to set a object second$/) do
  @rimg.set(@image,@origin)
end

Then(/^the image have set$/) do

end

Then(/^I use the send\(\) function to read image$/) do
  blob = @rimg.send(@size)
  @s_md5 = Digest::MD5.hexdigest(blob)
end

Then(/^I can see a new pictures in the cache_path$/) do
   @cache_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@path).to_blob)
   @s_md5.should == @cache_md5
end

Then(/^I can see a new pictures in the origin_path$/) do
  @cache_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@path).to_blob)
  @s_md5.should == @cache_md5
end

When(/^I change the pictures$/) do


  @rimg.send(@change_size)

  @change_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@path_2).to_blob)

  `rm #{@path}`
  `mv #{@path_2} #{@path}`

end

When(/^I use the send\(\) function to read image again$/) do
  @rimg.send(@size)
end

Then(/^I can see the changed image in the cache_path$/) do
  send_again_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@path).to_blob)
  send_again_md5.should == @change_md5
end


And(/^I delete the cache_path files$/) do
  `rm #{@path}`
end


Given(/^I set the argument for window "(.*?)","(.*?)","(.*?)" and "(.*?)"$/) do |image,origin,cache,word|
  img_arr = image.split(/\./)
  @image = image
  @img_name = img_arr[0]
  @img_type = img_arr[1]
  @origin = origin
  @cache = cache
  @word = word

  @rimg
end

Then(/^give me the error word\.$/) do
  @error.to_s.gsub(/\s/,'').should == @word.gsub(/\s/,'')
end

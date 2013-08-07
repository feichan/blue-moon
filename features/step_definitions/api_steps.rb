Given(/^I am a blue\-moon application\.$/) do
  #set application redirect,The default is NO
  header 'Accept', 'application/json'
end

Then(/^delete the public origin and cache files$/) do
  new_path =`ls public/images/origin/`.gsub(/\s/,"")
  new_path_2 =`ls public/images/cache/`.gsub(/\s/,"")
  if new_path != ""
    `rm public/images/origin/*`
  end
  if new_path_2 != ""
    `rm public/images/cache/*`
  end
end

Given(/^I set the argument for the application\."(.*?)","(.*?)","(.*?)"$/) do |path,image,size|
  @path = path
  @image = image
  @size = size
end

When(/^I send a get request "(.*?)"$/) do |url|
  get url
  @data = last_response.body
  @post_url = @data.scan(/action=\".*?\"/)[0].scan(/\".*\"/)[0].gsub(/\"/,"")
end

When(/^I upload the image$/) do
  #use the RestClient must run the `rackup` and the url is "localhost:9292"
  RestClient.post(
      @post_url,
      {
          :image => File.new("#{@path+@image}", 'rb')
      }
  )
  @old_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open("#{@path+@image}").to_blob)

  #post "/upload", "file" => Rack::Test::UploadedFile.new("features/test_img/origin/test.png","image/png")
end
Then(/^I can see a new pictures in the origin path$/) do
  @new_path =`ls public/images/origin/*`.gsub(/\s/,"")
  @new_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@new_path).to_blob)
  @new_md5.should == @old_md5
end
When(/^I change the image size$/) do
  type = @new_path.split(/\./)[1]
  file_id = @new_path.split(/\./)[0].split(/origin\//)[1]
  @read_url = "http://localhost:9292/image/#{file_id}_#{@size}.#{type}"
  get @read_url
  @cache_path = "public/images/cache/#{file_id}_#{@size}.#{type}"
end
Then(/^I can see a new pictures in the cache path\.$/) do
  @cache_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@cache_path).to_blob)
  @data = last_response.body
  return_md5 = Digest::MD5.hexdigest(@data)
  @cache_md5.should == return_md5
end

When(/^I change the cache path image$/) do
  change_img_path = "features/test_img/origin/test_tmp.jpg"
  `rm #{@cache_path}`
  `cp #{change_img_path} #{@cache_path}`
  @change_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@cache_path).to_blob)
end

When(/^I read the image again$/) do
  get @read_url
  @again_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@cache_path).to_blob)
end

When(/^I can see the changed image in the cache path$/) do
  @again_md5.should == @change_md5
end
Given(/^I set the error argument for the application\."(.*?)","(.*?)","(.*?)"$/) do |path,file,error_file|
  @path = path
  @file = file
  @error_file = error_file
end
When(/^I upload a other type file$/) do
  request = RestClient.post(
      @post_url,
      {
          :image => File.new("#{@path+@file}", 'rb')
      }
  )
  @error_md5 = Digest::MD5.hexdigest(request)
end

Then(/^I can see the error pictures$/) do
    file_error_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(@error_file).to_blob)
    file_error_md5.should == @error_md5
end

Given(/^I set the error_size argument for the application\."(.*?)","(.*?)","(.*?)","(.*?)","(.*?)"$/) do |path,image,size,code,error_file|
  @path = path
  @image = image
  @size = size
  @code = code
  @error_file = error_file
end

When(/^I read a error_size picture$/) do
  type = @new_path.split(/\./)[1]
  file_id = @new_path.split(/\./)[0].split(/origin\//)[1]
  read_error = "/image/#{file_id}_#{@size}.#{type}"

  @data =get read_error
end
Then(/^requerst the http code and error_image$/) do

  url_2 = @data.location.split(/org\//)[1]
  request_code = url_2.split(/\//)[1]
  request_code.to_i.should == @code.to_i

  @data_2 = get url_2
  @error_md5 = Digest::MD5.hexdigest(@data_2.body)

  path = "public/images/error/#{@error_file}"
  @error_img_md5 = Digest::MD5.hexdigest(MiniMagick::Image.open(path).to_blob)

  @error_md5.should == @error_img_md5
end

Given(/^I set the error_name argument for the application\."(.*?)","(.*?)","(.*?)","(.*?)","(.*?)","(.*?)"$/) do |path,image,error_name,size,code,error_file|
  @path = path
  @image = image
  @error_name = error_name
  @size = size
  @code = code
  @error_file = error_file
end

Then(/^I delelte the error files$/) do
  `rm public/images/error/#{@error_file}`
end

When(/^I read a error_name picture$/) do
  type = @new_path.split(/\./)[1]
  read_error = "/image/#{@error_name}_#{@size}.#{type}"
  @data =get read_error
end




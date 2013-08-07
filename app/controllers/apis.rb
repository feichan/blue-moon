# encoding: utf-8

before do
	# must send auth_token to blue-moon
	@auth_token = params[:auth_token]
	# TODO
	# search the @auth_token from Lamancha
	# if get error or false, return an not certified image
	# if get yes or true, access the api you want to 
end

# read image
# the API to return an image that request
# params:
# params[:image], the image name and size,
#	format like "#{image_id}_#{size}.#{type}"
# if there are some error or exception, will redirect the corresponding image
# get '/image/:image' do
get %r{/image/([a-z0-9]+)_(\d+).(jpg|png|JPG|jpeg|gif)} do

  begin
    image_id, size, type = params[:captures][0], params[:captures][1], params[:captures][2]
    valid_tmp = true
    valid_tmp = false unless settings.global_vars["image_sizes"].include?(size.to_i)
    valid_tmp = false unless settings.global_vars["image_types"].include?(type)
    status 404 unless valid_tmp

    # read image
    rimg = Rimg::HDD.new()
    rimg.set("#{image_id}.#{type}", settings.global_vars["origin"], settings.global_vars["cache"])
    content_type "image/#{type.downcase}"
    rimg.send(size)

  rescue Exception => e
     redirect to "/image_error/404?size=#{size}"
  end

end

# read image from aliyun
get %r{/image_aliyun/([a-z0-9]+)_(\d+).(jpg|png|JPG|jpeg|gif)} do

  begin
    image_id, size, type = params[:captures][0], params[:captures][1], params[:captures][2]
    valid_tmp = true
    valid_tmp = false unless settings.global_vars["image_sizes"].include?(size.to_i)
    valid_tmp = false unless settings.global_vars["image_types"].include?(type)
    status 404 unless valid_tmp

    rimg_aliyun = Rimg::AliyunOss.new('blue-moon')
    rimg_aliyun.set("#{image_id}.#{type}")
    content_type "image/#{type.downcase}"
    rimg_aliyun.send(size)
    
  rescue Exception => e
     redirect to "/image_error/404?size=#{size}"
  end

end

# upload image
# the API to upload image
# save image to HDD, resize a default size image and return it(default size is 960)
# params:
# params[:image], post a image file
# params[:size], the image size what will be returned
post '/upload' do
  image = params[:image]
  size = params[:size] || 960
  # params[:image] must not be nil
  begin
    # get the image info, image name, image type, image ext and image temp
    image_name, temp_image, type = image[:filename], image[:tempfile], image[:type]
    image_ext = image_name.split(".").last
    # generate saving image name
    image = Image.new()
    image_name = "#{image._id}.#{image_ext}"
    # set save path
    save_name_path = "#{settings.global_vars["origin"]}#{image_name}"

    # save image
    File.open(save_name_path,"w"){|file| file.write(temp_image.read)}
    # read default image(size 960 by default)
    rimg = Rimg::HDD.new()
    rimg.set(image_name, settings.global_vars["origin"], settings.global_vars["cache"])
    content_type type
    rimg.send(size)
  rescue Exception => e
    redirect to "/image_error/404?size=#{size}"
  end
end

# upload image to aliyun
post '/upload_aliyun' do
  image = params[:image]
  size = params[:size] || 960
  # params[:image] must not be nil
  begin
    # get the image info, image name, image type, image ext and image temp
    image_name, temp_image, type = image[:filename], image[:tempfile], image[:type]
    image_ext = image_name.split(".").last
    # generate saving image name
    image = Image.new()
    image_name = "#{image._id}.#{image_ext}"

    rimg_aliyun = Rimg::AliyunOss.new('blue-moon')
    rimg_aliyun.save(image_name, temp_image)
    
    # read default image(size 960 by default)
    rimg_aliyun.set(image_name)
    content_type type
    rimg_aliyun.send(size)

  rescue Exception => e
    redirect to "/image_error/404?size=#{size}"
  end
end

# if there unkown error, will redirect to this
# params:
# params[:code], http status code
# params[:size], image size
# and return an default error image
get '/image_error/:code' do
	code = params[:code]
	size = params[:size] || 960
	content_type "image/png"
	error_img = Rimg::Error.new(settings.global_vars["error"])
	error_img.code(code, size)
end

# if status code is bettween 400 with 510, will redirect to this
# this is sinatra method
error 400..510 do
	redirect to "/image_error/#{status}"
end

# if access an not existing url, will redirect to this.
# this si sinatra
not_found do
	redirect to "/image_error/#{status}"
end

# this is used to test
# just ignore it ......
get '/upload_form' do
  form_body = '<form action="http://127.0.0.1:9292/upload" method="post" enctype="multipart/form-data">'
  form_body += '<input type="hidden" name="auth_str" value="asdf4as64df6sd4f6" />'
  form_body += '<input type="hidden" name="size" value="640" />'
  form_body += '<input type="file" name="image" />'
  form_body += '<input type="submit" value="Upload" />'
  form_body += '</form>'
  body form_body
end

get '/upload_aliyun_form' do
  form_body = '<form action="http://127.0.0.1:9292/upload_aliyun" method="post" enctype="multipart/form-data">'
  form_body += '<input type="hidden" name="auth_str" value="asdf4as64df6sd4f6" />'
  form_body += '<input type="hidden" name="size" value="640" />'
  form_body += '<input type="file" name="image" />'
  form_body += '<input type="submit" value="Upload" />'
  form_body += '</form>'
  body form_body
end

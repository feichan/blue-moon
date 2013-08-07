module Rimg

  require 'aliyun/oss'
  include Aliyun::OSS
	
  class AliyunOss < Base

		attr_accessor :bucket, :ali_url, :img_type, :img_id

    def initialize(bucket = nil, cache_bucket = nil)
      # set the buket, default is "blue-moon"
      @bucket = bucket || "blue-moon"
      @cache_bucket = @bucket + "-cache"
    end

    # read the image and set the image origin cache path
    # params:
    # @param[:image], image name including image id and image type 
    #     like this "#{@img_id}.#{@img_type}"
    def set(image)
      # get the image path
      @img = image
      @img_type = image.split('.').last
      @img_id = image.split('.').first
      # if image is not exist, will throw an exception
      @ali_url = "http://#{@bucket}.oss.aliyuncs.com/#{@img}"
      raise "Image Not Found" unless is_exists?(@ali_url, 'aliyun_oss')
    end

    # read image as size and return image blob
    # if there is cache on aliyun, it will return cahce url
    # if there is not cache, it will resize image from aliyun 
    # and store cache to aliyun
    # params:
    # @param[:size], the size which client want to get
    def send(size)
      mini_mgk = nil
      image_cache = "#{@img_id}_#{size}.#{@img_type}"
      cache_url = "http://#{@cache_bucket}.oss.aliyuncs.com/#{image_cache}"
      # check cache exist or not
      if is_exists?(cache_url, 'aliyun_oss')
        mini_mgk = MiniMagick::Image.open(cache_url)
      else
        # access aliyun oss
        aliyun_auth
        mini_mgk = resize(@ali_url, size)
        Aliyun::OSS::OSSObject.store(image_cache, mini_mgk.to_blob, @cache_bucket)
      end
      return mini_mgk.to_blob
    end

    # save image to aliyun
    # params:
    # @params[:image_name], the name of image which will be sent to aliyun
    # @params[:file], origin image path
    def save(image_name, file)
      if is_exists?(file)
        aliyun_auth
        Aliyun::OSS::OSSObject.store(image_name, open(file), @bucket)
      else
        raise
      end
    end

    # access aliyun oss
    def aliyun_auth
      Aliyun::OSS::Base.establish_connection!(
        :server => 'oss.aliyuncs.com',
        :access_key_id => 'wPFWv85HG9lAsLUY',
        :secret_access_key => 't0oEP95rkiEhfVu7JWbsK22QEX4f5Q'
      )
    end

  end
end

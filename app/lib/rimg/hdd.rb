module Rimg

	class HDD < Base

		attr_accessor :img, :img_path, :image_cache_path, :img_id, :img_type

    def initialize

    end

    # read the image and set the image origin cache path
    # params:
    # @param[:image], image name including image id and image type like this "#{@img_id}.#{@img_type}"
    # @param[:image_path], origin image path
    # @param[:image_cache_path], cache image path
    def set(image, image_path, image_cache_path=nil)
      # get the image path
      @img = image
      @img_type = image.split('.').last
      @img_id = image.split('.').first
      @img_path = image_path
      @image_cache_path = image_cache_path || image_path
      # if image is not exist, will throw an exception
      raise "Image Not Found" unless is_exists?(get_full_path)
    end

    # read image as size and return image blob
    # params:
    # @param[:size], the size which client want to get
    def send(size)
      mini_mgk = nil
      if is_exists?(get_full_path(size))
        mini_mgk = MiniMagick::Image.open(get_full_path(size))
      else
        mini_mgk = resize(get_full_path, size)
        mini_mgk.write(get_full_path(size))
      end
      return mini_mgk.to_blob
    end

    # get the full path of image including origin and cache image
    # params:
    # params[:size], it can be nil
    # if :size is nil, it will return cache pull path
    # if :size isn't nil, it will return origin pull path
    def get_full_path(size=nil)
      origin_path = nil
      if size.nil?
        origin_path = case @img_path[-1]
        when '/'
          "#{@img_path}#{@img}"
        else
          "#{@img_path}/#{@img}"
        end
      else
        origin_path = case @image_cache_path[-1]
        when '/'
          "#{@image_cache_path}#{@img_id}_#{size}.#{@img_type}"
        else
          "#{@image_cache_path}/#{@img_id}_#{size}.#{@img_type}"
        end
      end
      return origin_path
    end

  end
end

module Rimg
	
	class Base
    # resize image and save cache image
    # the size is cache image with
    # then return a mini_magick object
    # params:
    # params[:image], image path
    # @param[:size], the size which client want to get
		def resize(image_path, size)
			mini_mgk = MiniMagick::Image.open(image_path)
			width, height = mini_mgk[:width].to_f, mini_mgk[:height].to_f
			want_with = size.to_f
			want_height = (want_with/width)*height
			mini_mgk.resize("#{want_with}x#{want_height}")
			return mini_mgk
		end

    def is_exists?(image_path, type = nil)
    	@type = type || "hdd"
    	result = true
    	case @type
    	when "hdd"
      	result = File.exists?(image_path) ? true : false
      when "aliyun_oss"
      	begin
          RestClient.get(image_path)
      	rescue Exception => e
        	result = false
      	end
    	end
      result
    end
	end
end
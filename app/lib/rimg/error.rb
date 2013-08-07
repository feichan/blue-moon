module Rimg

	# Before using this class, you must create error images in folder you send
	class Error < Base

		attr_accessor :path

		# params:
		# params[:path], error image folder
		def initialize(path)
			@path = path[-1] == "/" ? path : path+"/"
		end

		# return and error image
		# in this function, will use Rimg::Resizable to resize image
		# params:
		# params[:code], http code
		# params[:size], image size
		def code(code, size)
			image = case code.to_i
			when 100..199 then "message"
			when 300..399 then "redirect"
			when 400..499 then "not_found"
			when 500..599 then "server"
			else "default"
			end
			image_path = @path + image
			send(image_path, size)
		end

		def send(image_path, size)
			mini_mgk = nil
      if is_exists?("#{image_path}_#{size}.png")
        mini_mgk = MiniMagick::Image.open("#{image_path}_#{size}.png")
      else
        mini_mgk = resize("#{image_path}.png", size)
        mini_mgk.write("#{image_path}_#{size}.png")
      end
      return mini_mgk.to_blob
		end

	end

end
var fs = require('fs');
var imagemagick = require('imagemagick');
var ossApi = require('oss-client');
var oss = null;
var bkt = null;
var ca_bkt = null;
var obj = null;
var ca_obj = null;
var tmp = "tmp/";
var tmp_ca_path = null;
var content_type = null;

/*
params[:options] =>
	accessKeyId: id
	accessKeySecret: secret
*/
function Rimg (options) {
	oss = new ossApi.OssClient(options);
};

/*
params[:object] =>
	object name
*/
Rimg.prototype.set = function(options, callback){
	if (!options || !options.obj || !options.ca_obj) {
    throw new Error('error arguments!');
  }
	obj = options.obj;
	ca_obj = options.ca_obj;
	tmp_ca_path = tmp + ca_obj;

	bkt = options.bkt ? options.bkt : "blue-moon";
	ca_bkt = options.ca_bkt ? options.ca_bkt : "blue-moon-cache";

	oss.headObject(bkt, obj, function(error, result){
		callback(!error)
		if (!error) {
			content_type = result['content-type'];
		};
	})
}

/*
if cache is exsited, read it from aliyun oss
if chace is not exsited, generate and upload cache to aliyun oss
*/
Rimg.prototype.resize = function (image, size, callback){
	var self = this;
	// resize image
	// set the width
  imagemagick.resize({
  	srcData: image,
    width: parseInt(size)
  }, function(resize_err, stdout, sederr) {
    callback(stdout);
    // save cache file and upload
  	fs.writeFileSync(tmp_ca_path, stdout, 'binary');
    if (!resize_err) {
			var options = {
					bucket: ca_bkt,
					object: ca_obj,
					srcFile: tmp_ca_path
				}
			// upload cache to aliyun
			self.save(options, function(error){
				if(error){throw new Error(error);}
			});
    } else {
      throw new Error(resize_err);
    }
  });
}

Rimg.prototype.send = function(size, callback){
	var self = this;
	if (!size) {
    throw new Error('error arguments!');
  }
	// if cache is exsited
	oss.headObject(ca_bkt, ca_obj, function(error, result){
		if(!error){
			oss.readObject(ca_bkt, ca_obj, function(read_err, file){
				if (read_err) {
					throw new Error(read_err);
				}else{
					callback(file, content_type);
				}
			});
		}
		// if chace is not exsited
		else{
			oss.readObject(bkt, obj, function(read_err, image){
				if (read_err) {
					throw new Error(read_err);
				}else{
					self.resize(image, size, function(file){
						callback(file, content_type);
					})
				}
			});
		}
	});
}

Rimg.prototype.save = function(options, callback){
	oss.putObject(options, function(put_err){
		callback(put_err);
		// delete tmp file
		fs.unlink(options.srcFile, function(){});
	})
}

exports.Rimg = Rimg;
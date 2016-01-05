# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base

  include ::CarrierWave::Backgrounder::Delay
  # include CarrierWave::Video::Thumbnailer

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  process :watermark

  def watermark
    original_path = file.path
    original_video = FFMPEG::Movie.new(original_path)
    options = { resolution: original_video.resolution, watermark: "/sample_watermark.png", watermark_filter: { position: "RT", padding_x: 10, padding_y: 10 }}.to_json
    watermarked_video = Tempfile.new('watermarked_video')
    cmd = "ffmpeg -i #{original_path} -i #{Rails.public_path.join('sample_watermark.png').to_s} -filter_complex 'overlay=10:10' #{original_video.video_bitrate ? '-b:v ' + original_video.video_bitrate + 'K' : ''} -crf 18 -strict -2 -f #{File.extname(original_path).sub(/\A./, '')} #{watermarked_video.path} -y"

    puts cmd
    puts "original_path #{original_path}"
    puts "watermarked_video #{watermarked_video.path}"

    system( cmd )
    FileUtils.mv watermarked_video.path, original_path
  end

  # process thumbnail: [{format: 'png', quality: 10, size: 0, strip: true, logger: Rails.logger}]
  # def full_filename for_file
  #   png_name for_file, version_name
  # end

  # def png_name for_file, version_name
  #   %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end

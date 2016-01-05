class VideosController < ApplicationController

  def upload_form
    render
  end

  def upload_to_wistia
    video_file = params[:avatar]
    movie = FFMPEG::Movie.new(video_file.path)
    puts "The duration of the uploaded video file is #{ movie.duration }"
    options = { resolution: movie.resolution, watermark: "/sample_watermark.png", watermark_filter: { position: "RT", padding_x: 10, padding_y: 10 }}.to_json
    watermarked_video = Tempfile.new('foo')
    cmd = "ffmpeg -i #{video_file.tempfile.path} -i #{Rails.public_path.join('sample_watermark.png').to_s} -filter_complex 'overlay=10:10' #{original_video.video_bitrate ? '-b:v ' + original_video.video_bitrate + 'K' : ''} -crf 18 -strict -2 -f #{File.extname(video_file.original_filename).sub(/\A./, '')} #{watermarked_video.path} -y"
    system( cmd )
    uri = URI('https://upload.wistia.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post::Multipart.new uri.request_uri, { 'api_password' => '578b006b7192532ebd6e26ad014a09899ced6297baab9709f1400cb5281e7902', 'file' => UploadIO.new(File.open(watermarked_video.path), 'application/octet-stream', File.basename(watermarked_video.path)) }
    response = http.request(request)
    puts response.body
    redirect_to root_path
  end

end

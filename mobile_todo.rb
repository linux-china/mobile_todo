require 'rubygems'
require 'sinatra'
require 'rio'
require 'open-uri'
require 'hpricot'

configure :production do
  # configure stuff for production
end

# filter html
def filter_html(base_uri, page_content)
  begin
    doc = Hpricot(page_content)
    (doc/'//a').each do |link|
      href = "#{link.attributes['href']}"
      href = "#{base_uri}/#{href}" if !href.start_with?("http")
      link.attributes['href'] = "/proxy/#{href}" if (href.start_with?("http"))
    end
    (doc/'//img').each do |img|
      src = "#{img.attributes['src']}"
      src = "#{base_uri}#{src}" if src.start_with?("/")
      img.attributes['src'] = "/proxy/#{src}" if src.start_with?("http")
    end
    return doc.to_s
  rescue => e
    return e.to_s
  end
end

get '/' do
  "Welcome!!!"
end

get '/proxy/*' do
  dest_url = "#{params[:splat][0]}"
  dest_url = "http://#{dest_url}" if (!dest_url.start_with?("http"))
  uri = URI.parse(dest_url)
  base_uri = "http://#{uri.host}:#{uri.port}"
  content_type = nil
  charset = nil
  page_content = nil
  open(uri, "User-Agent" => "Ruby/#{RUBY_VERSION}") do |f|
    content_type =  f.content_type
    charset  = f.charset
    page_content = f.read
  end
  content_type content_type, :charset => charset
  if content_type.include?('html') || content_type.include?('text')
    page_content = filter_html(base_uri, page_content)
  end
  page_content
end

# app specific information. only for test
get '/env' do
  ENV.inspect
end


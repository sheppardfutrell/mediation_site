require 'rack'
require 'rack-rewrite'

use Rack::Rewrite do
  rewrite '/', '/index.html'
  rewrite %r{/(.*)}, lambda { |match, rack_env| 
    return '/' + match[1].gsub("/","") + '.html' if File.exists?('public/' + match[1].gsub("/","") + '.html')
    return '/' + match[1].gsub("/","")
  }
end
run Rack::Directory.new('/app')

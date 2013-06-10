require 'rack'
require 'rack-rewrite'

rse Rack::Rewrite do
  rewrite '/', '/index.html'
end
run Rack::Directory.new('/app')

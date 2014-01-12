require 'rack'
require 'rack-rewrite'
require 'rack_mailer'

Mail.defaults do
  delivery_method :smtp,
  {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true  }
end

map '/contact_request/' do |env|
  run Rack::Mailer.new { |mailer|
    # E-mail notification properties
    to 'sheppardfutrell@gmail.com'
    from 'contact@sheppardfutrell.com'
    subject 'New Contact Request'
    body ""

    # What to do when done
    success_url '/thank_you'
    failure_url '/request_error'

    # Message to automatically send to user that filled out form.
    auto_responder do |params|
      to params['mailer']['email']
      from 'no-reply@sheppardfutrell.com'
      subject 'Your message was received'
      body 'Thank you for your inquiry. Someone will be in contact with you very soon.'
    end
  }
end

use Rack::Rewrite do
  rewrite '/', '/index.html'
end
run Rack::Directory.new('/app')

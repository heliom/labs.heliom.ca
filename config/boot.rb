# Set up gems listed in the Gemfile
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

if defined?(Bundler)
  Bundler.require(:default, ENV['RACK_ENV'])
end

# Require app version first
require "#{File.expand_path('lib/heliom/labs/version.rb')}"

# Require helper & lib files
def recursive_require(basepath)
  Dir[File.expand_path("#{basepath}/**/*.rb", __FILE__)].each do |file|
    dirname = File.dirname(file)
    file_basename = File.basename(file, File.extname(file))
    require "#{dirname}/#{file_basename}"
  end
end

recursive_require('../../app/helpers')
recursive_require('../../lib')

# New Relic
if ENV['RACK_ENV'] == 'production'
  # See http://support.newrelic.com/kb/troubleshooting/unicorn-no-data
  ::NewRelic::Agent.after_fork(:force_reconnect => true) if defined? Unicorn
end

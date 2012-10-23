ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

if defined?(Bundler)
  Bundler.require(:default)
end

# App version
require './lib/heliom/labs/version'

# `bundle exec rake release`
# * Compile and commit assets
# * Bump version
# * Create a new tag and push it
# * Push to Heroku
desc 'deploy app to heroku'
task :release => [:bump, :'assets:compile', :'assets:commit', :tag, :deploy] do
end

# `bundle exec rake deploy`
# * Push to Heroku
desc 'deploy app to heroku'
task :deploy do
  puts "Pushing to heroku"
  `git push -f production master`
  puts "=> Successfully pushed to heroku"
end

# `bundle exec rake bump`
# * Bump version
#   => increment the version patch (Major.Minor.Patch)
desc 'bump version'
task :bump do
  puts "Bumping version"
  version = Heliom::Labs::VERSION.split('.')
  major = version[0]
  minor = version[1]
  patch = version[2].to_i
  patch += 1
  new_version = "#{major}.#{minor}.#{patch}"

  puts "New version will be #{new_version}. Is that alright? (y||x.y.z)"
  answer = STDIN.gets.chomp
  @new_version = answer == 'y' || answer == '' ? new_version : answer

  if @new_version.match(/^[0-9]+.[0-9]+.[0-9]+$/) == nil
    puts "=> Invalid version #{@new_version}"
    puts '=> Aborting'
    exit
  end

  content = "module Heliom::Labs\n\s\sVERSION = '#{@new_version}'\nend"
  `echo "#{content}" > lib/heliom/labs/version.rb`
  puts "=> Successfully bumped version to #{@new_version}"
end

# `bundle exec rake tag`
# * Create a new tag and push it
desc 'create a new version tag'
task :tag do
  version = @new_version || Heliom::Labs::VERSION
  `git add lib/heliom/labs/version.rb && git commit -m "Bump version to #{version}"`
  `git tag v#{version} && git push --tags`
end

namespace :assets do
  # `bundle exec rake assets:compile`
  # * Compile stylesheets and javascripts
  desc 'compile assets'
  task :compile => [:compile_css, :compile_js] do
  end

  # `bundle exec rake assets:compile_css`
  # IN  => /app/assets/stylesheets/styles.styl
  # OUT => /public/css/styles-<version>.min.css
  desc 'compile css assets'
  task :compile_css do
    puts "Compiling stylesheets"
    version = @new_version || Heliom::Labs::VERSION

    sprockets = Sprockets::Environment.new
    sprockets.append_path 'app/assets/stylesheets'
    Stylus.setup sprockets
    Stylus.compress = true
    Stylus.use :nib

    asset   = sprockets['styles.styl']
    outpath = File.join('public', 'css')
    outfile = Pathname.new(outpath).join("styles-#{version}.min.css")

    FileUtils.mkdir_p(outfile.dirname)
    asset.write_to(outfile)

    puts "=> Successfully compiled css assets"
  end

  # `bundle exec rake assets:compile_js`
  # IN  => /app/assets/javascripts/scripts.coffee
  # OUT => /public/js/scripts-<version>.min.js
  desc 'compile javascript assets'
  task :compile_js do
    puts "Compiling javascripts"
    version = @new_version || Heliom::Labs::VERSION

    sprockets = Sprockets::Environment.new
    sprockets.js_compressor = YUI::JavaScriptCompressor.new :munge => true, :optimize => true
    sprockets.append_path 'app/assets/javascripts'

    # General Scripts
    general_asset   = sprockets['scripts.coffee']
    general_outpath = File.join('public', 'js')
    general_outfile = Pathname.new(general_outpath).join("scripts-#{version}.min.js")

    FileUtils.mkdir_p(general_outfile.dirname)
    general_asset.write_to(general_outfile)

    # Header Scripts
    header_asset   = sprockets['heliom.js.coffee']
    header_outpath = File.join('public', 'js')
    header_outfile = Pathname.new(header_outpath).join("heliom-#{version}.min.js")

    FileUtils.mkdir_p(header_outfile.dirname)
    header_asset.write_to(header_outfile)

    puts "=> Successfully compiled js assets"
  end

  # `bundle exec rake assets:commit`
  # => Commit compiled assets if there are modifications
  desc 'commit compiled assets'
  task :commit do
    puts "Removing #{Heliom::Labs::VERSION} assets"

    js_remove_path = "public/js/scripts-#{Heliom::Labs::VERSION}.min.js"
    css_remove_path = "public/css/styles-#{Heliom::Labs::VERSION}.min.css"
    `git rm #{js_remove_path} #{css_remove_path}`

    puts "Commiting compiled assets"
    `git add public/css public/js`
    `git commit -m "Compile assets"`
    puts "=> Successfully commited static assets"
  end
end

# encoding: utf-8
require File.expand_path('../boot', __FILE__)

module Heliom::Labs
  class App < Sinatra::Base
    set :sessions, true
    set :session_secret, "BFDPII5fTVbYcCA0dcQdS5YFDTLWqiC8a1Xaxc0miPmUTW5FdMHAPZ2eWtJsBcb"
    set :root, File.expand_path('../../app',  __FILE__)
    set :public_folder, File.expand_path('../../public',  __FILE__)
    set :erb, :layout => :'layouts/application'

    configure :development do
      register Sinatra::Reloader
    end

    $labs = [
      { :title => 'iOS folders', :view => 'ios_folders', :tags => %w(css no-js) },
      { :title => 'Skeleton',    :view => 'skeleton',    :tags => %w(css) },
    ]

    $projects = [
      { :name => 'architect',           :user => 'EtienneLem', :desc => 'Your web workers’ supervisor' },
      { :name => 'skeleton',            :user => 'EtienneLem', :desc => 'Express 3.0 framework-less app structure generator' },
      { :name => 'rquest',              :user => 'EtienneLem', :desc => 'Rqest is to Rdio what pull requests are to GitHub' },
      { :name => 'divide',              :user => 'EtienneLem', :desc => 'Start Procfile processes in different Terminal/iTerm tabs' },
      { :name => 'rdio-display',        :user => 'EtienneLem', :desc => 'Screensaver ala AppleTV that displays currently playing song' },

      { :name => 'deebee',           :user => 'rafBM', :desc => 'Web client for your DB' },
      { :name => 'restoradar',       :user => 'rafBM', :desc => 'What to eat now?' },
      { :name => 'sourceresult.com', :user => 'rafBM', :desc => 'Write the source. See the result' },
      { :name => 'howtomakeaslider', :user => 'rafBM', :desc => 'How to make a slider' },

      { :name => 'stylus-utils', :user => 'heliom', :desc => 'A tiny Stylus utils library' },
      { :name => 'kckstrt',      :user => 'heliom', :desc => 'Sinatra app generator ' },
      { :name => 'head-script',  :user => 'heliom', :desc => 'A script that we basically include in every project’s <head>' },
      { :name => 'pushes',       :user => 'heliom', :desc => 'GitHub post-commit notifs in your OS X Notification Center' },
      { :name => 'octofeed',     :user => 'heliom', :desc => 'Your GitHub news feed, without the mess' },
    ].sort_by { |h| h[:name] }

    LAST_MODIFIED = Time.now

    # Before filter
    before do
      cache_control :public, :max_age => 86400
      last_modified LAST_MODIFIED
    end

    # Routes
    get '/' do
      @view_class = 'index'
      erb :index
    end

    $labs.each do |lab|
      url = url_for_view(lab[:view])

      get "/#{url}" do
        @title = lab[:title]
        @view_class = url
        erb "labs/#{lab[:view]}".to_sym
      end
    end

    # Errors
    not_found do
      erb :'404'
    end

  end
end

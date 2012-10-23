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
      { :title => 'Skeleton', :view => 'skeleton', :tags => %w(css) },
    ]

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
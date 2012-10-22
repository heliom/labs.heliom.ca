# Assets tag helper
# Uses sprockets in development and local precompiled files in production
def javascript_include_tag(file_name)
  path_prefix = development? ? '/assets/' : '/js/'
  suffix = development? ? '' : "-#{Heliom::Labs::VERSION}.min"
  %(<script src="#{path_prefix}#{file_name}#{suffix}.js"></script>)
end

def stylesheet_include_tag(file_name)
  path_prefix = development? ? '/assets/' : '/css/'
  suffix = development? ? '' : "-#{Heliom::Labs::VERSION}.min"
  %(<link rel="stylesheet" href="#{path_prefix}#{file_name}#{suffix}.css">)
end

# Render a view without layout
def partial(partial)
  partial_view = "partials/_#{partial}".to_sym
  erb partial_view, :layout => false
end

def url_for_view(view)
  view.gsub('_', '-')
end

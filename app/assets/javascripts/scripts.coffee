#= require_tree ./utils

$(document).on 'velcro:state_change', (e) ->
  if bodyClass = e.data.bodyClass
    document.body.className = bodyClass

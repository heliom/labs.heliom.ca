#= require_tree ./utils

$(document).on 'velcro:state_change', (e) ->
  if bodyClass = e.data.bodyClass
    document.body.className = bodyClass

$(document).ready =>
  @gaugesBaseScript = $('#gauges-base-script')
  @gaugesScript = @gaugesBaseScript.html()

$(document).on 'velcro:complete', (e) =>
  $('#gauges-tracker').remove()
  eval(@gaugesScript)

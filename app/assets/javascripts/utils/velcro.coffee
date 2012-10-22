class Velcro
  html = document.documentElement

  @defaultContainers = []
  @defaultPushContainers = []
  @defaultUpdateContainers = []

  if globalAll = html.getAttribute('data-velcro-all')
    @defaultContainers = globalAll.split(',')

  if globalPush = html.getAttribute('data-velcro-all-push')
    @defaultPushContainers = globalPush.split(',')

  if globalUpdate = html.getAttribute('data-velcro-all-update')
    @defaultUpdateContainers = globalUpdate.split(',')

  pushStateHistory = []

  @updateContainers: (state, href) ->
    $('html').addClass('velcro-loading')
    $(selector).addClass('velcro-loading') for selector in state.selectors

    $.ajax
      type: state.method || 'GET'
      url: href
      data: state.params
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-Velcro', 'true'
      success: (data) ->
        $('html').removeClass('velcro-loading')

        html = document.createElement('html')

        if html.insertAdjacentHTML
          html.insertAdjacentHTML 'beforeend', data
        else
          html.innerHTML = data

        html = $(html)

        if (title = html.find('title')).length
          document.title = title.html()

        if (metas = html.find('meta[name^="velcro:"]')).length
          meta_states = {}
          for meta in metas
            name = meta.name.match(/velcro:(.+)/)[1]
            meta_states[name] = meta.content

          $(selector).trigger('velcro:state_change', meta_states)

        if (head = html.find('head')).length
          $('head meta').remove()
          $('head').append(head.find('meta'))
          # TODO Trigger meta events

        if state.selectors.length == 1
          if (container = html.find(selector)).length
            $(selector).removeClass('velcro-loading').html(container.html()).trigger('velcro:complete')
          else
            $(selector).removeClass('velcro-loading').html(data).trigger('velcro:complete')
        else
          for selector in state.selectors
            $(selector).removeClass('velcro-loading').html(html.find(selector).html()).trigger('velcro:complete')

  @handleAction: (e) ->
    elem = this

    # Middle click, cmd click, and ctrl click should open links in a new tab as normal.
    return if elem.tagName == 'A' && (e.which > 1 || e.metaKey || e.ctrlKey)

    selectors = []

    # TODO Support data-velcro-append
    # TODO Support multiple attributes on same element
    # TODO Support empty attribute value (update only global containers)
    if elem.getAttribute('data-velcro-push')
      push = true
      if selector = elem.getAttribute('data-velcro-push')
        selectors = selector.split(',')
    else
      push = false
      if selector = elem.getAttribute('data-velcro-update')
        selectors = selector.split(',')

    return true if push && !history.pushState

    state =
      selectors: selectors.concat(Velcro.defaultContainers)

    if push
      state.selectors = state.selectors.concat(Velcro.defaultPushContainers)
    else
      state.selectors = state.selectors.concat(Velcro.defaultUpdateContainers)

    switch elem.tagName
      when 'A'
        url = elem.href
        pushStateUrl = url
      when 'FORM'
        url = elem.action
        state.params = $(elem).serialize()

        if elem.method.toUpperCase() == 'GET'
          pushStateUrl = url + '?' + $(elem).serialize()
        else
          state.method = 'POST'
          pushStateUrl = url

    Velcro.updateContainers(state, url)

    if push
      # `replaceState` current page if it hasn’t been loaded with `pushState`
      if pushStateHistory[0] != location.href
        history.replaceState(state, '', location.href)
      pushStateHistory.unshift(pushStateUrl)

      history.pushState(state, '', pushStateUrl)

    false

# Initialization
linkSelector = 'a[data-velcro-update], a[data-velcro-push], a[data-velcro-replace], a[data-velcro-append]'
formSelector = 'form[data-velcro-update], form[data-velcro-push], form[data-velcro-replace], form[data-velcro-append]'

$(document).on 'click',  linkSelector, Velcro.handleAction
$(document).on 'submit', formSelector, Velcro.handleAction

window.onpopstate = (e) ->
  return if !e.state
  Velcro.updateContainers(e.state, location.href)

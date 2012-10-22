html = document.documentElement

# Global namespace
window.Heliom = {}

# Touch
Heliom.IS_TOUCH_DEVICE = window.ontouchend != undefined

# Transitions
Heliom.HAS_TRANSITIONS = false
prefixes = ['webkit', 'Moz', 'Ms', 'O']
for prefix in prefixes
  if html.style["#{prefix}Transition"] != undefined
    html.className += " #{prefix.toLowerCase()}"
    Heliom.HAS_TRANSITIONS = true
    Heliom.BROWSER = prefix.toLowerCase()

# SVG
Heliom.HAS_SVG = !!document.createElementNS && !!document.createElementNS('http://www.w3.org/2000/svg', 'svg').createSVGRect

# Retina
Heliom.IS_RETINA = `('devicePixelRatio' in window && devicePixelRatio > 1) || ('matchMedia' in window && matchMedia("(min-resolution:144dpi)").matches)`

# HTML classes
html.className = html.className.replace 'no-js', 'js'
html.className += if Heliom.IS_TOUCH_DEVICE then ' touch' else ' non-touch'
html.className += if Heliom.HAS_TRANSITIONS then ' has-transitions' else ''
html.className += if Heliom.HAS_SVG then ' has-svg' else ''
html.className += if Heliom.IS_RETINA then ' retina' else ''
html.className += ' ios ipad'   if /\bipad\b/i.test navigator.userAgent
html.className += ' ios iphone' if /\biphone\b/i.test navigator.userAgent
if /safari/i.test navigator.userAgent
  html.className += ' safari-4' if /version\/4/i.test navigator.userAgent
  html.className += ' safari-5' if /version\/5/i.test navigator.userAgent
html.className += ' firefox-3' if /firefox\/3/i.test navigator.userAgent
html.className += ' chrome' if /Chrome/.test navigator.userAgent

# HTML5 Shiv
for elem in ['article', 'aside', 'canvas', 'details', 'figcaption', 'figure', 'footer', 'header', 'hgroup', 'mark', 'menu', 'nav', 'section', 'summary', 'time']
  document.createElement elem

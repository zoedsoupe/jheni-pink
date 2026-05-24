import "phoenix_html"
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/site"
import topbar from "../vendor/topbar"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks},
})

topbar.config({barColors: {0: "#FF1493"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

liveSocket.connect()
window.liveSocket = liveSocket

// ── Y2K cursor trail (skip on touch devices) ──
if (!window.matchMedia('(pointer: coarse)').matches) {
  const colors = ['#FF1493', '#FFD60A', '#CCFF00', '#FF9A56', '#FFB6E1', '#A30262']
  let last = 0
  document.addEventListener('mousemove', (e) => {
    const now = Date.now()
    if (now - last < 40) return
    last = now
    const sparkle = document.createElement('div')
    sparkle.className = 'cursor-trail-sparkle'
    sparkle.textContent = '♡'
    sparkle.style.cssText = `position:fixed;left:${e.clientX}px;top:${e.clientY}px;color:${colors[Math.floor(Math.random()*colors.length)]};font-size:${12+Math.random()*10}px;pointer-events:none;z-index:9999;animation:trail-fade 0.9s forwards;transform:translate(-50%,-50%);`
    document.body.appendChild(sparkle)
    setTimeout(() => sparkle.remove(), 900)
  })
}

if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    reloader.enableServerLogs()
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if (keyDown === "c") { e.preventDefault(); e.stopImmediatePropagation(); reloader.openEditorAtCaller(e.target) }
      else if (keyDown === "d") { e.preventDefault(); e.stopImmediatePropagation(); reloader.openEditorAtDef(e.target) }
    }, true)
    window.liveReloader = reloader
  })
}

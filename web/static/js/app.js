import 'phoenix_html'
import $ from 'jquery'
import 'jquery-ui-bundle'
import loadView from './views/loader'
import socket from './socket'

function handleDOMContentLoaded () {
  const viewName = document.getElementsByTagName('body')[0].dataset.jsViewName
  const ViewClass = loadView(viewName)
  const view = new ViewClass()
  view.mount()

  window.currentView = view
}

function handleDocumentUnload () {
  window.currentView.unmount()
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false)
window.addEventListener('unload', handleDocumentUnload, false)

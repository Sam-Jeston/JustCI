import MainView from './main'
import HomeShowView from './home/show'
import HomeIndexView from './home/index'
import TemplateShowView from './templates/show'

const views = {
  HomeShowView,
  HomeIndexView,
  TemplateShowView
}

export default function loadView(viewName) {
  return views[viewName] || MainView
}

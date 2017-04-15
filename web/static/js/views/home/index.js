import MainView from '../main'
const targetClass = '.ciBuild'

export default class View extends MainView {
  mount() {
    super.mount()
    showBuildListener()
  }

  unmount() {
    super.unmount()
    $(targetClass).unbind()
  }
}

export function showBuildListener () {
  $(targetClass).click((event) => {
    const buildId = $(event.currentTarget).attr('build_id')
    window.location.assign(`/ci/${buildId}`)
  })
}

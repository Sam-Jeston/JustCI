const targetClass = '.ciBuild'

export function showBuild () {
  $(targetClass).click((event) => {
    const buildId = $(event.currentTarget).attr('build_id')
    window.location.assign(`/ci/${buildId}`)
  })
}

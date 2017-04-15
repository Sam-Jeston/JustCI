import MainView from '../main'
import { joinBuildChannel } from '../../socket'
const targetClass = '#restartJob'

export default class View extends MainView {
  mount() {
    super.mount()
    restartJobListener()
    joinBuildChannel()
  }

  unmount() {
    super.unmount()
    $(targetClass).unbind()
  }
}

export function restartJobListener () {
  const csrf = document.querySelector("meta[name=csrf]").content

  $(targetClass).click(() => {
    const jobId = $(targetClass).attr('job_id')
    const buildId = $(targetClass).attr('build_id')

    return $.ajax({
      headers: {
        'X-CSRF-TOKEN': csrf
      },
      url: `/api/ci/${buildId}/restart/${jobId}`,
      contentType: 'application/json',
      method: 'post',
      success: (s) => console.log(s),
      error: (e) => console.error(e)
    })
  })
}

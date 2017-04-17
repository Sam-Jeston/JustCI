import MainView from '../main'
import socket from '../../socket'
const targetClass = '#restartJob'
const jobId = $(targetClass).attr('job_id')
const buildId = $(targetClass).attr('build_id')

export default class View extends MainView {
  mount () {
    super.mount()
    restartJobListener()
    joinBuildChannel(buildId, jobId)
  }

  unmount () {
    super.unmount()
    $(targetClass).unbind()
  }
}

export function restartJobListener () {
  const csrf = document.querySelector('meta[name=csrf]').content

  $(targetClass).click(() => {
    return $.ajax({
      headers: {
        'X-CSRF-TOKEN': csrf
      },
      url: `/api/ci/${buildId}/restart/${jobId}`,
      contentType: 'application/json',
      method: 'post',
      success: (newJob) => {
        $('#logResult').text('')
        $('#targetBranch').text(newJob.branch)
        $('#targetStatus').text(newJob.status)
        $(targetClass).attr('job_id', newJob.id)

        joinBuildChannel(buildId, newJob.id)
      },
      error: (e) => console.error(e)
    })
  })
}

function joinBuildChannel (buildId, jobId) {
  let channel = socket.channel(`ci:${buildId}:${jobId}`, {})

  channel.join()
    .receive('ok', resp => null)
    .receive('error', resp => { console.log('Unable to join build channel', resp) })

  channel.on('log_event', payload => {
    $('#logResult').append(`<p>${payload.log}</p>`)
  })

  channel.on('job_finished', payload => {
    $('#targetStatus').text(payload.status)
  })
}

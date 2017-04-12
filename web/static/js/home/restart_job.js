const targetClass = '#restartJob'
const csrf = document.querySelector("meta[name=csrf]").content

export function restartJob () {
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

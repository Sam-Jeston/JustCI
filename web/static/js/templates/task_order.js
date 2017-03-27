const targetClass = '#templateTaskOrder'
const csrf = document.querySelector("meta[name=csrf]").content

export function orderTasks () {
  $(targetClass).sortable({
    stop: (event, ui) => {
      iterateAndPostTaskOrder()
    }
  })

  $(targetClass).disableSelection()
}

function iterateAndPostTaskOrder () {
  let order = []

  const targetTasks = $(`${targetClass}`).children().each(function (index) {
    order.push({id: $(this).attr('task_id'), order: index + 1})
  })

  return $.ajax({
    headers: {
      'X-CSRF-TOKEN': csrf
    },
    url: '/api/tasks/update_order',
    data: JSON.stringify(order),
    contentType: 'application/json',
    method: 'put',
    success: (s) => console.log(s),
    error: (e) => console.error(e)
  })
}

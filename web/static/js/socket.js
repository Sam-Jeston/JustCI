import { Socket } from "phoenix"

const token = document.querySelector("meta[name=channel_token]")
  ? document.querySelector("meta[name=channel_token]").content
  : null

let socket

// We only connect and perform our socket behaviour is the client has the required
// token. The other end of the socket is authorized so this is safe
if (token) {
  socket = new Socket("/socket", {params: {token}})
  socket.connect()

  let channel = socket.channel("ci:lobby", {})
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("log_event", payload => {
    console.log(payload)
  })
}

export function joinBuildChannel () {
  // TODO: Fix brittle buildId lookup
  const buildId = window.location.href.slice(-1)
  let channel = socket.channel(`ci:${buildId}`, {})

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("log_event", payload => {
    console.log(payload)
  })
}

export default socket

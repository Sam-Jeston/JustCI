defmodule JustCi.GithubController do
  use JustCi.Web, :controller

  def start_job(conn, params) do
    headers = conn.req_headers

    github_event_tuple = Enum.find(headers, fn(h) -> elem(h, 0) == "x-github-event" end)
    github_event = elem(github_event_tuple, 1)

    IO.puts "------"
    IO.inspect github_event

    IO.inspect params
    conn
    |> redirect(to: page_path(conn, :index))
  end
end

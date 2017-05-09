defmodule JustCi.TemplateDependencyController do
  use JustCi.Web, :controller

  alias JustCi.Template
  alias JustCi.Dependency
  alias JustCi.TemplateDependency

  def view(conn, %{"id" => id}) do
    template = Template |> Repo.get(id) |> Repo.preload(:dependencies)
    IO.puts "~~~ Shit Our dependency is loading!!!"
    IO.inspect template
    render(conn, "view.html", template: template)
  end

  def link(conn, _params) do
  end
end

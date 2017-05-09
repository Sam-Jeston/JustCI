# Script for populating the database. You can run it as: mix run priv/repo/seeds.exs

alias JustCi.User
alias JustCi.Repo
alias JustCi.Registration
alias JustCi.Template
alias JustCi.Task
alias JustCi.Build
alias JustCi.Job
alias JustCi.ThirdPartyKey
alias JustCi.Dependency
alias JustCi.TemplateDependency

user_changeset = User.changeset(%User{}, %{
  email: "test@test.com",
  password: "password"
})

Registration.create(user_changeset, Repo)

key_changeset = ThirdPartyKey.changeset(%ThirdPartyKey{}, %{
  name: "Test key",
  key: "ABCDE"
})

key = Repo.insert! key_changeset

dependency_changeset = Dependency.changeset(%Dependency{}, %{
  command: "echo \Hello!\"",
  priority: 1
})

dependency = Repo.insert! dependency_changeset

template_1 = Template.changeset(%Template{}, %{ name: "Test Temp 1", third_party_key_id: key.id })
template_2 = Template.changeset(%Template{}, %{ name: "Test Temp 2" })

t1 = Repo.insert! template_1
t2 = Repo.insert! template_2

template_dependency_changeset = TemplateDependency.changeset(%TemplateDependency{}, %{
  template_id: t1.id,
  dependency_id: dependency.id
})

Repo.insert! template_dependency_changeset

task_1 = Task.changeset(%Task{}, %{
  template_id: t1.id,
  command: "echo \"Hello,\"",
  order: 1
})

task_2 = Task.changeset(%Task{}, %{
  template_id: t1.id,
  command: "echo \"Goodbye,\"",
  order: 2
})

task_3 = Task.changeset(%Task{}, %{
  template_id: t2.id,
  command: "echo \"Near,\"",
  order: 1
})

task_4 = Task.changeset(%Task{}, %{
  template_id: t2.id,
  command: "echo \"Far,\"",
  order: 2
})

Repo.insert! task_1
Repo.insert! task_2
Repo.insert! task_3
Repo.insert! task_4

build_1 = Build.changeset(%Build{}, %{
  repo: "test1",
  template_id: t1.id
})

build_2 = Build.changeset(%Build{}, %{
  repo: "test2",
  template_id: t2.id
})

b1 = Repo.insert! build_1
Repo.insert! build_2

job_1 = Job.changeset(%Job{}, %{
  status: "pending",
  sha: "abcde",
  owner: "Joe-Bloggs",
  build_id: b1.id,
  branch: "test-branch"
})

job_2 = Job.changeset(%Job{}, %{
  status: "success",
  sha: "abcde",
  owner: "Joe-Bloggs",
  build_id: b1.id,
  branch: "master",
  log: "We created this.\nBack when the world was flat.\n"
})

Repo.insert! job_1
Repo.insert! job_2

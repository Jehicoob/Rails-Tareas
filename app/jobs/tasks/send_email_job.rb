class Tasks::SendEmailJob
  include SuckerPunch::Job

  def perform(task_id) #Lo mejor es recibir tipos de datos planos
    task = Task.find(task_id)
    Tasks::SendEmail.new.call task
  end
end

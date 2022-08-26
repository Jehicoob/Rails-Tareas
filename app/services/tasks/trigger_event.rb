class Tasks::TriggerEvent
  def call(task, event)
    
    # security polices
    # access polices
    # connection to another service

    task.send "#{event}!" # = task.start!
    [true, 'successful']
  rescue => e
    Rails.logger.error e
    [false, 'failed']
  end
end



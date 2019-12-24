class DogWalkingDecorator < Draper::Decorator
  delegate_all

  def scheduled_at
    object.scheduled_at.strftime('%Y-%m-%d %H:%M:%S') if object.scheduled_at.present?
  end

  def started_at
    object.started_at.strftime('%Y-%m-%d %H:%M:%S') if object.started_at.present?
  end

  def finished_at
    object.finished_at.strftime('%Y-%m-%d %H:%M:%S') if object.finished_at.present?
  end

  def real_duration
    ((object.finished_at - object.started_at) / 60).round if object.finished_at.present?
  end
end

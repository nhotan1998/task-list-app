class Task < ApplicationRecord
  belongs_to :user
  has_many_attached :files

  validates :title, presence: true
  validates :due_date, presence: true
  validate :files_size_within_limit

  scope :by_query, ->(query) {
    return all if query.blank?

    where("title ILIKE :term OR description ILIKE :term", term: "%#{query}%")
  }

  scope :by_status, ->(status) {
    case status.to_s
    when "completed"
      where(completed: true)
    when "pending"
      where(completed: false)
    when "overdue"
      where(completed: false).where("due_date < ?", Time.current)
    when "due_today"
      where(due_date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    else
      all
    end
  }

  def overdue?
    !completed? && due_date.present? && due_date < Time.current
  end

  private

  def files_size_within_limit
    return if files.blank?

    files.each do |file|
      if file.blob.byte_size > 10.megabytes
        errors.add(:files, "must be less than or equal to 10MB")
        break
      end
    end
  end
end

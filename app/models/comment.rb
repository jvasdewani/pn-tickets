class Comment < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader

  belongs_to :issue
  belongs_to :person

  scope :ordered, -> { order(id: :asc) }

  after_create :keep_score

  def priority
    PRIORITIES[_np.to_i]
  end

  def prev_priority
    PRIORITIES[_pp.to_i]
  end

  def status
    STATUSES[_ns.to_i]
  end

  def prev_status
    STATUSES[_ps.to_i]
  end

  def author
    if person.present?
      "#{person.abbr_name} wrote:"
    else
      'System response:'
    end
  end

  private

  def keep_score
    if _ns.to_i == 30
      logger.fatal 'Scoring open'
      PersonScore.new(person_id, 'opened').increment
    elsif _ns.to_i == 10
      logger.fatal 'Scoring closed'
      PersonScore.new(person_id, 'closed').increment
      NotifyClosure.perform_async(issue_id)
    end
  end
end

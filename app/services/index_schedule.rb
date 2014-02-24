class IndexSchedule
  include Sidekiq::Worker

  def perform
    Issue.all.each do |issue|
      Indexing.perform_async(issue.id)
    end
  end
end

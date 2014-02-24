class OverdueCheck
  include Sidekiq::Worker

  def perform
    @issues = Issue.joins(:comments).select("issues.*, count(comments.id) as comment_count").group("comments.issue_id").having("comment_count=1")
    @issues.each do |issue|
      IssueNotifier.overdue(issue) if issue.response_time >= 2700
    end
  end
end

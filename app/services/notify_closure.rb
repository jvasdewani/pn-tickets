class NotifyClosure
  include Sidekiq::Worker

  def perform(issue_id)
    issue = Issue.find(issue_id)
    dept = issue.department
    if dept.notify_on_close? && !dept.notify_list.blank?
      IssueNotifier.closure(issue, dept.notify_list)
    end
  end
end

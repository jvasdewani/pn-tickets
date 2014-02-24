class Notifications
  include Sidekiq::Worker

  def perform(issue_id)
    @issue = Issue.find(issue_id)
    @managers = Person.where(manager: true)
    @department = @issue.department.people if @issue.department
    @author = @issue.person if @issue.person

    IssueNotifier.new_issue(@issue, @author, @department, @managers).deliver
  end
end

class IssueNotifier < ActionMailer::Base
  default :from => "tickets@prime-networks.co.uk"

  def new_issue(issue, author, department, managers)
    @issue = issue
    options = {
      :subject => "[#{@issue.issue_no}] New ticket raised",
      :bcc => managers.collect { |m| m.email }.join(',')
    }
    options.merge!({ :to => author.email }) if author
    options.merge!({ :cc => department.collect { |d| d.email }.join('.') }) if department
    mail(options)
  end

  def overdue(issue)
    @managers = Person.managers
    @issue = issue
    mail(:cc => @managers.collect { |m| m.email }.join('.'), :subject => "[#{@issue.issue_no}] Overdue notification")
  end

  def closure(issue, notify_list)
    @issue = issue
    mail(:bcc => notify_list, :subject => "[#{@issue.issue_no}] Resolved notification")
  end
end

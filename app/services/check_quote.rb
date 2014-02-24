class CheckQuote
  include Sidekiq::Worker

  def perform(issue_id)
    @issue = Issue.find(issue_id)
    @quote = @issue.quote

    if @issue.status == 'resolved'
      @quote.approve!
    else
      @quote.send_for_approval!
    end
  end
end

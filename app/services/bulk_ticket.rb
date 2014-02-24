class BulkTicket
  include Sidekiq::Worker

  def perform(id, person, message, status)
    unless id.to_i == 0
      issue = Issue.find(id)
      comment = issue.comments.ordered.last
      issue.comments.create person_id: person, content: message, _pp: comment._np, _np: comment._np, _ps: comment._ns, _ns: status
      CacheValue.perform_async(issue.id)
      if issue.checkid.present?
        HTTParty.get("https://www.systemmonitor.co.uk/api?apikey=c18fb67dd0fa6bd0d8d8880d4d56a759&service=clear_check&checkid=#{issue.checkid}")
      end
    end
  end
end

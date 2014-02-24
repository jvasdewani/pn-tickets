class PersonScoreWorker
  include Sidekiq::Worker

  def perform(guid, state)
    ticket = Ticket.find_by(guid: guid)
    PersonScore.new(ticket.author.guid, state).increment
  end
end

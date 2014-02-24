class SendQuote
  include Sidekiq::Worker

  def perform(quote_id, password)
    @quote = Quote.find(quote_id)
    @password = password
    QuoteNotifier.new_quote(@quote, @password).deliver
  end
end

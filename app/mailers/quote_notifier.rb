class QuoteNotifier < ActionMailer::Base
  default :from => "quotes@prime-networks.co.uk"

  def new_quote(quote, password)
    @quote = quote
    @password = password
    mail(:to => quote.email, :subject => "[#{@quote.id}] A quote needs your approval")
  end
end

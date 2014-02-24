class Import
  def initialize
    Dir['/var/app/pn-tickets/tickets/*'].each do |file|
      process File.read(file)
    end
  end

  def process(string)
    parsed = JSON.parse(string)
    create_issue(parsed)
  end

  private

  def create_issue(i)
    ImportIssue.perform_async(i)
  end
end

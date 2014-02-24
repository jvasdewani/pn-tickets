class PassingChecks
  include Sidekiq::Worker

  def perform
    @passing_checks = HTTParty.get('https://www.systemmonitor.co.uk/api?apikey=c18fb67dd0fa6bd0d8d8880d4d56a759&service=list_clients')
    data = JSON.parse(@passing_checks.parsed_response.to_json)['result']['items']['client']
    data.each do |c|
      client = Client.where(:company => c['name']).first
      if client
        branch = client.branches.first
        contact = branch.contacts.where(:forename => 'Prime').where(:surname => 'Networks').first
        contact = branch.contacts.create(:forename => 'Prime', :surname => 'Networks') if !contact

        department = Department.where(:department_name => 'Proactive').first
        agent = department.people.where(:forename => 'Prime').where(:surname => 'Networks').first

        create_ticket(client, branch, contact, department, agent)

      else
        puts "#{Time.now.to_s} - Couldn't find #{c['name']}"
      end
    end
  end

  def create_ticket(client, branch, contact, department, agent)
    puts "======= Creating ticket for client(id): #{client.id}"
    
    p "#{Time.now.to_s} - Issue logged for #{client.company}"
    issue = Issue.create do |i|
      i.subject = "All checks passed [Prime Networks Monitoring]"
      i.person = agent
      i.department = department
      i.client = client
      i.contact = contact
      i.priority = 'normal'
      i.status = 'resolved'
      i.response_time_cache = 0
      i.issue_time_cache = 300
      i.checkid = 'passcheck'
      i.comments.build do |m|
        m.person = agent
        m.content = "Checks have passed"
        m._np = 20
        m._ns = 40
      end
      i.comments.build do |m|
        m.person = agent
        m._pp = 20
        m._np = 20
        m._ns = 10
        m._ps = 40
      end
    end
  end
end

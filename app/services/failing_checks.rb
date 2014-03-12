class FailingChecks
  include Sidekiq::Worker

  def perform
    @failing_checks = HTTParty.get('https://www.systemmonitor.co.uk/api?apikey=c18fb67dd0fa6bd0d8d8880d4d56a759&service=list_failing_checks')
    data = JSON.parse(@failing_checks.parsed_response.to_json)['result']['items']['client']
    data.each do |c|
      client = Client.where(:company => c['name'].strip).first
      if client
        branch = client.branches.first
        contact = branch.contacts.where(:forename => 'Prime').where(:surname => 'Networks').first
        contact = branch.contacts.create(:forename => 'Prime', :surname => 'Networks') if !contact

        department = Department.where(:department_name => 'Proactive').first
        if department.nil?
          department = Department.create(:department_name => 'Proactive')
        end

        product = ProductType.where(:name => 'IT').first
        if product.nil?
          product = ProductType.create(:name => 'IT')
        end

        agent = department.people.where(:forename => 'Prime').where(:surname => 'Networks').first

        if c['site'].has_key?('servers') && !c['site']['servers'].nil?
          server = c['site']['servers']['server']

          if server.kind_of? Hash
            process(server, client, branch, contact, department, product, agent)
          else
            server.each { |s| process(s, client, branch, contact, department, product, agent) }
          end
        end

      else
        puts "#{Time.now.to_s} - Couldn't find #{c['name']}"
      end
    end
  end

  private

  def process(server, client, branch, contact, department, product, agent)
    if !server['failed_checks'].nil?
      if server['failed_checks']['check'].kind_of? Hash
        create_ticket(server['failed_checks']['check'], server['name'], client, branch, contact, department, product, agent)
      else
        server['failed_checks']['check'].each { |i| create_ticket(i, server['name'], client, branch, contact, department, product, agent) }
      end
    end

    # if !server['offline'].nil?
    #   create_offline(server['offline'], server['name'], client, branch, contact, department, agent)
    # end

    # if !server['overdue'].nil?
    #   create_overdue(server['overdue'], server['name'], client, branch, contact, department, agent)
    # end

    # if !server['unreachable'].nil?
    #   create_unreachable(server['unreachable'], server['name'], client, branch, contact, department, agent)
    # end
  end

  def create_ticket(check, server, client, branch, contact, department, product, agent)
    already_logged = Issue.where(:checkid => check['checkid']).order(created_at: :desc)
    if already_logged.count == 0
      p "#{Time.now.to_s} - Issue logged for #{check['checkid']}"
      issue = Issue.create do |i|
        i.subject = "Failed on #{server}: #{check['description']} [Prime Networks Monitoring]"
        i.person = agent
        i.department = department
        i.client = client
        i.contact = contact
        i.checkid = check['checkid']
        i.checkstarttime = check['time']
        i.checkstartdate = check['date']
        i.checkdescription = check['description']
        i.priority = 'normal'
        i.status = 'on_hold'
        i.product_type = product
        i.comments.build do |m|
          m.person = agent
          m.content = "#{check['description']}\n#{check['formatted_output']}"
          m._np = 20
          m._ns = 40
        end
        i.comments.build do |m|
          m.person = agent
          m._pp = 20
          m._np = 20
          m._ns = 20
          m._ps = 40
        end
      end
    else
=begin
      if already_logged.first.status == 'on_hold' || already_logged.first.status == 'resolved'
        p "#{Time.now.to_s} - Issue re-logged for #{check['checkid']}"
        issue = Issue.create do |i|
          i.subject = "Failed on #{server}: #{check['description']} [Prime Networks Monitoring]"
          i.person = agent
          i.department = department
          i.client = client
          i.contact = contact
          i.checkid = check['checkid']
          i.checkstarttime = check['time']
          i.checkstartdate = check['date']
          i.checkdescription = check['description']
          i.priority = 'normal'
          i.product_type = product
          i.status = 'on_hold'
          i.comments.build do |m|
            m.person = agent
            m.content = "#{check['description']}\n#{check['formatted_output']}"
            m._np = 20
            m._ns = 40
          end
          i.comments.build do |m|
            m.person = agent
            m._pp = 20
            m._np = 20
            m._ns = 20
            m._ps = 40
          end
        end
      else
        p "#{Time.now.to_s} - Skipping #{check['checkid']} already logged as #{already_logged.first.issue_no}"
      end
=end
    end
  end

  def create_offline(offline, server, client, branch, contact, department, agent)
    already_logged = client.issues.where(:checkstarttime => offline['starttime']).where(:checkstartdate => offline['startdate']).where(:checkdescription => offline['description']).order(created_at: :desc)
    if already_logged.count == 0
      p "#{Time.now.to_s} - Issue logged for offline server"
      issue = Issue.create do |i|
        i.subject = "#{server} Offline [Prime Networks Monitoring]"
        i.person = agent
        i.department = department
        i.client = client
        i.contact = contact
        i.checkstarttime = offline['starttime']
        i.checkstartdate = offline['startdate']
        i.checkdescription = offline['description']
        i.priority = 'normal'
        i.status = 'on_hold'
        i.comments.build do |m|
          m.person = agent
          m.content = "#{offline['description']}"
          m._np = 20
          m._ns = 40
        end
        i.comments.build do |m|
          m.person = agent
          m._pp = 20
          m._np = 20
          m._ns = 20
          m._ps = 40
        end
      end
    end
  end

  def create_overdue(overdue, server, client, branch, contact, department, agent)
    already_logged = client.issues.where(:checkstarttime => overdue['starttime']).where(:checkstartdate => overdue['startdate']).where(:checkdescription => overdue['description']).order(created_at: :desc)
    if already_logged.count == 0
      p "#{Time.now.to_s} - Issue logged for overdue server"
      issue = Issue.create do |i|
        i.subject = "#{server} Overdue [Prime Networks Monitoring]"
        i.person = agent
        i.department = department
        i.client = client
        i.contact = contact
        i.checkstarttime = overdue['starttime']
        i.checkstartdate = overdue['startdate']
        i.checkdescription = overdue['description']
        i.priority = 'normal'
        i.status = 'on_hold'
        i.comments.build do |m|
          m.person = agent
          m.content = "#{overdue['description']}"
          m._np = 20
          m._ns = 40
        end
        i.comments.build do |m|
          m.person = agent
          m._pp = 20
          m._np = 20
          m._ns = 20
          m._ps = 40
        end
      end
    end
  end

  def create_unreachable(unreachable, server, client, branch, contact, department, agent)
    already_logged = client.issues.where(:checkstarttime => unreachable['starttime']).where(:checkstartdate => unreachable['startdate']).where(:checkdescription => unreachable['description']).order(created_at: :desc)
    if already_logged.count == 0
      p "#{Time.now.to_s} - Issue logged for unreachable server"
      issue = Issue.create do |i|
        i.subject = "#{server} Unreachable [Prime Networks Monitoring]"
        i.person = agent
        i.department = department
        i.client = client
        i.contact = contact
        i.checkstarttime = unreachable['starttime']
        i.checkstartdate = unreachable['startdate']
        i.checkdescription = unreachable['description']
        i.priority = 'normal'
        i.status = 'on_hold'
        i.comments.build do |m|
          m.person = agent
          m.content = "#{unreachable['description']}"
          m._np = 20
          m._ns = 40
        end
        i.comments.build do |m|
          m.person = agent
          m._pp = 20
          m._np = 20
          m._ns = 20
          m._ps = 40
        end
      end
    end
  end
end

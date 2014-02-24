require_relative '../../client'

class ImportIssue
  include Sidekiq::Worker

  def perform(i)
    issue = Issue.create id: i['issue_no'], subject: i['subject'], issue_time_cache: issue_time_for(i), response_time_cache: response_time_for(i), status: status_for(i), priority: priority_for(i), checkid: i['checkid'], checkcleared: i['checkcleared'], checkstarttime: i['checkstarttime'], checkstartdate: i['checkstartdate'], checkdescription: i['checkdescription'], product_type_id: product_type_for(i), closed_by: closed_by_agent(i), person_id: person_for(i), department_id: department_for(i), client_id: client_for(i), contact_id: contact_for(i), created_at: i['created_at'], updated_at: i['updated_at']
    puts issue.errors.messages
    i['comments'].each do |c|
      issue.comments.create person_id: person_for(c), content: c['content'], _pp: c['_pp'], _np: c['_np'], _ps: c['_ps'], _ns: c['_ns'], created_at: c['created_at'], updated_at: c['updated_at']
    end
    Indexing.perform_async(issue.id)
  end

  private

  def issue_time_for(i)
    if i['issue_time_cache'].nil?
      0
    else
      i['issue_time_cache']
    end
  end

  def response_time_for(i)
    if i['response_time_cache'].nil?
      0
    else
      i['response_time_cache']
    end
  end

  def status_for(i)
    puts i['status']
    case i['status_cache'].to_i
    when 10
      'resolved'
    when 20
      'on_hold'
    when 30
      'open'
    when 40
      'new'
    else
      'resolved'
    end
  end

  def priority_for(i)
    puts i['priority']
    case i['priority_cache'].to_i
    when 10
      'low'
    when 20
      'normal'
    when 30
      'high'
    when 40
      'critical'
    else
      'normal'
    end
  end

  def product_type_for(i)
    pt = ProductType.where(name: i['product_type']).first
    pt.id if pt
  end

  def closed_by_agent(i)
    if @@agents.has_key? i['closed_by_agent']
      full_name = @@agents[i['closed_by_agents']]
      person = Person.where(forename: full_name.split(' ').first).where(surname: full_name.split(' ').last).first
      if person
        person.id
      end
    end
  end

  def person_for(i)
    if @@agents.has_key? i['person_id']
      full_name = @@agents[i['person_id']]
      person = Person.where(forename: full_name.split(' ').first).where(surname: full_name.split(' ').last).first
      if person
        person.id
      end
    end
  end

  def department_for(i)
    if @@departments.has_key? i['department_id']
      name = @@departments[i['department_id']]
      department = Department.where(department_name: name).first
      if department
        department.id
      end
    end
  end

  def client_for(i)
    if @@clients.has_key? i['client_id']
      name = @@clients[i['client_id']]
      @client = Client.where(company: name).first
      if @client
        @client.id
      end
    end
  end

  def branch_for(i)
    if @client && @@branches.has_key?(i['branch_id'])
      name = @@branches[i['branch_id']]
      @branch = @client.branches.where(branch_name: name).first
      if @branch
        @branch.id
      end
    end
  end

  def contact_for(i)
    if @branch && @@contacts.has_key?(i['contact_id'])
      full_name = @@contacts[i['contact_id']]
      contact = @branch.contacts.where(forename: full_name.split(' ').first).where(surname: full_name.split(' ').last).first
      if contact
        contact.id
      end
    end
  end
end

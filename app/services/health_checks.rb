class HealthChecks
  include Sidekiq::Worker

  def perform
    hc_start_date = Time.now.beginning_of_day + 1.week

    @healthchecks = Client.where("health_check_date <= ?", hc_start_date)

    @healthchecks.each do |hc|
      client = Client.find(hc.id)
      if hc.health_check_department.present?
        department = Department.find(hc.health_check_department)
      else
        department = Department.first
      end

      if hc.health_check_person.present?
        person = Person.find(hc.health_check_person)
      else
        person = nil
      end

      comment = Comment.new
      comment.person = person if person.present?
      comment._ns = 40
      comment._np = 20

      issue = Issue.new
      issue.subject = "Health Check (#{client.check_date})"
      issue.person = person if person.present?
      issue.department = department
      issue.client = client
      issue.comments << comment
      issue.save

      new_date = client.health_check_date + 3.months
      client.update_attribute :health_check_date, new_date
    end
  end
end


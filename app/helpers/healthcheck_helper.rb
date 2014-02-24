module HealthcheckHelper
  def select_hc_responsibility(form)
    html = ''
    Department.find(:all).each do |department|
      unless department.people.empty?
        html += "<h6>#{form.radio_button(:health_check_department, department.id)} #{form.label :health_check_department, department.department_name}</h6>"
        department.people.each do |person|
          unless person.id == session[:identity]
            html += "<p>#{form.radio_button(:health_check_person, person.id)} #{form.label(:health_check_person, person.full_name)}</p>"
          else
            name = "<strong>Me</strong> (#{person.full_name})".html_safe
            html += "<p>#{form.radio_button(:health_check_person, person.id)} #{form.label(:health_check_person, name)}</p>"
          end
        end
      end
    end
    html.html_safe
  end
end

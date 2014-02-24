module DashboardHelper
  def dashboard_header(s, c)
    if s.nil?
      return "All Tickets (#{pluralize(c, 'ticket')})"
    else
      return "Tickets for #{s.department_name} (#{pluralize(c, 'ticket')}) <em>(<a href=\"/issues\">Reset search</a>)</em>"
    end
  end

  def select_responsibility(form)
    html = ''
    Department.find(:all).each do |department|
      html += "<h6>#{form.radio_button(:department_id, department.id)} #{form.label :department_id, department.department_name}</h6>"
      department.people.each do |person|
        unless person.id == session[:identity]
          html += "<p>#{form.radio_button(:person_id, person.id)} #{form.label(:person_id, person.full_name)}</p>"
        else
          name = "<strong>Me</strong> (#{person.full_name})".html_safe
          html += "<p>#{form.radio_button(:person_id, person.id)} #{form.label(:person_id, name)}</p>"
        end
      end
    end
    html.html_safe
  end

  def ticket_assignment(i)
    if i.person_id.present? && i.person_id != 0
      if i.person_id == session[:identity]
        "Assigned to: <strong>Me</strong>".html_safe
      else
        "Assigned to: <strong>#{i.person.abbr_name}</strong>".html_safe
      end
    else
      "Assigned to: <strong>N/A</strong>".html_safe
    end
  end

  def ticket_department(i, x=true)
    if i.department && i.department.department_name
      i.department.department_name if x
      "Department <strong>#{i.department.department_name}</strong>".html_safe if !x
    else
      "-" if x
      "No Department" if !x
    end
  end

  def ticket_product(i, x=true)
    if i.product_type && i.product_type.name
      i.product_type.name if x
      "Product <strong>#{i.product_type.name}</strong>".html_safe if !x
    else
      "-" if x
      "No Product" if !x
    end
  end
end

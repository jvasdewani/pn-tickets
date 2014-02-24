module ApplicationHelper
  include Authentication

  def page_title(args)
    content_for(:title) { args }
  end

  def time_display(secs)
    hours =  secs/3600.to_i
    minutes = (secs/60 - hours * 60).to_i
    seconds = (secs - ((minutes * 60) + (hours * 3600)))
    "#{'%.2d' % hours}:#{'%.2d' % minutes}:#{'%.2d' % seconds}"
  end

  def display_class(payment)
    if payment.paid
      ' class="paid"'.html_safe
    elsif !payment.paid && payment.due_at < Date.today
      ' class="overdue"'.html_safe
    end
  end

  def s_to_s(string)
    case string.to_i
    when 10
      'resolved'
    when 20
      'on_hold'
    when 30
      'open'
    when 40
      'new'
    end
  end

  def p_to_s(string)
    case string.to_i
    when 10
      'low'
    when 20
      'normal'
    when 30
      'high'
    when 40
      'critical'
    end
  end
end

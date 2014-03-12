class ReportPdf < Prawn::Document
  def initialize(report)
    super :top_margin => 40
    super :page_layout => :landscape
    @report = report
    image File.expand_path('../../../public/logo.jpg', __FILE__), :at => [580, 560]
    text "Report #{Date.today.strftime('%d/%m/%Y')}", :size => 14, :style => :bold
    if @report.documents.empty?
      move_down 20
      text "No tickets", :size => 10
    else
      header_stub
      list_issues
    end
  end

  def list_issues
    move_down 20
    table issue_rows do
      row(0).font_style = :bold
      columns(0).align = :center
      columns(3..8).align = :right
      column(0).width = 35
      columns(3..8).width = 55
      self.row_colors = ["EEEEEE", "FFFFFF"]
      self.header = true
      self.cell_style = { :size => 8 }
    end
  end

  def issue_rows
    [["", "Client", "Subject", "Date", "Resp", "Total", "Status", "Agent", "Type", "Contact"]] +
    @report.documents.map do |issue|
      [issue.issue_no, "#{issue.client.company unless issue.client.nil?} (#{issue.client.group unless issue.client.nil?})", issue.subject, issue.created_at.strftime('%d %b, %y'), display_time(issue.response_time), display_time(issue.issue_time), issue.status.titleize, (issue.person ? issue.person.abbr_name : ''), (issue.product_type ? issue.product_type.name : ''), "#{issue.contact.forename unless issue.contact.nil?}"]
    end
  end

  def product_type_name(issue)
    if issue.product_type.nil?
      'None'
    else
      issue.product_type
    end
  end

  def s_to_s(string)
    case string
    when 10
      'Resolved'
    when 20
      'On hold'
    when 30
      'Open'
    when 40
      'New'
    end
  end

  def display_time(secs=0)
    secs = 0 if secs.nil?
    hours, secs = secs.divmod(3600)
    minutes, seconds = secs.divmod(60)
    "#{'%.2d' % hours}:#{'%.2d' % minutes}:#{'%.2d' % seconds}"
  end

  def header_stub
    move_down 10

    text "Average response time: #{display_time(@report.documents.map(&:response_time).compact.reduce(0, :+)/@report.documents.length)}", :size => 10, :style => :bold
    text "Based on #{@report.documents.length} ticket(s)", :size => 8
    move_down 5
    text "Average ticket time: #{display_time(@report.documents.map(&:issue_time).compact.reduce(0, :+)/@report.documents.length)}", :size => 10, :style => :bold
    text "Based on #{@report.documents.length} ticket(s)", :size => 8
    move_down 5

    move_down 10
    text "Longest response wait: #{display_time(@report.documents.collect(&:response_time).sort.last)}", :size => 8, :style => :normal
    text "Longest ticket wait: #{display_time(@report.documents.collect(&:issue_time).sort.last)}", :size => 8, :style => :normal

    move_down 15
    text "Late responses: #{@report.documents.collect(&:response_time).compact.delete_if { |t| t < 3600}.count} ticket(s)", :size => 10, :style => :normal
    text "Based on a wait of more than 1 hour", :size => 8
    move_down 5

    text "Late ticket time: #{@report.documents.collect(&:issue_time).compact.delete_if { |t| t < 18000}.count} ticket(s)", :size => 10, :style => :normal
    text "Based on a wait of more than 4 hours", :size => 8
  end
end

class SummaryPdf < Prawn::Document
  def initialize(issues, closed, summary_string, view)
    super :top_margin => 40
    super :page_layout => :landscape
    @issues = issues
    @closed = closed
    @view = view
    image File.expand_path('../../../public/logo.jpg', __FILE__), :at => [580, 560]
    text "Report: #{summary_string}", :size => 22, :style => :bold
    if @issues.empty?
      move_down 20
      text "No tickets", :size => 12
    else
      category_stub
      engineer_stub
    end
  end

  def display_time(secs)
    hours, secs = secs.divmod(3600)
    minutes, seconds = secs.divmod(60)
    "#{'%.2d' % hours}:#{'%.2d' % minutes}:#{'%.2d' % seconds}"
  end

  def category_stub
    move_down 20
    data = [["", "Tickets", "Avg. response time", "Avg. ticket time"]]
    @issues.group_by(&:product_type).each do |product_type, issues|
      data << [product_type, issues.count, display_time((issues.map { |i| i.response_time }.reduce(:+) / issues.count.to_f)), display_time((issues.map { |i| i.issue_time }.reduce(:+) / issues.count.to_f))]
    end
    data

    table data do
      row(0).font_style = :bold
      columns(1..3).align = :right
      column(0).width = 250
      self.row_colors = ["EEEEEE", "FFFFFF"]
      self.header = true
      self.cell_style = { :size => 10 }
    end
  end

  def engineer_stub
    move_down 20
    data = [["", "Closed tickets", "Avg. response time", "Avg. ticket time"]]
    @closed.group_by(&:closed_by).each do |person_id, issues|
      if person_id.nil?
        person_name = 'No-one'
      else
        person = Person.find(person_id)
        person_name = person.full_name
      end
      data << [person_name, issues.count, display_time((issues.map { |i| i.response_time }.reduce(:+) / issues.count.to_f)), display_time((issues.map { |i| i.issue_time }.reduce(:+) / issues.count.to_f))]
    end
    data

    table data do
      row(0).font_style = :bold
      columns(1..3).align = :right
      column(0).width = 250
      self.row_colors = ["EEEEEE", "FFFFFF"]
      self.header = true
      self.cell_style = { :size => 10 }
    end
  end
end

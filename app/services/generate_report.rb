class GenerateReport
  include Sidekiq::Worker

  def perform(report, uuid)
    sleep 2
    @report = Report.new report
    @report.save
    pdf = ReportPdf.new @report
    pdf.render_file("/var/app/pdfs/#{uuid}.pdf")

    client = Faye::Client.new('http://0.0.0.0:9292/faye')
    client.publish("/#{uuid}", 'pdf' => "/pdfs/#{uuid}.pdf")
  end
end

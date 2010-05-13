class KeywordReport < Ruport::Controller
  include ReportHelper
  
  stage :standard_report_header, :document_body
  finalize :standard_report

  def setup
    self.data = setup_keyword_report(options.project_id, options.extras)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => KeywordReport
    include StandardPDFReport

    build :document_body do
      if !self.data.empty?
        draw_table(self.data)
      else
        add_text "No keywords found for the selected report criteria."
      end
    end

  end
  
end
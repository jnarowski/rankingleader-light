class LinkReport < Ruport::Controller
  include ReportHelper
  
  stage :standard_report_header, :document_body
  finalize :standard_report

  def setup
    self.options.extras = setup_extras(options.extras)
    self.data = setup_link_report(options.project_id, options.extras)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => LinkReport
    include StandardPDFReport

    build :document_body do
      if self.data && !self.data.column_names.blank?
        draw_table(self.data)
      else
        add_text "No links have been added to this project yet."
      end
    end
    
  end
  
end
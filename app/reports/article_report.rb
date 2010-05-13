class ArticleReport < Ruport::Controller
  include ReportHelper
  
  stage :standard_report_header, :document_body
  finalize :standard_report

  def setup
    self.options.extras = setup_extras(options.extras)
    self.data = setup_article_report(options.project_id, options.extras)
  end

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => ArticleReport
    include StandardPDFReport
    include ReportHelper
  
    build :document_body do
      !self.data.empty? ? draw_table(self.data) : add_text("No articles have been added to this project yet.")
    end

  end
  
end
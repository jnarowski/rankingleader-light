class ProjectReport < Ruport::Controller
  include ReportHelper
  
  stage :standard_report_header, :document_body
  finalize :standard_report
  
  def setup
    self.options.extras = setup_extras(options.extras)
    
    self.data = []
    self.data << ProjectRank.faux_report_table(options.project_id, options.extras)
    self.data << setup_link_report(options.project_id, options.extras)
    self.data << setup_keyword_report(options.project_id, options.extras)
    self.data << setup_article_report(options.project_id, options.extras)
  end

  class PDF < Ruport::Formatter::PDF
    include ReportHelper
    include StandardPDFReport
    
    renders :pdf, :for => ProjectReport

    build :document_body do

      pad(7){
        pad_bottom(8) { 
          add_text "Report Date Range: #{options.extras[:start_date].strftime("%m/%d/%Y")} - #{options.extras[:end_date].strftime("%m/%d/%Y")}", :font_size => 16, :justification => :left 
          add_text 'This is a report that includes an overview of the activity on your project for the above date range. Look for more detailed explanations above each table regarding its contents', :font_size => 12, :justification => :left 
        }
      }
                    
      # overall project_rank history
      unless self.data[0].empty?
        pad(10){
          pad_bottom(10) { 
            pad_bottom(5) { add_text 'Domain Progress', :font_size => 16, :justification => :left } 
            add_text 'This data represents the inbound links acquired over the specified date range. The last record in the table represents the first result saved, so a comparison can be made with the sites current status.', :font_size => 12, :justification => :left 
          }
          draw_table(self.data[0]) 
        } 
        pad_top(10){ hr }
      end
    
      # links added during date range
      unless self.data[1].empty?
        pad(10){
          pad_bottom(10) { 
            pad_bottom(5) { add_text 'Links', :font_size => 16, :justification => :left } 
            add_link_description_text 
          }
          draw_table(self.data[1]) 
        } 
        pad_top(10){ hr }
      end

      # keywords added during date range
      unless self.data[2].empty?
        pad(10){
          pad_bottom(10) { 
            pad_bottom(5) { add_text 'Keywords', :font_size => 16, :justification => :left } 
            add_keyword_description_text
          }
          draw_table(self.data[2]) 
        } 
        pad_top(10){ hr }
      end
      
      # articles added during date range
      unless self.data[3].empty?
        pad(10){
          pad_bottom(10) { 
            pad_bottom(5) { add_text 'Articles', :font_size => 16, :justification => :left } 
            add_article_description_text
          }
          draw_table(self.data[3]) 
        } 
        pad_top(10){ hr }
      end
      

      
    end

  end
  
end
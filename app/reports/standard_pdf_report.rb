module StandardPDFReport
  
  def build_standard_report_header
    pdf_writer.select_font("Times-Roman")
    options.text_format = { :font_size => 14, :justification => :right }
    add_text "<i>#{options.report_title}</i>"
    add_text "Generated at #{Time.now.strftime('%H:%M on %Y-%m-%d')}"

    center_image_in_box "#{RAILS_ROOT}/public/images/metaspring_logo.png", :x => left_boundary - 10,  
                                      :y => top_boundary - 65, 
                                      :width => 300, 
                                      :height => 94 


    move_cursor_to top_boundary - 80
    pad_bottom(20) { hr }
    
    options.text_format[:justification] = :left
    options.text_format[:font_size] = 12
  end
  
  def build_standard_report_footer
  end
  
  def finalize_standard_report
    render_pdf
    pdf_writer.save_as(options.file)
  end
  
end
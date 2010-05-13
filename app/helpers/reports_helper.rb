module ReportsHelper
  def created_at_column(record)
    format_date record.created_at  
  end

  def name_column(record)
    link_to record.name, record.url_for_filename, :target => '_BLANK'  
  end

end
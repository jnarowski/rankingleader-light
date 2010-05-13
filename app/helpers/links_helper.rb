module LinksHelper
  def created_at_column(record)
    format_date record.created_at  
  end   
  
  def page_rank_column(record)
    "#{page_rank_image(record.page_rank)} #{record.page_rank}" if record.page_rank
  end
  
  def link_type_column(record)
    record.link_type ? record.link_type.name : '-'
  end

  def url_column(record)
    "<a href=\"http://#{record.url}\" alt=\"#{record.url}\" title=\"#{record.url}\" target=\"_BLANK\">#{truncate(record.url, :length => 40)}</a>"
  end
    
  def link_type_form_column(record, input_name)
    select :record, :link_type_id, LinkType.find(:all).collect {|lt| [ lt.name, lt.id ] }, :name => input_name, :prompt => 'Select Link Type'
  end
  
  def available_link_types
    str = "<ul style='margin: 0px; padding-left: 15px;'>"
    @link_types.each {|l| str += "<li>#{l.permalink}</li>" }
    str += "</ul>"
    str
  end
      
  def verify_backlink
    "Verify"
  end
end
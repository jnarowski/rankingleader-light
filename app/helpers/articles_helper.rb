module ArticlesHelper
  def created_at_column(record)
    format_date record.created_at  
  end  
  
  def title_column(record) 
    link_to(record.title, url_for_file_column(record, 'filename'))
  end
  
  def published_column(record)
    link_to(record.status, record.published_url)
  end

  def category_id_column(record)
    record.category.name if record.category
  end
    
  def rating_column(record)
    record.rating ? "#{record.rating} / 10" : '-'
  end
  
  def cost_column(record)
    record.cost && record.cost > 0 ? format_money(record.cost) : '-'
  end
  
  def published_url_column(record)
    record.published_url ? link_to('View', record.published_url, :target => '_BLANK') : '-'
  end
  
  def author_column(record)
    if record.writer_id
      current_user.client? ? 'Accepted' : record.writer.name
    else
      '-'
    end
  end
  
  def writer_id_form_column(record, input_name)
    select :record, :writer_id, Writer.find(:all).collect {|w| [ w.name, w.id ] }, :name => input_name, :prompt => 'Select Writer'
  end
  
end
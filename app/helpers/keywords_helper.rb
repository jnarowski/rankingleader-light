module KeywordsHelper
  def name_column(record)
    link_to(record.name, "http://www.google.com/search?site=&hl=en&q=#{ record.name.gsub(/ /, '+') }&btnG=Search", :target => "_BLANK")
  end
  
  def current_rank_column(record)
    record.current_rank && record.current_rank > 0 ? record.current_rank : '-' 
  end

  def previous_rank_column(record) 
    record.previous_rank && record.previous_rank > 0 ? record.previous_rank : '-' 
  end

  def last_ranked_column(record)
    format_date record.last_ranked  
  end
  
  def change_in_rank_column(record)  
    if record.current_rank && record.previous_rank
      if record.current_rank != 0 && record.previous_rank != 0
        change = (record.current_rank || 0) - (record.previous_rank || 0)  
        if change > 0
          return "<div style=\"color: red;\">+#{ change }</div>"
        elsif change < 0
          return "<div style=\"color: green;\">-#{ change *-1 }</div>"    
        else
          return "No Change"   
        end
      else
        return "-"
      end
    end  
  end    
end

module ReportHelper

  def setup_extras(extras = nil)
    extras ||= Hash.new
    extras[:start_date] ||= start_of_month
    extras[:end_date] ||= end_of_month
    extras
  end
  
  def setup_conditions(extras)  
    conditions = ''
    if extras && (!extras[:start_date].blank? || !extras[:end_date].blank?)
      conditions += " AND created_at >= '#{extras[:start_date]}'" unless extras[:start_date].blank?
      conditions += " AND created_at <= '#{extras[:end_date]}'"   unless extras[:end_date].blank?
    end
    conditions
  end
  
  def start_of_month(date = Date.today)
    Date.new(date.year, date.month, 1)
  end
  
  def end_of_month(date = Date.today)
    Date.new(date.year, date.month + 1, 1) - 1
  end

  # --------------------------------------------------------  
  # keyword report helpers
  # --------------------------------------------------------

  def add_keyword_description_text
    add_text 'Keywords that have been added to your project during the provided date range.', :font_size => 12, :justification => :left 
  end
    
  def setup_keyword_report(project_id, extras)
    table = Keyword.report_table(:all, :conditions => ["project_id = ? #{setup_conditions(extras)}", project_id])
    table.rename_columns(custom_keyword_columns)
    table
  end
  
  def custom_keyword_columns
    {
      'last_ranked_formatted' => 'Last Ranked',
      'change_in_rank' => 'Change',
      'current_rank' => 'Current Rank',
      'previous_rank' => 'Previous Rank',
      'name' => 'Keyword'     
    }
  end
  
  # --------------------------------------------------------  
  # article report helpers
  # --------------------------------------------------------

  def add_article_description_text
    add_text 'Articles that have been added to your project for the provided date range.', :font_size => 12, :justification => :left 
  end
    
  def setup_article_report(project_id, extras)
    table = Article.report_table(:all, :conditions => ["project_id = ? #{setup_conditions(extras)}", project_id])
    table.rename_columns(custom_article_columns)
    table
  end
  
  def custom_article_columns
    {
      'created_at_formatted' => 'Created At',
      'title' => 'Title',
      'status' => 'Status',
      'published_url' => 'Published At'
    }
  end
  
  # --------------------------------------------------------  
  # link report helpers
  # --------------------------------------------------------

  def add_link_description_text
    add_text 'Inbound links that have been added to your project for the provided date range.', :font_size => 12, :justification => :left
  end
  
  def setup_link_report(project_id, extras)
    table = Link.report_table(:all, :conditions => ["project_id = ? #{setup_conditions(extras)}", project_id])
    table.rename_columns(custom_link_columns)
    table
  end
  
  def custom_link_columns
    {
      'created_at_formatted' => 'Created At',
      'link_type_formatted' => 'Type',
      'url' => 'Url',
      'keyword' => 'Anchor Text',
      'backlink' => 'Backlink'
    }
  end

end
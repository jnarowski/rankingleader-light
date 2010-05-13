module ProjectsHelper
  def report_type_description(report_type)
    return case report_type
    when 'Project' then "This report is an overview of the campaigns progress including inbound linking progress, links and keywords"
    when 'Article' then "A list of all of the articles that have been produced during the below date range."
    when 'Link'    then "A list of all of the links that have been added to the campaign during the below date range."
    when 'Keyword' then "A list of all of the keywords and their ranking progress if applicable."
    end
  end  
end
class Report < ActiveRecord::Base
  belongs_to :project
  
  REPORT_PATH = "#{RAILS_ROOT}/public/"
  
  def self.generate_report(report_type, project_id, options = {})
    raise "No report type provided." if report_type.blank?
    
    
    # setup the report
    report_title = options[:title] ? options[:title] : "#{report_type} Report"
    
    # create a new report
    Report.transaction do 
      report = Report.create(:project_id => project_id)
      report.prepare_and_set_title(report_title)
    
      # call the correct report renderer
      # ProjectReport, ArticleReport, LinkReport, KeywordReport
      klass = eval("#{report_type}Report")
      klass.render_pdf(:file => report.abs_path_with_filename, :report_title => "#{report.name} for #{report.project.url}", :project_id => report.project_id, :extras => options)
    
      # finally save the report after the title and filename have been appended to it
      report.save
      report
    end
  end
  
  # ---------------------------------------------------------------------
  # Project Reports
  # ---------------------------------------------------------------------
  
  def self.generate_project_reports
    Project.all(:conditions => ["active = ? ", true]).each do |p|
      r = Report.create(:project_id => p.id)
      r.generate_project_report
    end
  end
  
  def generate_project_report(options = {})
    Report.transaction do 
      self.prepare_and_set_title('Project Report')
      ProjectReport.render_pdf(:file => abs_path_with_filename, :report_title => "#{self.name} for #{self.project.url}", :project_id => self.project_id)
      self.save
    end
  end
    
  # ---------------------------------------------------------------------
  # Article Reports
  # ---------------------------------------------------------------------
  
  def self.generate_article_reports
    Project.all(:conditions => ["active = ? ", true]).each do |p|
      r = Report.create(:project_id => p.id)
      r.generate_article_report
    end
  end
  
  def generate_article_report(options = {})
    Report.transaction do 
      self.prepare_and_set_title('Article Report')
      ArticleReport.render_pdf(:file => abs_path_with_filename, :report_title => "#{self.name} for #{self.project.url}", :project_id => self.project_id)
      self.save
    end
  end
  
  # ---------------------------------------------------------------------
  # Keyword Reports
  # ---------------------------------------------------------------------
  
  def self.generate_keyword_reports
    Project.all(:conditions => ["active = ? ", true]).each do |p|
      r = Report.create(:project_id => p.id)
      r.generate_keyword_report
    end
  end
  
  def generate_keyword_report(options = {})
    Report.transaction do 
      self.prepare_and_set_title('Keyword Report')
      KeywordReport.render_pdf(:file => abs_path_with_filename, :report_title => "#{self.name} for #{self.project.url}", :project_id => self.project_id)
      self.save
    end
  end

  # ---------------------------------------------------------------------
  # Link Reports
  # ---------------------------------------------------------------------
  
  def self.generate_link_reports(options = {})
    Project.all(:conditions => ["active = ? ", true]).each do |p|
      r = Report.create(:project_id => p.id)
      r.generate_link_report
    end
  end
  
  def generate_link_report(options = {})
    Report.transaction do 
      self.prepare_and_set_title('Link Report')
      LinkReport.render_pdf(:file => abs_path_with_filename, :report_title => "#{self.name} for #{self.project.url}", :project_id => self.project_id)
      self.save
    end
  end
  
  # ---------------------------------------------------------------------
  # General Reporting Methods
  # ---------------------------------------------------------------------
  
  def prepare_and_set_title(report_name)
    self.verify_or_create_dir
    self.name = report_name
    self.set_filename
  end
  
  def set_filename(report_type = 'report')
    raise "Report must be saved before generating the PDF" if self.new_record?
    self.filename = "#{self.id}.pdf"
  end
    
  def path
    "reports/#{self.project_id}"
  end
  
  def url_for_filename
    "#{path}/#{self.filename}"
  end
  
  def abs_path
    "#{REPORT_PATH}/#{path}"
  end
  
  def abs_path_with_filename
    "#{abs_path}/#{self.filename}"
  end
  
  def verify_or_create_dir(directory = self.abs_path)
    FileUtils.makedirs(directory) unless File.exist?(directory)
  end
  
end
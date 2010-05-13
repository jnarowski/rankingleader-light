class Link < ActiveRecord::Base
  acts_as_reportable :only => ['url', 'backlink', 'keyword'], :methods => [:created_at_formatted, :link_type_formatted]

  belongs_to :project      
  belongs_to :link_type
  
  validates_presence_of :url
  validates_uniqueness_of :url, :scope => :project_id

  # ---------------------------------------------------------------
  # ActiveScaffold Stuff
  # ---------------------------------------------------------------

  def created_at_formatted
    self.created_at.strftime("%m/%d/%Y")
  end
  
  def link_type_formatted
    self.link_type.name if self.link_type
  end
  
  def to_label
    self.url
  end
  
  def url_page_rank
    self.page_rank   
  end
  
  # ---------------------------------------------------------------
  # Instance Level
  # ---------------------------------------------------------------
  
  def before_save
    self.url = self.url.gsub(/http:\/\//, '')      
    self.get_google_rank
  end
  
  def before_update
    unless self.backlink_verified_on == Date.today
      self.verify_backlink
    end
  end
  
  def get_google_rank   
    begin 
      self.page_rank = Ruseo::Google::PageRank.new(self.url).parse   
    rescue
      #TODO: write to error log & send email?
    end
  end

  # verifies the presence of the project URL on the provided website
  def verify_backlink    
    page = Ruseo::PageInspecter.new(self.url, :backlink => self.project.url)
    page.find_backlinks
    
    unless page.backlinks.empty?
      #TODO: handle more than 1 link, the first is the most important
      link = page.backlinks.first
      
      # update the link attributes
      self.anchor_text = link.text  
      self.backlink = link.href
      self.backlink_verified_on = Date.today
      self.nofollow = link.nofollow?
      
      # automatically assign the keyword if it is being optimized for
      keyword = Keyword.find_by_name(link.text)
      self.keyword_id = keyword.id if keyword
  
      self.save
    end
  end
      
  # ---------------------------------------------------------------
  # Class Level
  # ---------------------------------------------------------------

  def self.verify_backlinks(project_id)
    Link.find(:all, :conditions => ["project_id = ?", project_id], :include => :project).each do |l|                                                                                                     
      l.verify_backlink
    end
  end
    
  def self.bulk_import(bulk_links, project_id)
    rows = bulk_links.split(/\r\n/)  
    unless rows.empty?
      rows.each do |row|
        link = Link.new(:project_id => project_id)
        result = row.split(",")
        # result[0] = link
        # result[1] = link_type (blog, website, social_media, forum)
        if result && result[1]
          link_type = LinkType.find_by_permalink(result[1].strip)
          link.link_type_id = link_type.id if link_type
        end
        # the first result wether or not the link type is present
        link.url = result[0]
        link.save
      end     
    end
  end
    
end
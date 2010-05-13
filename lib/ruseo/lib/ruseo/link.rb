module Ruseo
  class Link
    attr_accessor :href, :target, :rel, :text
    
    def initialize(link)
      @href = link['href']
      @target = link['target']
      @rel = link['rel']
      @text = link.content unless link.is_a?(Hash) #TODO: remove this line messy, in there just for testing purposes. 
    end
    
    def nofollow?
      @rel ? @rel.include?('nofollow') : false
    end
    
  end
end
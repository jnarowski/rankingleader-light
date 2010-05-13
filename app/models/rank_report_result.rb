class RankReportResult < ActiveRecord::Base   
  belongs_to :rank_report, :dependent => :destroy
end
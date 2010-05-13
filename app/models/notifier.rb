class Notifier < ActionMailer::Base
  
  def article_published(article)
    recipients      article.project.client_email_string
    bcc             'jp@metaspring.com'
    subject         "[MetaSpring SEO] #{article.title} has been published"
    from            "noreply@seo.metaspring.com"
    sent_on         Time.now
    content_type    "text/html"
    body            :article => article,
                    :project => article.project
  end
  
  def article_uploaded(article)
    writer_name = (article.writer ? article.writer.name : '-')
    recipients      'jp@metaspring.com'
    subject         "[MetaSpring SEO] #{writer_name} has uploaded an article for #{article.project.url}"
    from            "noreply@seo.metaspring.com"
    sent_on         Time.now
    content_type    "text/html"
    body            :writer  => article.writer,
                    :article => article,
                    :project => article.project
  end
  
  def report_completed(report, user)
    recipients      user.username
    bcc             'jp@metaspring.com'
    subject         "[MetaSpring SEO] Report has finished generating and is available for download."
    from            "noreply@seo.metaspring.com"
    sent_on         Time.now
    content_type    "text/html"

    part "text/html" do |p|
      p.body render_message('report_completed', { :report  => report, :project => report.project })
    end

    part :content_type => "multipart/mixed" do |p|
      p.attachment :content_type => "application/pdf", :body => File.read(report.abs_path_with_filename)        
    end             
    
  end
end
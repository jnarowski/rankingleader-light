class ArticleObserver < ActiveRecord::Observer
  def after_create(article)
    Notifier.deliver_article_uploaded(article)
    Notifier.deliver_article_published(article) if article.published?
  end
  
  def before_update(article)
    old_article = Article.find(article.id)
    Notifier.deliver_article_published(article) if (article.published? && !old_article.published?)
  end
end
class BlogOverviewPageController < CmsController
  POSTS_PER_PAGE = 5

  def index
    offset = params[:offset].to_i

    blog_posts_query = BlogPostPage.all.order(created: :desc)
    # If a tag is provided, then filter by it:    
    blog_posts_query.and(:tags, :equals, params[:tag]) if params[:tag].present? 
    @blog_posts = blog_posts_query.take(POSTS_PER_PAGE)    

    total = blog_posts_query.size

    if offset > 0
      @previous_page = scrivito_path(@obj, offset: offset - POSTS_PER_PAGE)
    end

    if total > offset + POSTS_PER_PAGE
      @next_page = scrivito_path(@obj, offset: offset + POSTS_PER_PAGE)
    end
  end
end
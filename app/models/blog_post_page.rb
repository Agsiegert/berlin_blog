class BlogPostPage < Obj
  attribute :title, :string
  attribute :body, :widgetlist
  attribute :child_order, :referencelist

  # Additional attributes
  attribute :tags, :stringlist
  attribute :abstract, :html
  attribute :created, :date
  attribute :author, :string
  
  default_for :created do
    Time.zone.now
  end

  def self.all_tags
    all.batch_size(0).facet("tags", limit: 50)
  end
end

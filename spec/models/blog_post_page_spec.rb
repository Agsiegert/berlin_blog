require 'rails_helper'

describe BlogPostPage do
  describe :all_tags do
    it "should return an empty array if no tag was set before" do
      expect(BlogPostPage.all_tags).to eql []
    end

    it "should return a tag if the blog post has tags" do
      bpp = BlogPostPage.create(tags: ["testing"])
      expect(BlogPostPage.all_tags).to eql ["testing"]
    end
  end

end
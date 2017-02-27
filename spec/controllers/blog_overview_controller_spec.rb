require 'rails_helper'

describe BlogOverviewPageController do

  let(:obj) { mock_obj(BlogOverviewPage, path: '/blog') }
  

  before do
    request.for_scrivito_obj(obj)
  end


  describe  '#index' do
    it 'returns blog a post' do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the posts into @blog_posts" do
      get :index

      expect(assigns(:blog_posts)).to eq(post1)
    end
  end

end


#     context 'with search term' do
#       let(:term) { 'example' }
#       let(:category) { double(parent: double) }
#       let(:categories) { [category] }

#       it 'searches for faq entries' do
#         expect(FaqEntry).to receive(:search).with(term) { categories }
#         expect(obj).to receive(:child_order) { [] }

#         get :index, q: term

#         expect(assigns(:categories)).to be_a(Array)
#         expect(response.status).to eq(200)
#       end
#     end
#   end
# end
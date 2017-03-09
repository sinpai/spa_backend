require "spec_helper"

describe Api::PostsController, type: :controller do

  subject { JSON.parse(response.body).fetch("answer") }

  describe "GET #index" do
    let!(:posts) { create_list(:post, 10) }
    before { get :index }

    it "returns 200 status code" do
      expect(response.status).to eq(200)
    end

    it "returns list of posts" do
      expect(subject.length).to eq(posts.length)
    end
  end

  describe "POST #create" do
    let(:post_params) do
       { post: attributes_for(:post) }
    end

    it "returns 200 status code" do
      request(post_params)
      expect(response.status).to eq(201)
    end

    it "changes post count" do
      expect { request(post_params) }.to change(Post, :count).by(1)
    end

    it "returns post" do
      request(post_params)
      expect(subject['title']).to eq(post_params[:post][:title])
    end

    def request(options = {})
      post :create, as: :json, params: options
    end
  end

  describe "GET #show" do
    let!(:post) { create(:post) }
    before { request }

    it "returns 200 status code" do
      expect(response.status).to eq(200)
    end

    it "returns post" do
      expect(subject['id'].to_i).to eq(post.id)
      expect(subject['title']).to eq(post.title)
    end

    def request
      get :show, id: post.id, as: :json
    end
  end

  describe "PUT #update" do
    let!(:post) { create(:post, title: "Yesterday's event") }
    let(:title) { "Today's news" }
    let(:post_params) do
      { post: { title: title } }
    end
    before { request }

    it "returns 200 status code" do
      expect(response.status).to eq(200)
    end

    it "update post" do
      expect(subject['title']).to eq(title)
    end

    def request
      put :update, id: post.id, as: :json, post: { title: title }
    end
  end

  describe "DELETE #destroy" do
    let!(:post) { create(:post) }

    it "returns 204 status code" do
      request
      expect(response.status).to eq(204)
    end

    it "destroy post" do
      expect { request }.to change(Post, :count).by(-1)
    end

    def request
      delete :destroy, id: post.id, as: :json
    end
  end
end

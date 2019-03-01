require "rails_helper"

RSpec.describe Admin::MoviesController, type: :controller do
  context "when current user is not admin" do
    before {get :index}

    it "should redirect to login page" do
      expect(response).to redirect_to new_user_session_path
    end

    it "should raise error" do
      expect{raise CanCan::AccessDenied}.to raise_error(
        "You are not authorized to access this page.")
    end
  end

  context "when current user is admin" do
    login_admin
    before {get :index, format: :html}

    it "should have a current_user" do
      expect(subject.current_user).not_to be_nil
    end

    describe "GET #index" do
      let(:movies){FactoryBot.create_list :movie, 2}

      it "populates an array of movies" do
        expect(assigns(:movies)).to match_array movies
      end

      it "should render the :index view" do
        expect(response).to render_template :index
      end
    end

    describe "ransack" do
      let!(:movie1){FactoryBot.create :movie, {title_vi: "Ahihi Do Ngoc"}}
      let!(:movie2){FactoryBot.create :movie, {title_vi: "Ahihi Dep Trai"}}
      let!(:movie3){FactoryBot.create :movie, {title_vi: "Ahihi Do Quy"}}
      it "should find three movies" do
        get :index, params: {q: {title_vi_cont: "Ahihi"}}
        expect(assigns(:movies)).to eq [movie1, movie2, movie3]
      end

      it "should find exactly one movie" do
        get :index, params: {q: {title_vi_cont: "Ahihi Do Ngoc"}}
        expect(assigns(:movies)).to eq [movie1]
      end
    end

    describe "DELETE #destroy" do
      let!(:movie) {create :movie}

      it "should delete the @movie" do
        expect{
          delete :destroy, params: {id: movie}
        }.to change(Movie, :count).by -1
      end

      context "when @movie is destroyed" do
        before {delete :destroy, params: {id: movie}}

        it "should redirect to movies#index" do
          expect(response).to redirect_to admin_movies_path
        end

        it "should flash success message" do
          redirect_to admin_movies_path
          expect(flash[:success]).to eq I18n.t "delete_success.movie"
        end
      end

      context "when @movie is not found" do
        before {delete :destroy, params: {id: 999}}

        it "should return to 404 page" do
          expect(response).to redirect_to page_404_path
        end

        it "should flash danger message" do
          expect(flash[:danger]).to eq I18n.t "not_found.movie"
        end
      end
    end
  end
end

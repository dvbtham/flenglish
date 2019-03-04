require "rails_helper"

RSpec.describe "users/show.html.erb", type: :view do
  let(:user){create :user}

  subject{rendered}

  before do
    assign :user, user
    render
  end

  it "should have three tabs title" do
    expect(subject).to have_css ".nav-tabs>li>a[data-toggle='tab']", count: 3
  end

  it "should have three tabs content" do
    expect(subject).to have_css ".tab-content>.tab-pane", count: 3
  end

  it "should have gravatar class" do
    expect(subject).to have_css "img", class: "gravatar"
  end

  it "should have edit button" do
    expect(subject).to have_css "a.edit-link", text: I18n.t(:edit)
  end
end

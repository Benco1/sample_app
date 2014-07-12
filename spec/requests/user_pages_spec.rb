require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit root_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('')) }
  end
end

require 'spec_helper'

describe "Micropost pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:wrong_user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "micropost creation" do
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a micropost" do
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before { fill_in "micropost_content", with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
			it { should have_content("Lorem ipsum") }
		end

		describe "pagination" do

      before do
				31.times { FactoryGirl.create(:micropost, user: user) }
				visit root_path
			end
      after  { Micropost.delete_all }

    	it { should have_selector('div.pagination') }

      it "should list each micropost" do
        	user.microposts.paginate(page: 1).each do |micropost|
          expect(page).to have_selector("li##{micropost.id}", text: micropost.content)
        end
      end
    end
	end

	describe "word wrap" do

		before do
			FactoryGirl.create(:micropost, user: user, content: "a" * 35)
			FactoryGirl.create(:micropost, user: user, content: "b" * 30)

			visit root_path
		end

		it { should_not have_content("a" * 35) }
		it { should have_content("a" * 30) }
		it { should have_content("b" * 30) }
	end

	describe "micropost destruction" do
		before do
			FactoryGirl.create(:micropost, user: user)
		end

		describe "as correct user" do
			before { visit root_path }

			it "should delete a micropost" do
				expect { click_link "delete" }.to change(Micropost, :count).by(-1)
			end
		end

		describe "as incorrect user" do
			before do
				sign_in wrong_user
				visit root_path
			end

			it "should not have a link to delete a micropost" do
				expect(page).not_to have_selector("delete")
			end
		end
	end
end
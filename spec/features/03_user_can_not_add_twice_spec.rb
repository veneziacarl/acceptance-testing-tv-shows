require 'spec_helper'

# As an organized TV fanatic
# I want to receive an error message if I try to add the same show twice
# So that I don't have duplicate entries

# Acceptance Criteria:
# [x] If the title is the same as a show that I've already added, the details are not saved to the csv
# [x] If the title is the same as a show that I've already added, I will be shown an error that says "The show has already been added".
# [x] If the details of the show are not saved, I will remain on the new form page

feature "user cannot submit duplicate titles" do
  include TelevisionTest
  scenario "user submits the same show twice" do
    visit '/television_shows/new'
    make_friends_show

    expect(page).to have_content "List of Shows"

    expect(page).to have_content "Friends (NBC)"

    visit '/television_shows/new'
    make_friends_show

    expect(page).to have_content("The show has already been added")
    expect(current_path).to eq('/television_shows/new')

    visit '/television_shows'
    expect(page.has_text?("Friends", count: 1)).to eq(true)
  end

end

require "spec_helper"

# As a TV fanatic
# I want to add one of my favorite shows
# So that I can encourage others to binge watch it
#
# Acceptance Criteria:
# []  I must provide the title, network, and starting year, genre, and synopsis
# []  The genre must be one of the following: Action, Mystery,
#     Drama, Comedy, Fantasy
# []  If any of the above criteria is left blank, the form should be
#     re-displayed with the failing validation message

feature "user adds a new TV show" do
  include TelevisionTest

  scenario "successfully add a new show" do
    visit "/television_shows/new"
    make_friends_show

    expect(page).to have_content "List of Shows"
    expect(page).to have_content "Friends (NBC)"
  end

  scenario "successfully two different shows" do
    visit "/television_shows/new"
    make_friends_show

    expect(page).to have_content "List of Shows"
    expect(page).to have_content "Friends (NBC)"

    visit "/television_shows/new"
    fill_in "Title", with: "DragonBallZ"
    fill_in "Network", with: "Cartoon Network"
    fill_in "Starting Year", with: "2000"
    fill_in "Synopsis", with: "Six friends living in DragonBallZ."
    select "Action", from: "Genre"
    click_button "Add TV Show"

    expect(page).to have_content "List of Shows"
    expect(page).to have_content "DragonBallZ (Cartoon Network)"
  end

  scenario "fails to add a show with valid information and stays on the same page" do
    visit "/television_shows/new"

    click_button "Add TV Show"

    expect(page).to have_content "Please fill in all required fields"
    expect(page).to have_content "Title"
  end
end

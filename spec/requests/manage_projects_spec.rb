require 'spec_helper'

describe 'Create a Project' do
  use_vcr_cassette

  before do
    login_google
    @user = User.first
    @user.update_attribute :nickname, 'solo'
    @user.reload

    @user2 = FactoryGirl.create :user, nickname:'chewbacca' 
  end

  it 'creates a project' do
    Project.count.should == 0

    click_link 'Create a Project'

    fill_in 'Name', with: 'projectname'
    click_button 'Save'

    Project.count.should ==1
    Project.first.name.should == 'projectname'
  end

  context 'with a project' do
    before do
      @project = FactoryGirl.create :project, name: 'han', users: [@user]
      visit url_for [:projects]
    end

    it 'shows the users projects' do
      within('.projects') do
        all('.project').length.should == 1
      end
    end

    it 'edits a project' do
      visit url_for([@project])
      click_link 'Edit Project Name'

      fill_in :name, with: 'numbfoot'
      click_button 'Save'
      current_url.should == url_for(@project)
      @project.reload
      @project.name.should == 'numbfoot'
    end
    
    it 'deletes a project' do
      Project.count.should == 1

      visit url_for([@project])

      click_link 'Delete This Project'

      current_url.should == url_for([:projects])
      Project.count.should == 0
    end

    it 'adds a user' do
      visit url_for(@project)

      page.should     have_css('.persons')
      page.should     have_css('.person')
      page.should_not have_content('chewbacca')
      click_link 'Add A User'
      fill_in :nickname, with: 'chewbacca'
      click_button 'Add User'

      page.should have_css('.person')
      page.should have_content('Chewbacca')

      @project.reload
      @project.users.should include(@user2)
      current_url.should == url_for(@project)
    end

    context 'with a user' do    
      before do
        @user2 = FactoryGirl.create :user, nickname: 'chewbacca'
        @project.users << @user2
        @project.reload

        visit url_for(@project)
      end

      it 'deletes a user' do
        @project.users.count.should == 2
        within("##{@user2.nickname}") do
          click_link 'Delete user'
        end
        
        current_url.should == url_for(@project)
        page.should_not have_content('chewbacca')

        @project.reload
        @project.users.count.should == 1
      end
    end

    it 'creates an epic' do
      Epic.count.should == 0

      visit url_for(@project)
      click_link 'Add An Epic'
      fill_in :name, with: 'EpicBattleofAwesome'
      click_button 'Save'
      
      Epic.count.should == 1

      @project.reload
      epic = @project.epics.first
      epic.name.should == 'EpicBattleofAwesome'


      current_url.should == url_for([@project, epic])
    end  


    context 'with a epic' do
      before do 
        @epic = FactoryGirl.create :epic, name: 'temp', project: @project
      end
      it 'deletes an epic' do
        Epic.count.should == 1
        visit url_for(@project)
        click_link 'Delete an Epic'
        
        current_url.should == url_for(@project)
        Epic.count.should == 0
      end    

      it 'edits an epic' do
        Epic.count.should == 1
        visit url_for(@project)
        click_link 'Edit an Epic'
        
        current_url.should == url_for([:edit, @project, @epic])
        
        fill_in :name, with: 'fitslikeaglove'
        click_button 'Save'
        current_url.should == url_for(@project)

        @project.reload
        @epic = @project.epics.first
        @epic.name.should == 'fitslikeaglove'
      end

      it 'views an epic' do
        epic = @project.epics.first

        visit url_for([@project])
        page.should have_content(epic.name)
      end

      it 'creates a story' do
        Story.count.should == 0
        visit url_for([@project, @epic])
        click_link 'Create a Task'
        fill_in 'Name', with: 'wachutu'
        fill_in 'Description', with: 'thealbinobatfromaceventura'
        click_button 'Save'
        
        Story.count.should == 1

        @epic.reload
        story = @epic.stories.first
        story.name.should == 'wachutu'
        story.description.should == 'thealbinobatfromaceventura'

        current_url.should == url_for([@project, @epic])
        page.should have_content(story.name)
      end

      context 'with a story' do
        before do 
          @story = FactoryGirl.create :story, name: 'temp', description: 'relaxinginthesun', points: 3, epic: @epic
        end

        it 'deletes a story' do
          Story.count.should == 1
          visit url_for([@project, @epic])
          click_link 'Delete a Story'
        
          current_url.should == url_for([@project, @epic])
          Story.count.should == 0
        end

        it 'edits a story' do
          Story.count.should == 1
          visit url_for([@project, @epic])
          click_link 'Edit a Story'
          
          current_url.should == url_for([:edit, @project, @epic, @story])
          fill_in 'Name', with: 'fitslikeaglove'
          fill_in 'Description', with: 'monopolyman'
          click_button 'Save'
          current_url.should == url_for([@project, @epic])
          
          @epic.reload
          @story = @epic.stories.first
          @story.name.should == 'fitslikeaglove'
          @story.description.should == 'monopolyman'
        end

        it 'adds points to a story' do
          Story.count.should == 1
          visit url_for([:edit, @project, @epic, @story])
          current_url.should == url_for([:edit, @project, @epic, @story])

          page.should have_content('Points')
          
          select '3', from: 'Points'
          click_button 'Save'

          current_url.should == url_for([@project, @epic])

          @epic.reload
          @story = @epic.stories.first
          @story.points.should == 3
        end

        
        it 'shows the projects point' do
          @story = @project.epics.first.stories.first
          Project.count.should == 1
          Story.count.should == 1
          @story.points.should == 3
          @story.status = 'completed'
          @story.save!
          @story.reload

          visit url_for(@project)
          page.should have_content('Points')
          page.should have_content('3')
        end
      end
    end
  end
end

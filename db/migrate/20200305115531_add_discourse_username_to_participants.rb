class AddDiscourseUsernameToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :discourse_username, :string
  end
end

class AddFieldsToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :topic, :string
    add_column :tweets, :text, :text
    add_column :tweets, :liked, :boolean
    add_column :tweets, :replied, :boolean
    add_column :tweets, :retweeted, :boolean
    add_column :tweets, :user_name, :string
    add_column :tweets, :user_location, :string
    add_column :tweets, :profile_link, :string
  end
end

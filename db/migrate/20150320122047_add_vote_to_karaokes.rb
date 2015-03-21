class AddVoteToKaraokes < ActiveRecord::Migration
  def change
    add_column :karaokes, :vote, :boolean, default: false
  end
end

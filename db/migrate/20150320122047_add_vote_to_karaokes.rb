class AddVoteToKaraokes < ActiveRecord::Migration
  def change
    add_column :karaokes, :vote, :bool, default: false
  end
end

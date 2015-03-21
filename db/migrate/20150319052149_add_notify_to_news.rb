class AddNotifyToNews < ActiveRecord::Migration
  def change
    add_column :news, :notify, :boolean
  end
end

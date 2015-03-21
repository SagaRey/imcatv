class AddNotifyToNews < ActiveRecord::Migration
  def change
    add_column :news, :notify, :bool
  end
end

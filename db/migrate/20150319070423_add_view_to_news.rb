class AddViewToNews < ActiveRecord::Migration
  def change
    add_column :news, :view, :integer, default: 0
  end
end

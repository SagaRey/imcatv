class AddViewToNews < ActiveRecord::Migration
  def change
    add_column :news, :view, :int, default: 0
  end
end

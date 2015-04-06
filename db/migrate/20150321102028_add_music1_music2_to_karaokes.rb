class AddMusic1Music2ToKaraokes < ActiveRecord::Migration
  def change
    add_column :karaokes, :music1, :string
    add_column :karaokes, :music2, :string
  end
end

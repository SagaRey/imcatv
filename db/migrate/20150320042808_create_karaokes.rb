class CreateKaraokes < ActiveRecord::Migration
  def change
    create_table :karaokes do |t|
      t.string :actor
      t.string :introduction
      t.string :picture
      t.string :video1
      t.string :video2
      t.integer :ballot1, default: 0

      t.timestamps null: false
    end
  end
end

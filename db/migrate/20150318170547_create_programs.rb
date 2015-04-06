class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :datatime
      t.string :content

      t.timestamps null: false
    end
  end
end

class CreateSurvivors < ActiveRecord::Migration[5.2]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age, default: 0
      t.integer :gender
      t.float :latitude
      t.float :longitude
      t.boolean :infected, default: false

      t.integer :water, default: 0
      t.integer :food, default: 0
      t.integer :medication, default: 0
      t.integer :ammunition, default: 0

      t.timestamps
    end
  end
end

class CreateInfectionMarks < ActiveRecord::Migration[5.2]
  def change
    create_table :infection_marks do |t|
      t.references :from, index: true, foreign_key: { to_table: :survivors }
      t.references :to, index: true, foreign_key: { to_table: :survivors }

      t.timestamps
    end
  end
end

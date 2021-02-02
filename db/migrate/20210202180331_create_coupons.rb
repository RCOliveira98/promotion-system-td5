class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.references :promotion, null: false, foreign_key: true

      t.timestamps
    end
    add_index :coupons, :code, unique: true
  end
end

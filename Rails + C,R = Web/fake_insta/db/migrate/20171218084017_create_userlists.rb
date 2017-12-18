class CreateUserlists < ActiveRecord::Migration
  def change
    create_table :userlists do |t|

      t.string :email
      t.string :password

      t.timestamps null: false
    end
  end
end

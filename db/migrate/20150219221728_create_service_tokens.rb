class CreateServiceTokens < ActiveRecord::Migration
  def change
    create_table :service_tokens do |t|
      t.string :name
      t.string :token
      t.uuid :user_id

      t.timestamps null: false
    end
  end
end

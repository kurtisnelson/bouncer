class DeleteServiceTokens < ActiveRecord::Migration
  def change
    drop_table :service_tokens
  end
end

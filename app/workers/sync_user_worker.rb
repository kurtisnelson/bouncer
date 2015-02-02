class SyncUserWorker
  include Sidekiq::Worker

  def perform user_id
    user = User.find user_id
    user.sync_details
  end
end

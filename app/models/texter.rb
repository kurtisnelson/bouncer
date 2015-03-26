class Texter

  def self.confirmation user_id
    user = User.find(user_id)
    Texter.new.confirmation user
  end

  def confirmation user
    logger.warn "unimplemented"
  end
end

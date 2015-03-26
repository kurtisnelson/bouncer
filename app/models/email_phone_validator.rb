class EmailPhoneValidator < ActiveModel::Validator
  def validate(record)
    if record.phone.nil? && record.email.nil?
      record.errors[:base] << "must have phone or email"
    end
  end
end

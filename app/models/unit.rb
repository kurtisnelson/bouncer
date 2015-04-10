class Unit < ActiveRecord::Base
  belongs_to :activator, class_name: 'User'
  validates_uniqueness_of :serial
  has_one :activation

  def activate device_id
    create_activation(device_id: device_id)
  end

  def deactivate
    Activation.where(unit_id: self.id).destroy_all
  end
end

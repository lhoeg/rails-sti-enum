class Animal < ApplicationRecord
  before_create :set_type
  enum type: ['Animal::Cat', 'Animal::Dog']

  private

  def set_type
    self.type = self.class.name
  end
end

class Animal < ApplicationRecord
  before_create :set_type
  enum type: { 'Animal::Cat' => 0, 'Animal::Dog' => 1 }

  private

  def set_type
    self.type = self.class.name
  end
end

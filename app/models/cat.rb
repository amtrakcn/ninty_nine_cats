class Cat < ActiveRecord::Base
  attr_accessible :age, :birth_date, :color, :name, :sex

  validates :age, :birth_date, :color, :name, :sex, :presence => true
  validates :color, inclusion: { in: ["black","white","brown","grey"] }
  validates :sex, inclusion: { in: ["m","f"] }

  has_many(
    :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: "cat_id",
    primary_key: "id",
    :dependent => :destroy
  )
end

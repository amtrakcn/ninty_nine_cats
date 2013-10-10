class CatRentalRequest < ActiveRecord::Base
  attr_accessible :cat_id, :start_date, :end_date, :status

  before_validation :status_check, on: :create
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: ["pending","approved","denied"] }
  validate :overlapping_approved_requests

  belongs_to(
    :cat,
    class_name: "Cat",
    foreign_key: "cat_id",
    primary_key: "id"
  )

  def status_check
    self.status ||= "pending"
  end

  def pending?
    self.status == "pending"
  end

  def overlapping_requests
    overlapping = []
    requests = self.class.all << self
    requests.uniq!
    requests.each_with_index do |request, index|
      reqs = requests[(index + 1)..-1]
      reqs.each do |request2|
        if (request2.start_date > request.start_date && request2.start_date < request.end_date) ||
          (request2.end_date > request.start_date && request2.end_date < request.end_date)
          overlapping << [request, request2]
        end
      end
    end
    overlapping
  end

  def overlapping_approved_requests
    if overlapping_requests.any? { |request1, request2| request1.status == "approved" && request2.status == "approved" }
      errors.add(:base, "Request overlaps with another approved request!")
    end
  end

  def self.requests_for_cat_id(cat_id)
    find_all_by_cat_id(cat_id)
  end

  def approve!
    self.status = "approved"
    requests_to_deny = []
    overlapping = overlapping_requests
    overlapping.each do |request1, request2|
      if request1 == self
        requests_to_deny << request2
      elsif request2 == self
        requests_to_deny << request1
      end
    end
    self.class.transaction do
      requests_to_deny.each { |request| request.deny! }
      self.save!
    end
  end

  def deny!
    self.status = "denied"
    save!
  end
end

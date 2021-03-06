class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  before_create :user_host_on
  after_destroy :user_host_off

  def average_review_rating
    self.reviews.average(:rating)
  end

  private

  def user_host_on
    self.host.update(host: true)
  end

  def user_host_off
    if self.host.listings.empty?
      self.host.update(host: false)
    end
  end
end

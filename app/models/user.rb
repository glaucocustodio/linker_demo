class User < ActiveRecord::Base
  belongs_to :company, dependent: :destroy
  belongs_to :my_family, class_name: 'Family', dependent: :destroy

  has_one :address, dependent: :destroy
  has_one :profile

  has_many :dependent_users, -> { order(id: :asc) }, dependent: :destroy
  has_many :tasks, -> { order(id: :asc) }, dependent: :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end

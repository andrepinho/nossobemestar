class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :name
  has_many :events
  has_many :services
  belongs_to :region

  include PgSearch
  pg_search_scope :search, against: [
      [:name, 'A'],
      [:surname, 'A'],
      [:email, 'B']
    ],
    using: {tsearch: {dictionary: "portuguese"}},
    ignoring: :accents

  def full_name
    "#{self.name} #{self.surname}".strip
  end

end

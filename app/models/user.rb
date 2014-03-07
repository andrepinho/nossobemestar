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

  def region_name
    self.region.name if self.region
  end

  def self.to_csv
    columns = ["id", "name", "surname", "email", "region_id", "region_name", "admin", "region_admin", "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip"]
    CSV.generate do |csv|
      csv << columns
      all.each do |row|
        csv << columns.map { |column| row.send(column) }
      end
    end
  end

end

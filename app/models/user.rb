class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  validates_presence_of :name
  validates_uniqueness_of :email
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

  def self.find_for_facebook_oauth(auth)
    unless user = find_by(provider: auth.provider, uid: auth.uid)
      user = where(email: auth.info.email).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.first_name
        user.surname = auth.info.last_name
      end
    end
    user
  end

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

require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  has_many :reactions, :foreign_key => "created_by", :dependent => :destroy
  has_many :definition_versions, :foreign_key => "updated_by", :dependent => :destroy

  ADMINS = [
    "aliekens",
    "haloewie",
    "Grytolle",
    "de Bon",
    "LimoWreck",
    "Georges Grootjans",
    "fansy",
    "Marcus",
    "petrik",
    "LeGrognard",
    "nathans"
  ].freeze

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by(login: login)
    return nil if u.nil?
    return nil unless u.authenticated?(password)

    u
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me!
    update_columns(remember_token_expires_at: 2.weeks.from_now.utc,
                   remember_token: SecureRandom.uuid)
  end

  def forget_me!
    update_columns(remember_token_expires_at: nil, remember_token: nil)
  end

  def inbox_size
    if @inbox_size
      @inbox_size
    else
      @inbox_size = Message.where(to_user: self.id, read: false).count
    end
  end

  def admin?
    login.in?(ADMINS)
  end

  protected

  # before filter
  def encrypt_password
    return if password.blank?

    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end
end

class Person < ActiveRecord::Base
  has_many :assignments
  has_many :departments, through: :assignments
  has_many :issues, dependent: :nullify

  validates_presence_of :forename
  validates_presence_of :surname
  validates_presence_of :password, on: :create
  validates_presence_of :password, on: :update, if: :password_present?
  validates_confirmation_of :password, on: :update, if: :password_present?
  validates_format_of :email, :with => /@/
  validates_presence_of :email
  validates_uniqueness_of :email

  before_save :encrypt_password, if: :password_present?

  scope :ordered, -> { order(:surname) }
  scope :fullordered, -> { order(:forename) }
  scope :managers, -> { where(manager: true) }
  scope :active, -> { where(is_active: true) }
  scope :scoreboard, -> { where(show_on_scoreboard: true) }
  scope :ordered_is_active_desc, -> { order(:is_active => :desc) }

  accepts_nested_attributes_for :assignments, :reject_if => :new_record?, :allow_destroy => true

  attr_accessor :password

  def abbr_name
    [forename, surname.first].compact.join(' ') + '.'
  end

  def full_name
    [forename, surname].compact.join(' ')
  end

  def resend_notification
    Notifications.delay.confirmation_email(guid)
  end

  private

  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt unless BCrypt::Engine.valid_salt? password_salt
    self.password_digest = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def password_present?
    !password.blank?
  end
end

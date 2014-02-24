class Quote < ActiveRecord::Base
  belongs_to :client
  has_many :supplier_quotes
  belongs_to :issue

  scope :ordered, -> { order(:created_at) }
  scope :active, -> { where.not(status: 'complete') }

  validates_presence_of :email
  validates_presence_of :requirements

  accepts_nested_attributes_for :supplier_quotes, reject_if: :new_record?, allow_destroy: true

  before_save :encrypt_password, if: :password_present?

  attr_accessor :password

  state_machine :status, :initial => :new do
    event :send_for_approval do
      transition all => :sent_for_approval
    end

    event :approve do
      transition all => :approved
    end

    event :send_for_client_approval do
      transition all => :sent_for_client_approval
    end

    event :client_approve do
      transition all => :client_approved
    end

    event :receive_goods do
      transition all => :goods_received
    end

    event :receive_payment do
      transition all => :payment_received
    end

    event :send_payment do
      transition all => :payment_sent
    end

    event :complete do
      transition all => :completed
    end
  end

  def value
    supplier_quotes.map { |s| s.unit_price.nil? ? 0 : s.unit_price * s.qty }.reduce(:+)
  end

  def sale
    supplier_quotes.map { |s| s.sale_price.nil? ? 0 : s.sale_price * s.qty }.reduce(:+)
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

class PasswordAuthenticator
  def initialize(person)
    @person = person
  end

  def authenticate(password)
    bcrypt_password(password) == @person.password_digest
  end

private

  def bcrypt_password(password)
    BCrypt::Engine.hash_secret(password, @person.password_salt)
  end
end

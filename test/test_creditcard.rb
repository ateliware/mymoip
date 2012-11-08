require 'helper'

class TestCreditCard < Test::Unit::TestCase
  def test_initialization_and_setters
    subject = MyMoip::CreditCard.new(
      logo: :visa,
      card_number: "4916654211627608",
      expiration_date: "06/15",
      security_code: "000",
      owner_name: "Juquinha da Rocha",
      owner_birthday: Date.new(1984, 11, 3),
      owner_phone: "5130405060",
      owner_rg: "1010202030"
    )

    assert_equal :visa, subject.logo
    assert_equal "4916654211627608", subject.card_number
    assert_equal "06/15", subject.expiration_date
    assert_equal "000", subject.security_code
    assert_equal "Juquinha da Rocha", subject.owner_name
    assert_equal Date.new(1984, 11, 3), subject.owner_birthday
    assert_equal "5130405060", subject.owner_phone
    assert_equal "1010202030", subject.owner_rg
  end

  def test_validate_presence_of_logo_attribute
    subject = Fixture.credit_card
    subject.logo = nil
    assert subject.invalid? && subject.errors[:logo].present?,
      'should be invalid without a logo'
  end

  def test_owner_birthday_accepts_string_version_of_dates
    subject = Fixture.credit_card
    subject.owner_birthday = '20/12/1980'
    assert_equal Date.new(1980, 12, 20), subject.owner_birthday
  end

  def test_validate_presence_of_security_code_attribute
    subject = Fixture.credit_card
    subject.security_code = nil
    assert subject.invalid? && subject.errors[:security_code].present?,
      'should be invalid without an security_code'
  end

  def test_validate_length_of_owner_phone_attribute_in_10_or_11_chars
    subject = Fixture.credit_card
    subject.owner_phone = '5130405060'
    assert subject.valid?, 'should accept 10 chars'
    subject.owner_phone = '51930405060'
    assert subject.valid?, 'should accept 11 chars'
    subject.owner_phone = '215130405060'
    assert subject.invalid? && subject.errors[:owner_phone].present?,
      'should not accept strings with other than 10 or 11 chars'
  end

  def test_remove_left_zeros_from_owner_phone
    subject = Fixture.credit_card
    subject.owner_phone = '05130405060'
    assert_equal '5130405060', subject.owner_phone
  end

  def test_remove_dashes_from_owner_phone
    subject = Fixture.credit_card
    subject.owner_phone = '513040-5060'
    assert_equal '5130405060', subject.owner_phone
    subject.owner_phone = '5193040-5060'
    assert_equal '51930405060', subject.owner_phone
  end

  def test_remove_parenthesis_from_owner_phone
    subject = Fixture.credit_card
    subject.owner_phone = '(51)30405060'
    assert_equal '5130405060', subject.owner_phone
    subject.owner_phone = '(51)930405060'
    assert_equal '51930405060', subject.owner_phone
  end

  def test_remove_dashes_from_owner_rg
    subject = Fixture.credit_card
    subject.owner_rg = '91122534-1'
    assert_equal '911225341', subject.owner_rg
  end

  def test_remove_dots_from_owner_rg
    subject = Fixture.credit_card
    subject.owner_rg = '91.122.5341'
    assert_equal '911225341', subject.owner_rg
  end
end

require_relative '../test_helper'

class TestTransparentRequest < Test::Unit::TestCase
  def test_last_payment_with_hash
    result = MyMoip::InstructionRequest.last_payment({io: 'ia'})
    assert_equal({io: 'ia'}, result)
  end

  def test_last_payment_with_array
    result = MyMoip::InstructionRequest.last_payment([
      {
        "Id" => 1,
        "Data" => "2016-10-10 10:10:10"
      },
      {
        "Id" => 2,
        "Data" => "2016-11-10 10:10:10"
      }
    ])
    assert_equal({"Id" => 2, "Data" => "2016-11-10 10:10:10"}, result)
  end
end


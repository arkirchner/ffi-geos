
$: << File.dirname(__FILE__)
require 'test_helper'

class WkbWriterTests < Test::Unit::TestCase
  include TestHelper

  def setup
    @wkb_writer = Geos::WkbWriter.new
    @writer = Geos::WktWriter.new
    @reader = Geos::WktReader.new
  end

  def wkb_tester(expected, g, dimensions, byte_order, srid, include_srid)
    geom = read(g)
    geom.srid = srid

    @wkb_writer.output_dimensions = dimensions
    @wkb_writer.byte_order = byte_order
    @wkb_writer.include_srid = include_srid

    assert_equal(expected, @wkb_writer.write_hex(geom))
  end

  def test_2d_little_endian
    wkb_tester(
      '010100000000000000000018400000000000001C40',
      'POINT(6 7)',
      2,
      1,
      43,
      false
    )
  end

  def test_2d_little_endian_with_srid
    wkb_tester(
      '01010000202B00000000000000000018400000000000001C40',
      'POINT(6 7)',
      2,
      1,
      43,
      true
    )
  end

  def test_2d_big_endian
    wkb_tester(
      '00000000014018000000000000401C000000000000',
      'POINT(6 7)',
      2,
      0,
      43,
      false
    )
  end

  def test_2d_big_endian_with_srid
    wkb_tester(
      '00200000010000002B4018000000000000401C000000000000',
      'POINT(6 7)',
      2,
      0,
      43,
      true
    )
  end

  def test_3d_little_endian_with_2d_output
    wkb_tester(
      '010100000000000000000018400000000000001C40',
      'POINT(6 7)',
      3,
      1,
      43,
      false
    )
  end

  def test_3d_little_endian__with_2d_output_with_srid
    wkb_tester(
      '01010000202B00000000000000000018400000000000001C40',
      'POINT(6 7)',
      3,
      1,
      43,
      true
    )
  end

  def test_3d_big_endian_with_2d_input
    wkb_tester(
      '00000000014018000000000000401C000000000000',
      'POINT(6 7)',
      3,
      0,
      43,
      false
    )
  end

  def test_3d_big_endian_with_2d_input_with_srid
    wkb_tester(
      '00200000010000002B4018000000000000401C000000000000',
      'POINT(6 7)',
      3,
      0,
      43,
      true
    )
  end



  def test_2d_little_endian_with_3d_input
    wkb_tester(
      '010100000000000000000018400000000000001C40',
      'POINT(6 7 8)',
      2,
      1,
      53,
      false
    )
  end

  def test_2d_little_endian_with_3d_input_with_srid
    wkb_tester(
      '01010000203500000000000000000018400000000000001C40',
      'POINT(6 7 8)',
      2,
      1,
      53,
      true
    )
  end



  def test_2d_big_endian_with_3d_input
    wkb_tester(
      '00000000014018000000000000401C000000000000',
      'POINT(6 7 8)',
      2,
      0,
      53,
      false
    )
  end

  def test_2d_big_endian_with_3d_input_with_srid
    wkb_tester(
      '0020000001000000354018000000000000401C000000000000',
      'POINT(6 7 8)',
      2,
      0,
      53,
      true
    )
  end

  def test_3d_little_endian_with_3d_input
    wkb_tester(
      '010100008000000000000018400000000000001C400000000000002040',
      'POINT(6 7 8)',
      3,
      1,
      53,
      false
    )
  end

  def test_3d_big_endian_with_3d_input
    wkb_tester(
      '00800000014018000000000000401C0000000000004020000000000000',
      'POINT(6 7 8)',
      3,
      0,
      53,
      false
    )
  end

  def test_3d_big_endian_with_3d_input_with_srid
    wkb_tester(
      '00A0000001000000354018000000000000401C0000000000004020000000000000',
      'POINT(6 7 8)',
      3,
      0,
      53,
      true
    )
  end

  def tester_try_bad_byte_order_value
    # raise on anything that's not a Fixnum
    assert_raise(TypeError) do
      wkb_tester(
    '010100008000000000000018400000000000001C400000000000002040',
    'POINT(6 7 8)',
    3,
    'gibberish',
    53,
    false
      )
    end

    # any Fixnums seem okay; anything other than 0 or 1 is set to 1.
    wkb_tester(
      '010100008000000000000018400000000000001C400000000000002040',
      'POINT(6 7 8)',
      3,
      1000,
      53,
      false
    )
  end
end

require "rtree"
require "minitest/unit"
require "minitest/autorun"
require 'minitest/pride'
require 'minitest/reporters'

MiniTest::Reporters.use!
ENV["RAILS_ENV"] = "test"

require 'rails_helper'

RSpec.describe Category, type: :model do
  #! have_timestamps
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }
  #! Field Matchers
  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:description).of_type(String) }
  #! Association Matchers
  it { is_expected.to have_many :tasks }
  #! Validation Matchers
  #* Presense
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  #* Uniqueness
  it { is_expected.to validate_uniqueness_of(:name) }
end

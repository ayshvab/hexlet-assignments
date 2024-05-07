# frozen_string_literal: true

require_relative 'model'
require 'date'

class User
  include Model

  attribute :name, type: :string, default: 'Andrey'
  attribute :birthday, type: :datetime
  attribute :active, type: :boolean, default: false
end

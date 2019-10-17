class MigrationMapping < ApplicationRecord
  belongs_to :source, polymorphic: true
end

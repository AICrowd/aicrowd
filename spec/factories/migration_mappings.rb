FactoryBot.define do
  factory :migration_mapping do
    association :source, factory: :submission
    source_type { Submission }
    source_id { 1 }
    crowdai_participant_id { 1 }
  end
end

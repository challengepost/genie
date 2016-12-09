FactoryGirl.define do
  factory :job do
    title "Senior Dev"
    dev_type 1
    deleted false
    state "published_privately"

    factory :draft_job do
      state "draft"
    end
  end
end

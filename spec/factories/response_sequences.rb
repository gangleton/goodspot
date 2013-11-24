# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response_sequence do
    phone_number_id 1
    outgoings ""
    incomings ""
  end
end

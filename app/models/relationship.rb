class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # as of Rails 5 the following are not required - the tests would still pass
  # without them - but are included for completeness. See tutorial ch 14.1.3
  # Exercise 1.
  validates  :follower_id, presence: true
  validates  :followed_id, presence: true
end
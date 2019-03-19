class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, id_presence:true
   
end

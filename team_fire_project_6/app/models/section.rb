class Section < ApplicationRecord

    has_many :section_users
    has_many :users, through: :section_users

end

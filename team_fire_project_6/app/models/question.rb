class Question < ApplicationRecord

    has_many :evaluation_questions
    has_many :evaluations, through: :evaluation_questions

end

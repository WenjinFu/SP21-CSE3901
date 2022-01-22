class Evaluation < ApplicationRecord

    has_many :evaluation_questions
    has_many :questions, through: :evaluation_questions

end

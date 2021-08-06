class Course < ApplicationRecord
  belongs_to :mountain

  enum level: { easy: 0, normal: 1, hard: 2 }
end

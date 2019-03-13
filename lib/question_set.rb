class QuestionSet
  attr_accessor :dataset

  # Initialize the question set with full dataset.
  def initialize(dataset="#{Rails.root}/lib/data/questions.yml")
    self.dataset = YAML.load_file(dataset).deep_symbolize_keys
  end

  def choose(total, percentages)
    check_percentages(percentages)

    easy_questions = choose_easy_questions(total.percent_of(percentages[:easy]))
    medium_questions = choose_medium_questions(total.percent_of(percentages[:medium]))
    hard_questions = choose_hard_questions(total.percent_of(percentages[:hard]))

    {questions: { easy: easy_questions, medium: medium_questions, hard: hard_questions}}
  end

  def choose_easy_questions(threshold_score)
    questions = self.dataset[:questions][:easy]
    filter_by_percentage(questions, threshold_score)
  end

  def choose_medium_questions(threshold_score)
    questions = self.dataset[:questions][:medium]
    filter_by_percentage(questions, threshold_score)
  end

  def choose_hard_questions(threshold_score)
    questions = self.dataset[:questions][:hard]
    filter_by_percentage(questions, threshold_score)
  end

  def check_percentages(percentages)
    if percentages.values.map.sum != 100
      raise ArgumentError.new("Total doesn't matches the percentages")
    end
  end

  def can_be_filtered(questions, total_questions_size, threshold_score)

    if threshold_score == 0
      return true
    end

    if total_questions_size == 0 and threshold_score != 0
      return false
    end

    if questions[total_questions_size - 1][:score] > threshold_score
      return can_be_filtered(questions, total_questions_size - 1, threshold_score)
    end

    can_be_filtered(questions, total_questions_size - 1, threshold_score) or can_be_filtered(questions, total_questions_size - 1, threshold_score - questions[total_questions_size-1][:score])

  end

  def filter_by_percentage(questions, threshold_score)
    total_questions_size = questions.size
    can_be_filtered(questions, total_questions_size, threshold_score)
  end


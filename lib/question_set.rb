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

  def can_be_filtered(questions, current_index, threshold_score, table)
    if current_index >= questions.size
      return 1 if threshold_score == 0
      return 0
    end

    unless table.key?("#{current_index}_#{threshold_score}")
      count = can_be_filtered(questions, current_index + 1, threshold_score, table)
      count += can_be_filtered(questions, current_index + 1, threshold_score - questions[current_index][:score], table)

      table["#{current_index}_#{threshold_score}"] = count
    end

    return table["#{current_index}_#{threshold_score}"]
  end

  def execute_filter(questions, sum, table)
    filtered_questions = []

    questions.each_with_index do |question, index|
      if can_be_filtered(questions, index + 1, sum - question[:score], {}) > 0
        filtered_questions.append(question)
        sum -= question[:score]
      end
    end
    return filtered_questions
  end


  def filter_by_percentage(questions, threshold_score)
    questions = questions.shuffle
    total_questions_size = questions.size
    if can_be_filtered(questions, 0, threshold_score, {}) > 0
      return execute_filter(questions, threshold_score, {})
    else
      raise StandardError.new("Cannot generate questions with the given requirements.")
    end
  end

end


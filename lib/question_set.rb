class QuestionSet
  attr_accessor :dataset

  # Initialize the question set with full dataset.
  def initialize(dataset="#{Rails.root}/lib/data/questions.yml")
    self.dataset = YAML.load_file(dataset)
  end

  def choose(total, percentages)
    check_percentages_equals_total(total, percentages)

    easy_questions = choose_easy_questions(percentages[:easy].percent_of(total))
    medium_questions = choose_medium_questions(percentages[:medium].percent_of(total))
    hard_questions = choose_hard_questions(percentages[:hard].percent_of(total))

    {questions: { easy: easy_questions, medium: medium_questions, hard: hard_questions}}
  end

  def choose_easy_questions(threshold_score)
    questions = self.dataset["questions"]["easy"]
    filter_by_percentage(questions, threshold_score)
  end

  def choose_medium_questions(threshold_score)
    questions = self.dataset["questions"]["medium"]
    filter_by_percentage(questions, threshold_score)
  end

  def choose_hard_questions(threshold_score)
    questions = self.dataset["questions"]["hard"]
    filter_by_percentage(questions, threshold_score)
  end

  def check_percentages_equals_total(total, percentages)
    # if total != percentages.map { |x| x[:score] }.sum 
      # raise ArgumentError, "Total doesn't matches the percentages"
    # end
  end

  def filter_by_percentage(questions, threshold_score)
    return [] if questions.empty?
    filtered_questions = []
    current_threshold = questions[0]["score"]
    start_index = 0
    current_question_index = 1
    total_questions_size = questions.size

    while(current_question_index <= total_questions_size) do 

      while (current_threshold > threshold_score) and ( start_index < i - 1) do 
        current_threshold -= questions[start_index]["score"]
        filtered_questions.pop
        start_index += 1
      end

      if current_threshold == threshold_score
        return filtered_questions
      end

      if current_question_index < total_questions_size
        current_threshold += questions[current_question_index]["score"]
        filtered_questions.append(questions[current_question_index])
      end
    end
     []
  end
end
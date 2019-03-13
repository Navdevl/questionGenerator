class QuestionSet
  attr_accessor :dataset

  # Initialize the question set with full dataset.
  def initialize(dataset="#{Rails.root}/lib/data/questions.yml")
    self.dataset = YAML.load_file(dataset).deep_symbolize_keys
  end

  def choose(total, percentages)
    check_percentages_equals_total(total, percentages)

    easy_questions = choose_easy_questions(percentages[:easy].percent_of(total))
    medium_questions = choose_medium_questions(percentages[:medium].percent_of(total))
    hard_questions = choose_hard_questions(percentages[:hard].percent_of(total))

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

  def check_percentages_equals_total(total, percentages)
    if total != percentages.values.sum
      raise ArgumentError.new("Total doesn't matches the percentages")
    end
  end

  def filter_by_percentage(questions, threshold_score)
    # if questions.empty?
    #   return []
    # end

    if questions.empty?
      raise StandardError.new("Insufficient data to process.")
    end

    # This shuffling is added to produce different and correct results for same values.
    questions = questions.shuffle
    filtered_questions = [questions[0]]
    current_threshold = questions[0][:score]
    start_index = 0
    current_question_index = 1
    total_questions_size = questions.size

    while(current_question_index <= total_questions_size) do 

      while (current_threshold > threshold_score) and ( start_index < current_question_index - 1 ) do 
        # current_threshold -= questions[start_index][:score]
        shifted_question = filtered_questions.shift
        current_threshold -= shifted_question[:score]
        start_index += 1
      end

      if current_threshold == threshold_score
        puts "#{threshold_score} ** #{current_threshold}"
        return filtered_questions
      end

      if current_question_index < total_questions_size
        puts "#{current_question_index} appending"
        current_threshold += questions[current_question_index][:score]
        filtered_questions.append(questions[current_question_index])
      end
      current_question_index += 1
      puts "#{threshold_score} ** #{current_threshold}"
    end
    
    raise StandardError.new("Cannot meet the requirements for the given values. Please try again with new values.")
  end
end
class QuestionsController < ApplicationController

  def index
    question_set = QuestionSet.new
    render json: {success: true, data: question_set.dataset }
  end

  def choose
    question_set = QuestionSet.new
    begin
      questions = question_set.choose(100, {easy: 40, medium: 48, hard: 12})
      render json: {success: true, data: questions }
    rescue Exception => e
      render json: {success: false, error: e}
    end
  end
end

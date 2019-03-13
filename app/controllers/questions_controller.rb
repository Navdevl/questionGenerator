class QuestionsController < ApplicationController

  def index
    question_set = QuestionSet.new
    render json: question_set.dataset
  end

  def choose
    question_set = QuestionSet.new
    questions = question_set.choose(100, {easy: 20, medium: 40, hard: 40})
    render json: questions
  end
end

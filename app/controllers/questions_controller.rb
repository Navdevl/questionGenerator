class QuestionsController < ApplicationController

  def index
    question_set = QuestionSet.new
    render json: {success: true, data: question_set.dataset }
  end

  def generate
    question_set = QuestionSet.new
    begin
      questions = question_set.generate(qgen_params[:total], qgen_params[:percentages])
      render json: {success: true, data: questions }
    rescue Exception => e
      render json: {success: false, error: e}
    end
  end

  private
  def qgen_params
    params.require(:question).permit(:total, percentages: {})
  end
end

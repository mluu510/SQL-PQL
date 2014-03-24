class StaticPagesController < ApplicationController
  def index
  end

  def lesson
    filename = "lesson_#{params[:id].to_i.to_words}.yaml"
    filepath = Rails.root.to_s + "/app/assets/lessons/#{filename}"
    lesson = YAML.load_file(filepath)

    @title = lesson[:title]
    @sections = lesson[:sections]
    @next_lesson = lesson[:next_lesson]

    if params[:id] == '0'
      render :lesson_zero
    else
      render :lesson_view
    end
  end

end
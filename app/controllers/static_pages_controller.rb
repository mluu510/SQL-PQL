require 'yaml'
class StaticPagesController < ApplicationController

  class SQLView
    attr_accessor :id, :title, :content, :query, :answer
  end


  def index
  end

  def lesson
    filename = "lesson_#{params[:id].to_i.to_words}.yaml"
    filepath = Rails.root.to_s + "/app/assets/lessons/#{filename}"
    lesson = YAML.load_file(filepath)

    @title = lesson[:title]
    @sections = lesson[:sections]

    render :lesson_view
    end

end
class SqlController < ApplicationController
  def run
    query = params['query'];


    db = SQLite3::Database.open('app/controllers/world.db')
    results = db.execute2(query)
    puts "RESULTS: #{results}"
    render :json => results
  end



end

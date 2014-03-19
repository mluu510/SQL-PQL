class SqlController < ApplicationController
  def run
    query = params['query'];


    db = PG::Connection.open(:dbname => 'sql_pql_development')
    pg_results = db.exec_params(query)
    render :json => {fields: pg_results.fields, rows:pg_results.values}
  end



end

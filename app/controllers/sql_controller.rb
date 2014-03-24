
class SqlController < ApplicationController
	def run
    # sleep 1
		query = params['query']
		answer = params['answer']

		blacklist = %w(DROP INSERT UPDATE CREATE ALTER DELETE)

		blacklist.each do |word|
			if query.upcase.include?(word) || answer.upcase.include?(word)
				return render :json => {status: "\"#{word}\" is blacklisted!"}
			end
		end

		pg_result = nil
    config = Rails.configuration.database_configuration[Rails.env]
    database = config['database']
    host = config['host']
    port = config['port']
    user = config['username']
    password = config['password']

		db = PG::Connection.open(host: host, port: port, dbname: database, user: user, password: password)

		begin
			pg_result = db.exec_params(query)

		rescue PGError => e
			puts "///////////////////////ERROR: #{e}"
      db.close
			return render :json => {error: e.message}

		end


		if answer.empty?
			render :json => {fields: pg_result.fields, rows:pg_result.values}
		else
			pg_answer = db.exec_params(answer)
			status = compare_results(pg_result, pg_answer)
			render :json => {fields: pg_result.fields, rows:pg_result.values, status: status}
		end
    db.close
	end

	def compare_results(result, answer)
		if result.ntuples < answer.ntuples
			return 'Result has too few rows'
		elsif result.ntuples > answer.ntuples
			return 'Result has too many rows'
		elsif result.nfields < answer.nfields
			return 'Result has too few columns'
		elsif result.nfields > answer.nfields
			return 'Result has too many columns'
		end

		for i in 0...result.ntuples
			r_row = result[i]
			a_row = answer[i]
			return "Result don't match" if r_row.values != a_row.values
		end

		return 'Correct!'
	end

	private
	def sanitize(str)
		balcklist = %w(drop, insert, update, set)
	end
end
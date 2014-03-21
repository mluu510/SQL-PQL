
class SqlController < ApplicationController
	def run
		sleep 1
		query = params['query']
		answer = params['answer']

		blacklist = %w(DROP INSERT UPDATE CREATE ALTER DELETE)

		blacklist.each do |word|
			if query.upcase.include?(word) || answer.upcase.include?(word)
				return render :json => {status: "\"#{word}\" is blacklisted!"}
			end
		end


		db = PG::Connection.open(:dbname => 'sql_pql_development')

		pg_results = db.exec_params(query)

		unless answer.empty?
			puts 'COMPARING RESULTS'
			pg_answer = db.exec_params(answer)
			status = compare_results(pg_results, pg_answer)
			render :json => {fields: pg_results.fields, rows:pg_results.values, status: status}
		else
			render :json => {fields: pg_results.fields, rows:pg_results.values}
		end

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
		return 'Correct!'
	end

	private
	def sanitize(str)
		balcklist = %w(drop, insert, update, set)
	end
end
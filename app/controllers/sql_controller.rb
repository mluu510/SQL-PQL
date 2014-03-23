
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
		# puts pg_results.error_messages


		if answer.empty?
			render :json => {fields: pg_results.fields, rows:pg_results.values}
		else
			pg_answer = db.exec_params(answer)
			status = compare_results(pg_results, pg_answer)
			render :json => {fields: pg_results.fields, rows:pg_results.values, status: status}
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

		for i in 0...result.ntuples
			r_row = result[i]
			a_row = answer[i]
			r_row.each do |key, r_value|
				a_value = a_row[key]
				return "Result don't match answer" if r_value != a_value
			end
		end
		return 'Correct!'
	end

	private
	def sanitize(str)
		balcklist = %w(drop, insert, update, set)
	end
end
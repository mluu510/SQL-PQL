var render = function(results) {
	$rootEl = $('.output-window');
	$rootEl.empty();
	$table = $('<table>');

	results.forEach(function(rows) {
		$row = $('<tr>');

		rows.forEach(function(column) {
			$td = $('<td>');
			$td.text(column);
			$row.append($td);
		});

		$table.append($row);
	});

	$rootEl.append($table);
}

$(document).ready(function() {
	$('form').on('submit', function(e) {
		e.preventDefault();
		var query = $(e.target).find('textarea').val();
		$.get('/run', { query: query}, function(results) {
			render(results);
		});

	});
});
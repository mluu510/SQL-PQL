var render = function(results, $targetEl) {
	console.log($targetEl);
	$targetEl.empty();

	var $header = $('<h3>');
	$header.text('Results:');
	$targetEl.append($header);

	var $table = $('<table>');
	$table.addClass('table table-striped');

	$hrow = $('<tr>');
	results.fields.forEach(function(field_name) {
		var $th = $('<th>');
		$th.text(field_name);
		$hrow.append($th);
	});
	$table.append($hrow);

	results.rows.forEach(function(row) {
		var $row = $('<tr>');

		row.forEach(function(column) {
			var $td = $('<td>');
			$td.text(column);
			$row.append($td);
		});

		$table.append($row);
	});

	$targetEl.append($table);
}

$(document).ready(function() {


	$('form').on('submit', function(e) {
		e.preventDefault();
		var parentDiv = $(e.target).parent();
		var outputWindow = $(parentDiv).siblings('.output-window');


		console.log(outputWindow);
		var query = $(e.target).find('textarea').val();
		$.get('/run', { query: query }, function(results) {
			render(results, outputWindow);
		});

	});
});
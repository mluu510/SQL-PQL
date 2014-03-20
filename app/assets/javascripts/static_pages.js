$(document).ready(function() {
	// HANDLE FORM SUBMIT
	$('form').on('submit', function(e) {
		e.preventDefault();
		var parentDiv = $(e.target).parent();
		var outputWindow = $(parentDiv).siblings('.output-window');
		var textarea = $(e.target).find('textarea');
		queryDB(outputWindow, textarea);

	});

	// HANLDE CTRL + ENTER
	$('textarea').keydown(function (e) {
		if ((e.ctrlKey || e.metaKey) && e.keyCode === 13) {
			e.preventDefault();
			var inputWindow = $(e.target).parents()[2];
			var outputWindow = $(inputWindow).next();
			var textarea = $(e.target);
			queryDB(outputWindow, textarea);
		}
	});

	// HANDLE SHOW ANSWER
	$('.show-answer').on('click', function(e) {
		e.preventDefault();
		var showAanswer = confirm('Are you sure you wish to see the answer?');
		if (showAanswer) {
			var parent = $(e.target).parent();
			var siblingDiv = $(parent).prev();
			var textarea = $(siblingDiv).find('.sql-input');
			textarea.val(textarea.data('answer'));
		}
	});
});

var queryDB = function(outputWindow, textarea) {
	var query = $(textarea).val();
	var answer = $(textarea).data('answer');

	// Show loading on output screen
	outputWindow.empty();
	var $loadingEl = $('<h4>');
	$loadingEl.text('Querying Database...');
	outputWindow.append($loadingEl);

	// AJAX query
	$.get('/run', { query: query, answer: answer })
	.done(function(results) {
		render(results, outputWindow);
	})
	.fail(function() {
		alert('Invalid SQL statement!')
	});
}

// Renders the view for the output screen
var render = function(results, $targetEl) {
	$targetEl.empty();

	if (results.status) {
		var $alertView = $('<div>')
		if (results.status === 'Correct!') {
			$alertView.addClass('alert alert-success alert-dismissable strong');
		} else {
			$alertView.addClass('alert alert-danger alert-dismissable');
		}
		$alertView.text(results.status);
		console.log(results.status);
		$targetEl.append($alertView);
	}

	// Create results header
	var $header = $('<h3>');
	$header.text('Results:');
	$targetEl.append($header);

	// Create table to display results
	var $table = $('<table>');
	$table.addClass('table table-striped');

	// Header row for table
	$hrow = $('<tr>');
	results.fields.forEach(function(field_name) {
		var $th = $('<th>');
		$th.text(field_name);
		$hrow.append($th);
	});
	$table.append($hrow);

	// Each rows of the result
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
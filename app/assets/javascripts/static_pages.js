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

var evilCount = 0;

var queryDB = function(outputWindow, textarea) {
	var query = $(textarea).val();
	var answer = $(textarea).data('answer');

	// Prevent SQL inejction!
	var invalid = false;
	var blacklist = ['DROP', 'INSERT', 'UPDATE', 'DELETE', 'ALTER'];
	blacklist.forEach(function(word) {
		if (query.toUpperCase().indexOf(word) !== -1 || answer.toUpperCase().indexOf(word) !== -1) {
			invalid = true;
			evilCount++;
			if (evilCount >= 3) {
				console.log('Get the fuck out!');
				window.location = 'https://www.youtube.com/watch?v=oHg5SJYRHA0';
			}
			alert('Wise guy, huh? ' + word + ' is not allowed!');
			return;
		}
	});
	if (invalid) return;

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
		renderErrorView(outputWindow);
	});
}

var renderErrorView = function(outputWindow) {
	outputWindow.empty();
	var $errorEl = $('<h3>');
	$errorEl.addClass('text-center');
	$errorEl.text('Invalid SQL Statment!');
	outputWindow.append($errorEl);

	var $subEl = $('<p>');
	$subEl.addClass('text-center');
	$subEl.text('Please try again')
	outputWindow.append($subEl);
}

// Renders the view for the output screen
var render = function(result, $targetEl) {

	var template = JST['result']
	var content = template({ result: result });
	$targetEl.html(content);
}


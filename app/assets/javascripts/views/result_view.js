window.SqlPql.Views.ResultView = Backbone.View.extend({
	initialize: function(options) {
		this.result = options.result
	},

	template: JST['result'],

	render: function() {
		var content = this.template({
			result: result
		});
		this.$el.html(content);
		return this;
	}
})
//= require jquery.tokeninput

function generate_token_input(value) {
  $(value).tokenInput(function($input) {
      var modelName = $input.data("model-name");
      return "/autocomplete/"+modelName;
    }, {
      theme: 'facebook',
      tokenLimit: value.className == "token-input" ? 1 : null,
      preventDuplicates: true,
      enableHTML: true,
      resultsFormatter: function(item) {
        var string = item[this.propertyToSearch];
        return "<li>" + (this.enableHTML ? string : _escapeHTML(string)) + "</li>";
    }
  });
}

$(function(){
  $.each($('input.token-input, input.token-input-multiple'), function (index, value) {
    generate_token_input(value);
  });
});

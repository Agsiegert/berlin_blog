// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require scrivito
//= require scrivito_advanced_editors
//= require scrivito_codemirror_editor
//= require bootstrap-sprockets
//= require_tree .

scrivito.on("load", function() {
  scrivito.editors.medium_editor.options = function() {
    var extensions;
    extensions = scrivito.editors.medium_editor.default_options().extensions;
    return {
      extensions: extensions,
      toolbar: {
        buttons: ['bold', 'italic', 'code', 'scrivito_anchor', 'h2', 'h3', 'unorderedlist', 'orderedlist', 'pre', 'removeFormat']
      }
    };
  };
  return scrivito.select_editor(function(element, editing) {
      editing.use("codemirror");
  });
});

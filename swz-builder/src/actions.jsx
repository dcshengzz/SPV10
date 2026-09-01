var Reflux = require('reflux');

var BuilderActions = Reflux.createActions([
  'add',
  'showEditForm',
  'remove',
  'saveData',
  'save',
  'move'
]);

module.exports = BuilderActions;
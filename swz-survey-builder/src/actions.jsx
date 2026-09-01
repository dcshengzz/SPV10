var Reflux = require('reflux');

var BuilderActions = Reflux.createActions([
  'add',
  'showEditForm',
  'remove',
  'saveData',
  'save',
  'move',
  'offScroll',
  'beforeSave',
  'back',
  'next',
]);

module.exports = BuilderActions;
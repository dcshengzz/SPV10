
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reactive;
using System.Reactive.Linq;
using System.Threading.Tasks;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Exceptions;
using swz.Clover.Core.Model;
using swz.Clover.Core.Utils;

namespace swz.Clover.Core.ORM
{
    public sealed class ObservableEntityContainer : EntityContainer
    {
        private string DataChangeConnectionString { get; }

        private readonly IDictionary<object, IList<ChangePart>> _changes = new Dictionary<object, IList<ChangePart>>();

        private readonly IList<object> _insertedObjectIds = new List<object>();

        private IList<object> _deletedObjectIds = new List<object>();
        
        private Dictionary<object,List<DynamicEntity>> _updateableEntitiesForSync = new Dictionary<object, List<DynamicEntity>>();


        public ObservableEntityContainer(IEnumerable<dynamic> entities, EntityModel model, bool readOnly = false, string dataChangeConnectionString = null)
            : base(entities, model, readOnly)
        {
            DataChangeConnectionString = string.IsNullOrEmpty(dataChangeConnectionString) ? CloverRuntime.ConnectionStringData : dataChangeConnectionString;
          //  SubscribeAllEvents();
        }

        public ObservableEntityContainer(EntityContainer container, bool readOnly = false, string dataChangeConnectionString = null)
            : base(container.Entities, container.Model, readOnly)
        {
            DataChangeConnectionString = string.IsNullOrEmpty(dataChangeConnectionString) ? CloverRuntime.ConnectionStringData : dataChangeConnectionString;
            //SubscribeAllEvents();
        }
        
        protected override EntityContainer CreateChildContainer(IEnumerable<dynamic> entities, EntityModel model, bool readOnly,string propertyName)
        {
            return  new ObservableEntityContainer(entities, model, readOnly)
            {
                PropertyName = propertyName
            };
        }

        private void SubscribeEvents(DynamicEntity entity)
        {
            var observable = GetObser(entity).Where(p => p.EventArgs.Id != null).Select(p => p.EventArgs);
            observable.Subscribe(AddChangePart);
        }

        protected override DynamicEntity ProcessSingleEntity(DynamicEntity entity)
        {
            SubscribeEvents(entity);
            return entity;
        }
        
        private readonly object _lock = new object();


        private void AddChangePart(DynamicPropertyChangedEventArgs args)
        {
            lock (_lock)
            {
                var attribute = Model.GetAttributeByName(args.PropertyName);
                
                //ignore changing of Calculated, Virtual and JoinedAttributes
                if (attribute != null && (attribute.IsCalculated || attribute.IsVirtual || attribute is JoinedAttributeModel))
                    return;
                
                if (!_changes.ContainsKey(args.Id))
                    _changes.Add(args.Id, new List<ChangePart>());

                var changeParts = _changes[args.Id];

                var change = changeParts.SingleOrDefault(p => p.PropertyName.Equals(args.PropertyName, StringComparison.OrdinalIgnoreCase));
                if (change == null)
                {
                    change = new ChangePart {PropertyName = args.PropertyName, InitialValue = args.OldValue};
                    changeParts.Add(change);
                }

                if ((change.InitialValue == null && args.NewValue == null) || (change.InitialValue != null && change.InitialValue.ExtendedEquals(args.NewValue)))
                {
                    changeParts.Remove(change);
                    if (changeParts.Count < 1)
                        _changes.Remove(args.Id);
                }
                else
                {
                    change.NewValue = args.NewValue;
                }
            }
        }


        public void ResetChanges()
        {
            _changes.Clear();
            _insertedObjectIds.Clear();
            _deletedObjectIds.Clear();
            _updateableEntitiesForSync.Clear();

            foreach (var child in Children)
            {
                if (child is ObservableEntityContainer container)
                    container.ResetChanges();
            }
        }

        public ObservableEntityContainer Merge(IEnumerable<dynamic> data, bool deleteMissing = false)
        {
            return MergeInternal(data, deleteMissing, (null, null));
        }

        private ObservableEntityContainer MergeInternal(IEnumerable<dynamic> data, bool deleteMissing, (CollectionModel collectionModel, DynamicEntity parentEntity) collectionInfo)
        {
            var dynamicEntities = data as IList<dynamic> ?? data.ToList();
            foreach (DynamicEntity dynamicEntity in dynamicEntities)
            {
                if (!Model.IsVirtual)
                {
                    var dynamicEntityId = dynamicEntity.GetId();
                    
                    var oldEntity = EntitiesList.FirstOrDefault(e => e.GetId().Equals(dynamicEntityId));
                    if (oldEntity != null)
                    {
                        if (_deletedObjectIds.Contains(dynamicEntityId))
                            throw new DynamicEntitiesMergeException("Can not merge item with id = {0}, item was deleted", dynamicEntityId);

                        if (!_updateableEntitiesForSync.ContainsKey(dynamicEntityId))
                        {
                            _updateableEntitiesForSync.Add(dynamicEntityId, new List<DynamicEntity>(){dynamicEntity});
                        }
                        else
                        {
                            _updateableEntitiesForSync[dynamicEntityId].Add(dynamicEntity);
                        }

                        oldEntity.MergeProperties(dynamicEntity, IgnoreNotChanged);
                    }
                    else
                    {
                        AddSingleEntity(dynamicEntity, true);
                        if (!_insertedObjectIds.Contains(dynamicEntityId))
                            _insertedObjectIds.Add(dynamicEntityId);
                    }
                    
                    SetForeignKeysForCollections(dynamicEntity);
                }

                foreach (var child in Children)
                {
                    if (child is ObservableEntityContainer container)
                    {
                        if (dynamicEntity[container.PropertyName] is IEnumerable<DynamicEntity> childEntities)
                        {
                            var collModel = Model.GetCollectionModelWithName(container.PropertyName);
                            if (collModel != null)
                            {
                                container.MergeInternal(childEntities, true,(collModel,dynamicEntity));
                            }
                            
                        }
                    }
                }
            }

            if (deleteMissing && !Model.IsVirtual)
            {
                var entitiesList = EntitiesList.Cast<DynamicEntity>().ToList();

                if (collectionInfo.collectionModel != null && collectionInfo.parentEntity != null && collectionInfo.parentEntity.HasPrimaryKey)
                {
                    entitiesList = collectionInfo.collectionModel.GetCollection(collectionInfo.parentEntity, entitiesList);

                }
                
                foreach (DynamicEntity entity in entitiesList)
                {
                    if (!entity.HasPrimaryKey)
                        continue;
                    
                    var id = entity.GetId();
                    var existsInNewData = dynamicEntities.Any(e => e.GetId().Equals(id));

                    if (!existsInNewData)
                    {
                        if (!_deletedObjectIds.Contains(id))
                            _deletedObjectIds.Add(id);
                    }
                }
            }

            return this;
        }

 
        public void Remove(IEnumerable<dynamic> data, bool cascadeDelete = false)
        {
            if (data == null)
                return;
            
            var dynamicEntities = data as IList<dynamic> ?? data.ToList();
            
            if (!dynamicEntities.Any())
                return;
            #region unused code
//            if (!string.IsNullOrEmpty(propertyName))
//            {
//                var properties = propertyName.Split(new string[] {"->"}, StringSplitOptions.RemoveEmptyEntries);
//                var containerToApply = this;
//                foreach (var property in properties)
//                {
//                    if (containerToApply.ChildrenList[property] is ObservableEntityContainer newContainer)
//                        containerToApply = newContainer;
//                    else
//                    {
//                        throw new DynamicEntitiesException("Observable container can contain only the observable containers as children");
//                    }
//                }
//
//                containerToApply.Remove(dynamicEntities);
//                return;
//            }
            #endregion

            foreach (DynamicEntity dynamicEntity in dynamicEntities)
            {
                var oldEntity = EntitiesList.FirstOrDefault(e => e.GetId().Equals(dynamicEntity.GetId())) as DynamicEntity;
                if (oldEntity != null && Model.HasVersionAttribute)
                {
                    if (!oldEntity.GetProperty(Model.VersionAttribute.PropertyName).Equals(dynamicEntity.GetProperty(Model.VersionAttribute.PropertyName)))
                        throw new DynamicEntitiesMergeException("Impossible to delete entity {0} with id = {1} different versions", Model.Name, dynamicEntity.GetId());

                }

                if (!_deletedObjectIds.Contains(dynamicEntity.GetId()))
                    _deletedObjectIds.Add(dynamicEntity.GetId());

                if (cascadeDelete && ChildrenList.Any())
                {
                    foreach (var child in ChildrenList)
                    {
                        if (child.Value is ObservableEntityContainer observableChildContainer)
                        {
                            if (dynamicEntity.HasProperty(child.Key))
                            {
                                observableChildContainer.Remove(dynamicEntity[child.Key] as List<DynamicEntity>, true);
                            }
                        }
                        else
                        {
                            throw new DynamicEntitiesException("Observable container can contain only the observable containers as children");
                        }
                        
                    }
                }
                    
            }
        }

        public void RemoveAll(bool cascadeDelete = false)
        {
            Remove(Entities, cascadeDelete);
        }


        public async Task<(long inserted, long updated, long deleted)> ApplyAsync()
        {
            (long inserted, long udated, long deleted) operationResult;
            
            //if (CloverRuntime.LicenseSemaphore != null) await CloverRuntime.LicenseSemaphore.WaitAsync();
            try
            {
                if (Children.Any())
                {
                    using (var shared = new SharedTransaction())
                    {
                        await shared.BeginTransactionAsync().ConfigureAwait(false);

                        operationResult = await ApplyInternalAsync(this, true, true);

                        await shared.CommitAsync().ConfigureAwait(false);
                    }
                }
                else
                {
                    operationResult = await ApplyInternalAsync().ConfigureAwait(false);
                }
            }
            finally
            {
                CloverRuntime.LicenseSemaphore?.Release();
            }
            
            return operationResult;
        }

        private async Task<(long inserted, long udated, long deleted)> ApplyInternalAsync(ObservableEntityContainer executionRoot, bool isDownward, bool isRoot = false)
        {
            (long inserted, long udated, long deleted) operationResult = (0, 0, 0);

            if (isDownward)
            {
                if (isRoot && Model.HasVersionAttribute && !ReadOnly)
                {
                    var allIds = new HashSet<object>(EntitiesList.Select(e => (object) e.GetId()).Distinct());
                    var inserted = new HashSet<object>(_insertedObjectIds);
                    var deleted = new HashSet<object>(_deletedObjectIds);
                    allIds.RemoveWhere(i => inserted.Contains(i));
                    allIds.RemoveWhere(i => deleted.Contains(i));
                    allIds.RemoveWhere(i => _changes.ContainsKey(i));

                    if (allIds.Any())
                    {
                        foreach (var id in allIds)
                        {
                            _changes.Add(id,
                                new List<ChangePart> {new ChangePart() {PropertyName = Model.PrimaryKeyAttributeName, InitialValue = id, NewValue = id}}); //TODO review
                        }
                    }
                }

                if (_insertedObjectIds.Count > 0 && !ReadOnly)
                   operationResult.inserted = await ApplyInsertAsync().ConfigureAwait(false);
                if(!ReadOnly)
                {
                    List<KeyValuePair<object, IList<ChangePart>>> changesForUpdate = GetChangesForUpdate();
                    if (changesForUpdate.Any())
                        operationResult.udated = await ApplyUpdateAsync(changesForUpdate).ConfigureAwait(false);
                }                
                _updateableEntitiesForSync.Clear();
                _changes.Clear();
                _insertedObjectIds.Clear();
            }

            if (!isDownward || !Children.Any())
            {
                if (_deletedObjectIds.Count > 0 && !ReadOnly)
                {
                    operationResult.deleted = await ApplyDeleteAsync().ConfigureAwait(false);
                }

                _deletedObjectIds.Clear();
            }

            if (isDownward)
            {
                if (Children.Any()) //go down
                {
                    foreach (var child in Children)
                    {
                        if (child is ObservableEntityContainer observableChild)
                        {
                            var res = await observableChild.ApplyInternalAsync(executionRoot, true);
                            operationResult.deleted = res.deleted;
                        }
                    }
                }
                else //at last child go up
                {
                    if (Parent is ObservableEntityContainer observableParent)
                    {
                        if (observableParent.ChildrenList.IndexOfKey(PropertyName) + 1 == observableParent.ChildrenList.Count)
                        {
                            var res = await observableParent.ApplyInternalAsync(executionRoot, false);
                            operationResult.deleted = res.deleted;
                        }
                    }
                }
            }
            else
            {
                if (this == executionRoot) //stop at the execution root
                    return operationResult;

                if (Parent is ObservableEntityContainer observableParent) //continue go up
                {
                    if (observableParent.ChildrenList.IndexOfKey(PropertyName) + 1 == observableParent.ChildrenList.Count)
                    {
                        var res = await observableParent.ApplyInternalAsync(executionRoot, false);
                        operationResult.deleted = res.deleted;
                    }
                }
            }

            return operationResult;
        }

        private async Task<(long inserted, long updated, long deleted)> ApplyInternalAsync()
        {
            (long inserted, long updated, long deleted) operationResult = (0, 0, 0);
            
            if (_insertedObjectIds.Count > 0 && !ReadOnly)
                operationResult.inserted = await ApplyInsertAsync().ConfigureAwait(false);
            if(!ReadOnly)
            {
                List<KeyValuePair<object, IList<ChangePart>>> changesForUpdate = GetChangesForUpdate();
                if (changesForUpdate.Any())
                    operationResult.updated = await ApplyUpdateAsync(changesForUpdate).ConfigureAwait(false);
            }            
            if (_deletedObjectIds.Count > 0 && !ReadOnly)
            {
                operationResult.deleted = await ApplyDeleteAsync().ConfigureAwait(false);
            }
            ResetChanges();

            return operationResult;
        }

        private List<KeyValuePair<object, IList<ChangePart>>> GetChangesForUpdate()
        {
            return _changes.Where(c => !_insertedObjectIds.Contains(c.Key)).ToList();
        }

        private async Task<long> ApplyDeleteAsync()
        {
            if (_deletedObjectIds.Count < 1)
                return 0;
            
            var deletes = new List<ChangeOperation>();
            
            foreach (var id in _deletedObjectIds)
            {
                DynamicEntity entity = Entities.SingleOrDefault(p =>
                {
                    var dynamicEntity = p as DynamicEntity;
                    return dynamicEntity != null && id.Equals(dynamicEntity.GetId());
                });
                var filter = Filter.And.Equal(id, Model.PrimaryKeyAttribute);
                if (Model.HasVersionAttribute)
                {
                    if (entity == null)
                        throw new DynamicEntitiesMergeException("Entity {0} with id = {1} have a version column and not exists in container", Model.Name, id);
                    var versionColumn = Model.VersionAttribute;
                    var version = entity.GetProperty(versionColumn.PropertyName);
                    if (version == null)
                        throw new Exception("Version is null");
                    filter.Equal(version,Model.VersionAttribute);
                }
                deletes.Add(new ChangeOperation() {Entity = entity, Filter = filter});
            }

            var entities = deletes.Select(d => d.Entity as dynamic).ToList();
            
            var result = await Model.ExecuteTriggersAsync(TriggerCallType.BeforeDelete, entities).ConfigureAwait(false);
            if (result.IsCancelled)
                throw new DeleteCancelledException(result.Message);
            await AuditHelper.AuditLog(deletes, Model, "Delete");
            var deleteResult = await CloverRuntime.DbProvider.Delete(Model, deletes, DataChangeConnectionString).ConfigureAwait(false);

            result = await Model.ExecuteTriggersAsync(TriggerCallType.AfterDelete, entities).ConfigureAwait(false);
            if (result.IsCancelled)
                throw new DeleteCancelledException(result.Message);
            
            await DynamicEntityOperationNotifier.NotifyDeleteAsync(Model, deletes);

            return deleteResult.AffectedRowsCount;
        }

        /// <summary>
        /// This global flag is a kludge that should only be set at startup and not modified after that.
        /// This flag can be cleared to disable the fix for Issue #287 if its causing any problems.
        /// (Plan is to remove this flag in a future build and always apply the fix)
        /// </summary>
        public static bool Global_Is_Fix_Issue_287 = true; 

        private async Task<long> ApplyInsertAsync()
        {
            if (!_insertedObjectIds.Any())
                return 0;

            var inserts = new List<ChangeOperation>();

            var insertedEntities = Entities.Where(e => _insertedObjectIds.Contains((e as DynamicEntity).GetId())).ToList();

            //Generating ids, if generated set foreign keys to the children 
            foreach (DynamicEntity entity in insertedEntities)
            {
                if (!entity.HasPrimaryKey && Model.HasPrimaryKey && !Model.PrimaryKeyAttribute.IsCalculated)
                {
                    var generatedPk = CloverRuntime.DbProvider.PrimaryKeyGenerator.Generate(Model, entity);
                    if (generatedPk != null)
                    {
                        entity.TrySetMember(Model.PrimaryKeyAttributeName, generatedPk, true, suppressEventCall: true);
                        if(Global_Is_Fix_Issue_287)
                        {
                            //For Issue #287
                            //The entity's GetId() had returned the clientId when its id was added to _insertedObjectIds
                            //and we've just changed that id here, so later when ApplyInsertAsync goes to check if there
                            //are any changes that haven't been inserts and so should be updates it will mistakenly not
                            //find this entity in there and go and update it. This causes an extraneous update after an insert
                            //and also problems where you have beforeUpdate triggers getting called with an entity whose
                            //info relects the insert (e.g. things like PropertyWasUpdated() etc)
                            //To fix this we'll replace the previously recorded id with the newly generated one.
                            //With child models a similar situation applies for _changes
                            (object id, object clientId, object _) = entity.GetClientIdAndPrimaryKey();
                            if(generatedPk == id)
                            {
                                //Update the id to the generated pk in _insertedObjectIds
                                int oldIdIndex = _insertedObjectIds.IndexOf(clientId);
                                //its a list and not a set, will there be more than one? don't think so, but we loop to be sure
                                while (oldIdIndex != -1) 
                                {
                                    _insertedObjectIds[oldIdIndex] = id;
                                    oldIdIndex = _insertedObjectIds.IndexOf(clientId);
                                }

                                //Update the id to the generated pk in _changes (its the key so we're moving the
                                //existing entry to be under the new key instead)
                                if (_changes.TryGetValue(clientId, out IList<ChangePart> changePart))
                                {
                                    _changes.Remove(clientId);
                                    _changes[id] = changePart;
                                }
                            }
                        } //end fix 287
                    }
                }

                if (entity.HasPrimaryKey)
                    SetForeignKeysForCollections(entity);
            }

            //Execution of Before trigger
            var triggerExecutionResult = await Model.ExecuteTriggersAsync(TriggerCallType.BeforeInsert, insertedEntities).ConfigureAwait(false);
            if (triggerExecutionResult.IsCancelled)
                throw new InsertCancelledException(triggerExecutionResult.Message);

            #region old code  

//            foreach (var id in _insertedObjectIds)
//            {
//                DynamicEntity entity = Entities.SingleOrDefault(p =>
//                {
//                    var dynamicEntity = p as DynamicEntity;
//                    return dynamicEntity != null && dynamicEntity.GetId() == id;
//                });
//
//                if (entity == null)
//                    continue;

            #endregion

            foreach (var entity in insertedEntities)
            {
                var changeParts = new List<ChangePart>();

                foreach (var item in entity.Dictionary)
                {
                    var attribute = Model.GetAttributeByName(item.Key) as PlainAttributeModel;

                    if (attribute == null || attribute.IsVirtual || attribute.IsCalculated)
                        continue;
                    if (attribute.IsVersion)
                    {
                        if (CloverRuntime.DbProvider.IsVersionUpdatable)
                        {
                            changeParts.Add(new ChangePart
                            {
                                InitialValue = null,
                                NewValue = CloverRuntime.DbProvider.GetNewVersion(),
                                PropertyName = item.Key
                            });
                        }
                    }
                    else
                    {
                        if (!IgnoreNotChanged || entity.PropertyWasChanged(item.Key) || entity.PropertyWasInitialized(item.Key))
                        {
                            changeParts.Add(new ChangePart
                            {
                                InitialValue = null,
                                NewValue = item.Value,
                                PropertyName = item.Key
                            });
                        }
                    }

                }

                inserts.Add(new ChangeOperation() {Entity = entity, Data = changeParts});
            }

            var insertResult = await CloverRuntime.DbProvider.Insert(Model, inserts, DataChangeConnectionString).ConfigureAwait(false);

            await AuditHelper.AuditLog(inserts, Model, "Insert");

            //setting new values for calculated (computed) columns
            if (Model.HasPlainCalculatedAttributes && insertResult.ContainsCalculatedColumnValues)
            {
                foreach (DynamicEntity entity in insertedEntities)
                {
                    if (!insertResult.ContainsCalculateColumnsValuesForId(entity.GetId()))
                        continue;

                    var calculatedValues = insertResult.GetCalculateColumnsValuesById(entity.GetId());

                    bool primaryKeyWasUpdated = false;

                    foreach (var value in calculatedValues)
                    {
                        var isPrimaryKey = Model.HasPrimaryKey && value.Key.Equals(Model.PrimaryKeyAttributeName);

                        if (isPrimaryKey)
                            primaryKeyWasUpdated = true;
                        entity.TrySetMember(value.Key, value.Value, isPrimaryKey, suppressEventCall: true);
                    }

                    //if the model have the calculate primary key we need to set it in collections
                    if (primaryKeyWasUpdated)
                        SetForeignKeysForCollections(entity);
                }
            }

            triggerExecutionResult = await Model.ExecuteTriggersAsync(TriggerCallType.AfterInsert, insertedEntities).ConfigureAwait(false);

            if (triggerExecutionResult.IsCancelled)
                throw new InsertCancelledException(triggerExecutionResult.Message);

            await DynamicEntityOperationNotifier.NotifyInsertAsync(Model, inserts);

            return insertResult.AffectedRowsCount;
        }

        private async Task<long> ApplyUpdateAsync(List<KeyValuePair<object, IList<ChangePart>>> changesForUpdate)
        {
            if (!Model.HasPrimaryKey)
                throw new DynamicEntitiesException($"The Model \"{Model.Name}\" hasn't primary key. Updates is not supported");

            var updates = new List<ChangeOperation>();
            var idAttribute = Model.PrimaryKeyAttribute;

            var keys = changesForUpdate.Select(c => c.Key).ToList();
            var entities = Entities.Where(e => keys.Contains((e as DynamicEntity).GetId())).ToList();

            //set foreign keys for possible inserts in collections
            if (Model.HasCollections)
            {
                foreach (DynamicEntity entity in entities)
                {
                    SetForeignKeysForCollections(entity);
                }
            }
            
            var triggerExecutionResult = await Model.ExecuteTriggersAsync(TriggerCallType.BeforeUpdate, entities).ConfigureAwait(false);
            if (triggerExecutionResult.IsCancelled)
                throw new UpdateCancelledException(triggerExecutionResult.Message);

            foreach (var item in changesForUpdate)
            {
                var changes = new List<ChangePart>();
                foreach (var changePart in item.Value)
                {
                    var attribute = Model.GetAttributeByName(changePart.PropertyName) as PlainAttributeModel;
                    if (attribute == null || attribute.IsVirtual || attribute.IsCalculated)
                        continue;
                    if ("StructDivisionId" == attribute.ColumnName)
                        throw new InvalidOperationException("StructDivisionId may not be updated here");
                    changes.Add(changePart);
                }

                if (changes.Count < 1)
                    continue;

                var filter = Filter.And.Equal(item.Key, idAttribute);
                var entity = Entities.Single(p =>
                {
                    var dynamicEntity = p as DynamicEntity;
                    return dynamicEntity != null && dynamicEntity.GetId().Equals(item.Key);
                }) as DynamicEntity;

                if (Model.HasVersionAttribute)
                {
                    var versionColumn = Model.VersionAttribute;
                    if (
                        changes.Any(
                            cp =>
                                cp.PropertyName.Equals(versionColumn.PropertyName,
                                    StringComparison.OrdinalIgnoreCase)))
                        throw new DynamicEntitiesConcurrencyException(
                            $"Optimistic lock. Model {Model.Name} Id={entity?.GetId()}. You can't change the version attribute manually.");

                    if (entity != null)
                    {
                        var version = entity.GetProperty(versionColumn.PropertyName);
                        if (version == null)
                            throw new NotSupportedException();
                        filter = filter.Equal(version, versionColumn);

                        if (CloverRuntime.DbProvider.IsVersionUpdatable)
                        {
                            changes.Add(new ChangePart
                            {
                                InitialValue = version,
                                NewValue = CloverRuntime.DbProvider.GetNewVersion(),
                                PropertyName = versionColumn.PropertyName
                            });
                        }
                    }
                }



                updates.Add(new ChangeOperation() {Entity = entity, Data = changes, Filter = filter});
            }

            var updateResult = await CloverRuntime.DbProvider.Update(Model, updates, DataChangeConnectionString).ConfigureAwait(false);


            await AuditHelper.AuditLog(updates, Model, "Update");

            //setting new values for calculated (computed) columns
            if (Model.HasPlainCalculatedAttributes && updateResult.ContainsCalculatedColumnValues)
            {
                foreach (DynamicEntity entity in entities)
                {
                    if (!updateResult.ContainsCalculateColumnsValuesForId(entity.GetId()))
                        continue;

                    var calculatedValues = updateResult.GetCalculateColumnsValuesById(entity.GetId());

                    List<DynamicEntity> entitiesForSync = _updateableEntitiesForSync.ContainsKey(entity.GetId()) ? _updateableEntitiesForSync[entity.GetId()] : null;

                    foreach (var value in calculatedValues)
                    {
                        var isPrimaryKey = Model.HasPrimaryKey && value.Key.Equals(Model.PrimaryKeyAttributeName);
                        entity.TrySetMember(value.Key, value.Value, isPrimaryKey,suppressEventCall:true);

                        if (entitiesForSync != null)
                        {
                            foreach (var entityForSync in entitiesForSync)
                            {
                                entityForSync.TrySetMember(value.Key, value.Value, isPrimaryKey); 
                            }
                        }
                    }
                }
            }
            
            triggerExecutionResult = await Model.ExecuteTriggersAsync(TriggerCallType.AfterUpdate, entities).ConfigureAwait(false);
            if (triggerExecutionResult.IsCancelled)
                throw new UpdateCancelledException(triggerExecutionResult.Message);
            
            await DynamicEntityOperationNotifier.NotifyUpdateAsync(Model, updates);

            return updateResult.AffectedRowsCount;
        }

        private void SetForeignKeysForCollections(DynamicEntity data) 
        {
            if (Model.HasCollections)
            {
                foreach (var collection in Model.Collections.Where(c => !c.ReadOnly))
                {
                    var fkAttribute = collection.Model.PlainAttributes.FirstOrDefault(pa => pa.IsReference && pa.ReferencedDataModel.IsSameTable(Model));
                    if (fkAttribute == null)
                    {
                        continue;
                    }

                    if (data[collection.Name] is List<DynamicEntity> collectionData)
                    {
                        foreach (var dynamicEntity in collectionData)
                        {
                           dynamicEntity[fkAttribute.PropertyName] = data.GetId();
                        }
                    }
                }
            }
        }

        public bool HasChanges(object id)
        {
            if (_deletedObjectIds.Contains(id))
                return true;
            if (_insertedObjectIds.Contains(id))
                return true;
            if (_changes.ContainsKey(id))
            {
                var changes = _changes[id];
                foreach (var changePart in changes)
                {
                    var attribute = Model.GetAttributeByName(changePart.PropertyName) as PlainAttributeModel;
                    if (attribute != null && !attribute.IsVersion && !attribute.IsVirtual && !attribute.IsCalculated)
                        return true;
                }

            }
            if (Children.Any())
                foreach (var child in Children)
                {
                    if (child is ObservableEntityContainer observableChild)
                        if (observableChild.HasChanges(id))
                            return true;
                            
                }
            return false;
        }

        public IEnumerable<ChangePart> GetChanges(object id) 
        {
            if (_changes.ContainsKey(id))
            {
                return _changes[id];
            }
            
            if (Children.Any())
                foreach (var child in Children)
                {
                    if (child is ObservableEntityContainer observableChild)
                    {
                        var changes = observableChild.GetChanges(id);
                        var changeParts = changes as IList<ChangePart> ?? changes.ToList();
                        if (changeParts.Any())
                            return changeParts;
                    }
                }

            return new List<ChangePart>();
        }


        private IObservable<EventPattern<DynamicPropertyChangedEventArgs>> GetObser(DynamicEntity obj)
        {
            return Observable.FromEventPattern<DynamicPropertyChangedEventArgs>(p => obj.PropertyChanged += p,
                p => obj.PropertyChanged -= p);
        }

        public ObservableEntityContainer Combine(ObservableEntityContainer container)
        {
            CombineInternal(container);
            return this;
        }

        private void CombineInternal(ObservableEntityContainer container)
        {
            //Merge deleted
            foreach (var deletedObjectId in container._deletedObjectIds)
            {
                _deletedObjectIds.Add(deletedObjectId);
            }

            _deletedObjectIds = _deletedObjectIds.Distinct().ToList();

            //Merge entities
            foreach (var entity in container.EntitiesList)
            {
                var entityId = (object) entity.GetId();
                var oldEntity = EntitiesList.FirstOrDefault(e => ((object) e.GetId()).Equals(entityId));
                if (oldEntity != null)
                {
                    oldEntity.MergeProperties(entity, IgnoreNotChanged);
                }
                else
                {
                    EntitiesList.Add(entity);
                    if (container._changes.ContainsKey(entityId))
                    {
                        var changes = container._changes[entityId];
                        _changes.Add(entityId, changes);
                    }
                    if (container._insertedObjectIds.Contains(entityId))
                    {
                        _insertedObjectIds.Add(entityId);
                    }
                    SubscribeEvents(entity);
                }
            }

            foreach (var child in Children)
            {
                if (child is ObservableEntityContainer observableChild)
                {
                    observableChild.CombineInternal(container.ChildrenList[observableChild.PropertyName] as ObservableEntityContainer);
                }
            }
        }
    }
}


using System;
using System.Collections.Concurrent;
using swz.Clover.Core.DataProvider;
using swz.Clover.Core.Model;

namespace swz.Clover.Core.ORM
{
    internal class FilterPredicate<T> : IFilterPredicate
    {
        //required to change providers in runtime
        private static readonly ConcurrentDictionary<Type, IFilterCriteriaBuilder<T>> BuildersByProvider 
            = new ConcurrentDictionary<Type, IFilterCriteriaBuilder<T>>();
        
        private static IFilterCriteriaBuilder<T> BuilderClass
        {
            get { return BuildersByProvider.GetOrAdd(CloverRuntime.DbProvider.GetType(), (t) => CloverRuntime.DbProvider.GetFilterCriteriaBuilder<T>()); }
        } 
        
        private Func<T, AttributeModel, FilterPurpose, string, string> _builder;
        
        private Func<T, string, FilterPurpose, string, string> _builderp;

        private bool _isLike;

        public string Build(T value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            return _builder.Invoke(value, attribute, purpose, tableAlias);
        }

        public string Build(object value, AttributeModel attribute, FilterPurpose purpose, string tableAlias)
        {
            return Build((T) value, attribute, purpose, tableAlias);
        }
        
        public string Build(T value, string property, FilterPurpose purpose, string tableAlias)
        {
            return _builderp.Invoke(value, property, purpose, tableAlias);
        }

        public string Build(object value,string property, FilterPurpose purpose, string tableAlias)
        {
            return Build((T) value, property, purpose, tableAlias);
        }

        public bool IsLike => _isLike;

        public static readonly FilterPredicate<T> LikeRight = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.LikeRight(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.LikeRight(v, a, p, al),
            _isLike = true
        };

        public static readonly FilterPredicate<T> LikeLeft = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.LikeLeft(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.LikeLeft(v, a, p, al),
            _isLike = true
        };

        public static readonly FilterPredicate<T> LikeRightLeft = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.LikeRightLeft(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.LikeRightLeft(v, a, p, al),
            _isLike = true
        };

        public static readonly FilterPredicate<T> NotLikeRight = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.NotLikeRight(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.NotLikeRight(v, a, p, al),
            _isLike = true
        };

        public static readonly FilterPredicate<T> NotLikeLeft = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.NotLikeLeft(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.NotLikeLeft(v, a, p, al),
            _isLike = true
        };

        public static readonly FilterPredicate<T> NotLikeRightLeft = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.NotLikeRightLeft(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.NotLikeRightLeft(v, a, p, al),
            _isLike = true
        };

        public static readonly FilterPredicate<T> Equal = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.Equal(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.Equal(v, a, p, al),
        };

        public static readonly FilterPredicate<T> NotEqual = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.NotEqual(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.NotEqual(v, a, p, al),
        };

        public static readonly FilterPredicate<T> Greater = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.Greater(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.Greater(v, a, p, al),
        };

        public static readonly FilterPredicate<T> Less = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.Less(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.Less(v, a, p, al),
            
        };

        public static readonly FilterPredicate<T> GreaterOrEqual = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.GreaterOrEqual(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.GreaterOrEqual(v, a, p, al),
        };

        public static readonly FilterPredicate<T> LessOrEqual = new FilterPredicate<T>
        {
            _builder = (v, a, p, al) => BuilderClass.LessOrEqual(v, a, p, al),
            _builderp = (v, a, p, al) => BuilderClass.LessOrEqual(v, a, p, al),
        };
    }
}

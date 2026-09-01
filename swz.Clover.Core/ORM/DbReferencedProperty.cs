using System;
using System.Threading;
using System.Threading.Tasks;

namespace swz.Clover.Core.ORM
{
    public sealed class DbReferencedProperty<T>
    {
        private T _value;
        private readonly Func<T> _syncFactory;
        private readonly Func<Task<T>> _asyncFactory;
        private readonly object _lock = new object();

        public DbReferencedProperty(Func<T> syncFactory)
        {
            _syncFactory = syncFactory;
            _asyncFactory = () => Task.Run(() => syncFactory.Invoke());
        }

        public DbReferencedProperty(Func<Task<T>> asyncFactory)
        {
            _asyncFactory = asyncFactory;
            _syncFactory = () => asyncFactory.Invoke().Result;
        }

        public T Value
        {
            get
            {
                if (_value != null)
                    return _value;
                lock (_lock)
                {
                    Interlocked.MemoryBarrier();
                    if (_value == null)
                        _value = _syncFactory.Invoke();
                }

                return _value;
            }
            set => _value = value;
        }

        public Task<T> AsyncValue => GetValueTask();

        private async Task<T> GetValueTask()
        {
            if (_value != null)
                return _value;
            var newValue = await _asyncFactory.Invoke().ConfigureAwait(false);
            lock (_lock)
            {
                Interlocked.MemoryBarrier();
                if (_value == null)
                    _value = newValue;
            }

            return _value;
        }

    }
}
